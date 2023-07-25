class Message {
  final String sender;
  final String receiver;
  final String message;
  final String time;

  Message({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'time': time,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      receiver: json['receiver'],
      message: json['message'],
      time: json['time'],
    );
  }
}
