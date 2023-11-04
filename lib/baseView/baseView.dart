import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'baseModel.dart';


class BaseView<T extends BaseModel > extends StatefulWidget {
  final Widget Function(BuildContext context, Widget? child)? builder;

  final T model;
  final Widget? child;
  final void Function(T) onModelReady;
  final bool wantKeepAlive;

  BaseView(
      {Key? key,
        required this.model,
        this.builder,
        this.child,
        this.wantKeepAlive = true,
        required this.onModelReady})
      : super(key: key);

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel > extends State<BaseView<T>>
    with AutomaticKeepAliveClientMixin<BaseView<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady(model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ChangeNotifierProvider<T>(
      child: widget.child ?? Container(),
      builder: widget.builder,
      create: (BuildContext context) {
        return model;
      },
    );
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  void dispose() {
    super.dispose();
  }
}
