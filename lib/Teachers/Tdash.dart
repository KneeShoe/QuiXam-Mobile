import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quixam/MIsc/Session_Id.dart';

class TDash extends StatefulWidget {
  @override
  _TDashState createState() => _TDashState();
}

class _TDashState extends State<TDash> {

  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey= new GlobalKey<ScaffoldState>();
  String _name=Session_Id.getName();
  List lists= new List();
  List classes= new List();
  List classesData= new List();
  List classList= new List();
  final dbRef = FirebaseDatabase.instance.reference().child("Classes");
  String nSem,nSec,cname;

  void validateAndSubmit() async {
    _formKey.currentState.save();
    if(_formKey.currentState.validate()){
       classList.clear();
       final ds= await dbRef.orderByChild(nSem).orderByChild(nSec).once();
       Map<dynamic, dynamic> classP= ds.value;
       if(classP  == null)
         return
       classP.forEach((key, value) {
         classList.add(key);
       });
       if(classList.contains(cname)){
         _scaffoldKey.currentState.showSnackBar(new SnackBar(
           content: Text("That class already exists"),
         ));
       }else{
         dbRef.child(nSem).child(nSec).child(cname).set({
           "tname":Session_Id.getName().toString(),
         }).then((value) => _scaffoldKey.currentState.reassemble());
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Welcome, $_name"),
        backgroundColor: Color.fromRGBO(166 ,118, 51, 1),
      ),
      body: new Column(
        children: [
         new Card(
          child: new Form(
            key: _formKey,
            child: Column(
              children: [
                new Row(
                  children: [
                      new TextFormField(
                        decoration: new InputDecoration(labelText: "Semester"),
                        validator: (value)=> value.isEmpty ? 'Please fill in the semester' : null,
                        onSaved: (value) => nSem=value,
                      ),
                      new TextFormField(
                        decoration: new InputDecoration(labelText: "Semester"),
                        validator: (value)=> value.isEmpty ? 'Please fill in the semester' : null,
                        onSaved: (value) => nSec=value,
                      ),
                      new TextFormField(
                        decoration: new InputDecoration(labelText: "Semester"),
                        validator: (value)=> value.isEmpty ? 'Please fill in the semester' : null,
                        onSaved: (value) => cname=value,
                      )
                  ],
                ),
                new RaisedButton(
                  color: Color.fromRGBO(166 ,118, 51, 1),
                  onPressed: validateAndSubmit,
                  child: Text('Submit'),
                )
              ]
            )
          ),
         ),
        new Container(
        color: Color.fromRGBO(247, 216, 189,1),
          child: FutureBuilder(
              future: dbRef.child(Session_Id.getSem()).orderByChild(Session_Id.getSec()).once(),
              builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                if (snapshot.hasData) {
                  classes.clear();
                  Map<dynamic, dynamic> values = snapshot.data.value;
                  if(values== null)
                    return new Text("There are no classes for your section as of now.", textAlign: TextAlign.center,style: new TextStyle(fontSize: 30,fontWeight: FontWeight.bold),);
                  values.forEach((key, values) {
                    classes.add(key);
                    classesData.add(values);
                  });
                  return new ListView.builder(
                      shrinkWrap: true,
                      itemCount: classes.length,
                      padding: EdgeInsets.all(25),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(classes[index]),
                              Text(classesData[index]["tname"]),
                            ],
                          ),
                        );
                      });
                }
                return CircularProgressIndicator();
             }),
           ),
         ]
      )
    );
  }
}
