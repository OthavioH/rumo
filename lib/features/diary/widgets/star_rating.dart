import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_images.dart';

class StarRating extends StatefulWidget {
  final void Function(double rating) onRatingChanged;
  final double? initialRating;
  const StarRating({required this.onRatingChanged, this.initialRating, super.key});

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  final double size = 32;
  double rating = 0;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating ?? 0;
  }

  void setRating(double newRating) {
    setState(() {
      rating = newRating;
    });
    widget.onRatingChanged(rating);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (var i = 1; i <= 5; i++) {
      stars.add(
        GestureDetector(
          onTapDown: (details) {
            double dx = details.localPosition.dx;
            double half = size / 2;
            if (dx <= half) {
              setRating(i - 0.5);
            } else {
              setRating(i.toDouble());
            }
          },
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: rating),
            duration: Duration(milliseconds: 150),
            builder: (context, value, _) {
              String asset = AssetImages.iconStar;
              if (value >= i) {
                asset = AssetImages.iconStar;
              } else if (value >= i - 0.5) {
                asset = AssetImages.iconHalfStar;
              } else {
                asset = AssetImages.iconStar;
              }
              return SvgPicture.asset(
                asset,
                width: size,
                height: size,
                colorFilter: value >= i
                    ? ColorFilter.mode(Color(0xFFFFCB45), BlendMode.srcIn)
                    : null,
              );
            },
          ),
        ),
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: stars);
  }
}
