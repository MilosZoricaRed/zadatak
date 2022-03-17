import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:zadatak/models/comment_model.dart';

class Api {
  static const url = "https://jsonplaceholder.typicode.com/";

  getComments() async {
    List<Comment> comments = [];
    try {
      final response = await http.get(
        Uri.parse(url + "comments"),
      );

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        res.forEach((c) {
          comments.add(Comment.fromJson(c));
        });
      } else {
        comments = [];
      }
    } catch (e) {
      log(e.toString());
    }
    return comments;
  }
}
