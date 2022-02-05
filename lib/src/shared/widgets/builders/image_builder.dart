import 'dart:io';

import 'package:flutter/material.dart';

class AdaptiveImageBuilder extends StatelessWidget {
  const AdaptiveImageBuilder({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AdaptiveImageProvider(url),
      fit: BoxFit.cover,
      errorBuilder: (context, child, s) {
        return ImageLoadErrorWidget();
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: (context, child, chunk) {
        if (chunk == null) {
          return child;
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        );
      },
    );
  }
}

class ImageLoadErrorWidget extends StatelessWidget {
  const ImageLoadErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.info,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        SizedBox(height: 5),
        Text(
          "Failed to load image",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}

class AdaptiveImageProvider extends ImageProvider {
  AdaptiveImageProvider(String url) : _delegate = _resolve(url);
  final ImageProvider _delegate;

  static ImageProvider _resolve(String url) {
    final uri = Uri.parse(url);
    switch (uri.scheme) {
      case 'asset':
        final path = uri.toString().replaceFirst('asset://', '');
        return AssetImage(path);
      case 'file':
        final file = File.fromUri(uri);
        return FileImage(file);
      case '':
        final file = File.fromUri(uri);
        return FileImage(file);
      case 'http':
        return NetworkImage(url);
      case 'https':
        return NetworkImage(url);
      default:
        throw Exception('Invalid URL: ${uri.scheme}');
    }
  }

  @override
  ImageStreamCompleter load(Object key, DecoderCallback decode) =>
      _delegate.load(key, decode);

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) =>
      _delegate.obtainKey(configuration);
}
