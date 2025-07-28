import 'package:flutter/material.dart';

class WindowState {
  final String id;
  final String title;
  final Widget content;
  final Offset position;
  final Size size;
  final bool isMinimized;
  final bool isMaximized;
  final bool isFocused;
  final int zIndex;
  final IconData? icon;
  final bool canResize;
  final bool canClose;
  final Size? minSize;
  final Size? maxSize;

  const WindowState({
    required this.id,
    required this.title,
    required this.content,
    this.position = const Offset(100, 100),
    this.size = const Size(800, 600),
    this.isMinimized = false,
    this.isMaximized = false,
    this.isFocused = false,
    this.zIndex = 0,
    this.icon,
    this.canResize = true,
    this.canClose = true,
    this.minSize = const Size(400, 300),
    this.maxSize,
  });

  WindowState copyWith({
    String? id,
    String? title,
    Widget? content,
    Offset? position,
    Size? size,
    bool? isMinimized,
    bool? isMaximized,
    bool? isFocused,
    int? zIndex,
    IconData? icon,
    bool? canResize,
    bool? canClose,
    Size? minSize,
    Size? maxSize,
  }) {
    return WindowState(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      position: position ?? this.position,
      size: size ?? this.size,
      isMinimized: isMinimized ?? this.isMinimized,
      isMaximized: isMaximized ?? this.isMaximized,
      isFocused: isFocused ?? this.isFocused,
      zIndex: zIndex ?? this.zIndex,
      icon: icon ?? this.icon,
      canResize: canResize ?? this.canResize,
      canClose: canClose ?? this.canClose,
      minSize: minSize ?? this.minSize,
      maxSize: maxSize ?? this.maxSize,
    );
  }
}
