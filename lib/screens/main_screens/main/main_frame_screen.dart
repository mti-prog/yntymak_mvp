import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/locale_provider/locale_provider.dart';
import '../favorites/favorites_screen.dart';
import '../help/help_screen.dart';
import '../profile/profile_screen.dart';
import '../services/services_screen.dart';
import '../volunteer/volunteer_screen.dart';
import '../charity/charity_screen.dart';

class MainFrameScreen extends StatefulWidget {
  const MainFrameScreen({super.key});

  @override
  State<MainFrameScreen> createState() => _MainFrameScreenState();
}

class _MainFrameScreenState extends State<MainFrameScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isVolunteer = auth.isVolunteerMode;
    context.watch<LocaleProvider>();

    return Scaffold(
      body: _buildPage(_selectedIndex, isVolunteer),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isVolunteer
            ? AppTheme.orgPurpleLight
            : AppTheme.lightGreenBackGround,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: isVolunteer
            ? AppTheme.orgPurple
            : AppTheme.baseGreen,
        unselectedItemColor: AppTheme.gray,
        items: [
          BottomNavigationBarItem(
            icon: Icon(isVolunteer ? Icons.volunteer_activism : Icons.home),
            label: isVolunteer
                ? AppLocalizations.tr(context, 'nav_volunteers')
                : AppLocalizations.tr(context, 'nav_services'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              isVolunteer ? Icons.favorite_border : Icons.help_outline,
            ),
            label: isVolunteer
                ? AppLocalizations.tr(context, 'nav_charity')
                : AppLocalizations.tr(context, 'nav_help'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark_border),
            label: AppLocalizations.tr(context, 'nav_favorites'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: AppLocalizations.tr(context, 'nav_profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index, bool isVolunteer) {
    switch (index) {
      case 0:
        return isVolunteer ? const VolunteerScreen() : const ServiceScreen();
      case 1:
        return isVolunteer ? const CharityScreen() : const HelpRequestsScreen();
      case 2:
        return const FavoritesScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const ServiceScreen();
    }
  }
}
