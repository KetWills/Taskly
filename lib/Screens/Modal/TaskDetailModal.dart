class TaskDetail {
  int commentCount;
  bool completed;
  String content;
  Due due;
  int id;
  int order;
  int priority;
  int projectId;
  int sectionId;
  int parentId;
  String url;

  TaskDetail(
      {this.commentCount,
        this.completed,
        this.content,
        this.due,
        this.id,
        this.order,
        this.priority,
        this.projectId,
        this.sectionId,
        this.parentId,
        this.url});

  TaskDetail.fromJson(Map<String, dynamic> json) {
    commentCount = json['comment_count'];
    completed = json['completed'];
    content = json['content'];
    due = json['due'] != null ? new Due.fromJson(json['due']) : null;
    id = json['id'];
    order = json['order'];
    priority = json['priority'];
    projectId = json['project_id'];
    sectionId = json['section_id'];
    parentId = json['parent_id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_count'] = this.commentCount;
    data['completed'] = this.completed;
    data['content'] = this.content;
    if (this.due != null) {
      data['due'] = this.due.toJson();
    }
    data['id'] = this.id;
    data['order'] = this.order;
    data['priority'] = this.priority;
    data['project_id'] = this.projectId;
    data['section_id'] = this.sectionId;
    data['parent_id'] = this.parentId;
    data['url'] = this.url;
    return data;
  }
}

class Due {
  String date;
  String datetime;
  String string;
  String timezone;

  Due({this.date, this.datetime, this.string, this.timezone});

  Due.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    datetime = json['datetime'];
    string = json['string'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['datetime'] = this.datetime;
    data['string'] = this.string;
    data['timezone'] = this.timezone;
    return data;
  }
}

