import 'package:flutter/material.dart';

import '../models/lugar.dart';
import 'favorite_widget.dart';

// ── Design tokens ────────────────────────────────────────────────────────────
const _kGreen = Color(0xFF1B4332);       // Andean forest green — primary
const _kGold = Color(0xFFD4A853);        // Colonial gold — accent
const _kTextDark = Color(0xFF1A1A18);    // Near-black — headings
const _kTextMid = Color(0xFF5C5C54);     // Mid-tone — body

class LugarCard extends StatefulWidget {
  const LugarCard({
    super.key,
    required this.lugar,
  });

  final Lugar lugar;

  @override
  State<LugarCard> createState() => _LugarCardState();
}

class _LugarCardState extends State<LugarCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.975).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    setState(() => _pressed = true);
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _pressed = false);
    _scaleController.reverse();
  }

  void _onTapCancel() {
    setState(() => _pressed = false);
    _scaleController.reverse();
  }

  void _toggleFavorite() {
    setState(() {
      if (widget.lugar.isFavorite) {
        widget.lugar.likes--;
      } else {
        widget.lugar.likes++;
      }
      widget.lugar.isFavorite = !widget.lugar.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _pressed
                  ? _kGold.withValues(alpha: 0.6)
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _kGreen.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero image ─────────────────────────────────────────────
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.asset(
                      widget.lugar.image,
                      height: 210,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Bottom gradient scrim for readability
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 90,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xCC000000),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Location pill — bottom left of image
                  Positioned(
                    bottom: 12,
                    left: 14,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.place_rounded,
                          size: 12,
                          color: _kGold,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.lugar.location,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Favorite button — top right of image
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _ImageFavoriteButton(
                      isFavorite: widget.lugar.isFavorite,
                      onTap: _toggleFavorite,
                    ),
                  ),
                ],
              ),

              // ── Text content ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      widget.lugar.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _kTextDark,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Thin divider with gold accent
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 2,
                          decoration: BoxDecoration(
                            color: _kGold,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 2,
                          decoration: BoxDecoration(
                            color: _kGold.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Description
                    Text(
                      widget.lugar.description,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: _kTextMid,
                        height: 1.55,
                        letterSpacing: 0.1,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Footer: likes count ───────────────────────────────
                    Row(
                      children: [
                        // Likes display
                        FavoriteWidget(
                          isFavorite: widget.lugar.isFavorite,
                          likes: widget.lugar.likes,
                          onChanged: _toggleFavorite,
                        ),

                        const Spacer(),

                        // Subtle "explorar" affordance
                        Row(
                          children: [
                            Text(
                              'Explorar',
                              style: TextStyle(
                                fontSize: 12,
                                color: _kGreen.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 13,
                              color: _kGreen.withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Floating favorite button overlaid on the image ───────────────────────────
class _ImageFavoriteButton extends StatelessWidget {
  const _ImageFavoriteButton({
    required this.isFavorite,
    required this.onTap,
  });

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isFavorite
              ? const Color(0xFFD4253A).withValues(alpha: 0.92)
              : Colors.black.withValues(alpha: 0.32),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}