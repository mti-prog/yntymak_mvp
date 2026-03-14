import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/localization/app_localizations.dart';
import '../models/service_model.dart';
import '../providers/locale_provider/locale_provider.dart';
import '../providers/translation_provider/translation_provider.dart';
import '../screens/main_screens/detail_screen/service_details_screen.dart';

class ServiceGridCard extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback onFavoritePressed;
  final VoidCallback? onDelete;

  const ServiceGridCard({
    super.key,
    required this.service,
    required this.onFavoritePressed,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final translator = context.watch<TranslationProvider>();
    final title = translator.translate(service.title, locale);
    final description = translator.translate(service.description, locale);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsScreen(service: service),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.lightGreenBackGround,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + favorite
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Hero(
                  tag: 'image_${service.id}',
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: AppTheme.lightBlueBackground,
                    backgroundImage: service.userAvatar.isNotEmpty
                        ? NetworkImage(service.userAvatar)
                        : null,
                    child: service.userAvatar.isEmpty
                        ? Text(
                            service.userName.isNotEmpty
                                ? service.userName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.dark,
                            ),
                          )
                        : null,
                  ),
                ),
                GestureDetector(
                  onTap: onFavoritePressed,
                  child: Icon(
                    service.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: AppTheme.baseGreen,
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Title
            Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.dark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (service.isVerified) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.verified,
                    color: Color(0xFF1DA1F2),
                    size: 14,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),

            // Description
            if (description.isNotEmpty)
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: AppTheme.gray),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            const Spacer(),

            // Price + delete
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  service.price > 0
                      ? '${service.price} ${AppLocalizations.tr(context, 'som')}'
                      : AppLocalizations.tr(context, 'card_free'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: service.price > 0
                        ? const Color(0xFF2E7D32)
                        : AppTheme.dark,
                  ),
                ),
                if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
