import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_flutte/helper/conn.dart';
import 'package:flash_chat_flutte/helper/show_snackbar.dart';
import 'package:flash_chat_flutte/messages.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

CollectionReference _messages =
    FirebaseFirestore.instance.collection(Keymessages);

User? userCredential;

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController mess = TextEditingController();

  final _auth = FirebaseAuth.instance;
  String? messageText;
  // late User newUser;

  @override
  void initState() {
    super.initState();
    getLoggedUsers();
  }

  void getLoggedUsers() async {
    final newUser = await _auth.currentUser;
    try {
      if (newUser != null) {
        userCredential = newUser;
        print("Osama :" + userCredential!.email.toString());
      }
      print("Osama :" + userCredential!.email.toString());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessagesStrem(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: mess,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      mess.clear();
                      _messages.add({
                        'text': messageText,
                        'sender': userCredential!.email,
                        'creatAt': DateTime.now(),
                        //    'sender' : newUser.email
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStrem extends StatelessWidget {
  const MessagesStrem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _messages.orderBy('creatAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messag = snapshot.data!.docs;
        List<Messages> _listMess = [];
        List<MessageBubble> messageBubbles = [];
        for (var messalldata in messag) {
          final messageMap = messalldata;
          final messagesText = messageMap['text'];
          final messagesSender = messageMap['sender'];
          final messagesCreatAt = messageMap['creatAt'];

          final currentUser = userCredential!.email;
          if (currentUser == messagesSender) {}

          final messageBubble = MessageBubble(
            sender: messagesSender,
            text: messagesText,
            isMe: currentUser == messagesSender,
            // creatAt: messagesCreatAt,
          );
          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.sender,
    required this.text,
    required this.isMe,
  });

  final String sender;
  final String text;
  //final DateTime creatAt;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            elevation: 5,
            color: isMe ? Colors.lightBlueAccent : Colors.grey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15,
                  color: isMe ? Colors.white : Colors.black,
                ),
                textAlign: isMe ? TextAlign.start : TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
