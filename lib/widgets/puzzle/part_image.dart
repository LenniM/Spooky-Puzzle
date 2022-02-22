import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';



class PartImagePainter extends StatefulWidget {
  final ImageProvider imageProvider;
  final Rect rect;

  const PartImagePainter(
      {required this.imageProvider, required this.rect, Key? key})
      : super(key: key);

  @override
  _PartImagePainterState createState() => _PartImagePainterState();
}

class _PartImagePainterState extends State<PartImagePainter> {
  // ui.Image? _image;

  // Future<ui.Image> getImage(ImageProvider _provider) async {
  //   Completer<ImageInfo> completer = Completer();
  //   // var img = NetworkImage(path);
  //   var img = _provider;
  //   img
  //       .resolve(const ImageConfiguration())
  //       .addListener(ImageStreamListener((ImageInfo info, bool _) {
  //     completer.complete(info);
  //   }));
  //   ImageInfo imageInfo = await completer.future;
  //   return imageInfo.image;
  // }

  StreamController<ui.Image> gifCtrl = StreamController();
  // var img = NetworkImage(path);

  @override
  void initState() {
    super.initState();
    widget.imageProvider
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
          if(!gifCtrl.isClosed){
            gifCtrl.sink.add(info.image);
          }
    }));
    // getImage(widget.imageProvider).then(
    //   (_img) => setState(
    //     () {
    //       _image = _img;
    //     },
    //   ),
    // );
  }

  @override
  void dispose() {
    super.dispose();
    gifCtrl.close();
  }

  @override
  Widget build(BuildContext context) {

    // return FutureBuilder(
    //     future: getImage(widget.imageUrl),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         // If the Future is complete, display the preview.
    //         return paintImage(snapshot.data);
    //       } else {
    //         // Otherwise, display a loading indicator.
    //         return const Center(child: CircularProgressIndicator());
    //       }
    //     });

//    print("Gif");
    return StreamBuilder(
        stream: gifCtrl.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If the Future is complete, display the preview.
            return paintImage(snapshot.data);
          } else {
//             Otherwise, display a loading indicator.
//            return const Center(child: CircularProgressIndicator());
            return Center(child: Container());
          }
        });
    // return _image != null
    //     ? paintImage(_image)
    //     : const Center(child: CircularProgressIndicator());
  }

  paintImage(image) {
    return CustomPaint(
      painter: ImagePainter(image, widget.rect),
      child: SizedBox(
        width: widget.rect.width,
        height: widget.rect.height,
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  ui.Image resImage;

  Rect rectCrop;

  ImagePainter(this.resImage, this.rectCrop);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Size imageSize =
    Size(resImage.width.toDouble(), resImage.height.toDouble());
    FittedSizes sizes = applyBoxFit(BoxFit.fitWidth, imageSize, size);

    Rect inputSubRect = Rect.fromLTRB(
        rectCrop.left * imageSize.width,
        rectCrop.top * imageSize.height,
        rectCrop.right * imageSize.width,
        rectCrop.bottom * imageSize.height);
    final Rect outputSubRect =
    Alignment.center.inscribe(sizes.destination, rect);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;
    canvas.drawRect(rect, paint);

    canvas.drawImageRect(resImage, inputSubRect, outputSubRect, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


//class PartImagePainter extends HookConsumerWidget {
//  const PartImagePainter({Key? key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context, WidgetRef ref) {
//    final gifCtrl = useStreamController<ui.Image>();
//    final imageProvider = ref.watch(puzzleStateProvider).imageProvider!;
//    final rect = ref.read(rectProvider);
//
//    useEffect(() {
//      imageProvider
//          .resolve(const ImageConfiguration())
//          .addListener(ImageStreamListener((ImageInfo info, bool _) {
//        if (!gifCtrl.isClosed) {
//          gifCtrl.sink.add(info.image);
//        }
//      }));
//      return null;
//    }, []);
//
//    return StreamBuilder(
//        stream: gifCtrl.stream,
//        builder: (context, snapshot) {
//          if (snapshot.hasData) {
//            // If the Future is complete, display the preview.
//            return paintImage(snapshot.data, rect);
//          } else {
//            // Otherwise, display a loading indicator.
//            return const Center(child: CircularProgressIndicator());
//          }
//        });
//  }
//
//  Widget paintImage(image, rect) {
//    return CustomPaint(
//      painter: ImagePainter(image, rect),
//      child: SizedBox(
//        width: rect.width,
//        height: rect.height,
//      ),
//    );
//  }
//}
//
//class ImagePainter extends CustomPainter {
//  ui.Image resImage;
//
//  Rect rectCrop;
//
//  ImagePainter(this.resImage, this.rectCrop);
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    final Rect rect = Offset.zero & size;
//    final Size imageSize =
//    Size(resImage.width.toDouble(), resImage.height.toDouble());
//    FittedSizes sizes = applyBoxFit(BoxFit.fitWidth, imageSize, size);
//
//    Rect inputSubRect = Rect.fromLTRB(
//        rectCrop.left * imageSize.width,
//        rectCrop.top * imageSize.height,
//        rectCrop.right * imageSize.width,
//        rectCrop.bottom * imageSize.height);
//    final Rect outputSubRect =
//    Alignment.center.inscribe(sizes.destination, rect);
//
//    final paint = Paint()
//      ..color = Colors.white
//      ..style = PaintingStyle.fill
//      ..strokeWidth = 4;
//    canvas.drawRect(rect, paint);
//    canvas.drawImageRect(resImage, inputSubRect, outputSubRect, Paint());
//  }
//
//  @override
//  bool shouldRepaint(CustomPainter oldDelegate) {
//    return false;
//  }
//}