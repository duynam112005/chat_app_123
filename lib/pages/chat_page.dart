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

  bool _sendByMe = false;

  int _lastMessageCount = 0;
  bool _showNewMessageIndicator = false;
  int _unReadCount = 0;

  //send message method
  void sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    //clear sớm => UX mượt
    _messageController.clear();
    _sendByMe = true;
    //send message
    await _chatService.sendMessage(widget.receiverId, text);
  }

  final ScrollController _scrollController = ScrollController();

  // hàm kiểm tra xem có đang ở gần đáy không
  // nghĩa là khi người kia nhắn tin thì phải tự động scroll xuống nếu đang ở gần bottom
  // set < 50px vì để tran auto scroll khi đang xem lại tin nhắn cũ mà người khác nhắn tin

  //check xem gần bottom không (nhỏ hơn offset<= 120px thì auto scroll)
  bool isNearBottom() {
    if (!_scrollController.hasClients) return true;
    return _scrollController.offset <= 120;
  }

  //hàm cuộn xuống tin nhắn mới nhất
  void scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
    );
  }

  //dispose method
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(widget.receiverEmail)),
      body: Column(
        children: [
          //display all messages
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [_buildMessageList(), if (_showNewMessageIndicator) _showNewMessage()],
            ),
          ),

          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

  //showNewMessage
  Widget _showNewMessage() {
    return Positioned(
      bottom: 16,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showNewMessageIndicator = false;
            _unReadCount = 0;
          });
          //đổi key xong mới scroll
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollToBottom();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(_unReadCount > 1 ? '$_unReadCount new messages' : 'New message'),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    final String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder<QuerySnapshot>(
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

        int currentMessageCount = snapshot.data!.docs.length;

        //scroll nếu mình gửi tin nhắn hoặc nếu đang ở tin nhắn mới nhất
        //ví dụ đang đọc tin nhắn cũ mà mình nhắn 1 tin mới thì scroll (vào nhánh if)
        //còn nếu người khác nhắn tin thì đang ở đáy thì scroll(vào nhánh else if)
        //WidgetsBinding.instance.addPostFrameCallback: đợi các widget bị thay đổi phải rebuild xong thì mới thực hiện code bên trong

        //chỉ addCallback khi có tin nhắn mới
        if (_lastMessageCount != currentMessageCount) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            //!_scrollController.hasClients nghĩa là scrollController chưa được gắn vào 1 widget scrollable nào
            // if (!_scrollController.hasClients) return;
            //nếu mình gửi tin nhắn, hoặc đang ở gần tin nhắn mới nhất thì auto scroll
            if (_sendByMe || isNearBottom()) {
              scrollToBottom();
              _sendByMe = false;
              if (_showNewMessageIndicator || _unReadCount > 0) {
                setState(() {
                  _showNewMessageIndicator = false;
                  _unReadCount = 0;
                });
              }
            } else {
              //chỉ những cái nào UI thay đổi thì mới cần đưa vào setState
              setState(() {
                _showNewMessageIndicator = true;
                _unReadCount++;
              });
            }
          });
          _lastMessageCount = currentMessageCount;
        }


        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
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
              //focusNode: myFocusNode,
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


