class Character {
  late int charId;
  late String name;
  late String nickName;
  late String image;
  late String jobs;
  late String statusIfDeadOrAlive;
  late String appearanceOfSeasons;
  late String acotrName;
  late String categoryForTwoSeries;
  late String betterCallSaulAppearance;

  Character.fromJson(Map<String, dynamic> json) {
    charId = json["char_id"];
    name = json["name"];
    nickName = json["nickname"];
    image = json["img"];
    jobs = json["occupation"].join(' / ');
    statusIfDeadOrAlive = json["status"];
    appearanceOfSeasons = json["appearance"].join(' / ');
    acotrName = json["portrayed"];
    categoryForTwoSeries = json["category"];
    betterCallSaulAppearance = json["better_call_saul_appearance"].join(' / ');
  }
}
