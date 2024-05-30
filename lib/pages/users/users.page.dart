import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:git_hub_mobile_app/pages/repositories/respositories.page.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatefulWidget {
  UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  TextEditingController queryTextEditingController =
      new TextEditingController();

  String query = "";
  dynamic data = null;
  int currentPage = 0;
  int totalPages = 0;
  int pageSize = 20;

  ScrollController scrollController = new ScrollController();

  List<dynamic> items = [];

  void _search(String query) {
    String url =
        "https://api.github.com/search/users?q=${query}&per_page=${pageSize}&page=${currentPage}";
    print(url);
    http.get(Uri.parse(url)).then((response) {
      setState(() {
        this.data = json.decode(response.body);
        this.items.addAll(data['items']);
        if (this.data['total_count'] % pageSize == 0) {
          this.totalPages = this.data['total_count'] ~/ pageSize;
        } else
          this.totalPages = (this.data['total_count'] / pageSize).floor() + 1;
      });
      //print(response.body);
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          if (currentPage < totalPages - 1) {
            ++currentPage;
            _search(query);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Users => $query: ${currentPage} / $totalPages",
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        this.query = value;
                        print(value);
                      });
                    },
                    controller: queryTextEditingController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {},
                      ),
                      contentPadding: EdgeInsets.only(
                        left: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(width: 3, color: Colors.deepOrange),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  if (items.length != 0) items.clear();
                  this.query = queryTextEditingController.text;
                  _search(query);
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 3,
                color: Colors.deepOrange,
              ),
              controller: scrollController,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserRepositoriePage(
                                login: items[index]['login'],
                                avatarUrl: items[index]['avatar_url'])));
                  },
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(items[index]['avatar_url']),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(items[index]['login']),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
