import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quixam/Misc/Session_Id.dart';
import 'package:quixam/Teachers/createQuiz.dart';
import 'package:quixam/Teachers/tInsideClass.dart';

class tInsideClass extends StatefulWidget {
  @override
  _tInsideClassState createState() => _tInsideClassState();
}

class _tInsideClassState extends State<tInsideClass> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name = Session_Id.getName();
  List quizzes = new List();
  List quizList = new List();
  final dbRef = FirebaseDatabase.instance.reference();
  String nqnq,nmqn,nqname;
  List classes;

  void validateAndSubmit() async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      try {
        final ds = await dbRef.child("Quizzes").once();
        Map<dynamic, dynamic> quiz = ds.value;
        if (quiz != null) {
          if (quiz.containsKey(nqname)) {
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: Text("That quiz already exists"),
            ));
            return;
          }
        }
      } catch (onError) {
        print(onError);
      }finally{
        Session_Id.setqname(nqname);
        Session_Id.setTqn(int.parse(nmqn));
        Session_Id.setnqn(int.parse(nqnq));
      }
    }
    navigateToCreateQuiz(context);
    _formKey.currentState.reset();
    _scaffoldKey.currentState.reassemble();
  }

  void navigateToCreateQuiz(context) async{
    Navigator.push(context, MaterialPageRoute(builder: (context) => createQuiz()));
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
                    child: Column(
                        children: [
                          Spacer(),
                      Flexible(
                        flex: 4,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Expanded(
                              flex: 6,
                              child: new TextFormField(
                                decoration:
                                new InputDecoration(labelText: "Quiz Name"),
                                validator: (value) =>
                                value.isEmpty
                                    ? 'Please fill in the quiz name'
                                    : null,
                                onSaved: (value) => nqname = value,
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 2,
                              child: new TextFormField(
                                decoration:
                                new InputDecoration(labelText: "Max Qn"),
                                validator: (value) =>
                                value.isEmpty
                                    ? 'Please fill in the Max Qn'
                                    : null,
                                onSaved: (value) => nmqn = value,
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 2,
                              child: new TextFormField(
                                decoration: new InputDecoration(
                                    labelText: "Qn/quiz"),
                                validator: (value) =>
                                value.isEmpty
                                    ? 'Please fill in the Qn/quiz'
                                    : null,
                                onSaved: (value) => nqnq = value,
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
                    future: dbRef.child("Classes").child("S"+Session_Id.getSem()).child(Session_Id.getSec()).child(Session_Id.getClassId()).once(),
                    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        quizzes.clear();
                        Map<dynamic, dynamic> values = snapshot.data.value;
                        if (values == null) {
                          print(values);
                          return Padding(
                            padding: EdgeInsets.all(50),
                            child: new Text(
                              "Please add quizzes. You currently have '0' quizzes.",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        values.forEach((key, value) {
                          if(!(value is String))
                            quizzes.add(value["qname"]);
                        });
                        return Expanded(
                          flex: 8,
                              child: new ListView.builder(
                                physics: BouncingScrollPhysics(),
                                  itemCount: quizzes.length,
                                  shrinkWrap: true,
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
                                                  child: Text(quizzes[index],style: new TextStyle(fontSize: 30)),
                                                ),
                                              ),
                                              onPressed: () {
                                                Session_Id.setQname(quizzes[index]);
                                                print(quizzes[index]);
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    );
                                  }),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
              ),
            ),
          ]),
        ));
  }
}
