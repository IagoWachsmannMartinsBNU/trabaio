import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String cidade;
  String pais;
  String cep;
  var temperatura;
  var tempoDescricao;
  var tempoAgora;
  var umidadeAr;
  var vento;

  var logradouro;
  var complemento;
  var bairro;
  var estado;
  var ddd;

  Future getWeather() async {
    http.Response response = await http.get(
      "http://api.openweathermap.org/data/2.5/weather?q=$cidade&Brasil&appid=44185947ca3544e1860c1fc810deb997",
    );
    var results = jsonDecode(response.body);

    setState(() {
      this.temperatura = results['main']['temp'];
      this.tempoDescricao = results['weather'][0]['description'];
      this.tempoAgora = results['weather'][0]['main'];
      this.umidadeAr = results['main']['humidity'];
      this.vento = results['wind']['speed'];
    });
  }

  Future getCep() async {
    http.Response response = await http.get(
      "https://viacep.com.br/ws/$cep/json/",
    );
    var results = jsonDecode(response.body);

    setState(() {
      this.logradouro = results['logradouro'];
      this.complemento = results['complemento'];
      this.bairro = results['bairro'];
      this.cidade = results['localidade'];
      this.estado = results['uf'];
      this.ddd = results['ddd'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = new Form(
      key: _key,
      autovalidate: _validate,
      child: _formUI(),
    );
    return MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Previsão do tempo'),
        ),
        body: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(15.0),
            child: form,
          ),
        ),
      ),
    );
  }

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Cidade'),
          maxLength: 40,
          validator: _validarCidade,
          onSaved: (String val) {
            this.cidade = val;
          },
        ),
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Pais'),
          maxLength: 40,
          validator: _validarCidade,
          onSaved: (String val) {
            pais = val;
          },
        ),
        new SizedBox(height: 15.0),
        new RaisedButton(
          onPressed: _sendForm,
          child: new Text('Enviar'),
        ),
        Container(
          color: Colors.cyan[300],
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Clima: ' + tempoDescricao.toString()
                  : "",
              style: TextStyle(
                fontSize: 30,
              )),
        ),
        Container(
          color: Colors.blue[200],
          child: Text(
              temperatura.toString().isNotEmpty != null
                  ? 'temperatura ' + temperatura.toString()
                  : "",
              style: TextStyle(
                fontSize: 30,
              )),
        ),
        Container(
          color: Colors.deepPurple[200],
          child: Text(
              umidadeAr.toString() != null
                  ? 'Umidade Ar ' + umidadeAr.toString()
                  : "",
              style: TextStyle(
                fontSize: 30,
              )),
        ),
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Cep'),
          maxLength: 40,
          validator: _validarCep,
          onSaved: (String val) {
            cep = val;
          },
        ),
        new RaisedButton(
          onPressed: _sendForm,
          child: new Text('Enviar'),
        ),
        Container(
          color: Colors.cyan[300],
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Logradouro: ' + logradouro.toString()
                  : "",
              style: TextStyle(
                fontSize: 30,
              )),
        ),
        Container(
          color: Colors.cyan[300],
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Complemento: ' + complemento.toString()
                  : "",
              style: TextStyle(
                fontSize: 30,
              )),
        ),
        Container(
          color: Colors.cyan[300],
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Bairro: ' + bairro.toString()
                  : "",
              style: TextStyle(
                fontSize: 30,
              )),
        ),
        Container(
          color: Colors.cyan[300],
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Cidade: ' + cidade.toString()
                  : "",
              style: TextStyle(
                fontSize: 30,
              )),
        ),
        Container(
          color: Colors.cyan[300],
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Estado: ' + estado.toString()
                  : "",
              style: TextStyle(
                fontSize: 30,
              )),
        ),
        Container(
          color: Colors.cyan[300],
          child: Text(
              tempoDescricao.toString() != null ? 'DDD: ' + ddd.toString() : "",
              style: TextStyle(
                fontSize: 30,
              )),
        ),
      ],
    );
  }

  String _validarCidade(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe a cidade";
    } else if (!regExp.hasMatch(value)) {
      return "A cidade deve apenas caracteres de a-z ou A-Z";
    }
    return null;
  }

  String _validarCep(String value) {
    String patttern = r'(^[0-9 ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o cep";
    } else if (!regExp.hasMatch(value)) {
      return "o cep deve conter somente números";
    }
    return null;
  }

  _sendForm() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      this.getWeather();
      this.getCep();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
