import 'package:flutter/material.dart';


class TZC extends StatefulWidget {
  const TZC({super.key});

  @override
  State<TZC> createState() => _TZCState();
}

class _TZCState extends State<TZC> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Center(
          child: Text('Time Zone Converter',style: TextStyle(
            fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white
          ),
          ),
        ),
      ),

      //to display current timezone - user able to change the current time zone
      body: Column(
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
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.teal,
                    width: 5.0,
                  )
                ),
              ),
            ),
          ),

          //to display Current time for specific timezone  - user can chnage
          const Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Center(child: Text("Current Time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Colors.teal),),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Center(
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.teal,
                      width: 5.0,
                    )
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
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.teal,
                      width: 5.0,
                    )
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
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.teal,
                      width: 5.0,
                    )
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
