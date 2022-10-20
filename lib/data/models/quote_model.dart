class Quote {
  late String text;

  Quote.fromJson(Map<String, dynamic> json) {
    text = json['quote'];
  }
}
