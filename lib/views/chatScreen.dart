import 'package:flutter/material.dart';
import 'package:satu/views/message.dart';

// import 'package:satu/views/main.dart';
import '../views/main.dart';
// import '../controllers/blutut.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final messages = <Message>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allBluetooth.listenForData.listen((event) {
      messages.add(Message(
        message: event.toString(),
        aku: false,
      ));
    });
    setState(() {
      
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screeenWidth = MediaQuery.of(context).size.width;
    double screeenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 203, 232, 255),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Chat Screen",
          style: TextStyle(color: Colors.white),
        ),
        // actions: [
        //   Container(
        //     margin: EdgeInsets.only(right: 20.0),
        //     child: IconButton(
        //       onPressed: (){
        //         //logic button
        //         Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => MyApp())
        //         );
        //       },
        //       icon: Icon(Icons.arrow_left_rounded, size: 40.0, color: Colors.blue,)
        //       ),
        //   )
        // ],
      ),
      body: Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
            children: [
              //expanded text history :
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: screeenWidth * 0.8,
                    height: screeenHeight * 0.8,
                    child: 
                    ListView.builder( 
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Text(messages[index].message);
                      },
                    ),
                  ),
                ),
              ),

              Spacer(),
              //send and type message
              Center(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Center(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screeenWidth * 0.7,
                                child: TextField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Kirim Pesan',
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    //logic buton
                                    final message = messageController.text;
                                    allBluetooth.sendMessage(message);
                                    messageController.clear();
                                    messages.add(
                                      Message(
                                        message: message,
                                        aku: true,
                                      ),
                                    );
                                    setState(() {
                                      
                                    });
                                  },
                                  icon: Icon(
                                    Icons.send_rounded,
                                    size: 30.0,
                                    color: Colors.blue,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          )),
    );
  }
}
