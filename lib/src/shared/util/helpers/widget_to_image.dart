import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// Creates an image from the given widget by first spinning up a element and render tree,
/// then waiting for the given [wait] amount of time and then creating an image via a [RepaintBoundary].
///
/// The final image will be of size [imageSize] and the the widget will be layout, ... with the given [logicalSize].
Future<Uint8List> createImageFromWidget(
  Widget widget, {
  Duration? wait,
  Size? logicalSize,
  Size? imageSize,
}) async {
  final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

  logicalSize ??= ui.window.physicalSize / ui.window.devicePixelRatio;
  imageSize ??= ui.window.physicalSize;

  assert(logicalSize.aspectRatio == imageSize.aspectRatio);

  final RenderView renderView = RenderView(
    window: ui.window,
    child: RenderPositionedBox(child: repaintBoundary),
    configuration: ViewConfiguration(
      size: logicalSize,
    ),
  );

  final PipelineOwner pipelineOwner = PipelineOwner();
  final KeyMessageHandler? oldkeyMessageHandler =
      ServicesBinding.instance.keyEventManager.keyMessageHandler;
  ServicesBinding.instance.keyEventManager.keyMessageHandler = null;
  final BuildOwner buildOwner = BuildOwner();
  ServicesBinding.instance.keyEventManager.keyMessageHandler =
      oldkeyMessageHandler;

  pipelineOwner.rootNode = renderView;
  renderView.prepareInitialFrame();

  final RenderObjectToWidgetElement<RenderBox> rootElement =
      RenderObjectToWidgetAdapter<RenderBox>(
    container: repaintBoundary,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: widget,
    ),
  ).attachToRenderTree(buildOwner);

  buildOwner.buildScope(rootElement);

  if (wait != null) {
    await Future<void>.delayed(wait);
  }

  buildOwner.buildScope(rootElement);
  buildOwner.finalizeTree();

  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();

  final ui.Image image = await repaintBoundary.toImage(
    pixelRatio: imageSize.width / logicalSize.width,
  );
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}
