import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quixam/Misc/Session_Id.dart';

class SDash extends StatefulWidget {
  @override
  _SDashState createState() => _SDashState();
}

class _SDashState extends State<SDash> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name = Session_Id.getName();
  List lists = new List();
  List classes = new List();
  List classesData = new List();
  final dbRef = FirebaseDatabase.instance.reference().child("Classes");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Welcome, $_name"),
        backgroundColor: Color.fromRGBO(166, 118, 51, 1),
      ),
      body: new Container(
        height: 1000,
        color: Color.fromRGBO(247, 216, 189, 1),
        child: FutureBuilder(
            future: dbRef
                .child("S"+Session_Id.getSem())
                .child(Session_Id.getSec())
                .once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                classes.clear();
                Map<dynamic, dynamic> values = snapshot.data.value;
                if (values == null) {
                  return Column(
                    children: [
                      new Text(
                        "There are no classes for your section as of now. Please contact your faculty to add classes.",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  );
                } else {
                  values.forEach((semester, section) {
                    if(!(section is String))
                                classes.add({
                                  "tname": section["tname"],
                                  "cname": section["cname"],});
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
                                width:double.infinity,
                                child: RaisedButton(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  child: Container(
                                    padding: EdgeInsets.all(25),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            classes[index]["cname"].toString(),
                                            style: new TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(classes[index]["tname"].toString(),
                                              style: new TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Session_Id.setClassId(classes[index].toString());
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      });
                }
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
