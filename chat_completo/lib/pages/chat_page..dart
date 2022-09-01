import 'dart:math';

import 'package:chat_completo/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/messages.dart';
import '../components/new_message.dart';
import '../core/models/chat_notification.dart';
import '../core/services/auth/auth_service.dart';
import '../core/services/notification/chat_notification_service.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Chat"),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: Row(
                      children: const [
                        Icon(Icons.exit_to_app, color: Colors.black),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Sair"),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == 'logout') {
                  AuthService().logout();
                }
              },
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                ),
                icon: const Icon(Icons.notifications),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  maxRadius: 10,
                  backgroundColor: Colors.red.shade800,
                  child: Text(
                      '${Provider.of<ChatNotificationService>(context).itemsCount}',
                      style: const TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: const [
            Expanded(child: Messages()),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
