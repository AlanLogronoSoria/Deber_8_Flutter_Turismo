import 'package:flutter/material.dart';

// Matches the design tokens in lugar_card.dart
const _kRed = Color(0xFFD4253A);
const _kTextLight = Color(0xFF9B9B90);

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({
    super.key,
    required this.isFavorite,
    required this.likes,
    required this.onChanged,
  });

  final bool isFavorite;
  final int likes;
  final VoidCallback onChanged;

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _bounceController.forward(from: 0);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated heart icon
          ScaleTransition(
            scale: _bounceAnim,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                widget.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                key: ValueKey(widget.isFavorite),
                color: widget.isFavorite ? _kRed : _kTextLight,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 6),

          // Likes count with animated transition
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.5),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Text(
              '${widget.likes}',
              key: ValueKey(widget.likes),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: widget.isFavorite ? _kRed : _kTextLight,
                letterSpacing: 0.2,
              ),
            ),
          ),

          const SizedBox(width: 4),

          Text(
            widget.isFavorite ? 'guardado' : 'guardar',
            style: TextStyle(
              fontSize: 11,
              color: widget.isFavorite
                  ? _kRed.withValues(alpha: 0.7)
                  : _kTextLight.withValues(alpha: 0.8),
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}