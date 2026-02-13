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
  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id']?.toString() ?? '',
      userName: json['userName'] ?? 'Unknown',
      userAvatar: json['userAvatar'] ?? '',
      title: json['title'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      isPaid: json['isPaid'] ?? false,
      // Превращаем строку в enum
      type: json['type'] == 'request'
          ? ServiceType.request
          : ServiceType.offer,
      // isFavorite обычно не приходит с сервера,
      // а берется из локальной памяти (SharedPreferences)
      isFavorite: false,
    );
  }
}
