import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';
import '../../models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 画像
          Expanded(
            flex: responsive.isSmallScreen ? 4 : 5,
            child: restaurant.imageUrl != null
                ? Image.network(
                    restaurant.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildPlaceholder(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  )
                : _buildPlaceholder(),
          ),

          // 情報
          Expanded(
            flex: responsive.isSmallScreen ? 5 : 4,
            child: Padding(
              padding: EdgeInsets.all(responsive.isSmallScreen ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 店舗名
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      fontSize: responsive.scaledFontSize(20),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: responsive.isSmallScreen ? 4 : 8),

                  // ジャンル・予算
                  Chip(
                    label: Text(
                      restaurant.genre,
                      style: TextStyle(
                        fontSize: responsive.scaledFontSize(12),
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.isSmallScreen ? 4 : 8,
                    ),
                  ),
                  SizedBox(height: responsive.isSmallScreen ? 4 : 8),
                  Row(
                    children: [
                      Icon(
                        Icons.currency_yen,
                        size: responsive.isSmallScreen ? 14 : 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          restaurant.budget,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: responsive.scaledFontSize(14),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // 住所
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: responsive.isSmallScreen ? 14 : 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant.address,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: responsive.scaledFontSize(13),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder({Widget? child}) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: child ??
            const Icon(
              Icons.restaurant,
              size: 64,
              color: Colors.grey,
            ),
      ),
    );
  }
}
