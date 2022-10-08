class User {
  late String firstname;
  late String lastname;
  late String email;
  late String phone;
  late String address;
  late String companyLogo;

  User(this.firstname, this.lastname, this.email, this.phone, this.address,
      {this.companyLogo = ""});

  //constructor that convert json to object instance
  User.fromJson(Map<String, dynamic> json)
      : firstname = json['firstname'],
        lastname = json['lastname'],
        address = json['address'],
        email = json['email'],
        companyLogo = json['companyLogo'],
        phone = json['phone'];

  //a method that convert object to json
  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'phone': phone,
        'address': address,
        'companyLogo': companyLogo
      };
}
