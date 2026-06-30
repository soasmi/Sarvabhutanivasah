import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class SvgRoomRect {
  final int index;
  final Rect rect;

  SvgRoomRect({required this.index, required this.rect});
}

class SvgParserService {
  static List<SvgRoomRect> extractRoomRects(String svgString) {
    final document = XmlDocument.parse(svgString);
    final List<SvgRoomRect> rooms = [];
    int rectIndex = 0;

    // The SVG has <rect> elements inside <g> or root
    final rectElements = document.findAllElements('rect');

    for (var element in rectElements) {
      // Exclude background/clip rects if they have huge dimensions like width="576" height="864"
      final widthAttr = element.getAttribute('width');
      final heightAttr = element.getAttribute('height');
      
      if (widthAttr != null && heightAttr != null) {
        final width = double.tryParse(widthAttr) ?? 0;
        final height = double.tryParse(heightAttr) ?? 0;

        // Arbitrary threshold to exclude background rectangles (assuming rooms are smaller than 500x500)
        if (width > 0 && width < 500 && height > 0 && height < 500) {
          final x = double.tryParse(element.getAttribute('x') ?? '0') ?? 0;
          final y = double.tryParse(element.getAttribute('y') ?? '0') ?? 0;
          
          rooms.add(
            SvgRoomRect(
              index: rectIndex,
              rect: Rect.fromLTWH(x, y, width, height),
            ),
          );
          rectIndex++;
        }
      }
    }

    return rooms;
  }

  static Size? extractViewBox(String svgString) {
    final document = XmlDocument.parse(svgString);
    final svgElement = document.findElements('svg').firstOrNull;
    if (svgElement != null) {
      final viewBoxAttr = svgElement.getAttribute('viewBox');
      if (viewBoxAttr != null) {
        final parts = viewBoxAttr.split(' ');
        if (parts.length == 4) {
          final width = double.tryParse(parts[2]);
          final height = double.tryParse(parts[3]);
          if (width != null && height != null) {
            return Size(width, height);
          }
        }
      }
    }
    return const Size(576, 864); // Fallback to provided SVG's viewBox
  }
}
