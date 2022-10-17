class User {
  late String name;
  late String email;
  late String phone;
  late String address;
  late String companyLogo;

  User(this.name, this.email, this.phone, this.address,
      {this.companyLogo = ""});

  //constructor that convert json to object instance
  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        address = json['address'],
        email = json['email'],
        companyLogo = json['companyLogo'],
        phone = json['phone'];

  //a method that convert object to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'companyLogo': companyLogo
      };
}
