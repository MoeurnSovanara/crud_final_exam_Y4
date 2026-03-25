import 'package:exam_y4/models/task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/task_provider.dart';

class TaskScreen extends StatelessWidget {
  final tx = TextEditingController();

  void showForm(BuildContext ctx, [Task? t]) {
    if (t != null) tx.text = t.title;
    showDialog(context: ctx, builder: (c) => AlertDialog(
      title: Text(t == null ? "Add" : "Edit"),
      content: TextField(controller: tx),
      actions: [ElevatedButton(onPressed: () {
        final p = ctx.read<TaskProvider>();
        t == null ? p.add(tx.text) : p.update(Task(id: t.id, title: tx.text, completed: t.completed));
        tx.clear(); Navigator.pop(c);
      }, child: Text("Save"))],
    ));
  }

  @override
  Widget build(BuildContext ctx) {
    final p = ctx.watch<TaskProvider>();
    return Scaffold(
      appBar: AppBar(title: Text("CRUD"), actions: [IconButton(icon: Icon(Icons.refresh), onPressed: p.fetch)]),
      body: p.loading ? Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: p.tasks.length,
        itemBuilder: (c, i) {
          final t = p.tasks[i];
          return ListTile(
            leading: Checkbox(value: t.completed, onChanged: (v) {
              t.completed = v!; p.update(t);
            }),
            title: Text(t.title), onTap: () => showForm(ctx, t),
            trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => p.del(t.id!)),
          );
        }),
      floatingActionButton: FloatingActionButton(onPressed: () => showForm(ctx), child: Icon(Icons.add)),
    );
  }
}