import 'dart:async';
import 'dart:io';
import 'list.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
//Image Plugin
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File sampleImage;
  String filename;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
       filename=basename(sampleImage.path);
    });
  }
 Future getImageByCamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera,);
    setState(() {
      sampleImage = tempImage;
       filename=basename(sampleImage.path);
    });
  }
  


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Image Upload'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[

            Center(
            child: sampleImage == null ? Text('Select an image') : enableUpload(),
          ),
          SizedBox(height: 100.0,),
        Row(
          children: <Widget>[
            FloatingActionButton(
            onPressed: getImageByCamera,
            tooltip: 'Add Image by camera',
            child: new Icon(Icons.camera),
      ),
          
  FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image by gallery',
        child: new Icon(Icons.image),
      ),
      
      ],
        ), 
      ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(sampleImage, height: 300.0, width: 300.0),
          RaisedButton(child: Text('upload'),onPressed: () async {
          final StorageReference firebaseRef = FirebaseStorage.instance.ref().child(filename);
          final StorageUploadTask task = firebaseRef.putFile(sampleImage);
     var  downUrl = await (await task.onComplete).ref.getDownloadURL();
       var url =downUrl.toString();
         Image.network(url,height: 20.0,width: 20.0,);
       print('download Link: $url');
       SizedBox(height: 10.0,);
     
        },)
        ],
      ),
    );
  }
}
