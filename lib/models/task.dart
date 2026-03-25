class Task {
  int? id; String title; bool completed;
  Task({this.id, required this.title, this.completed = false});

  factory Task.fromJson(Map json) => Task(
    id: json['id'], title: json['title'], completed: json['completed']);
  
  Map toJson() => {"title": title, "completed": completed};
}