import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String date = DateFormat.d().format(today);
    String day = DateFormat.EEEE().format(today);
    String month = DateFormat.LLLL().format(today);

    return Scaffold(
      appBar: AppBar(
        title: Text("To Do".toUpperCase(),style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.5
        ),),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(26),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Today's Task",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text("${day}, ${date} ${month}",style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),)
                      ],
                    ),
                    Spacer(),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "New Task",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 219, 239, 246),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.black54,
                thickness: 1.5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
