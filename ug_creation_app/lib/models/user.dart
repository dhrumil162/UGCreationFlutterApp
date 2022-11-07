class User {
  late String name;
  late String email;
  late String phone;
  late String address;
  late String companyName;
  late String website;
  late String companyLogo;

  User(this.name, this.email, this.phone, this.address,
      {this.companyLogo = "", this.website = "", this.companyName = ""});

  //constructor that convert json to object instance
  User.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'] ?? "Your name",
        address = json['address'] ?? "Your address",
        email = json['email'] ?? "abc@xyz.com",
        companyLogo = json['companyLogo'],
        phone = json['phone'] ?? "9999999999",
        companyName = json['companyName'] ?? "Your company name",
        website = json['website'] ?? "Your website";

  //a method that convert object to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'companyLogo': companyLogo,
        'companyName': companyName,
        'website': website
      };
}
