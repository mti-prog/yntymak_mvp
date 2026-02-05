class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

// Сразу подготовим список данных из твоих макетов
List<OnboardingContent> contents = [
  OnboardingContent(
    image: 'assets/images/onboarding_first.png',
    title: 'Find People',
    description: 'Discover people who are ready to help or need your services right now.',
  ),
  OnboardingContent(
    image: 'assets/images/onboarding_second.png',
    title: 'Share Help',
    description: 'Offer your skills and help others in your community for a reward.',
  ),
  OnboardingContent(
    image: 'assets/images/onboarding_third.png',
    title: 'Easy Communication',
    description: 'Contact users directly and solve problems together through our platform.',
  ),
];