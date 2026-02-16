import 'package:flutter/material.dart';

/// Provider for responsive dimensions that calculates sizes based on game area,
/// not window size. This is crucial for web where the game is centered in a
/// fixed aspect ratio container.
class ResponsiveProvider extends InheritedWidget {
  /// The design size used as reference (mobile design dimensions)
  static const Size designSize = Size(360, 690);

  /// The actual game area size (can be smaller than screen on web)
  final Size gameSize;

  /// Width scaling ratio (actual width / design width)
  late final double scaleWidth;

  /// Height scaling ratio (actual height / design height)
  late final double scaleHeight;

  ResponsiveProvider({
    super.key,
    required this.gameSize,
    required super.child,
  }) {
    scaleWidth = gameSize.width / designSize.width;
    scaleHeight = gameSize.height / designSize.height;
  }

  /// Get the ResponsiveProvider from context
  static ResponsiveProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ResponsiveProvider>();
    assert(provider != null, 'No ResponsiveProvider found in context');
    return provider!;
  }

  /// Try to get the ResponsiveProvider from context, returns null if not found
  static ResponsiveProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ResponsiveProvider>();
  }

  @override
  bool updateShouldNotify(ResponsiveProvider oldWidget) {
    return gameSize != oldWidget.gameSize;
  }
}

/// Extension on num to provide responsive sizing methods
extension ResponsiveExtension on num {
  /// Width scaled according to game width (not screen width)
  /// Usage: 100.rw returns width scaled proportionally
  double get rw {
    final context = _getContext();
    if (context == null) return toDouble();
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return toDouble();
    return this * provider.scaleWidth;
  }

  /// Height scaled according to game height (not screen height)
  /// Usage: 100.rh returns height scaled proportionally
  double get rh {
    final context = _getContext();
    if (context == null) return toDouble();
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return toDouble();
    return this * provider.scaleHeight;
  }

  /// Font size scaled with minimum of width and height scale
  /// This prevents text from becoming too large or too small
  /// Usage: 16.rsp returns scaled font size
  double get rsp {
    final context = _getContext();
    if (context == null) return toDouble();
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return toDouble();
    final minScale = provider.scaleWidth < provider.scaleHeight
        ? provider.scaleWidth
        : provider.scaleHeight;
    return this * minScale;
  }

  /// Get percentage of game width
  /// Usage: 0.5.rsw returns 50% of game width
  double get rsw {
    final context = _getContext();
    if (context == null) return toDouble();
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return toDouble();
    return provider.gameSize.width * this;
  }

  /// Get percentage of game height
  /// Usage: 0.5.rsh returns 50% of game height
  double get rsh {
    final context = _getContext();
    if (context == null) return toDouble();
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return toDouble();
    return provider.gameSize.height * this;
  }

  // We need to get context somehow. This is a workaround.
  // In practice, these extensions will be used within build methods
  // where context is available. For now, return null and let the
  // extensions fall back to the raw value.
  BuildContext? _getContext() {
    return null;
  }
}

/// Helper class to get responsive values with context
class Responsive {
  final BuildContext context;

  const Responsive(this.context);

  /// Get width scaled value
  double width(num size) {
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return size.toDouble();
    return size * provider.scaleWidth;
  }

  /// Get height scaled value
  double height(num size) {
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return size.toDouble();
    return size * provider.scaleHeight;
  }

  /// Get font size scaled value
  double sp(num size) {
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return size.toDouble();
    final minScale = provider.scaleWidth < provider.scaleHeight
        ? provider.scaleWidth
        : provider.scaleHeight;
    return size * minScale;
  }

  /// Get percentage of game width
  double screenWidth(num percentage) {
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return percentage.toDouble();
    return provider.gameSize.width * percentage;
  }

  /// Get percentage of game height
  double screenHeight(num percentage) {
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return percentage.toDouble();
    return provider.gameSize.height * percentage;
  }

  /// Get the game size
  Size get gameSize {
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return ResponsiveProvider.designSize;
    return provider.gameSize;
  }

  /// Get scale width ratio
  double get scaleWidth {
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return 1.0;
    return provider.scaleWidth;
  }

  /// Get scale height ratio
  double get scaleHeight {
    final provider = ResponsiveProvider.maybeOf(context);
    if (provider == null) return 1.0;
    return provider.scaleHeight;
  }
}
