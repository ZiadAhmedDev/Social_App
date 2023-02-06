class MessageModel {
  String? senderUid;
  String? date;
  String? text;
  String? receiverUid;

  MessageModel({this.senderUid, this.date, this.text, this.receiverUid});

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderUid = json['senderUid'];
    date = json['date'];
    text = json['text'];
    receiverUid = json['receiverUid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'date': date,
      'text': text,
      'receiverUid': receiverUid,
    };
  }
}
