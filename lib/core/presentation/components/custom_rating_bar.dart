import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies_app/core/resources/app_colors.dart';
import 'package:movies_app/core/resources/app_values.dart';




class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar({
    this.initialRating = 0.0,
    super.key,
    this.enableOnRating = false,
    this.onRatingUpdate,
    this.itemSize,
    this.allowHalfRating,
    this.maxRating,
    this.minRating = 0,
  });

  final double initialRating;
  final bool enableOnRating;
  final void Function(double)? onRatingUpdate;
  final double? itemSize;
  final bool? allowHalfRating;
  final double? maxRating;
  final double minRating;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: initialRating,
      direction: Axis.horizontal,
      allowHalfRating: allowHalfRating ?? true,
      itemCount: 10,
      maxRating: maxRating,
      minRating: minRating,
      ignoreGestures: !enableOnRating,
      itemSize: itemSize ?? 8,
      ratingWidget: RatingWidget(
        full: const Icon(
          Icons.star_rate_rounded,
          color: AppColors.ratingIconColor,
          size: AppSize.s18,
        ),
        half: const Icon(
          Icons.star_half_rounded,
          color: AppColors.ratingIconColor,
          size: AppSize.s18,
        ),
        empty: const Icon(
          Icons.star_rate_rounded,
          // color: AppColors.ratingIconColor,
          size: AppSize.s18,
        ),
      ),
      itemPadding: const EdgeInsets.symmetric(horizontal: 2),
      onRatingUpdate: onRatingUpdate ?? (rating) {},
    );
  }
}
