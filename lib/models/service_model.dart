enum ServiceType { offer, request, volunteer, charity }

// ── Категории для Services ──────────────────────────────────────────────────
const Map<String, String> serviceCategories = {
  'repairs': '🔧 Домашний мастер',
  'construction': '🏗 Стройка и ремонт',
  'beauty': '💅 Красота и здоровье',
  'tutoring': '📚 Репетиторство',
  'it_digital': '💻 IT & Digital',
  'cleaning': '🧹 Уборка',
  'events': '🎉 Праздники',
};

// ── Категории для Help ──────────────────────────────────────────────────────
const Map<String, String> helpCategories = {
  'heavy_lifting': '💪 Физическая помощь',
  'borrow_lend': '🔄 Взаймы',
  'volunteering': '❤️ Волонтёрство',
  'transportation': '🚗 По пути',
  'advice': '💡 Советы',
  'lost_found': '🔍 Бюро находок',
  'giving_away': '🎁 Даром',
};

// ── Категории для Волонтёров ────────────────────────────────────────────────
const Map<String, String> volunteerCategories = {
  'ecology': '🌿 Экология',
  'animals': '🐾 Животные',
  'education': '📖 Образование',
  'social': '🤝 Социальная помощь',
  'medical': '🏥 Медицина',
  'events': '🎪 Мероприятия',
};

// ── Категории для Благотворительности ───────────────────────────────────────
const Map<String, String> charityCategories = {
  'treatment': '💊 Лечение',
  'orphanages': '🏠 Детские дома',
  'elderly': '👴 Пожилые люди',
  'animals': '🐕 Животные',
  'urgent': '🚨 Срочная помощь',
  'community': '🏘 Для сообщества',
};

class ServiceItem {
  final String id;
  final String userName;
  final String userAvatar;
  final String title;
  final String description;
  final String phoneNumber;
  final bool isPaid;
  final int price;
  final ServiceType type;
  final String? userId;
  final String category;
  final bool isVerified;
  bool isFavorite;

  ServiceItem({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.title,
    this.description = '',
    required this.phoneNumber,
    required this.isPaid,
    this.price = 0,
    required this.type,
    this.userId,
    this.category = 'other',
    this.isVerified = false,
    this.isFavorite = false,
  });

  /// Человекочитаемое название категории (fallback, русский)
  String get categoryLabel {
    switch (type) {
      case ServiceType.offer:
        return serviceCategories[category] ?? category;
      case ServiceType.request:
        return helpCategories[category] ?? category;
      case ServiceType.volunteer:
        return volunteerCategories[category] ?? category;
      case ServiceType.charity:
        return charityCategories[category] ?? category;
    }
  }

  static ServiceType _parseType(String? typeStr) {
    switch (typeStr) {
      case 'request':
        return ServiceType.request;
      case 'volunteer':
        return ServiceType.volunteer;
      case 'charity':
        return ServiceType.charity;
      default:
        return ServiceType.offer;
    }
  }

  static String _typeToString(ServiceType type) {
    switch (type) {
      case ServiceType.offer:
        return 'offer';
      case ServiceType.request:
        return 'request';
      case ServiceType.volunteer:
        return 'volunteer';
      case ServiceType.charity:
        return 'charity';
    }
  }

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    final price = json['price'] as int? ?? 0;
    return ServiceItem(
      id: json['id']?.toString() ?? '',
      userName: json['user_name'] ?? 'Unknown',
      userAvatar: json['user_avatar'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      isPaid: price > 0,
      price: price,
      type: _parseType(json['type']),
      userId: json['user_id']?.toString(),
      category: json['category'] ?? 'other',
      isVerified: json['is_verified'] == true,
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_name': userName,
    'user_avatar': userAvatar,
    'title': title,
    'description': description,
    'phone_number': phoneNumber,
    'is_paid': isPaid,
    'price': price,
    'type': _typeToString(type),
    'category': category,
    'is_verified': isVerified,
    if (userId != null) 'user_id': userId,
  };
}
