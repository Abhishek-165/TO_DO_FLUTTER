import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:tasktracker/Database/database_helper.dart';
import 'package:tasktracker/taskpage.dart';

class AddTask extends StatefulWidget {

  
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  DateTime dateTime = DateTime.now();
  List<String> priorities = ['Low', 'Medium', 'High'];
  String _priority;
  String _status = "0";

  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat("MMM dd,yyyy");

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(2001),
      lastDate: DateTime(2050),
      initialDate: dateTime,
    );

    if (date != null && date != dateTime) {
      setState(() {
        dateTime = date;
      });

      _dateController.text = _dateFormat.format(date);
    }
  }

  _submit() async {
    if (_formKey.currentState != null && _formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("$_title,$_priority,$dateTime");

      await DatabaseHelper.instance.insert({
        DatabaseHelper.columntitle: _title,
        DatabaseHelper.columndate: _dateController.text,
        DatabaseHelper.columnpriority: _priority,
        DatabaseHelper.columnstatus: _status,
      });

      List<Map<String, dynamic>> verifyusernames =
          await DatabaseHelper.instance.queryAll();
      print(verifyusernames);

      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TaskPage(),
      ),
    );
    } else {
      print("error");
    }

    
  }

  @override
  void initState() {
    _dateController.text = _dateFormat.format(dateTime);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context)
            .unfocus(), //it is used to unfocus keyboard from the context
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Icon(Icons.arrow_back_ios_outlined,
                      color: Theme.of(context).primaryColor, size: 30.0),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskPage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 40.0),
                Text(
                  "Add Task",
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),

                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onSaved: (value) => _title = value,
                            initialValue: _title,
                          ),
                        ),

                        //date

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            readOnly: true, // to call only show date picker
                            controller: _dateController,
                            onTap: _handleDatePicker,
                            decoration: InputDecoration(
                              labelText: 'Date',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),

                        //priority

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: DropdownButtonFormField(
                            iconSize: 20.0,
                            icon: Icon(Icons.arrow_drop_down_circle),
                            iconEnabledColor: Theme.of(context).primaryColor,
                            items: priorities.map((String priority) {
                              return DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Priority',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),

                            // The validator receives the text that the user has entered.
                            validator: (value) => _priority == null
                                ? 'Please select an option'
                                : null,
                            value: _priority,
                            onChanged: (value) {
                              setState(() {
                                _priority = value;
                              });
                            },
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: FlatButton(
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                            onPressed: _submit,
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}


