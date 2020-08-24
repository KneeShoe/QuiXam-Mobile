import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class TRegisteration extends StatefulWidget {
  @override
  _TRegisterationState createState() => _TRegisterationState();
}

class _TRegisterationState extends State<TRegisteration> {

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  final dbRef = FirebaseDatabase.instance.reference().child("Credentials");
  String _name;
  String _fid;
  String _pass;
  String _cpass;
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
                new Text("Teacher Registration", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Color.fromRGBO(166 ,118, 51, 1)), ),

                new TextFormField( decoration: new InputDecoration(labelText: "Name"),
                  validator: (value)=> value.isEmpty ? 'Please fill in your name' : null,
                  onSaved: (value) => _name=value,),

                new TextFormField( decoration: new InputDecoration(labelText: "Faculty ID"),
                  validator: (value)=> value.isEmpty ? 'Please fill in your FID' : null,
                  onSaved: (value) => _fid=value,),

                new TextFormField( decoration: new InputDecoration(labelText: "Password"),
                  validator: (value)=> value.isEmpty ? 'Please fill in your password' : null,
                  autofocus: false, obscureText: true,
                  onSaved: (value) => _pass=value,),

                new TextFormField( decoration: new InputDecoration(labelText: "Confirm Password"),
                  validator: (value)=> value!=_pass ? 'Passwords did not match' : null,
                  autofocus: false, obscureText: true,
                  onSaved: (value) => _cpass=value,),

                new TextFormField( decoration: new InputDecoration(labelText: "Email"),
                  validator: (value)=> value.isEmpty ? 'Please fill in your Email' : null,
                  onSaved: (value) => _email=value,),

                new TextFormField( decoration: new InputDecoration(labelText: "Registeration Key"),
                  validator: (value)=> value!="112233" ? 'Wrong Key' : null,),

                new RaisedButton(
                  color: Color.fromRGBO(166 ,118, 51, 1),
                  onPressed: () {
                    _formKey.currentState.save();
                    _scaffoldKey.currentState.showSnackBar((SnackBar(
                      content: Text("Registering your User"),
                    )));
                    if (_formKey.currentState.validate()) {
                      dbRef.push().set({
                        "name": "$_name",
                        "usn": "$_fid",
                        "pass": "$_pass",
                        "email": "$_email",
                        "type": "Teacher",
                      }).then((_) {
                        _scaffoldKey.currentState.showSnackBar((SnackBar(
                          content: Text("Successfully added"),
                        )));
                      }).catchError((onError) {
                        _scaffoldKey.currentState.showSnackBar((SnackBar(
                          content: Text(onError),
                        )));
                      });
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        )
    );
  }
}
