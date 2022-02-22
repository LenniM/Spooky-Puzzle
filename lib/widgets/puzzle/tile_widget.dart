import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spookypuzzle/widgets/puzzle/part_image.dart';
import 'package:spookypuzzle/widgets/puzzle/tile_data.dart';

class TileWidget extends StatelessWidget {
  final TileData tileData;
  final ImageProvider? imageProvider;
  final void Function()? onTap;

  const TileWidget({
    Key? key,
    this.imageProvider,
    required this.tileData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned.fromRect(
      rect: Rect.fromLTRB(
        tileData.offset.dx,
        tileData.offset.dy,
        tileData.offset.dx + tileData.size.height,
        tileData.offset.dy + tileData.size.width,
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      child: tileData.isBlank
          ? const SizedBox.expand()
          : GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            if (imageProvider != null)
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: PartImagePainter(
                      imageProvider: imageProvider!,
                      rect: tileData.imageRect,

                    ),
//                    child: ImageFiltered(
//                      imageFilter: tileData.initOffset == tileData.offset
//                          ? ImageFilter.blur()
//                          : ImageFilter.blur(sigmaX: 1, sigmaY: 1),
////                          : ImageFilter.blur(sigmaX: max(0.001, 1), sigmaY: max(0.001, 1)),
//                      child: PartImagePainter(
//                        imageProvider: imageProvider!,
//                        rect: tileData.imageRect,
//                      ),
//                    ),
                  ),
                ),
              ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.all(2.0),
              height: double.infinity,
              width: double.infinity,
              decoration: imageProvider != null
                  ? null
                  : BoxDecoration(
                color: tileData.initOffset == tileData.offset
                    ? Colors.blue[700]
                    : Colors.lightBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    tileData.body,
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.white.withOpacity(
                            tileData.initOffset == tileData.offset
                                ? 0.0
                                : 0.5)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}