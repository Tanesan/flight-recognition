import 'package:flutter/material.dart';

import 'flight_info.dart';


class BottomBar extends StatefulWidget {
  final FlightInfo flightInfo;

  const BottomBar({super.key, required this.flightInfo});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            ),
          ],
        ),
    const SizedBox(height: 5),
        Padding(padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
          child:
          Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SizedBox(
              width: 37,
              height: 37,
              child: Image.asset(
                widget.flightInfo.isDeparture ? 'images/departure.png' : 'images/arrival.png',
                fit: BoxFit.contain,
              ),
            ),
            Text(widget.flightInfo.isDeparture ? '出発' : '到着', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        Column(
          children: [
            Text(widget.flightInfo.airplaneCode, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            Text(widget.flightInfo.flightNumber, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue)),
            Text(widget.flightInfo.airline, style: const TextStyle(fontSize: 12, color: Colors.blue)),
          ],
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic, // CrossAxisAlignment.base指定時に必須
            children: [
              Text(widget.flightInfo.isDeparture ? widget.flightInfo.arrivalCity : widget.flightInfo.departureCity, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8), // 余白を追加
              Text(widget.flightInfo.isDeparture ? '行' : 'から', style: const TextStyle(fontSize: 15)),
            ],
          )
        ],
    )),
    const SizedBox(height: 30),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
          child:
              Column(
                children: [
                  widget.flightInfo.isDeparture ? Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('搭乗完了', style: TextStyle(fontSize: 15)),
                          Text('予定時刻', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      const SizedBox(width: 25), // 余白を追加
                      Text(widget.flightInfo.formattedActualPushbackTime, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ) :  Container(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(widget.flightInfo.isDeparture ? '離陸推定' : '到着推定', style: const TextStyle(fontSize: 15)),
                          const Text('時刻', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      const SizedBox(width: 25), // 余白を追加
                      Text(widget.flightInfo.isDeparture ? widget.flightInfo.formattedActualDepartureTime : widget.flightInfo.formattedActualArrivalTime, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic, // CrossAxisAlignment.base指定時に必須
                    children: [
                      const Text('　定刻　', style: TextStyle(fontSize: 15)),
                      const SizedBox(width: 25), // 余白を追加
                      Text(widget.flightInfo.formattedScheduledTime, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ]
              )
        ),
        Padding(padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child:
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.flightInfo.isDeparture ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text('出発まで', style: TextStyle(fontSize: 15)),
                  SizedBox(width: widget.flightInfo.minutesSincePushBackTime / 10 > 1 ? 10 : 25), // 余白を追加
                  Text(widget.flightInfo.minutesSincePushBackTime.toString(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10), // 余白を追加
                  const Text('分', style: TextStyle(fontSize: 15)),
                ],
              ) : Container(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic, // CrossAxisAlignment.base指定時に必須
                children: [
                  Text(widget.flightInfo.isDeparture? '離陸まで' : '到着まで', style: const TextStyle(fontSize: 15)),
                  SizedBox(width: widget.flightInfo.minutesUntilScheduledTime / 10 > 1 ? 10 : 25), // 余白を追加
                  Text(widget.flightInfo.minutesUntilScheduledTime.toString(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10), // 余白を追加
                  const Text('分', style: TextStyle(fontSize: 15)),
                ],
              ),
              const SizedBox(height: 10),
              widget.flightInfo.lateMinutes != 0 ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic, // CrossAxisAlignment.base指定時に必須
                children: [
                  const Text('　遅れ　', style: TextStyle(fontSize: 15)),
                  SizedBox(width: widget.flightInfo.lateMinutes / 10 > 1 ? 10 : 25), // 余白を追加
                  Text(widget.flightInfo.lateMinutes.toString(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10), // 余白を追加
                  const Text('分', style: TextStyle(fontSize: 15)),
                ],
              ) : Container(),
            ],
          ),
        ),
      ],
    ),
    ],));
  }
}
