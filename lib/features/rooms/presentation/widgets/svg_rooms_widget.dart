import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../services/svg_parser_service.dart';

class SvgRoomsWidget extends StatefulWidget {
  final String svgAsset;
  final String svgString;
  final Map<int, Color> roomColors;
  final Function(int)? onRoomTap;
  final int? selectedRoomIndex;

  const SvgRoomsWidget({
    super.key,
    required this.svgAsset,
    required this.svgString,
    this.roomColors = const {},
    this.onRoomTap,
    this.selectedRoomIndex,
  });

  @override
  State<SvgRoomsWidget> createState() => _SvgRoomsWidgetState();
}

class _SvgRoomsWidgetState extends State<SvgRoomsWidget> {
  late List<SvgRoomRect> _roomRects;
  late Size _viewBox;

  @override
  void initState() {
    super.initState();
    _parseSvg();
  }

  @override
  void didUpdateWidget(covariant SvgRoomsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.svgString != widget.svgString) {
      _parseSvg();
    }
  }

  void _parseSvg() {
    _roomRects = SvgParserService.extractRoomRects(widget.svgString);
    _viewBox = SvgParserService.extractViewBox(widget.svgString) ?? const Size(576, 864);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate scaling factor to fit the SVG in the available space while preserving aspect ratio
        final double scaleX = constraints.maxWidth / _viewBox.width;
        final double scaleY = constraints.maxHeight / _viewBox.height;
        final double scale = scaleX < scaleY ? scaleX : scaleY;

        final double renderedWidth = _viewBox.width * scale;
        final double renderedHeight = _viewBox.height * scale;

        // Calculate offsets to center the SVG
        final double offsetX = (constraints.maxWidth - renderedWidth) / 2;
        final double offsetY = (constraints.maxHeight - renderedHeight) / 2;

        return Stack(
          children: [
            Center(
              child: SvgPicture.string(
                widget.svgString,
                width: renderedWidth,
                height: renderedHeight,
                fit: BoxFit.contain,
              ),
            ),
            ..._roomRects.map((room) {
              final left = offsetX + (room.rect.left * scale);
              final top = offsetY + (room.rect.top * scale);
              final width = room.rect.width * scale;
              final height = room.rect.height * scale;

              final isSelected = widget.selectedRoomIndex == room.index;
              final color = widget.roomColors[room.index] ?? Colors.transparent;

              return Positioned(
                left: left,
                top: top,
                width: width,
                height: height,
                child: GestureDetector(
                  onTap: () => widget.onRoomTap?.call(room.index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.5),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: isSelected ? 3 : 0,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
