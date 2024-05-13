import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dropdown_model.dart';

class DropDownClass extends StatefulWidget {
  const DropDownClass({super.key});

  @override
  State<DropDownClass> createState() => _DropDownClassState();
}

class _DropDownClassState extends State<DropDownClass> {
  Future<List<DropDownModel>> getPost() async {
    try {
      final response = await http
          .get(Uri.parse('http://jsonplaceholder.typicode.com/posts'));
      final body = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return DropDownModel(
            userId: map['userId'],
            id: map['id'],
            title: map['title'],
            body: map['body'],
          );
        }).toList();
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error fetchingdata');
  }

  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DropDown API'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<DropDownModel>>(
              future: getPost(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                      hint: Text('Select value'),
                      isExpanded: true,
                      value: selectedvalue,
                      items: snapshot.data!.map((e) {
                        return DropdownMenuItem(
                          value: e.id.toString(),
                          child: Text(
                            e.id.toString(),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedvalue = value;
                        setState(() {

                        });
                      });
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
