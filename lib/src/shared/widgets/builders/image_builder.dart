import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AdaptiveImageBuilder extends StatelessWidget {
  const AdaptiveImageBuilder({
    super.key,
    required this.url,
    this.showLoading = true,
  });

  final String url;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AdaptiveImageProvider(url),
      fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object child, StackTrace? s) {
        return const ImageLoadErrorWidget();
      },
      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
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
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? chunk) {
        if (chunk == null) {
          return child;
        }

        return showLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class ImageLoadErrorWidget extends StatelessWidget {
  const ImageLoadErrorWidget({
    super.key,
  });

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
        const SizedBox(height: 5),
        Text(
          'Failed to load image',
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
    final bool isAssetImage = url.startsWith('assets/');

    final Uri uri = Uri.parse(url);
    final String scheme = !isAssetImage ? uri.scheme : 'asset';
    switch (scheme) {
      case 'asset':
        final String path = uri.toString().replaceFirst('asset://', '');
        return AssetImage(path);
      case 'file':
        final File file = File.fromUri(uri);
        return FileImage(file);
      case '':
        final File file = File.fromUri(uri);
        return FileImage(file);
      case 'http':
        return CachedNetworkImageProvider(url);
      case 'https':
        return CachedNetworkImageProvider(url);
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
