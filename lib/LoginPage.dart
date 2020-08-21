import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Registeration.dart';

class LoginPage extends StatefulWidget{

    @override
    State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
    FirebaseAuth auth = FirebaseAuth.instance;
    String _email;
    String _password;
    final formkey = new GlobalKey<FormState>();


    bool ValidateAndSave(){
      final form = formkey.currentState;
      if(form.validate()){
        form.save();
        return true;
      }
      return false;
    }

    void ValidateAndSubmit() async {

      if (ValidateAndSave()) {
        try {
          UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _email,
              password: _password
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }else
            print(e.code);
        }
      }
    }

    Future navigateToSubPage(context) async {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Registeration()));
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
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
                  new TextFormField( decoration: new InputDecoration(labelText: "Email"),
                                      validator: (value)=> value.isEmpty ? 'Please fill in the email' : null,
                                      onSaved: (value) => _email=value,),
                  new TextFormField( decoration: new InputDecoration(labelText: "Password"), obscureText: true,
                                      validator: (value)=> value.isEmpty ? 'Please fill in the password' : null,
                                      onSaved: (value) => _password=value,),
                  new RaisedButton(
                    color: Color.fromRGBO(166 ,118, 51, 1),
                      child: new Text("Login", style: new TextStyle(fontSize: 20),),
                      onPressed: ValidateAndSubmit,
                  ),
                  new FlatButton(
                    child: new Text("Create a new Account?", style: new TextStyle(fontSize: 15),),
                    onPressed:(){
                      navigateToSubPage(context);
                    }
                  )
                ],
              ),
            )
          ),
        );
    }
}