// import 'package:all_bluetooth/all_bluetooth.dart';


import 'package:all_bluetooth/all_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:satu/views/chatScreen.dart';

import '../views/main.dart';
// import 'package:get/get.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Blutut extends StatefulWidget {
  const Blutut({super.key});

  @override
  State<Blutut> createState() => _BlututState();
}

class _BlututState extends State<Blutut> {

  final bondedDevices = ValueNotifier(<BluetoothDevice>[]);
  
  bool isListening = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.wait([
      Permission.bluetooth.request(),
      Permission.bluetoothConnect.request()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: allBluetooth.streamBluetoothState,
        builder: (context, snapshot) {
          final bluetoothOn = snapshot.data ?? false;
          print(bluetoothOn);
          return Scaffold(
            appBar: AppBar(
              // actions: [
              //   ElevatedButton(
              //       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              //       onPressed: (){
              //         Navigator.push(context, 
              //         MaterialPageRoute(builder: (context) => ChatScreen()));
              //       },
              //       child: Icon(Icons.chat_rounded, size: 40, color: Colors.white,)),
              // ],
              backgroundColor: Colors.red,
              title: Text(
                "Bluetooth Connection",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            floatingActionButton: 
            switch(isListening){
              true=> null,
              false=> 
                Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                child: Icon(
                  Icons.wifi,
                  size: 40,
                ),
                onPressed: switch (bluetoothOn) {
                  false => null,
                  true => () {
                    allBluetooth.startBluetoothServer();
                    setState(() => isListening=true);
                  },
                },
                backgroundColor: bluetoothOn
                    ? Theme.of(context).primaryColor
                    : const Color.fromARGB(255, 197, 197, 197),
              ),
            ),
            },
            
            body: 
            isListening ? 
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  SizedBox(height: 16.0,),
                  const Text("Listening For Connection"),
                  const CircularProgressIndicator(),
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close_rounded, color: Colors.white,),
                    onPressed: (){
                      allBluetooth.closeConnection();
                      setState(() {
                        isListening=false;
                      });
                    },
                    ),
                  SizedBox(height: 16.0,)
                  
                ],
              ),
            ):
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          switch (bluetoothOn) {
                            true => "ON",
                            false => "Off",
                          },
                          style: bluetoothOn
                              ? TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)
                              : TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: switch(bluetoothOn) {
                            //masukan logic disini
                            false => null,
                            true => () async {
                              final devices = await allBluetooth.getBondedDevices();
                              bondedDevices.value = devices;
                            },
                          },
                          child: bluetoothOn ? Text("Bonded Device", style: TextStyle(color: Colors.white),) : Icon(
                            Icons.bluetooth,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                        ),
                      ]),
                      if (!bluetoothOn)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Turn on Bluetooth"),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: bondedDevices, 
                          builder: (context,devices,child){
                            return Expanded(
                              child: 
                                ListView.builder(
                                  itemCount: bondedDevices.value.length,
                                  itemBuilder: (context, index) {
                                  final device = devices[index];
                                  return ListTile(
                                    title: Text(device.name),
                                    subtitle: Text(device.address),
                                    onTap: (){
                                      allBluetooth.connectToDevice(device.address);
                                    },
                                  );
                                })
                                );
                          }),
                ],
              ),
            ),
          );
        });
  }
}
