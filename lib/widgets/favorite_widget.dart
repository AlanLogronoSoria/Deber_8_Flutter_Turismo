import 'package:flutter/material.dart';

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

class _FavoriteWidgetState extends State<FavoriteWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            widget.isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: widget.onChanged,
        ),
        Text('${widget.likes}'),
      ],
    );
  }
}