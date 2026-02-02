import '../models/service_model.dart';

class MockData {
  static List<ServiceItem> getMockServices() {
    return [
      ServiceItem(
        id: '1',
        userName: 'Alex Ivanov',
        userAvatar: 'https://i.pravatar.cc/150?u=1',
        title: 'Tutoring. I can help with math, science and school homework',
        phoneNumber: '+996 706 785 768',
        isPaid: false,
        type: ServiceType.offer,
      ),
      ServiceItem(
        id: '2',
        userName: 'Anna Sokolova',
        userAvatar: 'https://i.pravatar.cc/150?u=2',
        title: 'I can help elderly and busy people with grocery shopping and delivery',
        phoneNumber: '+996 706 785 768',
        isPaid: false,
        type: ServiceType.offer,
      ),
    ];
  }
}