enum ServiceType { offer, request } // Предложение услуги или запрос помощи

class ServiceItem {
  final String id;
  final String userName;
  final String userAvatar; // Ссылка на картинку
  final String title;      // Описание услуги/проблемы
  final String phoneNumber;
  final bool isPaid;       // Paid или Free на макете
  final ServiceType type;
  bool isFavorite;

  ServiceItem({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.title,
    required this.phoneNumber,
    required this.isPaid,
    required this.type,
    this.isFavorite = false,
  });
}