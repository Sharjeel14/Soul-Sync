import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_app/core/router/transition_helper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class _GalleryState {
  final int currentIndex;

  const _GalleryState({required this.currentIndex});

  _GalleryState copyWith({int? currentIndex}) =>
      _GalleryState(currentIndex: currentIndex ?? this.currentIndex);
}

// ─── Cubit ────────────────────────────────────────────────────────────────────

class _GalleryCubit extends Cubit<_GalleryState> {
  _GalleryCubit(int initialIndex)
    : super(_GalleryState(currentIndex: initialIndex));

  void onPageChanged(int index) => emit(state.copyWith(currentIndex: index));
}

// ─── Widget ───────────────────────────────────────────────────────────────────

class FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenGallery({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  static void showImage(BuildContext context, List<String> images, int index) {
    Navigator.push(
      context,
      buildBottomUpRoute(
        child: FullScreenGallery(images: images, initialIndex: index),
      ),
    );
  }

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late final PageController _pageController;
  late final _GalleryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = _GalleryCubit(widget.initialIndex);
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                pageController: _pageController,
                itemCount: widget.images.length,
                onPageChanged: _cubit.onPageChanged,
                builder: (context, index) {
                  final image = widget.images[index];
                  return PhotoViewGalleryPageOptions(
                    heroAttributes: PhotoViewHeroAttributes(tag: image),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 3,
                    imageProvider: AppCacheImageProvider.get(image),
                  );
                },
              ),

              // ─── Close button ───────────────────────────────────────────
              Positioned(
                top: 20,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // ─── Index indicator ────────────────────────────────────────
              if (widget.images.length > 1)
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: BlocBuilder<_GalleryCubit, _GalleryState>(
                    builder: (context, state) => Center(
                      child: Text(
                        '${state.currentIndex + 1}/${widget.images.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Image Provider Helper ────────────────────────────────────────────────────

class AppCacheImageProvider {
  const AppCacheImageProvider._();

  static ImageProvider get(String url, {Map<String, String>? headers}) {
    return CachedNetworkImageProvider(url, headers: headers);
  }
}
