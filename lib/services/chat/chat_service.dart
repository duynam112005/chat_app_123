import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/message.dart';

class ChatService {
  //get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through each individual user
        final user = doc.data();
        //return user
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiverId, String message) async {
    //don't send empty messages
    if(message.trim().isEmpty) return;

    //get current infor user
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    //construct chat room Id for 2 users (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //chắc chắn chatRoomId cùng cho 2 người, ví dụ A - B và B - A cùng 1 room chat
    String chatRoomId = ids.join('_'); // để có dạng A_B

    //add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct a chatroom Id for the two users
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    //descending:true (tin nhắn mới -> tin nhắn cũ) xong ListView ở UI dùng reverse:true để luôn hiển thị tin nhắn mới nhất ở cuối
    return _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp', descending: true).snapshots();
  }
}
