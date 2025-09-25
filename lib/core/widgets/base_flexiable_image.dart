import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/gen/assets.gen.dart';
import 'package:shimmer/shimmer.dart';

class FlexibleImage extends StatefulWidget {
  final dynamic source;
  final double borderRadius;
  final bool isCircular;
  final Color? color;
  final Widget? placeholder;
  final double? width;
  final double? height;
  final BoxFit fit;

  const FlexibleImage({
    super.key,
    required this.source,
    this.borderRadius = 0,
    this.isCircular = false,
    this.placeholder,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  });

  @override
  State<FlexibleImage> createState() => _FlexibleImageState();
}

class _FlexibleImageState extends State<FlexibleImage> {
  bool _isNetworkImage(String path) {
    final cleanPath = path.trim();
    return Uri.tryParse(cleanPath)?.hasAbsolutePath ?? false;
  }

  bool _isFileImage(dynamic source) {
    if (source is String) {
      final file = File(source);
      return file.existsSync() &&
          (source.toLowerCase().endsWith('.png') ||
              source.toLowerCase().endsWith('.jpg') ||
              source.toLowerCase().endsWith('.jpeg') ||
              source.toLowerCase().endsWith('.gif') ||
              source.toLowerCase().endsWith('.bmp') ||
              source.toLowerCase().endsWith('.webp'));
    }
    return false;
  }

  bool _isMemoryImage(dynamic data) {
    return data is Uint8List;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.source == null ||
        (widget.source is String && widget.source.toString().trim().isEmpty)) {
      return _buildDefaultImage();
    }

    Widget mediaWidget;

    if (widget.source is String) {
      final cleanSource = widget.source.toString().trim();

      if (widget.source.toString() != cleanSource) {
        debugPrint(
          'DEBUG: Cleaned URL from "${widget.source}" to "$cleanSource"',
        );
      }

      if (_isFileImage(widget.source)) {
        mediaWidget = Image.file(File(widget.source), fit: widget.fit);
      } else if (_isNetworkImage(cleanSource)) {
        if (cleanSource.toLowerCase().endsWith('.svg')) {
          mediaWidget = SvgPicture.network(
            cleanSource,
            placeholderBuilder: (context) => buildShimmer(),
            errorBuilder: (context, error, stackTrace) {
              debugPrint('FlexibleImage: Failed to load SVG: $cleanSource');
              return _errorPlaceholder();
            },
          );
        } else {
          mediaWidget = _SafeCachedNetworkImage(
            imageUrl: cleanSource,
            fit: widget.fit,
            placeholder: buildShimmer(),
            errorWidget: _errorPlaceholder(),
            width: widget.width,
            height: widget.height,
          );
        }
      } else if (cleanSource.endsWith('.svg')) {
        mediaWidget = SvgPicture.asset(
          widget.source,
          errorBuilder: (context, error, stackTrace) =>
              widget.placeholder ?? _errorPlaceholder(),
          colorFilter: widget.color != null
              ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
              : null,
        );
      } else {
        mediaWidget = Image.asset(
          widget.source,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) =>
              widget.placeholder ?? _errorPlaceholder(),
        );
      }
    } else if (_isMemoryImage(widget.source)) {
      mediaWidget = Image.memory(widget.source, fit: widget.fit);
    } else if (widget.source is IconData) {
      mediaWidget = Icon(widget.source, color: widget.color);
    } else {
      mediaWidget = widget.placeholder ?? _errorPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        widget.isCircular ? 1000 : widget.borderRadius,
      ),
      child: (widget.width != null || widget.height != null)
          ? SizedBox(
              width: widget.width,
              height: widget.height,
              child: mediaWidget,
            )
          : IntrinsicWidth(child: IntrinsicHeight(child: mediaWidget)),
    );
  }

  Container _errorPlaceholder() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AllColors.grayLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: AllColors.grayLight.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: SvgPicture.asset(Assets.images.companyLogo),
    );
  }

  Shimmer buildShimmer() => Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.blueGrey,
        ),
        width: widget.width ?? 50.w,
        height: widget.height ?? 50.w,
      ),
    ),
  );

  Widget _buildDefaultImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        widget.isCircular ? 1000 : widget.borderRadius,
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[200],
        child: widget.placeholder ?? _errorPlaceholder(),
      ),
    );
  }
}

class _SafeCachedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final Widget placeholder;
  final Widget errorWidget;
  final double? width;
  final double? height;

  const _SafeCachedNetworkImage({
    required this.imageUrl,
    required this.fit,
    required this.placeholder,
    required this.errorWidget,
    this.width,
    this.height,
  });

  @override
  State<_SafeCachedNetworkImage> createState() =>
      _SafeCachedNetworkImageState();
}

class _SafeCachedNetworkImageState extends State<_SafeCachedNetworkImage> {
  static final Set<String> _brokenImageUrls = <String>{};

  bool get _isKnownBrokenImage => _brokenImageUrls.contains(widget.imageUrl);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isKnownBrokenImage) {
      return widget.errorWidget;
    }

    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      placeholder: (context, url) => widget.placeholder,
      errorWidget: (context, url, error) {
        _brokenImageUrls.add(url);
        debugPrint(
          'FlexibleImage: Failed to load image (cached as broken): $url',
        );
        return widget.errorWidget;
      },
    );
  }
}
