import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_drawer.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/services/chat/chat_service.dart';

import '../components/user_tile.dart';
import 'chat_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //chat & auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('HomePage'),
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  //build a list of user except for the current logged in user
  Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot){
        //errors
        if(snapshot.hasError){
          return Text('Error');
        }

        //loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        //has data => return List View
        return ListView(
          children: snapshot.data!.map<Widget>((userData)=> _buildUserListItem(userData,context)).toList(),
        );
      },
    );
  }

  //build individual list tile for user
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    //display all user except current user
    if(userData["email"] != _authService.getCurrentUser()!.email){//userData["email"] là email trong firestore, _authService.getCurrentUser()!.email là email đang đăng nhập
      return UserTile(
        text: userData["email"],
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatPage(receiverEmail: userData["email"], receiverId: userData['uid'],)),
          );
        },
      );
    }
    else{
      return Container();
    }
  }
}
