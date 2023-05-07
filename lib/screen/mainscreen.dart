import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqltodo/database2.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late File imageFile;
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void refreshJournals() async {
    final data = await SQLhelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  _getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _getFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void showForm(int? id) async {
    //to update our result and submit to database
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];

    showModalBottomSheet(context: context,
      isScrollControlled: true,

       builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom+120
        ),
        
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            SizedBox(height: 10,),
            TextField(
         
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshJournals();
    print("Success");
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String date = DateFormat.d().format(today);
    String day = DateFormat.EEEE().format(today);
    String month = DateFormat.LLLL().format(today);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "To Do".toUpperCase(),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showForm(null);
        },
        backgroundColor: Colors.black54,
        child: Icon(Icons.add),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                        Text(
                          "${day}, ${date} ${month}",
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        _getFromGallery();
                      },
                      child: Container(
                          child: Icon(
                        CupertinoIcons.profile_circled,
                        size: 55,
                      )),
                    ),
                    Divider(
                      color: Colors.black54,
                      thickness: 1.5,
                    ),
                    Container(
                      height: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
