import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../models/service_model.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/locale_provider/locale_provider.dart';
import '../../../providers/service_provider/service_provider.dart';
import '../../../providers/volunteer_provider/volunteer_provider.dart';
import '../../../widgets/service_card.dart';
import '../../../widgets/service_grid_card.dart';
import '../../../widgets/help_card.dart';
import '../../../widgets/help_grid_card.dart';
import '../../login_sign_up/login_screen.dart';
import '../add_post_screen/add_post_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  List<ServiceItem> _filter(List<ServiceItem> items) {
    if (_searchQuery.isEmpty) return items;
    return items
        .where(
          (s) =>
              s.title.toLowerCase().contains(_searchQuery) ||
              s.description.toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final serviceProvider = context.watch<ServiceProvider>();
    context.watch<LocaleProvider>();

    return Scaffold(
      backgroundColor: auth.isOrganization
          ? AppTheme.orgBackground
          : AppTheme.lightBlueBackground,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.tr(context, 'profile_title'),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.dark,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    serviceProvider.toggleProfileGrid(),
                                icon: Icon(
                                  serviceProvider.isProfileGrid
                                      ? Icons.view_list_rounded
                                      : Icons.grid_view_rounded,
                                  color: AppTheme.dark,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _showSwitchAccountSheet(context, auth),
                                icon: const Icon(
                                  Icons.swap_horiz_rounded,
                                  color: AppTheme.dark,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _showLogoutDialog(context, auth),
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Avatar
                      GestureDetector(
                        onTap: () => _pickAvatar(context, auth),
                        child: Center(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppTheme.lightGreenBackGround,
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundColor:
                                      AppTheme.lightGreenBackGround,
                                  backgroundImage: auth.avatarUrl != null
                                      ? NetworkImage(auth.avatarUrl!)
                                      : null,
                                  child: auth.avatarUrl == null
                                      ? Text(
                                          auth.userName.isNotEmpty
                                              ? auth.userName[0].toUpperCase()
                                              : 'U',
                                          style: const TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.dark,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.dark,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme.lightBlueBackground,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Name & contacts
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            auth.userName,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.dark,
                            ),
                          ),
                          if (auth.isVerified) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified,
                              color: Color(0xFF1DA1F2),
                              size: 24,
                            ),
                          ],
                        ],
                      ),
                      if (auth.isOrganization) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.orgPurpleLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            AppLocalizations.tr(context, 'org_label'),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7B1FA2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        auth.userEmail,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.gray,
                        ),
                      ),
                      if (auth.userPhone.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          auth.userPhone,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.gray,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Volunteer mode toggle (only for regular users)
                      if (!auth.isOrganization) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            title: Text(
                              '🤝 ${AppLocalizations.tr(context, 'volunteer_mode')}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.dark,
                              ),
                            ),
                            value: auth.isVolunteerMode,
                            activeThumbColor: AppTheme.orgPurple,
                            onChanged: (_) => auth.toggleVolunteerMode(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      // ── Language Selector ──────────────────────
                      _buildLanguageSelector(context),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // TabBar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.dark,
                    unselectedLabelColor: AppTheme.gray,
                    indicatorColor: auth.isOrganization
                        ? AppTheme.orgPurple
                        : AppTheme.baseGreen,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(fontSize: 16),
                    tabs: [
                      Tab(
                        text: auth.isOrganization
                            ? AppLocalizations.tr(context, 'tab_volunteers')
                            : AppLocalizations.tr(context, 'tab_my_services'),
                      ),
                      Tab(
                        text: auth.isOrganization
                            ? AppLocalizations.tr(context, 'tab_charity')
                            : AppLocalizations.tr(context, 'tab_help_requests'),
                      ),
                    ],
                  ),
                  auth.isOrganization
                      ? AppTheme.orgBackground
                      : AppTheme.lightBlueBackground,
                ),
              ),
            ];
          },
          body: Column(
            children: [
              // Search bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                decoration: BoxDecoration(
                  color: auth.isOrganization
                      ? AppTheme.orgPurpleLight
                      : AppTheme.lightGreenBackGround,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  onChanged: (q) =>
                      setState(() => _searchQuery = q.trim().toLowerCase()),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.tr(context, 'search_your_posts'),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.gray),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              Expanded(
                child: auth.isOrganization
                    ? _buildOrgTabView(context, auth)
                    : _buildUserTabView(context, auth, serviceProvider),
              ),
            ],
          ),
        ),
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final PostType type;
          if (auth.isOrganization) {
            type = _tabController.index == 0
                ? PostType.volunteer
                : PostType.charity;
          } else {
            type = _tabController.index == 0 ? PostType.service : PostType.help;
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddPostScreen(type: type)),
          );
        },
        backgroundColor: auth.isOrganization
            ? AppTheme.orgPurple
            : AppTheme.baseGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ── Language Selector ─────────────────────────────────────────────────────────

  Widget _buildLanguageSelector(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final current = locale.locale;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.language, color: AppTheme.dark, size: 22),
          const SizedBox(width: 12),
          Text(
            AppLocalizations.tr(context, 'language'),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.dark,
            ),
          ),
          const Spacer(),
          _langButton(locale, current, 'ru', '🇷🇺', 'RU'),
          const SizedBox(width: 6),
          _langButton(locale, current, 'ky', '🇰🇬', 'KG'),
          const SizedBox(width: 6),
          _langButton(locale, current, 'en', '🇬🇧', 'EN'),
        ],
      ),
    );
  }

  Widget _langButton(
    LocaleProvider provider,
    String current,
    String code,
    String flag,
    String label,
  ) {
    final selected = current == code;
    return GestureDetector(
      onTap: () => provider.setLocale(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.dark : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '$flag $label',
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? Colors.white : AppTheme.dark,
          ),
        ),
      ),
    );
  }

  // ── User tabs (Services / Help) ─────────────────────────────────────────────

  Widget _buildUserTabView(
    BuildContext context,
    AuthProvider auth,
    ServiceProvider provider,
  ) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTabContent(
          items: _filter(provider.userOffers(auth.userId)),
          isGrid: provider.isProfileGrid,
          emptyText: AppLocalizations.tr(context, 'no_services_yet'),
          isService: true,
          onFav: provider.toggleFavorite,
          onDelete: (id) => _confirmDelete(context, id, isVolunteer: false),
        ),
        _buildTabContent(
          items: _filter(provider.userRequests(auth.userId)),
          isGrid: provider.isProfileGrid,
          emptyText: AppLocalizations.tr(context, 'no_help_yet'),
          isService: false,
          onFav: provider.toggleFavorite,
          onDelete: (id) => _confirmDelete(context, id, isVolunteer: false),
        ),
      ],
    );
  }

  // ── Org tabs (Volunteers / Charity) ─────────────────────────────────────────

  Widget _buildOrgTabView(BuildContext context, AuthProvider auth) {
    final provider = context.watch<VolunteerProvider>();
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTabContent(
          items: _filter(provider.userVolunteers(auth.userId)),
          isGrid: provider.isVolunteerGrid,
          emptyText: AppLocalizations.tr(context, 'no_volunteers_yet'),
          isService: true,
          onFav: provider.toggleFavorite,
          onDelete: (id) => _confirmDelete(context, id, isVolunteer: true),
        ),
        _buildTabContent(
          items: _filter(provider.userCharity(auth.userId)),
          isGrid: provider.isCharityGrid,
          emptyText: AppLocalizations.tr(context, 'no_charity_yet'),
          isService: false,
          onFav: provider.toggleFavorite,
          onDelete: (id) => _confirmDelete(context, id, isVolunteer: true),
        ),
      ],
    );
  }

  // ── Tab content ─────────────────────────────────────────────────────────────

  Widget _buildTabContent({
    required List<ServiceItem> items,
    required bool isGrid,
    required String emptyText,
    required bool isService,
    required void Function(String) onFav,
    required void Function(String) onDelete,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Text(emptyText, style: const TextStyle(color: AppTheme.gray)),
      );
    }

    if (isGrid) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (isService) {
            return ServiceGridCard(
              service: item,
              onFavoritePressed: () => onFav(item.id),
              onDelete: () => onDelete(item.id),
            );
          } else {
            return HelpGridCard(
              service: item,
              onFavoritePressed: () => onFav(item.id),
              onDelete: () => onDelete(item.id),
            );
          }
        },
      );
    }

    // List mode
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (isService) {
          return ServiceCard(
            service: item,
            onFavoritePressed: () => onFav(item.id),
            onDelete: () => onDelete(item.id),
          );
        } else {
          return HelpCard(
            service: item,
            onFavoritePressed: () => onFav(item.id),
            onDelete: () => onDelete(item.id),
          );
        }
      },
    );
  }

  // ── Confirm delete ──────────────────────────────────────────────────────────

  void _confirmDelete(
    BuildContext context,
    String id, {
    required bool isVolunteer,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.tr(context, 'delete_post')),
        content: Text(AppLocalizations.tr(context, 'delete_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.tr(context, 'cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final String? error;
              if (isVolunteer) {
                error = await context.read<VolunteerProvider>().deletePost(id);
              } else {
                error = await context.read<ServiceProvider>().deletePost(id);
              }
              if (error != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${AppLocalizations.tr(context, 'error')}$error',
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: Text(
              AppLocalizations.tr(context, 'delete'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // ── Avatar upload ───────────────────────────────────────────────────────────

  void _pickAvatar(BuildContext context, AuthProvider auth) async {
    final error = await auth.pickAndUploadAvatar();
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.tr(context, 'error_upload_photo')}$error',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ── Dialogs ─────────────────────────────────────────────────────────────────

  void _showSwitchAccountSheet(BuildContext context, AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final accounts = auth.savedAccounts;
        final currentEmail = auth.userEmail;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.tr(context, 'switch_account'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (accounts.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    AppLocalizations.tr(context, 'no_saved_accounts'),
                    style: const TextStyle(color: AppTheme.gray),
                  ),
                )
              else
                ...accounts.map((account) {
                  final email = account['email'] ?? '';
                  final name = account['name'] ?? email;
                  final type = account['accountType'] ?? 'user';
                  final avatar = account['avatarUrl'] ?? '';
                  final isCurrent = email == currentEmail;

                  return Dismissible(
                    key: Key(email),
                    direction: isCurrent
                        ? DismissDirection.none
                        : DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.redAccent,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => auth.removeSavedAccount(email),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: type == 'organization'
                            ? AppTheme.orgPurpleLight
                            : AppTheme.lightBlueBackground,
                        backgroundImage: avatar.isNotEmpty
                            ? NetworkImage(avatar)
                            : null,
                        child: avatar.isEmpty
                            ? Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: type == 'organization'
                                      ? AppTheme.orgPurple
                                      : AppTheme.baseGreen,
                                ),
                              )
                            : null,
                      ),
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (type == 'organization') ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.orgPurpleLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'ORG',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7B1FA2),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        email,
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: isCurrent
                          ? const Icon(
                              Icons.check_circle,
                              color: AppTheme.baseGreen,
                            )
                          : const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.gray,
                            ),
                      onTap: isCurrent
                          ? null
                          : () async {
                              Navigator.pop(ctx);
                              await auth.signOut();
                              if (!context.mounted) return;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LoginScreen(initialEmail: email),
                                ),
                                (route) => false,
                              );
                            },
                    ),
                  );
                }),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.lightBlueBackground,
                  child: Icon(Icons.add, color: AppTheme.baseGreen),
                ),
                title: Text(
                  AppLocalizations.tr(context, 'add_another_account'),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  await auth.signOut();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.tr(context, 'logout')),
        content: Text(AppLocalizations.tr(context, 'logout_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.tr(context, 'cancel')),
          ),
          TextButton(
            onPressed: () async {
              await auth.signOut();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: Text(
              AppLocalizations.tr(context, 'exit'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ── SliverPersistentHeader delegate для TabBar ────────────────────────────────

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color _backgroundColor;

  _SliverTabBarDelegate(this._tabBar, this._backgroundColor);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: _backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) =>
      oldDelegate._backgroundColor != _backgroundColor;
}
