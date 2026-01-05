import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/chat_bubble.dart';
import 'package:flutter_application_1/components/my_textfield.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const ChatPage({super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  //chat & auth service
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  //send message method
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      //send message
      await _chatService.sendMessage(widget.receiverId, _messageController.text);

      //after send message, clear _messageController
      _messageController.clear();
    }
  }

  //for textfield focus: để theo dõi trạng thái focus textfield
  FocusNode myFocusNode = FocusNode();

  @override
  //trong init để chạy 1 lần duy nhất khi widget được khởi tạo
  void initState() {
    super.initState();
    //add listen to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        //phải delay vì khi tap vào textfield mà scroll ngay thì sẽ bị sai vị trí do layout của textfield chưa đực set
        //nên delay để hiển thị bàn phím đã rồi mới cuộn xuống tin nhắn mới nhất
        Future.delayed(Duration(milliseconds: 500),
                () => scrollDown());
      }
    });
  }

  //scroll controller: ScrollController dùng để điều chỉnh vị trí cuộn của ListView:
  //maxScrollExtent: cuộn về cuối danh sách ( về tin nhắn cuối)
  //minScrollExtent: cuộn về đầu danh sách (tin nhắn đầu). ở đây dùng min vì mình đang dùng reverse
  //aminateTo: cuộn mượt
  //curve: chuyển động. fastOutSlowIn: nhanh lúc đầu, chậm lúc cuối
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
        _scrollController.position.minScrollExtent, duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  //dispose method
  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    myFocusNode.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          //display all messages
          Expanded(child: _buildMessageList()),

          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    final String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderId, widget.receiverId),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return Text("Error");
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        //return ListView
        // return ListView(
        //   controller: _scrollController,
        //   children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        // );
        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){
            return _buildMessageItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //is current user
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;
    //align message to the right if sender is current user, otherwise left
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
    );
  }

  //build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Type a message',
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),

          //send button
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            child: IconButton(onPressed: sendMessage, icon: Icon(Icons.send)),
          ),
        ],
      ),
    );
  }
}
