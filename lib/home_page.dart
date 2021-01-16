import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:ui';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _controller = TextEditingController();
  String _search;
  int _reqs = 100; //Essa é a variavel responsável pela paginação.
  List listResources = []; // lista que armazena os recursos de tradução após a primeira requisição.


  Future<List> _getSearch() async{
    if(listResources.length == 0){
      http.Response response;
      response = await http.get("http://portal.greenmilesoftware.com/get_resources_since/");
      listResources = json.decode(response.body);
      return listResources;
    }else{
      return listResources;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("images/logo_greenmile.png", color: Colors.white, width: 220.0),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Search here",
                labelStyle: TextStyle(color: Colors.lightGreen),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightGreen),
                  borderRadius: BorderRadius.all(Radius.circular(15.0))
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                    borderRadius: BorderRadius.all(Radius.circular(15.0))
                ),
                prefixIcon: Icon(Icons.search, color: Colors.lightGreen,),
              ),
              style: TextStyle(color: Colors.lightGreen, fontSize: 18.0),
              textAlign: TextAlign.start,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getSearch(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 250.0,
                      height: 250.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if(snapshot.hasError){
                      return Container(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: AlertDialog(
                          title: Text(
                            "Error: Unable to load data, please check your internet connection!",
                            style: TextStyle(color: Colors.redAccent, fontSize: 18.0),
                            textAlign: TextAlign.justify,
                          ),
                          content: Text(
                            "Click the button to try to reestablish the connection!",
                            style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                            textAlign: TextAlign.justify,
                          ),
                          actions: [
                            FlatButton(
                              child: Text(
                                "Try reconnecting",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16.0,
                                ),
                              ),
                              onPressed: (){
                                setState(() {

                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(color: Colors.blueAccent),
                              ),
                            ),
                          ],
                          backgroundColor: Colors.grey[200],
                          scrollable: true,
                        )
                      );

                    }else{
                      //print(list);
                      return _createTable(context, snapshot);
                    }
                }
              },
            ),
          ),
          // Esse container foi comentado, pois era o responsável pela parte de paginação.
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  key: Key("loadMoreData"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                  child: Text(
                    "Load more data",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  onPressed: (){
                    setState(() {
                      _search = "";
                      _reqs += 100;
                      _controller.text = "";
                    });
                  },
		  elevation: 5.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createTable(BuildContext context, AsyncSnapshot snapshot){
    return ListView.builder(
      itemCount: _reqs,//snapshot.data.length,//
      itemBuilder: (context, index){
        if(_search == null || _search == ""){
          return createComponent(snapshot.data, index);
        }else{
          if(_search.length == 2){
            if(snapshot.data[index]["resource"]["language_id"].toLowerCase() == _search.toLowerCase()){
              return createComponent(snapshot.data, index);
            }else if(snapshot.data[index]["resource"]["module_id"].toLowerCase() == _search.toLowerCase()){
              return createComponent(snapshot.data, index);
            }else{
              if(snapshot.data[index]["resource"]["language_id"].toLowerCase() == _search.toLowerCase() &&
                  !snapshot.data[index]["resource"]["value"].toLowerCase().contains(_search.toLowerCase())){
                return createComponent(snapshot.data, index);
              }else{
                return Container();
              }
            }
          }else{
            if(snapshot.data[index]["resource"]["language_id"].toLowerCase() == _search.toLowerCase()){
              return createComponent(snapshot.data, index);
            }else if(snapshot.data[index]["resource"]["module_id"].toLowerCase() == _search.toLowerCase()){
              return createComponent(snapshot.data, index);
            }else{
              if(snapshot.data[index]["resource"]["value"].toLowerCase().contains(_search.toLowerCase())){
                return createComponent(snapshot.data, index);
              }else{
                return Container();
              }
            }
          }
        }

      },
    );
  }

  Widget createComponent(List list, int index){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.grey[300],
      ),
      padding: EdgeInsets.all(10.0),
      margin: index == 0 ? EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0) : EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Resource_id: ${list[index]["resource"]["resource_id"]}", maxLines: 5),
          Divider(color: Colors.black),
          Text("Updated_at: ${list[index]["resource"]["updated_at"]}"),
          Divider(color: Colors.black),
          Text("Value: ${list[index]["resource"]["value"]}", maxLines: 10,),
        ],
      ),
    );
  }

}
