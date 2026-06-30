import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'widgets/svg_rooms_widget.dart';
import '../domain/room.dart';

class RoomMappingScreen extends ConsumerStatefulWidget {
  final String buildingId;
  final String svgAsset;

  const RoomMappingScreen({
    super.key,
    required this.buildingId,
    required this.svgAsset,
  });

  @override
  ConsumerState<RoomMappingScreen> createState() => _RoomMappingScreenState();
}

class _RoomMappingScreenState extends ConsumerState<RoomMappingScreen> {
  String? _svgString;
  int? _selectedRectIndex;
  List<Room> _unmappedRooms = [];
  Map<int, String> _currentMappings = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final svgData = await rootBundle.loadString(widget.svgAsset);
      
      final supabase = Supabase.instance.client;
      // Fetch all rooms for this building
      final roomsResponse = await supabase
          .from('rooms')
          .select('*, floors!inner(building_id)')
          .eq('floors.building_id', widget.buildingId);
          
      final List<Room> allRooms = (roomsResponse as List).map((e) => Room.fromJson(e)).toList();

      // Fetch existing mappings
      final mappingResponse = await supabase
          .from('room_svg_mapping')
          .select('*')
          .eq('building_id', widget.buildingId);

      final Map<int, String> mappings = {};
      for (var row in mappingResponse as List) {
        mappings[row['svg_element_index'] as int] = row['room_id'] as String;
      }

      final mappedRoomIds = mappings.values.toSet();
      final unmapped = allRooms.where((r) => !mappedRoomIds.contains(r.id)).toList();

      setState(() {
        _svgString = svgData;
        _unmappedRooms = unmapped;
        _currentMappings = mappings;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
      setState(() => _isLoading = false);
    }
  }

  void _onRoomTap(int index) {
    setState(() {
      _selectedRectIndex = index;
    });

    final existingMapping = _currentMappings[index];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                existingMapping != null ? 'Edit Mapping for Area $index' : 'Map Area $index to Room',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (existingMapping != null)
                Text('Currently mapped to Room ID: $existingMapping'),
              const SizedBox(height: 16),
              if (_unmappedRooms.isEmpty && existingMapping == null)
                const Text('All rooms are already mapped.')
              else
                DropdownButtonFormField<String>(
                  hint: const Text('Select a Room'),
                  items: _unmappedRooms.map((r) {
                    return DropdownMenuItem(
                      value: r.id,
                      child: Text('Room ${r.roomNumber} (${r.category})'),
                    );
                  }).toList(),
                  onChanged: (roomId) {
                    if (roomId != null) {
                      _saveMapping(index, roomId);
                      Navigator.pop(context);
                    }
                  },
                ),
              const SizedBox(height: 16),
              if (existingMapping != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                  onPressed: () {
                    _removeMapping(index);
                    Navigator.pop(context);
                  },
                  child: const Text('Remove Mapping'),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveMapping(int index, String roomId) async {
    try {
      await Supabase.instance.client.from('room_svg_mapping').upsert({
        'building_id': widget.buildingId,
        'room_id': roomId,
        'svg_element_index': index,
      }, onConflict: 'building_id,svg_element_index');
      _loadData(); // Reload to refresh lists
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save mapping: $e')));
    }
  }

  Future<void> _removeMapping(int index) async {
    try {
      await Supabase.instance.client
          .from('room_svg_mapping')
          .delete()
          .eq('building_id', widget.buildingId)
          .eq('svg_element_index', index);
      _loadData();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove mapping: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_svgString == null) {
      return const Scaffold(body: Center(child: Text('Failed to load SVG')));
    }

    final Map<int, Color> colors = {};
    _currentMappings.forEach((index, roomId) {
      colors[index] = Colors.green; // Mapped rooms show as green
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Rooms'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Tap a room area to assign it a room number. Unmapped rooms remaining: ${_unmappedRooms.length}'),
                ),
              ],
            ),
          ),
          Expanded(
            child: InteractiveViewer(
              maxScale: 5.0,
              child: SvgRoomsWidget(
                svgAsset: widget.svgAsset,
                svgString: _svgString!,
                roomColors: colors,
                onRoomTap: _onRoomTap,
                selectedRoomIndex: _selectedRectIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
