import 'package:flutter/material.dart';

class Registeration extends StatefulWidget {
  @override
  _RegisterationState createState() => _RegisterationState();
}

class _RegisterationState extends State<Registeration> {

  final formKey = new GlobalKey<FormState>();
  String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration Page"),
        backgroundColor: Color.fromRGBO(166 ,118, 51, 1),
      ),
      body: new Container(
        color: Color.fromRGBO(247, 216, 189,1),
        padding: EdgeInsets.only(top: 100, left: 50, right: 50),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text("Registration Page", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Color.fromRGBO(166 ,118, 51, 1)), ),
              new TextFormField( decoration: new InputDecoration(labelText: "Name"),
                validator: (value)=> value.isEmpty ? 'Please fill in your name' : null,
                onSaved: (value) => _name=value,),
              new TextFormField( decoration: new InputDecoration(labelText: "USN"),
                validator: (value)=> value.isEmpty ? 'Please fill in your USN' : null,
                onSaved: (value) => _name=value,),
              new TextFormField( decoration: new InputDecoration(labelText: "Name"),
                validator: (value)=> value.isEmpty ? 'Please fill in your name' : null,
                onSaved: (value) => _name=value,),
            ],
          ),
        ),
        )
      );
    }
}
