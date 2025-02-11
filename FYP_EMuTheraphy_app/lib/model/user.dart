class UserData {
  String id;
  String name;
  String age;
  String gender;

  UserData({required this.id, required this.name, required this.age, required this.gender});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "age": age,
      "gender": gender
    };
  }

  //from json
  static UserData fromJson(Map<String, dynamic> json) => UserData(
    id: json['id'],
    name: json['name'],
    age: json['age'],
    gender: json['gender']
  );
}
