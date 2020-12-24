import 'dart:core';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quixam/Misc/Session_Id.dart';

class createQuiz extends StatefulWidget {
  @override
  _createQuizState createState() => _createQuizState();
}

class _createQuizState extends State<createQuiz>{

  final _scaffoldKey= new GlobalKey<ScaffoldState>();
  final dbRef = FirebaseDatabase.instance.reference();
  List<TextEditingController> qnc = new List.generate(Session_Id.getTqn(), (_)=> TextEditingController());
  List<TextEditingController> opac = new List.generate(Session_Id.getTqn(), (_)=> TextEditingController());
  List<TextEditingController> opbc = new List.generate(Session_Id.getTqn(), (_)=> TextEditingController());
  List<TextEditingController> opcc = new List.generate(Session_Id.getTqn(), (_)=> TextEditingController());
  List<TextEditingController> opdc = new List.generate(Session_Id.getTqn(), (_)=> TextEditingController());
  List<TextEditingController> corrc = new List.generate(Session_Id.getTqn(), (_)=> TextEditingController());
  String dropdownValue='Select';

  Widget question(int index){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex:1,child: Text((index+1).toString()+")",style: new TextStyle(fontSize: 20),)),
                Expanded(
                  flex:12,
                  child: TextFormField(
                    decoration: new InputDecoration(labelText: "Question"),
                    validator: (value)=> value.isEmpty ? 'Please the Question' : null,
                    controller: qnc[index],),
                ),
              ],
            ),
            TextFormField(
              decoration: new InputDecoration(labelText: "Option A"),
              validator: (value)=> value.isEmpty ? 'Please enter option A' : null,
              controller: opac[index],),
            TextFormField(
              decoration: new InputDecoration(labelText: "Option B"),
              validator: (value)=> value.isEmpty ? 'Please enter option B' : null,
              controller: opbc[index],),
            TextFormField(
              decoration: new InputDecoration(labelText: "Option C"),
              validator: (value)=> value.isEmpty ? 'Please enter option C' : null,
              controller: opcc[index],),
            TextFormField(
              decoration: new InputDecoration(labelText: "Option D"),
              validator: (value)=> value.isEmpty ? 'Please enter option D' : null,
              controller: opdc[index],),
            TextFormField(
              decoration: new InputDecoration(labelText: "Correct Answer (A/B/C/D)"),
              validator: (value)=> value.isEmpty ? 'Please enter the correct answer(A,B,C,D)' : null,
              controller: corrc[index],),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(Session_Id.getqname()),
        backgroundColor: Color.fromRGBO(166, 118, 51, 1),
      ),
      body: Container(
        color: Color.fromRGBO(247, 216, 189, 1),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: Session_Id.getTqn(),
                itemBuilder: (BuildContext context, int index){
                  return question(index);
                },
              ),
            ),
            RaisedButton(
              child: Text("Create Quiz!", style: TextStyle(fontSize: 20),),
              onPressed: (){
                String sem= "S" + Session_Id.getSem();
                String sec= Session_Id.getSec();
                String classn= Session_Id.getClassId();
                var json={};
                for(int i=0;i<Session_Id.getTqn();i++){
                    json.addAll({
                      (i+1).toString() : {
                        "qn": qnc[i].value.text,
                        "opa": opac[i].value.text,
                        "opb": opbc[i].value.text,
                        "opc": opcc[i].value.text,
                        "opd": opdc[i].value.text,
                        "corr": corrc[i].value.text.toString().toLowerCase(),
                      }
                    });
                }
                dbRef.child("Classes").child(sem).child(sec).child(classn).push().set({
                  "qname": Session_Id.getqname(),
                  "Tqn": Session_Id.getTqn(),
                  "Nqn": Session_Id.getnqn(),
                });
                dbRef.child("Quizzes").child(Session_Id.getqname()).set(json);
                Navigator.pop(context);
              },
            )
          ],
        ),
      )
    );
  }
}
