import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/app_theme.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../models/service_model.dart';
import '../../../providers/locale_provider/locale_provider.dart';
import '../../../providers/service_provider/service_provider.dart';
import '../../../providers/translation_provider/translation_provider.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceItem service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    context.watch<LocaleProvider>();
    final locale = context.watch<LocaleProvider>().locale;
    final translator = context.watch<TranslationProvider>();

    final currentService = context.watch<ServiceProvider>().services.firstWhere(
      (s) => s.id == service.id,
    );

    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackGround,
      body: Column(
        children: [
          Stack(
            children: [
              Hero(
                tag: 'image_${service.id}',
                child: Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(service.userAvatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppTheme.lightGreenBackGround,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: Icon(
                          currentService.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: currentService.isFavorite
                              ? AppTheme.baseGreen
                              : AppTheme.baseGreen,
                          size: 30,
                        ),
                        onPressed: () {
                          context.read<ServiceProvider>().toggleFavorite(
                            service.id,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: AppTheme.lightGreenBackGround,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: service.type == ServiceType.offer
                            ? AppTheme.baseGreen
                            : AppTheme.baseGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        service.type == ServiceType.offer
                            ? AppLocalizations.tr(context, 'service_offer')
                            : AppLocalizations.tr(context, 'help_request'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppTheme.lightGreenBackGround,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      translator.translate(service.title, locale),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.dark,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      service.price > 0
                          ? '${service.price} ${AppLocalizations.tr(context, 'currency')}'
                          : AppLocalizations.tr(context, 'free'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: service.price > 0
                            ? const Color(0xFF2E7D32)
                            : AppTheme.gray,
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (service.description.isNotEmpty) ...[
                      Text(
                        AppLocalizations.tr(context, 'description_label'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.dark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        translator.translate(service.description, locale),
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.dark,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],

                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.dark,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.tr(context, 'from_label'),
                              style: const TextStyle(
                                color: AppTheme.gray,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              service.userName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.dark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
        decoration: BoxDecoration(color: AppTheme.lightGreenBackGround),
        child: ElevatedButton.icon(
          onPressed: () {
            _makePhoneCall(service.phoneNumber);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.dark,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          icon: const Icon(Icons.phone, color: AppTheme.lightGreenBackGround),
          label: Text(
            "${AppLocalizations.tr(context, 'call_btn')}  ${service.phoneNumber}",
            style: const TextStyle(
              color: AppTheme.lightGreenBackGround,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  try {
    await launchUrl(launchUri);
  } catch (e) {
    debugPrint('Could not launch $launchUri: $e');
  }
}
