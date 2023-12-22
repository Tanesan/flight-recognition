import 'package:intl/intl.dart';

class FlightInfo {
  final bool isDeparture;
  final String flightNumber;
  final String airplaneCode;
  final String airline;
  final String departureCity;
  final String arrivalCity;
  final int lateMinutes;
  final DateTime scheduledTime;
  final DateTime actualDepartureTime;
  final DateTime actualArrivalTime;
  final DateTime actualPushbackTime;

  FlightInfo({
    required this.isDeparture,
    required this.flightNumber,
    required this.airplaneCode,
    required this.airline,
    required this.departureCity,
    required this.arrivalCity,
    required this.scheduledTime,
    required this.actualDepartureTime,
    required this.actualPushbackTime,
    required this.actualArrivalTime,
    required this.lateMinutes,
  });

  factory FlightInfo.fromJson(Map<String, dynamic> json) {
    return FlightInfo(
      isDeparture: json['isDeparture'],
      flightNumber: json['flightNumber'],
      airplaneCode: json['airplaneCode'],
      airline: json['airline'],
      departureCity: json['departureCity'],
      arrivalCity: json['arrivalCity'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      actualDepartureTime: DateTime.parse(json['actualDepartureTime']),
      actualArrivalTime: DateTime.parse(json['actualArrivalTime']),
      actualPushbackTime: DateTime.parse(json['actualPushbackTime']),
      lateMinutes: json['lateMinutes'],
    );
  }
  String get formattedScheduledTime {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(scheduledTime);
  }

  String get formattedActualDepartureTime {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(actualDepartureTime);
  }

  String get formattedActualArrivalTime {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(actualArrivalTime);
  }

  String get formattedActualPushbackTime {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(actualPushbackTime);
  }

  int minutesDifferenceFromNow(DateTime time) {
    final Duration diff = DateTime.now().difference(time);
    return diff.inMinutes;
  }

  int get minutesSincePushBackTime => minutesDifferenceFromNow(actualPushbackTime);
  int get minutesUntilScheduledTime => minutesDifferenceFromNow(scheduledTime);
  int get minutesSinceActualDeparture => minutesDifferenceFromNow(actualDepartureTime);
}
