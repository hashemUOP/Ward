import 'package:flutter/material.dart';
import 'package:ward/chatbot/chatbot.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/15675864.png",height: 100,),
              const SizedBox(height: 10,),
              const Text("Need some advice?",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
               Padding(
                padding:const EdgeInsets.only(left: 40.0,right: 30,top: 10,bottom: 30),
                child: Text("Our AI powered chat bot is ready to help you with any plant-related problems you may be facing.",style:TextStyle(fontSize: 12,color: Colors.grey.shade700),),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const ChatPage(),)
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 40.0,right: 30),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300)
                    ),
                    child: Center(child: Text("Write your message here",style: TextStyle(color: Colors.grey.shade600),)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      
    );
  }
}
