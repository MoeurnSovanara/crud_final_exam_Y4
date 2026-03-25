import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = []; bool loading = false;
  final url = "http://localhost:8080/api/tasks";

  Future fetch() async {
    loading = true; notifyListeners();
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      tasks = (jsonDecode(res.body) as List).map((e) => Task.fromJson(e)).toList();
    }
    loading = false; notifyListeners();
  }

  Future add(String t) async {
    await http.post(Uri.parse(url), headers: {"Content-Type":"application/json"}, 
      body: jsonEncode(Task(title: t).toJson()));
    fetch();
  }

  Future update(Task t) async {
    await http.put(Uri.parse("$url/${t.id}"), headers: {"Content-Type":"application/json"}, 
      body: jsonEncode(t.toJson()));
    fetch();
  }

  Future del(int id) async {
    await http.delete(Uri.parse("$url/$id"));
    fetch();
  }
}