import 'package:chat_completo/core/services/notification/chat_notification_service.dart';
import 'package:chat_completo/pages/auth_page.dart';
import 'package:chat_completo/pages/chat_page..dart';
import 'package:chat_completo/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../core/models/chat_user.dart';
import '../core/services/auth/auth_service.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  Future<void> initFirebase(BuildContext context) async {
    await Firebase.initializeApp();
    Provider.of<ChatNotificationService>(context, listen: false)
        .initPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initFirebase(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          return StreamBuilder<ChatUser?>(
            stream: AuthService().UserChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingPage();
              } else {
                return snapshot.hasData ? const ChatPage() : const AuthPage();
              }
            },
          );
        }
      },
    );
  }
}
