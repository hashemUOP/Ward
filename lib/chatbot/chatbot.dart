import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "ChatBot",
    profileImage:
    "assets/images/15675864.png",
  );//create a gemini that sends messages answers like another user in a message bubbles
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,  // this removes the back arrow
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_circle_left,
              color: Colors.black54),
        ),
        centerTitle: true,
        title: const Text(
          "Ward's ChatBot",
          style: TextStyle(color: Colors.black54),
        ),
      ),
      backgroundColor: Colors.white,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(
        cursorStyle: CursorStyle(color: Colors.green.shade500),//change the caret(cursor color)
          sendButtonBuilder: (onSend) {
            return IconButton(
              icon: Icon(Icons.send_rounded, color: Colors.green.shade500),  // send icon color
              onPressed: onSend,
            );
          },
       trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon:  Icon(
            Iconsax.gallery,
            color: Colors.green.shade500,
          ),
        )
      ],
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
        currentUserContainerColor: Colors.green.shade500, // color for current user message bubbles (sent messages)
        containerColor: Colors.grey.shade300, // message bubbles color for other users (received messages (gemini))
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
              "", (previous, current) => "$previous ${current.text}") ?? "";
          lastMessage.text += response;
          setState(
                () {
              messages = [lastMessage!, ...messages];
            },
          );
        } else {
          String response = event.content?.parts?.fold(
              "", (previous, current) => "$previous ${current.text}") ?? "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      //print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}
