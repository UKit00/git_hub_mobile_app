import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserRepositoriePage extends StatefulWidget {
  String login = "";
  String avatarUrl;

  UserRepositoriePage({required this.login, required this.avatarUrl});

  @override
  State<UserRepositoriePage> createState() => _UserRepositoriePageState();
}

class _UserRepositoriePageState extends State<UserRepositoriePage> {
  dynamic data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loadRepo();
    });
  }

  void loadRepo() {
    Uri url = Uri.parse("https://api.github.com/users/${widget.login}/repos");
    http.get(url).then((response) {
      setState(() {
        data = json.decode(response.body);
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(this.widget.avatarUrl),
              radius: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "${widget.login}",
            ),
          ],
        ),
      ),
      body: Expanded(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("${data[index]["name"]}"),
            );
          },
          separatorBuilder: ((context, index) => Divider(
                height: 1,
                color: Colors.teal,
              )),
          itemCount: data.length,
        ),
      ),
    );
    //);
  }
}
