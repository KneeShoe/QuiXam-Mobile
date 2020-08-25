import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quixam/PasswordUtils.dart';


class SRegisteration extends StatefulWidget {
  @override
  _SRegisterationState createState() => _SRegisterationState();
}

class _SRegisterationState extends State<SRegisteration> {

  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final dbRef = FirebaseDatabase.instance.reference().child("Credentials");
  String _name;
  String _usn;
  String _pass;
  String _sec;
  String _sem;
  String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Registration"),
        backgroundColor: Color.fromRGBO(166 ,118, 51, 1),
      ),
      body: new Container(
        color: Color.fromRGBO(247, 216, 189,1),
        padding: EdgeInsets.all(25),
        child: new Form(
          key: _formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text("Student Registration", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Color.fromRGBO(166 ,118, 51, 1)), ),


              new TextFormField( decoration: new InputDecoration(labelText: "Name"),
                validator: (value)=> value.isEmpty ? 'Please fill in your name' : null,
                onSaved: (value) => _name=value,),


              new TextFormField( decoration: new InputDecoration(labelText: "USN"),
                validator: (value)=> value.isEmpty ? 'Please fill in your USN' : null,
                onSaved: (value) => _usn=value,),


              new TextFormField( decoration: new InputDecoration(labelText: "Password"),
                validator: (value)=> value.isEmpty ? 'Please fill in your password' : null,
                autofocus: false, obscureText: true,
                onSaved: (value) => _pass=value,),


              new TextFormField( decoration: new InputDecoration(labelText: "Confirm Password"),
                validator: (value)=> value!=_pass ? 'Passwords did not match' : null,
                autofocus: false, obscureText: true,),


              new TextFormField( decoration: new InputDecoration(labelText: "Semester"),
                validator: (value)=> value.isEmpty ? 'Please fill in your semester' : null,
                onSaved: (value) => _sem=value,),


              new TextFormField( decoration: new InputDecoration(labelText: "Section"),
                validator: (value)=> value.isEmpty ? 'Please fill in your section' : null,
                onSaved: (value) => _sec=value,),


              new TextFormField( decoration: new InputDecoration(labelText: "Email"),
                validator: (value)=> value.isEmpty ? 'Please fill in your Email' : null,
                onSaved: (value) => _email=value,),


              new RaisedButton(
                color: Color.fromRGBO(166 ,118, 51, 1),
                onPressed: ()  {
                  _formKey.currentState.save();
                  if (_formKey.currentState.validate()) {
//                    final ref = db.reference();
//                    _scaffoldKey.currentState.showSnackBar(
//                        SnackBar(content: Text("Logging in..."),)
//                    );
//                    final cred = await ref.child("Credentials").orderByChild(
//                        "usn").equalTo(_usn).once();
//                    Map<dynamic, dynamic> values = cred.value;
//                    if (cred.value == null) {
//                      _scaffoldKey.currentState.showSnackBar(
//                          SnackBar(content: Text("User does not exist"),)
//                      );
//                    }
                      PasswordUtils pu = new PasswordUtils();
                      List l1 = pu.hash(_pass);
                      dbRef.push().set({
                        "name": "$_name",
                        "usn": "$_usn",
                        "hash": l1[0],
                        "salt": l1[1],
                        "sec": "$_sec",
                        "sem": "$_sem",
                        "email": "$_email",
                        "type": "Student",
                      }).then((_) {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Successfully Added')));
                      }).catchError((onError) {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text(onError)));
                      });
                    }
                },
                child: Text('Submit'),
              ),
              RaisedButton(
                onPressed: (){

                },
              )
            ],
          ),
        ),
        )
      );
    }
}
