import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/service_provider/service_provider.dart';

enum PostType { help, service }

class AddPostScreen extends StatefulWidget {
  final PostType type;
  const AddPostScreen({super.key, required this.type});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Настраиваем цвета и тексты в зависимости от типа
    final bool isHelp = widget.type == PostType.help;
    final Color bgColor = isHelp ? const Color(0xFFEBF2F0) : const Color(0xFFE2EBF2);
    final String title = isHelp ? "Add Help Request" : "Add Service";
    final String hint = isHelp
        ? "I need help moving to a new apartment tonight"
        : "Tutoring. I can help with math, science and school homework";

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isHelp ? "Add Help" : "Add Service",
            style: const TextStyle(color: Colors.grey, fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B334B)
              ),
            ),
            const SizedBox(height: 60),

            // Большая карточка для ввода текста
            Container(
              height: 180,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: TextField(
                controller: _controller,
                maxLines: null, // Позволяет вводить много строк
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Кнопка Public справа
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 120,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B334B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      context.read<ServiceProvider>().addPost(text, widget.type);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a description')),
                      );
                    }
                  },
                  child: const Text("Public",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}