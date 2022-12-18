

class Address {
    Address({
      required this.addressId,
      this.addressLine,
      this.city,
      this.state,
      this.pincode,
      this.coordinates,
    });

    int addressId;
    String? addressLine;
    String? city;
    String? state;
    String? pincode;
    String? coordinates;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        addressId: json["addressId"],
        addressLine: json["addressLine"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
        coordinates: json["coordinates"],
    );

    Map<String, dynamic> toJson() => {
        "addressId": addressId,
        "addressLine": addressLine,
        "city": city,
        "state": state,
        "pincode": pincode,
        "coordinates": coordinates,
    };
}
