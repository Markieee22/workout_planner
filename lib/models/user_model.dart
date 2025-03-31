class UserModel {
  String name;
  int age;
  double weight;
  double height;
  String? fitnessGoal; // Make it nullable

  UserModel({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    this.fitnessGoal, // Allow it to be null initially
  });
}
