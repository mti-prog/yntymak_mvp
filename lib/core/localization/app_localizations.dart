import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider/locale_provider.dart';

class AppLocalizations {
  /// Get translated string by key
  static String tr(BuildContext context, String key) {
    final locale = context.read<LocaleProvider>().locale;
    return _translations[key]?[locale] ?? _translations[key]?['en'] ?? key;
  }

  /// Get translated category map
  static Map<String, String> categories(BuildContext context, String mapName) {
    final locale = context.read<LocaleProvider>().locale;
    return _categoryMaps[mapName]?[locale] ??
        _categoryMaps[mapName]?['en'] ??
        {};
  }

  /// All key category chip label
  static String allChip(BuildContext context, String emoji) {
    final locale = context.read<LocaleProvider>().locale;
    final word = {'en': 'All', 'ru': 'Все', 'ky': 'Баары'}[locale] ?? 'All';
    return '$emoji $word';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSLATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, Map<String, String>> _translations = {
    // ── Onboarding ──────────────────────────────────────────────────────────
    'onboarding_title_1': {
      'en': 'Find People',
      'ru': 'Найди людей',
      'ky': 'Адамдарды тап',
    },
    'onboarding_desc_1': {
      'en':
          'Discover people who are ready to help or need your services right now.',
      'ru':
          'Находите людей, которые готовы помочь или нуждаются в ваших услугах.',
      'ky':
          'Жардам берүүгө даяр же сиздин кызматтарыңызга муктаж адамдарды табыңыз.',
    },
    'onboarding_title_2': {
      'en': 'Share Help',
      'ru': 'Делитесь помощью',
      'ky': 'Жардам бөлүшүңүз',
    },
    'onboarding_desc_2': {
      'en': 'Offer your skills and help others in your community for a reward.',
      'ru':
          'Предлагайте свои навыки и помогайте другим в вашем сообществе за вознаграждение.',
      'ky':
          'Өз жөндөмүңүздү сунуштаңыз жана коомчулукта башкаларга жардам бериңиз.',
    },
    'onboarding_title_3': {
      'en': 'Easy Communication',
      'ru': 'Простое общение',
      'ky': 'Жеңил байланыш',
    },
    'onboarding_desc_3': {
      'en':
          'Contact users directly and solve problems together through our platform.',
      'ru': 'Связывайтесь с пользователями напрямую и решайте проблемы вместе.',
      'ky': 'Колдонуучулар менен түз байланышып, маселелерди чогуу чечиңиз.',
    },
    'get_started': {'en': 'Get Started', 'ru': 'Начать', 'ky': 'Баштоо'},
    'next': {'en': 'Next', 'ru': 'Далее', 'ky': 'Кийинки'},

    // ── Login ────────────────────────────────────────────────────────────────
    'welcome_back': {
      'en': 'Welcome\nBack!',
      'ru': 'С возвращением!',
      'ky': 'Кайра\nкелиңиз!',
    },
    'email': {
      'en': 'Email',
      'ru': 'Электронная почта',
      'ky': 'Электрондук почта',
    },
    'password': {'en': 'Password', 'ru': 'Пароль', 'ky': 'Сыр сөз'},
    'forgot_password': {
      'en': 'Forgot Password?',
      'ru': 'Забыли пароль?',
      'ky': 'Сыр сөздү унуттуңузбу?',
    },
    'login': {'en': 'Login', 'ru': 'Войти', 'ky': 'Кирүү'},
    'create_an_account': {
      'en': 'Create An Account ',
      'ru': 'Создать аккаунт ',
      'ky': 'Аккаунт түзүү ',
    },
    'sign_up': {'en': 'Sign Up', 'ru': 'Регистрация', 'ky': 'Катталуу'},
    'fill_all_fields': {
      'en': 'Please fill in all fields',
      'ru': 'Пожалуйста, заполните все поля',
      'ky': 'Бардык талааларды толтуруңуз',
    },

    // ── Sign Up ──────────────────────────────────────────────────────────────
    'create_account_title': {
      'en': 'Create an\naccount',
      'ru': 'Создайте\nаккаунт',
      'ky': 'Аккаунт\nтүзүңүз',
    },
    'user': {'en': 'User', 'ru': 'Пользователь', 'ky': 'Колдонуучу'},
    'organization': {'en': 'Organization', 'ru': 'Организация', 'ky': 'Уюм'},
    'org_name': {
      'en': 'Organization Name',
      'ru': 'Название организации',
      'ky': 'Уюмдун аты',
    },
    'your_name': {'en': 'Your Name', 'ru': 'Ваше имя', 'ky': 'Сиздин атыңыз'},
    'phone_number': {
      'en': 'Phone Number',
      'ru': 'Номер телефона',
      'ky': 'Телефон номери',
    },
    'confirm_password': {
      'en': 'Confirm Password',
      'ru': 'Подтвердите пароль',
      'ky': 'Сыр сөздү ырастаңыз',
    },
    'agree_terms': {
      'en': 'By clicking the Register button, you agree\nto the public offer',
      'ru': 'Нажимая кнопку Регистрация, вы соглашаетесь\nс публичной офертой',
      'ky':
          'Катталуу баскычын басуу менен сиз\nжалпыга маалымдоо менен макулдашасыз',
    },
    'register': {'en': 'Register', 'ru': 'Регистрация', 'ky': 'Катталуу'},
    'already_have_account': {
      'en': 'I Already Have an Account ',
      'ru': 'У меня есть аккаунт ',
      'ky': 'Менин аккаунтум бар ',
    },
    'passwords_no_match': {
      'en': 'Passwords do not match!',
      'ru': 'Пароли не совпадают!',
      'ky': 'Сыр сөздөр дал келбейт!',
    },
    'password_min_length': {
      'en': 'Password must be at least 6 characters',
      'ru': 'Пароль должен быть не менее 6 символов',
      'ky': 'Сыр сөз жок дегенде 6 белгиден турушу керек',
    },

    // ── Forgot Password ──────────────────────────────────────────────────────
    'forgot_password_title': {
      'en': 'Forgot\npassword?',
      'ru': 'Забыли\nпароль?',
      'ky': 'Сыр сөздү\nунуттуңузбу?',
    },
    'reset_info': {
      'en': '* We will send you a message to set or reset\nyour new password',
      'ru': '* Мы отправим вам сообщение для установки\nили сброса пароля',
      'ky':
          '* Жаңы сыр сөзүңүздү коюу же\nкалыбына келтирүү үчүн билдирүү жөнөтөбүз',
    },
    'submit': {'en': 'Submit', 'ru': 'Отправить', 'ky': 'Жөнөтүү'},
    'reset_link_sent': {
      'en': 'Reset link sent to your phone!',
      'ru': 'Ссылка для сброса отправлена!',
      'ky': 'Калыбына келтирүү шилтемеси жөнөтүлдү!',
    },

    // ── Navigation ──────────────────────────────────────────────────────────
    'nav_services': {'en': 'Services', 'ru': 'Услуги', 'ky': 'Кызматтар'},
    'nav_help': {'en': 'Help', 'ru': 'Помощь', 'ky': 'Жардам'},
    'nav_volunteers': {
      'en': 'Volunteers',
      'ru': 'Волонтёры',
      'ky': 'Волонтёрлор',
    },
    'nav_charity': {
      'en': 'Charity',
      'ru': 'Благотворительность',
      'ky': 'Кайрымдуулук',
    },
    'nav_favorites': {
      'en': 'Favorites',
      'ru': 'Избранные',
      'ky': 'Тандалмалар',
    },
    'nav_profile': {'en': 'Profile', 'ru': 'Профиль', 'ky': 'Профиль'},

    // ── Services Screen ─────────────────────────────────────────────────────
    'services_title': {'en': 'Services', 'ru': 'Услуги', 'ky': 'Кызматтар'},
    'search_services': {
      'en': 'Search for services...',
      'ru': 'Поиск услуг...',
      'ky': 'Кызматтарды издөө...',
    },
    'no_services': {
      'en': 'No services available',
      'ru': 'Нет доступных услуг',
      'ky': 'Кызматтар жок',
    },

    // ── Help Screen ─────────────────────────────────────────────────────────
    'help_title': {
      'en': 'Help Requests',
      'ru': 'Запросы помощи',
      'ky': 'Жардам сурамдары',
    },
    'search_help': {
      'en': 'Search for help requests...',
      'ru': 'Поиск запросов помощи...',
      'ky': 'Жардам сурамдарын издөө...',
    },
    'no_help': {
      'en': 'No help requests available',
      'ru': 'Нет запросов помощи',
      'ky': 'Жардам сурамдары жок',
    },

    // ── Volunteers Screen ───────────────────────────────────────────────────
    'volunteers_title': {
      'en': 'Volunteers',
      'ru': 'Волонтёры',
      'ky': 'Волонтёрлор',
    },
    'search_volunteers': {
      'en': 'Search for volunteers...',
      'ru': 'Поиск волонтёров...',
      'ky': 'Волонтёрлорду издөө...',
    },
    'no_volunteers': {
      'en': 'No volunteer posts yet',
      'ru': 'Нет постов волонтёров',
      'ky': 'Волонтёр посттору жок',
    },

    // ── Charity Screen ──────────────────────────────────────────────────────
    'charity_title': {
      'en': 'Charity',
      'ru': 'Благотворительность',
      'ky': 'Кайрымдуулук',
    },
    'search_charity': {
      'en': 'Search charity posts...',
      'ru': 'Поиск благотворительных постов...',
      'ky': 'Кайрымдуулук посттарын издөө...',
    },
    'no_charity': {
      'en': 'No charity posts yet',
      'ru': 'Нет благотворительных постов',
      'ky': 'Кайрымдуулук посттору жок',
    },

    // ── Favorites Screen ────────────────────────────────────────────────────
    'favourites_title': {
      'en': 'Favourites',
      'ru': 'Избранные',
      'ky': 'Тандалмалар',
    },
    'search_favourites': {
      'en': 'Search favourites...',
      'ru': 'Поиск в избранных...',
      'ky': 'Тандалмалардан издөө...',
    },
    'tab_services': {'en': 'Services', 'ru': 'Услуги', 'ky': 'Кызматтар'},
    'tab_help': {'en': 'Help', 'ru': 'Помощь', 'ky': 'Жардам'},
    'tab_volunteers': {
      'en': 'Volunteers',
      'ru': 'Волонтёры',
      'ky': 'Волонтёрлор',
    },
    'tab_charity': {
      'en': 'Charity',
      'ru': 'Благотворительность',
      'ky': 'Кайрымдуулук',
    },
    'no_fav_services': {
      'en': 'No favourite services',
      'ru': 'Нет избранных услуг',
      'ky': 'Тандалма кызматтар жок',
    },
    'no_fav_help': {
      'en': 'No favourite help requests',
      'ru': 'Нет избранных запросов помощи',
      'ky': 'Тандалма жардам сурамдары жок',
    },
    'no_fav_volunteers': {
      'en': 'No favourite volunteer posts',
      'ru': 'Нет избранных волонтёрских постов',
      'ky': 'Тандалма волонтёр посттору жок',
    },
    'no_fav_charity': {
      'en': 'No favourite charity posts',
      'ru': 'Нет избранных благотворительных постов',
      'ky': 'Тандалма кайрымдуулук посттору жок',
    },

    // ── Profile Screen ──────────────────────────────────────────────────────
    'profile_title': {'en': 'Profile', 'ru': 'Профиль', 'ky': 'Профиль'},
    'tab_my_services': {
      'en': 'My Services',
      'ru': 'Мои услуги',
      'ky': 'Менин кызматтарым',
    },
    'tab_help_requests': {
      'en': 'Help Requests',
      'ru': 'Запросы помощи',
      'ky': 'Жардам сурамдары',
    },
    'search_your_posts': {
      'en': 'Search your posts...',
      'ru': 'Поиск своих постов...',
      'ky': 'Посттарды издөө...',
    },
    'no_services_yet': {
      'en': 'You have no services yet',
      'ru': 'У вас пока нет услуг',
      'ky': 'Сизде азырынча кызматтар жок',
    },
    'no_help_yet': {
      'en': 'You have no help requests yet',
      'ru': 'У вас пока нет запросов помощи',
      'ky': 'Сизде азырынча жардам сурамдары жок',
    },
    'no_volunteers_yet': {
      'en': 'You have no volunteer posts yet',
      'ru': 'У вас пока нет волонтёрских постов',
      'ky': 'Сизде азырынча волонтёр посттору жок',
    },
    'no_charity_yet': {
      'en': 'You have no charity posts yet',
      'ru': 'У вас пока нет благотворительных постов',
      'ky': 'Сизде азырынча кайрымдуулук посттору жок',
    },
    'delete_post': {
      'en': 'Delete post',
      'ru': 'Удалить пост',
      'ky': 'Постту жок кылуу',
    },
    'delete_confirm': {
      'en': 'Are you sure you want to delete this post?',
      'ru': 'Вы уверены, что хотите удалить этот пост?',
      'ky': 'Бул постту жок кылууну каалайсызбы?',
    },
    'cancel': {'en': 'Cancel', 'ru': 'Отмена', 'ky': 'Жокко чыгаруу'},
    'delete': {'en': 'Delete', 'ru': 'Удалить', 'ky': 'Жок кылуу'},
    'logout': {'en': 'Logout', 'ru': 'Выход', 'ky': 'Чыгуу'},
    'logout_confirm': {
      'en': 'Are you sure you want to exit?',
      'ru': 'Вы уверены, что хотите выйти?',
      'ky': 'Чыгууну каалайсызбы?',
    },
    'exit': {'en': 'Exit', 'ru': 'Выйти', 'ky': 'Чыгуу'},
    'org_label': {
      'en': '🏠 Organization',
      'ru': '🏠 Организация',
      'ky': '🏠 Уюм',
    },
    'volunteer_mode': {
      'en': 'Volunteer Mode',
      'ru': 'Режим волонтёра',
      'ky': 'Волонтёр режими',
    },
    'switch_account': {
      'en': 'Switch Account',
      'ru': 'Сменить аккаунт',
      'ky': 'Аккаунтту алмаштыруу',
    },
    'no_saved_accounts': {
      'en': 'No saved accounts',
      'ru': 'Нет сохранённых аккаунтов',
      'ky': 'Сакталган аккаунттар жок',
    },
    'add_another_account': {
      'en': 'Add another account',
      'ru': 'Добавить другой аккаунт',
      'ky': 'Башка аккаунт кошуу',
    },
    'language': {'en': 'Language', 'ru': 'Язык', 'ky': 'Тил'},
    'error_upload_photo': {
      'en': 'Error uploading photo: ',
      'ru': 'Ошибка загрузки фото: ',
      'ky': 'Сүрөт жүктөөдө ката: ',
    },

    // ── Add Post Screen ─────────────────────────────────────────────────────
    'add_service': {
      'en': 'Add Service',
      'ru': 'Добавить услугу',
      'ky': 'Кызмат кошуу',
    },
    'add_help_request': {
      'en': 'Add Help Request',
      'ru': 'Добавить запрос помощи',
      'ky': 'Жардам сурамын кошуу',
    },
    'find_volunteers': {
      'en': 'Find Volunteers',
      'ru': 'Найти волонтёров',
      'ky': 'Волонтёрлорду табуу',
    },
    'add_charity_post': {
      'en': 'Add Charity Post',
      'ru': 'Добавить благотворительный пост',
      'ky': 'Кайрымдуулук постун кошуу',
    },
    'add_help_short': {'en': 'Add Help', 'ru': 'Помощь', 'ky': 'Жардам'},
    'volunteer_short': {'en': 'Volunteer', 'ru': 'Волонтёр', 'ky': 'Волонтёр'},
    'charity_short': {
      'en': 'Charity',
      'ru': 'Благотворительность',
      'ky': 'Кайрымдуулук',
    },
    'field_title': {'en': 'Title', 'ru': 'Название', 'ky': 'Аталышы'},
    'field_title_hint': {
      'en': 'Short post title',
      'ru': 'Краткое название поста',
      'ky': 'Посттун кыскача аталышы',
    },
    'field_desc': {'en': 'Description', 'ru': 'Описание', 'ky': 'Сүрөттөмө'},
    'field_desc_hint': {
      'en': 'Detailed description...',
      'ru': 'Подробное описание...',
      'ky': 'Толук сүрөттөмө...',
    },
    'field_price_hint': {
      'en': 'Price / budget (0 = free)',
      'ru': 'Цена / бюджет (0 = бесплатно)',
      'ky': 'Баа / бюджет (0 = бекер)',
    },
    'currency': {'en': 'som', 'ru': 'сом', 'ky': 'сом'},
    'select_category': {
      'en': 'Select category',
      'ru': 'Выберите категорию',
      'ky': 'Категория тандаңыз',
    },
    'publish': {'en': 'Publish', 'ru': 'Опубликовать', 'ky': 'Жарыялоо'},
    'enter_title': {
      'en': 'Please enter a title',
      'ru': 'Введите название',
      'ky': 'Аталышын жазыңыз',
    },
    'select_category_err': {
      'en': 'Please select a category',
      'ru': 'Выберите категорию',
      'ky': 'Категория тандаңыз',
    },
    'publish_fail': {
      'en': 'Failed to publish: ',
      'ru': 'Ошибка публикации: ',
      'ky': 'Жарыялоо катасы: ',
    },

    // ── Details Screen ──────────────────────────────────────────────────────
    'service_offer': {
      'en': 'Service Offer',
      'ru': 'Предложение услуги',
      'ky': 'Кызмат сунушу',
    },
    'help_request': {
      'en': 'Help Request',
      'ru': 'Запрос помощи',
      'ky': 'Жардам сурамы',
    },
    'free': {'en': 'Free', 'ru': 'Бесплатно', 'ky': 'Бекер'},
    'description_label': {
      'en': 'Description',
      'ru': 'Описание',
      'ky': 'Сүрөттөмө',
    },
    'from_label': {'en': 'From', 'ru': 'От', 'ky': 'Жазган'},
    'call_btn': {'en': 'Call', 'ru': 'Позвонить', 'ky': 'Чалуу'},

    // ── Cards ────────────────────────────────────────────────────────────────
    'som': {'en': 'som', 'ru': 'сом', 'ky': 'сом'},
    'card_free': {'en': 'Free', 'ru': 'Бесплатно', 'ky': 'Бекер'},
    'error': {'en': 'Error: ', 'ru': 'Ошибка: ', 'ky': 'Ката: '},
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY MAPS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, Map<String, Map<String, String>>> _categoryMaps = {
    'service': {
      'en': {
        'repairs': '🔧 Home Repair',
        'construction': '🏗 Construction',
        'beauty': '💅 Beauty & Health',
        'tutoring': '📚 Tutoring',
        'it_digital': '💻 IT & Digital',
        'cleaning': '🧹 Cleaning',
        'events': '🎉 Events',
      },
      'ru': {
        'repairs': '🔧 Домашний мастер',
        'construction': '🏗 Стройка и ремонт',
        'beauty': '💅 Красота и здоровье',
        'tutoring': '📚 Репетиторство',
        'it_digital': '💻 IT & Digital',
        'cleaning': '🧹 Уборка',
        'events': '🎉 Праздники',
      },
      'ky': {
        'repairs': '🔧 Үй чебери',
        'construction': '🏗 Курулуш',
        'beauty': '💅 Сулуулук жана ден соолук',
        'tutoring': '📚 Репетиторлук',
        'it_digital': '💻 IT & Digital',
        'cleaning': '🧹 Тазалоо',
        'events': '🎉 Майрамдар',
      },
    },
    'help': {
      'en': {
        'heavy_lifting': '💪 Physical Help',
        'borrow_lend': '🔄 Borrow/Lend',
        'volunteering': '❤️ Volunteering',
        'transportation': '🚗 Ride Share',
        'advice': '💡 Advice',
        'lost_found': '🔍 Lost & Found',
        'giving_away': '🎁 Giving Away',
      },
      'ru': {
        'heavy_lifting': '💪 Физическая помощь',
        'borrow_lend': '🔄 Взаймы',
        'volunteering': '❤️ Волонтёрство',
        'transportation': '🚗 По пути',
        'advice': '💡 Советы',
        'lost_found': '🔍 Бюро находок',
        'giving_away': '🎁 Даром',
      },
      'ky': {
        'heavy_lifting': '💪 Физикалык жардам',
        'borrow_lend': '🔄 Карызга',
        'volunteering': '❤️ Волонтёрлук',
        'transportation': '🚗 Жолдо',
        'advice': '💡 Кеңештер',
        'lost_found': '🔍 Табылга бюросу',
        'giving_away': '🎁 Бекер берүү',
      },
    },
    'volunteer': {
      'en': {
        'ecology': '🌿 Ecology',
        'animals': '🐾 Animals',
        'education': '📖 Education',
        'social': '🤝 Social Help',
        'medical': '🏥 Medical',
        'events': '🎪 Events',
      },
      'ru': {
        'ecology': '🌿 Экология',
        'animals': '🐾 Животные',
        'education': '📖 Образование',
        'social': '🤝 Социальная помощь',
        'medical': '🏥 Медицина',
        'events': '🎪 Мероприятия',
      },
      'ky': {
        'ecology': '🌿 Экология',
        'animals': '🐾 Жаныбарлар',
        'education': '📖 Билим берүү',
        'social': '🤝 Социалдык жардам',
        'medical': '🏥 Медицина',
        'events': '🎪 Иш-чаралар',
      },
    },
    'charity': {
      'en': {
        'treatment': '💊 Treatment',
        'orphanages': '🏠 Orphanages',
        'elderly': '👴 Elderly',
        'animals': '🐕 Animals',
        'urgent': '🚨 Urgent Help',
        'community': '🏘 Community',
      },
      'ru': {
        'treatment': '💊 Лечение',
        'orphanages': '🏠 Детские дома',
        'elderly': '👴 Пожилые люди',
        'animals': '🐕 Животные',
        'urgent': '🚨 Срочная помощь',
        'community': '🏘 Для сообщества',
      },
      'ky': {
        'treatment': '💊 Дарылоо',
        'orphanages': '🏠 Балдар үйлөрү',
        'elderly': '👴 Карылар',
        'animals': '🐕 Жаныбарлар',
        'urgent': '🚨 Шашылыш жардам',
        'community': '🏘 Коомчулук үчүн',
      },
    },
  };
}
