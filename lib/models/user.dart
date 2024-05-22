class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String username; 
  final String email;
  final String password;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.username, 
    required this.email,
    required this.password,
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username, 
      'email': email,
      'password': password,
    };
  }

  // Convert a Map object into a User object
factory User.fromMap(Map<String, dynamic>? map) {
  if (map == null) {
    throw ArgumentError("Map cannot be null");
  }
  return User(
    id: map['id'],
    firstName: map['firstName'] ?? '',
    lastName: map['lastName'] ?? '',
    username: map['username'] ?? '',
    email: map['email'] ?? '',
    password: map['password'] ?? '',
  );
}

}
