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
  final List<String> timeZones=[
    '-12:00',
    '-11:00',
    '-10:00',
    '-09:00',
    '-08:00',
    '-07:00',
    '-06:00',
    '-05:00',
    '-04:00',
    '-03:00',
    '-02:00',
    '-01:00',
    '+00:00',
    '+01:00',
    '+02:00',
    '+03:00',
    '+03:30',
    '+04:00',
    '+04:30',
    '+05:00',
    '+05:30',
    '+05:45',
    '+06:00',
    '+06:30',
    '+07:00',
    '+08:00',
    '+09:00',
    '+10:00',
    '+11:00',
    '+12:00',
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
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time_outlined,color: Colors.white,),
              SizedBox(width: 10,),
              Text('Time Zone Converter',style: TextStyle(
                  fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white
              ),
              ),

            ],
          ),
        ),
      ),

      //to display current timezone - user able to change the current time zone
      body: Stack(
          children: [
            // Background Lottie animation
            Center(
              child: Positioned.fill(
              child: Lottie.asset('images/background_animation3.json' ),
                        ),
            ),

      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [

          const Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Center(child: Text("Current Time Zone",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Colors.teal),),),
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
                      items: timeZones.map((String zone){
                        return DropdownMenuItem<String>(
                          value: zone,
                          child: Text(zone, style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color.fromRGBO(
                              0, 96, 92, 1.0)),),
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          currentTimeZone=value!;
                        });
                      }),
                ),
              ),
            ),
          ),

          //to display Current time for specific timezone  - user can chnage
          const Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Center(child: Text("Current Time (24h)",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Colors.teal),),),
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
                      hintStyle: TextStyle(
                        fontSize: 30.0,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold
                      ),
                      contentPadding: EdgeInsets.all(15.0),
                    ),
                    style: const TextStyle(
                      fontSize: 30.0,
                      color: Colors.teal,
                        fontWeight: FontWeight.bold

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
                            selection: TextSelection.collapsed(
                                offset: '$hours:$minutes'.length
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),

              ),
            ),
          ),

          //to select the destination time zone- which also user can change. here user select the timezone
          const Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Center(child: Text("Destination Time Zone",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Colors.teal),),),
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
                      items: timeZones.map((String zone){
                        return DropdownMenuItem<String>(
                          value: zone,
                          child: Text(zone, style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color.fromRGBO(
                              0, 96, 92, 1.0),
                          ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          destinationTimeZone=value!;
                        });
                      }),
                ),

              ),
            ),
          ),

          //this will display the current time of the destination timezone.
          //here is to show output of the current time in the destination time zone.
          const Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Center(child: Text("Destination Time/Converted Time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Colors.teal),),),
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
                  child: Text(
                    convertedTime,
                    style: const TextStyle(fontSize: 30,color: Colors.teal,fontWeight: FontWeight.bold),
                  ),
                ),

              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(

                onPressed:_convertTime,
                style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.teal,
                    disabledBackgroundColor: const Color.fromRGBO(
                        3, 105, 86, 0.30196078431372547),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),

                child: const Text("🕐 Convert Time",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white),)),
          )
        ],
      ),
    ]
    ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:lottie/lottie.dart';
//
// class TZC extends StatefulWidget {
//   const TZC({super.key});
//
//   @override
//   State<TZC> createState() => _TZCState();
// }
//
// class _TZCState extends State<TZC> {
//   final List<String> timeZones = [
//     '-12:00', '-11:00', '-10:00', '-09:00', '-08:00', '-07:00', '-06:00',
//     '-05:00', '-04:00', '-03:00', '-02:00', '-01:00', '+00:00', '+01:00',
//     '+02:00', '+03:00', '+03:30', '+04:00', '+04:30', '+05:00', '+05:30',
//     '+05:45', '+06:00', '+06:30', '+07:00', '+08:00', '+09:00', '+10:00',
//     '+11:00', '+12:00',
//   ];
//
//   String currentTimeZone = '+00:00';
//   String destinationTimeZone = '+00:00';
//   String convertedTime = '';
//   final TextEditingController timeInputController = TextEditingController();
//
//   void _convertTime() {
//     if (timeInputController.text.isEmpty) {
//       setState(() {
//         convertedTime = "Please enter the current time!";
//       });
//       return;
//     }
//     try {
//       final inputTimeParts = timeInputController.text.split(':');
//       final hours = int.parse(inputTimeParts[0]);
//       final minutes = int.parse(inputTimeParts[1]);
//
//       final now = DateTime.now();
//       final userTime = DateTime(now.year, now.month, now.day, hours, minutes);
//
//       final sourceOffset = _parseTimeZoneOffset(currentTimeZone);
//       final destOffset = _parseTimeZoneOffset(destinationTimeZone);
//
//       final sourceTime = userTime.subtract(Duration(hours: sourceOffset[0], minutes: sourceOffset[1]));
//       final destinationTime = sourceTime.add(Duration(hours: destOffset[0], minutes: destOffset[1]));
//
//       setState(() {
//         convertedTime = "${_twoDigits(destinationTime.hour)}:${_twoDigits(destinationTime.minute)}";
//       });
//     } catch (e) {
//       setState(() {
//         convertedTime = "Invalid time format! Use HH:mm.";
//       });
//     }
//   }
//
//   List<int> _parseTimeZoneOffset(String timeZone) {
//     final sign = timeZone.contains('+') ? 1 : -1;
//     final parts = timeZone.split(RegExp(r'[+-]'))[1].split(':');
//     final hours = int.parse(parts[0]) * sign;
//     final minutes = parts.length > 1 ? int.parse(parts[1]) * sign : 0;
//     return [hours, minutes];
//   }
//
//   String _twoDigits(int n) => n.toString().padLeft(2, '0');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Animated Background
//           Positioned.fill(
//             child: Lottie.asset('images/background_animation3.json', fit: BoxFit.fitWidth),
//           ),
//           // Main Content
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Time Zone Converter",
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               const SizedBox(height: 20),
//               _buildDropdown("Current Time Zone", currentTimeZone, (value) {
//                 setState(() {
//                   currentTimeZone = value!;
//                 });
//               }),
//               const SizedBox(height: 10),
//               _buildTimeInputField(),
//               const SizedBox(height: 10),
//               _buildDropdown("Destination Time Zone", destinationTimeZone, (value) {
//                 setState(() {
//                   destinationTimeZone = value!;
//                 });
//               }),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: _convertTime,
//                 icon: const Icon(Icons.access_time, color: Colors.white),
//                 label: const Text(
//                   "Convert Time",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
//                   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Converted Time: $convertedTime",
//                 style: const TextStyle(fontSize: 24, color: Colors.white),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDropdown(String label, String value, ValueChanged<String?> onChanged) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 20, color: Colors.tealAccent, fontWeight: FontWeight.bold),
//         ),
//         Container(
//           margin: const EdgeInsets.all(10),
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.white, width: 2),
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: DropdownButton<String>(
//             value: value,
//             items: timeZones.map((String zone) {
//               return DropdownMenuItem<String>(
//                 value: zone,
//                 child: Text(zone, style: const TextStyle(fontSize: 18, color: Colors.tealAccent)),
//               );
//             }).toList(),
//             onChanged: onChanged,
//             underline: const SizedBox(),
//             dropdownColor: Colors.teal,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTimeInputField() {
//     return Column(
//       children: [
//         const Text(
//           "Enter Current Time (24h)",
//           style: TextStyle(fontSize: 20, color: Colors.tealAccent, fontWeight: FontWeight.bold),
//         ),
//         Container(
//           margin: const EdgeInsets.all(10),
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.white, width: 2),
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: TextField(
//             controller: timeInputController,
//             keyboardType: TextInputType.number,
//             inputFormatters: [
//               FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}(:\d{0,2})?$')),
//               LengthLimitingTextInputFormatter(5),
//             ],
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               hintText: 'HH:mm',
//               hintStyle: TextStyle(color: Colors.tealAccent),
//             ),
//             style: const TextStyle(fontSize: 18, color: Colors.tealAccent),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
