import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/localization/app_localizations.dart';
import '../models/service_model.dart';
import '../providers/locale_provider/locale_provider.dart';
import '../providers/translation_provider/translation_provider.dart';
import '../screens/main_screens/detail_screen/service_details_screen.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback onFavoritePressed;
  final VoidCallback? onDelete;

  const ServiceCard({
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
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightGreenBackGround,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'image_${service.id}',
              child: CircleAvatar(
                radius: 35,
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.dark,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.dark,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            if (service.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                color: Color(0xFF1DA1F2),
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              service.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppTheme.baseGreen,
                            ),
                            onPressed: onFavoritePressed,
                          ),
                          if (onDelete != null)
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: onDelete,
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.dark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.price > 0
                            ? '${service.price} ${AppLocalizations.tr(context, 'som')}'
                            : AppLocalizations.tr(context, 'card_free'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: service.price > 0
                              ? const Color(0xFF2E7D32)
                              : AppTheme.dark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.dark,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          service.phoneNumber,
                          style: const TextStyle(
                            color: AppTheme.lightBlueBackground,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
