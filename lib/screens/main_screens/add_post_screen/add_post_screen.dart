import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/locale_provider/locale_provider.dart';
import '../../../providers/service_provider/service_provider.dart';
import '../../../providers/volunteer_provider/volunteer_provider.dart';

enum PostType { help, service, volunteer, charity }

class AddPostScreen extends StatefulWidget {
  final PostType type;
  const AddPostScreen({super.key, required this.type});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isPosting = false;
  String _selectedCategory = 'other';

  Map<String, String> get _categories {
    switch (widget.type) {
      case PostType.service:
        return AppLocalizations.categories(context, 'service');
      case PostType.help:
        return AppLocalizations.categories(context, 'help');
      case PostType.volunteer:
        return AppLocalizations.categories(context, 'volunteer');
      case PostType.charity:
        return AppLocalizations.categories(context, 'charity');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LocaleProvider>();

    final Color bgColor;
    switch (widget.type) {
      case PostType.service:
        bgColor = AppTheme.serviceBg;
      case PostType.help:
        bgColor = AppTheme.helpBg;
      case PostType.volunteer:
      case PostType.charity:
        bgColor = AppTheme.orgBackground;
    }

    final String screenTitle;
    switch (widget.type) {
      case PostType.service:
        screenTitle = AppLocalizations.tr(context, 'add_service');
      case PostType.help:
        screenTitle = AppLocalizations.tr(context, 'add_help_request');
      case PostType.volunteer:
        screenTitle = AppLocalizations.tr(context, 'find_volunteers');
      case PostType.charity:
        screenTitle = AppLocalizations.tr(context, 'add_charity_post');
    }

    final String appBarTitle;
    switch (widget.type) {
      case PostType.service:
        appBarTitle = AppLocalizations.tr(context, 'add_service');
      case PostType.help:
        appBarTitle = AppLocalizations.tr(context, 'add_help_short');
      case PostType.volunteer:
        appBarTitle = AppLocalizations.tr(context, 'volunteer_short');
      case PostType.charity:
        appBarTitle = AppLocalizations.tr(context, 'charity_short');
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          appBarTitle,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                screenTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B334B),
                ),
              ),
              const SizedBox(height: 30),

              _buildCategorySelector(),
              const SizedBox(height: 16),

              _buildInputField(
                controller: _titleController,
                hint: AppLocalizations.tr(context, 'field_title_hint'),
                label: AppLocalizations.tr(context, 'field_title'),
                icon: Icons.title,
                maxLines: 1,
              ),
              const SizedBox(height: 16),

              _buildInputField(
                controller: _descController,
                hint: AppLocalizations.tr(context, 'field_desc_hint'),
                label: AppLocalizations.tr(context, 'field_desc'),
                icon: Icons.description_outlined,
                maxLines: 4,
                minHeight: 120,
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: AppLocalizations.tr(context, 'field_price_hint'),
                    hintStyle: TextStyle(
                      color: Colors.black.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.payments_outlined,
                      color: Color(0xFF1B334B),
                    ),
                    suffixText: AppLocalizations.tr(context, 'currency'),
                    suffixStyle: const TextStyle(
                      color: Color(0xFF1B334B),
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 140,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _isPosting ? null : _submitPost,
                    child: _isPosting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            AppLocalizations.tr(context, 'publish'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedCategory == 'other' ? null : _selectedCategory,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.category_outlined, color: Color(0xFF1B334B)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        hint: Text(
          AppLocalizations.tr(context, 'select_category'),
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1B334B)),
        items: _categories.entries.map((e) {
          return DropdownMenuItem<String>(
            value: e.key,
            child: Text(e.value, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) setState(() => _selectedCategory = val);
        },
      ),
    );
  }

  void _submitPost() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.tr(context, 'enter_title'))),
      );
      return;
    }

    if (_selectedCategory == 'other') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.tr(context, 'select_category_err')),
        ),
      );
      return;
    }

    setState(() => _isPosting = true);

    final price = int.tryParse(_priceController.text.trim()) ?? 0;
    final auth = context.read<AuthProvider>();

    final String? error;
    if (widget.type == PostType.volunteer || widget.type == PostType.charity) {
      error = await context.read<VolunteerProvider>().addPost(
        title,
        desc,
        widget.type,
        userName: auth.userName,
        userPhone: auth.userPhone,
        userAvatar: auth.avatarUrl ?? '',
        price: price,
        category: _selectedCategory,
      );
    } else {
      error = await context.read<ServiceProvider>().addPost(
        title,
        desc,
        widget.type,
        userName: auth.userName,
        userPhone: auth.userPhone,
        userAvatar: auth.avatarUrl ?? '',
        price: price,
        category: _selectedCategory,
      );
    }

    if (!mounted) return;
    setState(() => _isPosting = false);

    if (error == null) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.tr(context, 'publish_fail')}$error',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required String label,
    required IconData icon,
    int maxLines = 1,
    double minHeight = 0,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppTheme.darkBlue),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B334B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration.collapsed(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.black.withValues(alpha: 0.4),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
