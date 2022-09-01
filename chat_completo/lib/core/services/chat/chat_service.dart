import 'package:chat_completo/core/models/chat_message.dart';
import 'package:chat_completo/core/services/chat/chat_service_firebase.dart';
import 'package:chat_completo/core/services/chat/chat_service_mock.dart';

import '../../models/chat_user.dart';

abstract class ChatService {
  Stream<List<ChatMessage>> messageStream();

  Future<ChatMessage?> save(String text, ChatUser user);

  factory ChatService() {
    //return ChatServiceMock();
    return ChatFirebaseService();
  }
}
