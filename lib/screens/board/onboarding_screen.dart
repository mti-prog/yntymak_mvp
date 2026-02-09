import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_theme.dart';
import '../login_sign_up/login_screen.dart';
import '../../models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0; // Следим за текущей страницей

  @override
  Widget build(BuildContext context) {
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
                        contents[index].title,
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              fontSize: 28,
                              color: AppTheme.dark,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        contents[index].description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Индикатор (точки)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
              (index) => buildDot(index, context),
            ),
          ),

          // Кнопка перехода
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.baseGreenBackGround
              ),
              // Внутри метода onPressed кнопки на последнем слайде:
              onPressed: () async {
                if (_currentIndex < contents.length - 1) {
                  // Если страница НЕ последняя, просто листаем вперед
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // Если страница ПОСЛЕДНЯЯ, сохраняем настройки и выходим
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('showOnboarding', false);

                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                }
              },
              child: Text(
                style: TextStyle(color: AppTheme.baseGreen),
                _currentIndex == contents.length - 1 ? "Get Started" : "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Виджет одной точки индикатора
  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentIndex == index ? 25 : 10, // Активная точка длиннее
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentIndex == index
            ? AppTheme.baseGreen
            : AppTheme.gray,
      ),
    );
  }
}
