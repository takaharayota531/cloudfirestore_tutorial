import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyFirestorePage(),
    );
  }
}

class MyFirestorePage extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<MyFirestorePage> {
  List<DocumentSnapshot> documentList = [];
  String orderDocumentInfo = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: Text('コレクション＋ドキュメント作成'),
              onPressed: () async {
                // ドキュメント作成
                await FirebaseFirestore.instance
                    .collection('users') // コレクションID
                    .doc('id_abc') // ドキュメントID
                    .set({'name': '鈴木', 'age': 40}); // データ
              },
            ),
            ElevatedButton(
              child: Text('コレクションとドキュメント作成'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users') // コレクションID
                    .doc('id_abc') // ドキュメントID << usersコレクション内のドキュメント
                    .collection('orders') // サブコレクションID
                    .doc('id_123') // ドキュメントID << サブコレクション内のドキュメント
                    .set({'price': 600, 'date': '9/13'}); // データ
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  final snapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .get();
                  setState(() {
                    documentList = snapshot.docs.toList();
                  });
                },
                child: Text('ドキュメント一覧取得')),
            Column(
              children: documentList.map((document) {
                return ListTile(
                  title: Text('${document['name']}さん'),
                  subtitle: Text('${document['age']}歳'),
                );
              }).toList(),
            ),
            ElevatedButton(
                child: Text('ドキュメントを指定して取得'),
                onPressed: () async {
                  final doc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc('id_abc')
                      .collection('orders')
                      .doc('id_123')
                      .get();
                  setState(() {
                    orderDocumentInfo = '${doc['date']}+${doc['price']}';
                  });
                }),
            ListTile(title: Text(orderDocumentInfo)),
          ],
        ),
      ),
    );
  }
}
