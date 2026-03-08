class BrowserHistory {
  final String id;
  final String url;
  final String title;
  final String? favicon;
  final DateTime visitTime;

  BrowserHistory({
    required this.id,
    required this.url,
    required this.title,
    this.favicon,
    required this.visitTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'favicon': favicon,
      'visitTime': visitTime.millisecondsSinceEpoch,
    };
  }

  static BrowserHistory fromMap(Map<String, dynamic> map) {
    return BrowserHistory(
      id: map['id'],
      url: map['url'],
      title: map['title'],
      favicon: map['favicon'],
      visitTime: DateTime.fromMillisecondsSinceEpoch(map['visitTime']),
    );
  }
}

class Bookmark {
  final String id;
  final String url;
  final String title;
  final String? favicon;
  final DateTime createTime;

  Bookmark({
    required this.id,
    required this.url,
    required this.title,
    this.favicon,
    required this.createTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'favicon': favicon,
      'createTime': createTime.millisecondsSinceEpoch,
    };
  }

  static Bookmark fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'],
      url: map['url'],
      title: map['title'],
      favicon: map['favicon'],
      createTime: DateTime.fromMillisecondsSinceEpoch(map['createTime']),
    );
  }
}
