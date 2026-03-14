import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/locale_provider/locale_provider.dart';
import '../login_sign_up/login_screen.dart';
import '../../models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Watch locale so we rebuild on change
    context.watch<LocaleProvider>();

    final titles = [
      AppLocalizations.tr(context, 'onboarding_title_1'),
      AppLocalizations.tr(context, 'onboarding_title_2'),
      AppLocalizations.tr(context, 'onboarding_title_3'),
    ];
    final descs = [
      AppLocalizations.tr(context, 'onboarding_desc_1'),
      AppLocalizations.tr(context, 'onboarding_desc_2'),
      AppLocalizations.tr(context, 'onboarding_desc_3'),
    ];

    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackGround,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(contents[index].image, height: 300),
                      const SizedBox(height: 40),
                      Text(
                        titles[index],
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(fontSize: 28, color: AppTheme.dark),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        descs[index],
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
              (index) => buildDot(index, context),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(40.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.baseGreenBackGround,
              ),
              onPressed: () async {
                if (_currentIndex < contents.length - 1) {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  final navigator = Navigator.of(context);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('showOnboarding', false);

                  if (mounted) {
                    navigator.pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                }
              },
              child: Text(
                style: TextStyle(color: AppTheme.baseGreen),
                _currentIndex == contents.length - 1
                    ? AppLocalizations.tr(context, 'get_started')
                    : AppLocalizations.tr(context, 'next'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentIndex == index ? AppTheme.baseGreen : AppTheme.gray,
      ),
    );
  }
}
