import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(MaterialApp(
    home: Scaffold(
      body: Clock(),
    ),
  ));
}

class BinaryTime {
  List<String> binaryIntegers;

  BinaryTime() {
    DateTime now = DateTime.now();
    String hhmmss = DateFormat('Hms').format(now).replaceAll(':', '');
    binaryIntegers = hhmmss
        .split('')
        .map((str) => int.parse(str).toRadixString(2).padLeft(4, '0'))
        .toList();
  }

  get hrsTens => binaryIntegers[0];

  get hrsOnes => binaryIntegers[1];

  get minTens => binaryIntegers[2];

  get minOnes => binaryIntegers[3];

  get secTens => binaryIntegers[4];

  get secOnes => binaryIntegers[5];
}

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  BinaryTime _now = BinaryTime();

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _now = BinaryTime();

//        print(_now);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClockColumn(
            color: Colors.blue,
            title: 'H',
            binaryInteger: _now.hrsTens,
            rows: 2,
          ),
          ClockColumn(
            color: Colors.blue,
            title: 'h',
            binaryInteger: _now.hrsOnes,
            rows: 4,
          ),
          ClockColumn(
            color: Colors.red,
            title: 'M',
            binaryInteger: _now.minTens,
            rows: 3,
          ),
          ClockColumn(
            color: Colors.red,
            title: 'm',
            binaryInteger: _now.minOnes,
            rows: 4,
          ),
          ClockColumn(
            color: Colors.green,
            title: 'S',
            binaryInteger: _now.secTens,
            rows: 3,
          ),
          ClockColumn(
            color: Colors.green,
            title: 's',
            binaryInteger: _now.secOnes,
            rows: 4,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ClockColumn extends StatelessWidget {
  String binaryInteger;
  String title;
  Color color;
  int rows;
  List bits;

  ClockColumn(
      {this.title, this.color, this.binaryInteger, this.bits, this.rows}) {
    bits = binaryInteger.split('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ...[
          Container(
            child: Text(
              title,
              style: Theme.of(context).textTheme.display1,
            ),
          )
        ],
        ...bits.asMap().entries.map((entry) {
          int idx = entry.key;
          String bit = entry.value;
          bool isActive = bit == '1';
          int binaryCellValue = pow(2, 3 - idx);
          return AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
            height: 40,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: isActive
                  ? color
                  : idx < 4 - rows
                      ? Colors.white.withOpacity(0)
                      : Colors.black38,
            ),
            margin: EdgeInsets.all(4),
            child: Center(
              child: isActive
                  ? Text(
                      binaryCellValue.toString(),
                      style: TextStyle(
                          color: Colors.black.withOpacity(.2),
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    )
                  : Container(),
            ),
          );
        }),
        ...[
          Text(
            int.parse(binaryInteger, radix: 2).toString(),
            style: TextStyle(fontSize: 15, color: color),
          ),
//          Container(
//            child: Text(
//              binaryInteger,
//              style: TextStyle(
//                fontSize: 15,
//                color: color,
//              ),
//            ),
//          )
        ]
      ],
    );
  }
}
