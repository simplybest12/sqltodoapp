import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqltodo/database2.dart';
import 'package:path_provider/path_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  bool _isPressed = false;
  List<Map<String, dynamic>> _journals = [];
  File? _image;
  final picker = ImagePicker();
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

  Future _addItem() async {
    await SQLhelper.createItem(
        _titleController.text, _descriptionController.text);
    refreshJournals();
  }

  Future _updateItem(int id) async {
    await SQLhelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    refreshJournals();
    print("ID Is $id");
  }

  void _deleteItem(int id) async {
    await SQLhelper.deleteItem(id);
    print('Deleted Id $id');
    refreshJournals();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Successfully Deleted")));
  }

  void checkBoxFunction(int index) {
    setState(() {
      _journals[index] = _journals[index];
    });
    refreshJournals();
  }

  void showForm(int? id) async {
    //to update our result and submit to database
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  top: 16,
                  left: 25,
                  right: 25,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 120),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                    controller: _titleController,
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await _addItem();
                        } else {
                          await _updateItem(id);
                        }
                        //clear text field safter click
                        _titleController.text = '';
                        _descriptionController.text = '';
                        //close
                        Navigator.pop(context);
                      },
                      child: Text(id == null ? "Create" : "Update"))
                ],
              ),
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshJournals();
    print("Success");
    print(".. number of times ${_journals.length}");
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
                      child: _image!=null?
                          CircleAvatar(
                              backgroundImage: FileImage(_image!,
                              
                              ),
                              radius: 35,
                            )
                          :const Icon(
                              CupertinoIcons.profile_circled,
                              size: 55,
                            )

                      // :Container(
                      //     child:Image.file(imageFile,fit: BoxFit.cover,)
                      //     ),
                      ),
                ],
              ),
            ),
            Divider(
              color: Colors.black54,
              thickness: 1.5,
            ),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: _journals.length,
              itemBuilder: (context, index) => Slidable(
                endActionPane: ActionPane(motion: StretchMotion(), children: [
                  SlidableAction(
                    autoClose: true,
                    onPressed: (value) {
                      _deleteItem(_journals[index]['id']);
                    },
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  SlidableAction(
                    onPressed: (value) {
                      showForm(_journals[index]['id']);
                    },
                    backgroundColor: Colors.blue,
                    icon: Icons.edit,
                    borderRadius: BorderRadius.circular(30),
                  )
                ]),
                child: GestureDetector(
                  onTap: () {
                    checkBoxFunction(index);
                  },
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                      color: Colors.white,
                      margin: const EdgeInsets.all(15),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _journals[index]['title'].toString(),
                            style: TextStyle(
                                decoration: _isPressed
                                    ? TextDecoration.none
                                    : TextDecoration.lineThrough),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child:
                              Text(_journals[index]['description'].toString()),
                        ),
                        trailing: SizedBox(
                          width: 50,
                          child: Text(
                            _journals[index]['createdAt'],
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

   void _getFromGallery() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery);
      setState(() {
        _image = image as File?;
      });
    
  }
}
