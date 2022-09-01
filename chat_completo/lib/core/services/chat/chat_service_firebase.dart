import 'dart:async';
import 'package:chat_completo/core/models/chat_user.dart';
import 'package:chat_completo/core/models/chat_message.dart';
import 'package:chat_completo/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messageStream() {
    final store = FirebaseFirestore.instance;
    final snapshot = store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .orderBy('createdAt', descending: true)
        .snapshots();

    // Obtendo as mensagensd o chat

    return snapshot.map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });

    /*return Stream<List<ChatMessage>>.multi(
      (controller) {
        snapshot.listen(
          (query) {
            List<ChatMessage> lista = snapshot.docs.map((document) {
              return document.data();
            }).toList();
            controller.add(lista);
          },
        );
      },
    );*/
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    final msg = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageUrl,
    );

    //ChatMessage=> Map<String,dynamic>
    final docRef = await store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .add(msg);

    // Map<String,dynamic> => ChatMessage
    final doc = await docRef.get();
    return doc.data()!;
  }

  Map<String, dynamic> _toFirestore(
    ChatMessage msg,
    SetOptions? options,
  ) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt,
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageUrl': msg.userImageUrl,
    };
  }

  // Map => ChatMessage
  ChatMessage _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return ChatMessage(
      id: doc.id,
      text: doc['text'],
      createdAt: DateTime.parse(doc['createdAt']),
      userId: doc['userId'],
      userName: doc['userName'],
      userImageUrl: doc['userImageUrl'],
    );
  }
}
