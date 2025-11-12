import 'package:flutter/material.dart';

class AppRestartWrapper extends StatefulWidget {
  final Widget child;

  const AppRestartWrapper({super.key, required this.child});

  @override
  State<AppRestartWrapper> createState() => _AppRestartWrapperState();

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_AppRestartWrapperState>()?.restartApp();
  }
}

class _AppRestartWrapperState extends State<AppRestartWrapper> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
