import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class TZC extends StatefulWidget {
  const TZC({super.key});

  @override
  State<TZC> createState() => _TZCState();
}

class _TZCState extends State<TZC> {
  final List<String> timeZones = [
    '-12:00', '-11:00', '-10:00', '-09:00', '-08:00', '-07:00', '-06:00', '-05:00', '-04:00', '-03:00', '-02:00',
    '-01:00', '+00:00', '+01:00', '+02:00', '+03:00', '+03:30', '+04:00', '+04:30', '+05:00', '+05:30', '+05:45',
    '+06:00', '+06:30', '+07:00', '+08:00', '+09:00', '+10:00', '+11:00', '+12:00',
  ];

  String currentTimeZone = '+00:00';
  String destinationTimeZone = '+00:00';
  String currentTime = '';
  String convertedTime = '';
  final TextEditingController timeInputController = TextEditingController();

  // Convert the entered time based on selected time zones
  void _convertTime() {
    if (timeInputController.text.isEmpty) {
      setState(() {
        convertedTime = "Please enter the current time!";
      });
      return;
    }

    try {
      // Parse the user-entered time
      final inputTimeParts = timeInputController.text.split(':');
      final hours = int.parse(inputTimeParts[0]);
      final minutes = int.parse(inputTimeParts[1]);
      final now = DateTime.now();
      final userTime = DateTime(now.year, now.month, now.day, hours, minutes);

      // Apply time zone offsets
      final sourceOffset = _parseTimeZoneOffset(currentTimeZone);
      final destOffset = _parseTimeZoneOffset(destinationTimeZone);

      final sourceTime = userTime.subtract(Duration(hours: sourceOffset[0], minutes: sourceOffset[1]));
      final destinationTime = sourceTime.add(Duration(hours: destOffset[0], minutes: destOffset[1]));

      setState(() {
        convertedTime = "${_twoDigits(destinationTime.hour)}:${_twoDigits(destinationTime.minute)}:${_twoDigits(destinationTime.second)}";
      });
    } catch (e) {
      setState(() {
        convertedTime = "Invalid time format! Use HH:mm.";
      });
    }
  }

  // Helper to parse time zone offsets
  List<int> _parseTimeZoneOffset(String timeZone) {
    final sign = timeZone.contains('+') ? 1 : -1;
    final parts = timeZone.split(RegExp(r'[+-]'))[1].split(':');
    final hours = int.parse(parts[0]) * sign;
    final minutes = parts.length > 1 ? int.parse(parts[1]) * sign : 0;
    return [hours, minutes];
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time_outlined, color: Colors.white,),
              SizedBox(width: 10,),
              Text(
                'Time Zone Converter',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),

      // to display current timezone - user able to change the current time zone
      body: Stack(
        children: [
          Positioned.fill(

            child: Opacity(
              opacity: 0.5,
              child: Transform.scale(
                scale: 3,
                child: Lottie.asset('images/background_animation3.json'),
            ),
          ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Center(
                  child: Text("Current Time Zone", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.teal),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 125,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.teal,
                          width: 5.0,
                        )
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: currentTimeZone,
                        items: timeZones.map((String zone) {
                          return DropdownMenuItem<String>(
                            value: zone,
                            child: Text(
                              zone,
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 96, 92, 1.0)),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            currentTimeZone = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Center(child: Text("Current Time (24h)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.teal),),),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 125,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.teal,
                          width: 5.0,
                        )
                    ),
                    child: Center(
                      child: TextField(
                        controller: timeInputController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}(:\d{0,2})?$')),
                          LengthLimitingTextInputFormatter(5),
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Time (HH:mm)',
                          hintStyle: TextStyle(fontSize: 30.0, color: Colors.teal, fontWeight: FontWeight.bold),
                          contentPadding: EdgeInsets.all(15.0),
                        ),
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (value) {
                          if (value.contains(':')) {
                            final parts = value.split(':');
                            if (parts.length == 2) {
                              String hours = parts[0];
                              String minutes = parts[1];

                              if (hours.isNotEmpty) {
                                final hourValue = int.tryParse(hours) ?? -1;
                                if (hourValue > 23) {
                                  hours = '23';
                                }
                              }

                              if (minutes.isNotEmpty) {
                                final minuteValue = int.tryParse(minutes) ?? -1;
                                if (minuteValue > 59) {
                                  minutes = '59';
                                }
                              }

                              timeInputController.value = TextEditingValue(
                                text: '$hours:$minutes',
                                selection: TextSelection.collapsed(offset: '$hours:$minutes'.length),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Center(child: Text("Destination Time Zone", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.teal),),),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 125,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.teal,
                          width: 5.0,
                        )
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: destinationTimeZone,
                        items: timeZones.map((String zone) {
                          return DropdownMenuItem<String>(
                            value: zone,
                            child: Text(
                              zone,
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 96, 92, 1.0)),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            destinationTimeZone = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: _convertTime,
                    child: const Text(
                      'Convert Time',
                      style: TextStyle(fontSize: 24.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
              if (convertedTime.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "Converted Time: $convertedTime",
                      style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
