library;

import 'dart:async';

import 'package:flutter/material.dart';

abstract class HareWidget extends StatefulWidget {
  final StateHolder holder = StateHolder();

  HareWidget() : super(key: UniqueKey());

  @override
  State<HareWidget> createState() {
    return HareWidgetState();
  }

  bool get mounted => holder.state?.mounted ?? false;

  BuildContext get context {
    if (holder.state != null) {
      return holder.state!.context;
    }
    throw Exception("widget state has not created");
  }

  void postCreate() {}

  void onCreate() {}

  void onDestroy() {}

  void onStateRemoved() {}

  void onStateUpdated(HareWidgetState newState) {}

  void reassemble() {}

  void postUpdate() {
    _delayCall(0, () => updateState());
  }

  void updateState() => setState(() {});

  void setState(VoidCallback cb) => holder.state?._updateState(cb);

  void beforeBuild(BuildContext context) {}

  Widget build(BuildContext context);
}

class HareWidgetState extends State<HareWidget> {
  void _updateState(VoidCallback c) {
    if (mounted) {
      setState(c);
    }
  }

  void _checkCreate() {
    if (widget.holder.life != HareLife.created) {
      widget.holder.life = HareLife.created;
      widget.onCreate();
      _delayCall(0, widget.postCreate);
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.reassemble();
  }

  @override
  void initState() {
    widget.holder.state = this;
    super.initState();
    _checkCreate();
  }

  @override
  void activate() {
    widget.holder.state = this;
    super.activate();
    _checkCreate();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    if (identical(widget.holder.state, this)) {
      if (widget.holder.life != HareLife.destroyed) {
        widget.holder.life = HareLife.destroyed;
        widget.onDestroy();
      }
      widget.holder.state = null;
    }
  }

  @override
  void didUpdateWidget(covariant HareWidget oldWidget) {
    if (identical(oldWidget.holder.state, this)) {
      oldWidget.holder.state = null;
      oldWidget.onStateRemoved();
    }
    widget.holder.state = this;
    widget.onStateUpdated(this);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    widget.beforeBuild(context);
    return widget.build(context);
  }
}

class StateHolder {
  HareLife life = HareLife.inited;
  HareWidgetState? state;
  Map<String, dynamic> attrs = {};

  void put(String key, dynamic value) {
    if (value == null) {
      attrs.remove(key);
    } else {
      attrs[key] = value;
    }
  }

  T? get<T>(String key) {
    return attrs[key];
  }
}

enum HareLife {
  inited(0),
  created(1),
  destroyed(2),
  disposed(3);

  const HareLife(this.value);

  final int value;
}

Future<void> _delayCall(int milliSeconds, FutureOr<void> Function() callback) {
  return Future.delayed(Duration(milliseconds: milliSeconds), callback);
}
