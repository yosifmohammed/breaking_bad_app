class Character{
  late int charId;
  late String name;
  late String nickname;
  late String birthday;
  late List<dynamic> jobs;
  late String image;
  late String status;
  late List<dynamic> breakingBadAppearance;
  late String portrayed;
  late String category;
  late List<dynamic> betterCallSaulAppearance;

  Character.fromJson(Map<String, dynamic> json){
    charId = json['char_id'];
    name = json['name'];
    birthday = json['birthday'];
    jobs = json['occupation'];
    image = json['img'];
    status = json['status'];
    nickname = json['nickname'];
    breakingBadAppearance = json['appearance'];
    portrayed = json['portrayed'];
    category = json['category'];
    betterCallSaulAppearance = json['better_call_saul_appearance'];
  }
}