

class Address {
    Address({
      this.addressId,
      this.addressLine,
      this.city,
      this.state,
      this.pincode,
      this.country,
      this.latitude,
      this.longitude
    });

    int? addressId;
    String? addressLine;
    String? city;
    String? state;
    String? country;
    String? pincode;
    double? latitude;
    double? longitude;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        addressId: json["addressId"],
        addressLine: json["addressLine"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        latitude: double.tryParse(json["latitude"]??''),
        longitude: double.tryParse(json["longitude"]??''),
    );

    Map<String, dynamic> toJson() => {
        "addressId": addressId,
        "addressLine": addressLine,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "latitude": latitude,
        "longitude": longitude,
    };

}
