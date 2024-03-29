
class GeoLocation {
  final String? name;
  final String? sublocality;
  final String? state;
  final String? city;
  final String? country;
  final String? pincode;
  final double longitude;
  final double latitude;

  GeoLocation({
    this.name,
    this.sublocality,
    this.state, 
    this.city, 
    this.country,
    this.pincode,
    required this.longitude,
    required this.latitude
  });
}
