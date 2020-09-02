import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quixam/Misc/Session_Id.dart';

class TDash extends StatefulWidget {
  @override
  _TDashState createState() => _TDashState();
}

class _TDashState extends State<TDash> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name = Session_Id.getName();
  List lists = new List();
  List classes = new List();
  List classList = new List();
  final dbRef = FirebaseDatabase.instance.reference().child("Classes");
  String nSem, nSec, cname;

  void validateAndSubmit() async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      classList.clear();
      try {
        final ds = await dbRef.orderByChild(nSem).orderByChild(nSec).once();
        Map<dynamic, dynamic> classP = ds.value;
        if (classP != null) {
          classP.forEach((key, value) {
            classList.add(key);
          });
          if (classList.contains(cname)) {
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: Text("That class already exists"),
            ));
            return;
          }
        }
      } catch (onError) {
        dbRef.child(nSem).child(nSec).child(cname).set({
          "tname": Session_Id.getName().toString(),
        }).then((value) => _scaffoldKey.currentState.reassemble());
      }
    }
    _formKey.currentState.reset();
    _scaffoldKey.currentState.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Welcome, $_name"),
          backgroundColor: Color.fromRGBO(166, 118, 51, 1),
        ),
        body: Container(
          color: Color.fromRGBO(247, 216, 189, 1),
          padding: EdgeInsets.all(10),
          child: new Column(children: [
            Flexible(
              flex: 2,
              child: new Card(
                child: new Form(
                    key: _formKey,
                    child: Column(children: [
                      Spacer(),
                      Flexible(
                        flex: 4,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Expanded(
                              flex: 3,
                              child: new TextFormField(
                                decoration:
                                    new InputDecoration(labelText: "Semester"),
                                validator: (value) => value.isEmpty
                                    ? 'Please fill in the semester'
                                    : null,
                                onSaved: (value) => nSem = value,
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 3,
                              child: new TextFormField(
                                decoration:
                                    new InputDecoration(labelText: "Section"),
                                validator: (value) => value.isEmpty
                                    ? 'Please fill in the section'
                                    : null,
                                onSaved: (value) => nSec = value,
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 6,
                              child: new TextFormField(
                                decoration: new InputDecoration(
                                    labelText: "Class Name"),
                                validator: (value) => value.isEmpty
                                    ? 'Please fill in the class name'
                                    : null,
                                onSaved: (value) => cname = value,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Spacer(),
                      Flexible(
                        flex: 5,
                        child: new RaisedButton(
                          color: Color.fromRGBO(166, 118, 51, 1),
                          onPressed: validateAndSubmit,
                          child: Text('Submit'),
                        ),
                      ),
                      Spacer(),
                    ])),
              ),
            ),
            Flexible(
              flex: 8,
              child: new Container(
                child: FutureBuilder(
                    future: dbRef.once(),
                    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        classes.clear();
                        Map<dynamic, dynamic> values = snapshot.data.value;
                        if (values == null) {
                          print(Session_Id.getName());
                          return new Text(
                            "Please add classes. You currently have '0' classes.",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          );
                        }
                        values.forEach((semester, section) {
                          section.forEach((className, value) {
                            value.forEach((key, teachName) {
                              if (teachName['tname'] == Session_Id.getName()) {
                                classes.add({
                                  "sem": semester,
                                  "sec": section.toString()[1],
                                  "cname": key,
                                });
                              }
                            });
                          });
                        });
                        return new ListView.builder(
                            shrinkWrap: true,
                            itemCount: classes.length,
                            padding: EdgeInsets.all(25),
                            itemBuilder: (BuildContext context, int index) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 5,
                                              top: 20,
                                              right: 20,
                                              bottom: 20),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(classes[index]["cname"],
                                                    style: new TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Row(children: <Widget>[
                                                  Text(
                                                    classes[index]["sem"],
                                                    style: new TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  SizedBox(width: 7,),
                                                  Text(classes[index]["sec"],
                                                      style: new TextStyle(
                                                          fontSize: 20)),
                                                ],)
                                              ],
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Session_Id.setClassId(
                                              classes[index]["cname"]);
                                          Session_Id.setSem(
                                            classes[index]["sem"]);
                                          Session_Id.setSec(
                                            classes[index]["sec"]);
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              );
                            });
                      }
                      return Center(child:CircularProgressIndicator());
                    }),
              ),
            ),
          ]),
        ));
  }
}
