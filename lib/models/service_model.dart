enum ServiceType { offer, request } // Предложение услуги или запрос помощи

class ServiceItem {
  final String id;
  final String userName;
  final String userAvatar; // Ссылка на картинку
  final String title; // Описание услуги/проблемы
  final String phoneNumber;
  final bool isPaid; // Paid или Free на макете
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

  /// Читаем строки из Supabase (snake_case колонки)
  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id']?.toString() ?? '',
      userName: json['user_name'] ?? 'Unknown',
      userAvatar: json['user_avatar'] ?? '',
      title: json['title'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      isPaid: json['is_paid'] ?? false,
      type: json['type'] == 'request' ? ServiceType.request : ServiceType.offer,
      // isFavorite берётся из локального хранилища
      isFavorite: false,
    );
  }

  /// Подготавливаем Map для INSERT в Supabase
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_name': userName,
    'user_avatar': userAvatar,
    'title': title,
    'phone_number': phoneNumber,
    'is_paid': isPaid,
    'type': type == ServiceType.offer ? 'offer' : 'request',
  };
}
