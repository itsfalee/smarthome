import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LampPage extends StatefulWidget {
  const LampPage({Key? key}) : super(key: key);

  @override
  _LampPageState createState() => _LampPageState();
}

class _LampPageState extends State<LampPage> {
  Map<String, bool?> lightSwitches = {
    'Living Room': true,
    'Bedroom': false,
    'Dining Room': true,
    'Kitchen': true,
    'Entrance': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 233, 194),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 247, 233, 194),
        ),
        body: Column(children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Light Switches',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black54),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: lightSwitches.keys
                      .map((roomName) => CheckboxListTile(
                            title: Text(roomName),
                            value: lightSwitches[roomName],
                            onChanged: (bool? value) {
                              setState(() {
                                lightSwitches[roomName] = value;
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
              flex: 1),
          Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: lightSwitches.keys
                      .map((roomName) => LightBulbCard(
                            room: roomName,
                            on: lightSwitches[roomName],
                          ))
                      .toList(),
                ),
              ),
              flex: 1),
        ]));
  }
}

class LightBulbCard extends StatelessWidget {
  const LightBulbCard({
    this.on = true,
    this.room = 'Room Name',
  });
  final bool? on;
  final String room;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffeeeeee), width: 2.0),
        color: Colors.white38,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.white10,
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.all(8),
      height: 200,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Icon(
            Icons.lightbulb,
            size: 100.0,
            color: on! ? Colors.yellow : Colors.grey,
          )),
          SizedBox(
            height: 20.0,
          ),
          Text(
            room,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
