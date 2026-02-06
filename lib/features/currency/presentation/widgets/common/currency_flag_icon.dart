import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CurrencyFlagIcon extends StatelessWidget {
  final String countryCode;

  const CurrencyFlagIcon({super.key, required this.countryCode});

  @override
  Widget build(BuildContext context) {
    final lowerCaseCode = countryCode.toLowerCase();
    final flagUrl = "https://flagcdn.com/w40/$lowerCaseCode.png";

    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: CachedNetworkImage(
        imageUrl: flagUrl,
        width: 40.0,
        height: 30.0,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => const Icon(
          Icons.flag,
          size: 16.0,
        ),
      ),
    );
  }
}