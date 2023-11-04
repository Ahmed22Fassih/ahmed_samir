import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingDialog extends StatefulWidget {
  bool? shown;

  bool? isShowing() {
    if (shown == null) return true;
    return shown;
  }

  @override
  createState() => LoadingDialogState();
}

class LoadingDialogState extends State<LoadingDialog> {
  @override
  void initState() {
    super.initState();
    widget.shown = true;
  }

  @override
  Widget build(BuildContext context) {
    widget.shown = true;
    return Align(
      alignment: Alignment.center,
      child: SpinKitFadingCircle(
        color: Colors.yellow,
      ),
    );
  }

  @override
  void dispose() {
    widget.shown = false;
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.shown = false;
  }
}
