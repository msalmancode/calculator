import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class SnappingSheetTop extends StatelessWidget {
  Widget body;
  Widget sheet;
  SnappingSheetTop({required this.body, required this.sheet, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      initialSnappingPosition: SnappingPosition.factor(
        positionFactor: 1.0,
      ),
      child: body,
      grabbingHeight: 150,
      grabbing: Container(color: Colors.transparent),
      sheetAbove: SnappingSheetContent(
        draggable: true,
        child: sheet,
      ),
    );
  }
}
