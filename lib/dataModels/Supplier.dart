class Supplier {
  final String supplierId;
  final String supplierName;
  String? contactPerson;
  String? phoneNumber;
  String? email;
  String? address;
  int? leadTime;
  double? averagePrice;
  int? qualityRating;

  Supplier({
    required this.supplierId,
    required this.supplierName,
    this.contactPerson,
    this.phoneNumber,
    this.email,
    this.address,
    this.leadTime,
    this.averagePrice,
    this.qualityRating,
  });

  Supplier copyWith({
    String? supplierId,
    String? supplierName,
    String? contactPerson,
    String? phoneNumber,
    String? email,
    String? address,
    int? leadTime,
    double? averagePrice,
    int? qualityRating,
  }) {
    return Supplier(
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      contactPerson: contactPerson ?? this.contactPerson,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      leadTime: leadTime ?? this.leadTime,
      averagePrice: averagePrice ?? this.averagePrice,
      qualityRating: qualityRating ?? this.qualityRating,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Supplier &&
        other.supplierId == supplierId &&
        other.supplierName == supplierName &&
        other.contactPerson == contactPerson &&
        other.phoneNumber == phoneNumber &&
        other.email == email &&
        other.address == address &&
        other.leadTime == leadTime &&
        other.averagePrice == averagePrice &&
        other.qualityRating == qualityRating;
  }

  @override
  int get hashCode {
    return supplierId.hashCode ^
    supplierName.hashCode ^
    contactPerson.hashCode ^
    phoneNumber.hashCode ^
    email.hashCode ^
    address.hashCode ^
    leadTime.hashCode ^
    averagePrice.hashCode ^
    qualityRating.hashCode;
  }

// Opsiyonel: JSON serileştirme/deserialize etme metodları ekleyebilirsiniz
// ...
}