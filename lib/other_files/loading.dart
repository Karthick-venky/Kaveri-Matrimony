import 'package:flutter/material.dart';

class MyCustomLoading extends StatefulWidget{
  static OverlayEntry? _overlay;

  const MyCustomLoading({super.key});

  static Future<void> start(
      BuildContext context, {
        Color? barrierColor = Colors.black54,
        Widget? widget,
        Color color = Colors.black38,
        String? gifOrImagePath,
        double? loadingWidth,
      }) async {
    if (_overlay != null) return;
    _overlay = OverlayEntry(builder: (BuildContext context) {
      return _LoadingWidget(
        color: color,
        barrierColor: barrierColor,
        widget: widget,
        gifOrImagePath: gifOrImagePath,
        loadingWidth: loadingWidth,
      );
    });
    Overlay.of(context).insert(_overlay!);
  }

  static stop() {
    if (_overlay == null) return;
    _overlay!.remove();
    _overlay = null;
  }

  @override
  State<MyCustomLoading> createState() => _MyCustomLoadingState();
}

class _MyCustomLoadingState extends State<MyCustomLoading> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _LoadingWidget extends StatelessWidget {
  final Widget? widget;
  final Color? color;
  final Color? barrierColor;
  final String? gifOrImagePath;
  final double? loadingWidth;

  const _LoadingWidget({
    this.widget,
    this.color,
    this.barrierColor,
    this.gifOrImagePath,
    this.loadingWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: barrierColor,
      child: Center(
        child: widget ??
            Container(
              height: 45,width: 45,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              // dimension: loadingWidth,
              child: gifOrImagePath != null
                  ? Image.asset(gifOrImagePath!)
                  : const CircularProgressIndicator(strokeWidth: 3,),
            ),
      ),
    );
  }
}



// MyCustomLoading.stop();