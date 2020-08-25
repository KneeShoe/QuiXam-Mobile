import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quixam/PasswordUtils.dart';

import 'SReg.dart';
import 'TReg.dart';

class LoginPage extends StatefulWidget{

    @override
    State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
    final _scaffoldKey= new GlobalKey<ScaffoldState>();
    final db= FirebaseDatabase.instance;
    String _usn;
    String _password;
    String _salt;
    String _hash;
    final formkey = new GlobalKey<FormState>();

    void validateAndSubmit() async {
      PasswordUtils pu=new PasswordUtils();
      formkey.currentState.save();
      if(formkey.currentState.validate()) {
        final ref=db.reference();
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text("Logging in..."),)
        );
        final cred= await ref.child("Credentials").orderByChild("usn").equalTo(_usn).once();
        Map<dynamic, dynamic> values=cred.value;
        if(cred.value == null){
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("User does not exist"),)
          );
        }
        else{
          values.forEach((key, value) {
            _salt = value['salt'];
            _hash = value['hash'];
          });
          if(pu.verify(_password, _salt, _hash)){
            _scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text("Login Succesful"),)
            );
          }else{
            _scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text("Wrong Password"),)
            );
          }
        }
      }
    }

    Future navigateToTReg(context) async {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TRegisteration()));
    }

    Future navigateToSReg(context) async {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SRegisteration()));
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            title: new Text("Login Page"),
            backgroundColor: Color.fromRGBO(166 ,118, 51, 1),
          ),
          body: new Container(
            color: Color.fromRGBO(247, 216, 189,1),
            padding: EdgeInsets.only(top: 100, left: 50, right: 50),
            child: new Form(
              key: formkey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget> [
                  new Text("QuiXam", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Color.fromRGBO(166 ,118, 51, 1)), ),
                  new TextFormField( decoration: new InputDecoration(labelText: "USN"),
                                      validator: (value)=> value.isEmpty ? 'Please fill in the USN' : null,
                                      onSaved: (value) => _usn=value,),
                  new TextFormField( decoration: new InputDecoration(labelText: "Password"), obscureText: true,
                                      validator: (value)=> value.isEmpty ? 'Please fill in the password' : null,
                                      onSaved: (value) => _password=value,),
                  new RaisedButton(
                    color: Color.fromRGBO(166 ,118, 51, 1),
                      child: new Text("Login", style: new TextStyle(fontSize: 20),),
                      onPressed: validateAndSubmit,
                  ),new Row(
                    children: [
                       new FlatButton(
                         child: new Text("Register as Teacher", style: new TextStyle(fontSize: 13),),
                         onPressed:() {
                            navigateToTReg(context);
                        }
                      ),
                      new FlatButton(
                         child: new Text("Register as Student", style: new TextStyle(fontSize: 13),),
                          onPressed:(){
                            navigateToSReg(context);
                         }
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
        );
    }
}