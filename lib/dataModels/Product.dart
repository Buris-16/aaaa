import 'package:flutter/foundation.dart';
import 'package:istanbullumert/dataModels/Supplier.dart';
import 'package:istanbullumert/screens/MeasurementApprovalScreen.dart';

// Ürün kalitesi için bir enum tanımlayalım
enum ProductQuality { good, average, poor }

class Product {
  final String? productName;
  final String productId;
  int _quantity; // Miktarı private yapalım ve getter/setter kullanalım
  final ProductQuality quality; // Enum kullanarak kaliteyi temsil edelim
  final Map<String, dynamic>? measurementData;
  bool measurementApproved;
  final String? supplierId;
  double? unitPrice;
  int? leadTime;
  String status;
  int? pendingDecrementQuantity;

  Product({
    this.productName,
    required this.productId,
    required int quantity, // quantity parametresini private değişkene atayalım
    required this.quality,
    this.measurementData,
    this.measurementApproved = false,
    this.supplierId,
    this.unitPrice,
    this.leadTime,
    this.status = 'Beklemede',
    this.pendingDecrementQuantity,
  }) : _quantity = quantity;

  // Miktar için getter ve setter metodları
  int get quantity => _quantity;

  set quantity(int newQuantity) {
    if (newQuantity >= 0) {
      _quantity = newQuantity;
    } else {
      // Negatif miktar hatası fırlat veya uygun bir şekilde işle
      debugPrint("Hata: Ürün miktarı negatif olamaz!");
    }
  }

  //copyWith metodu, nesnenin bir kopyasını oluştururken bazı alanlarını güncellemek için kullanılır.
  Product copyWith({
    String? productName,
    String? productId,
    int? quantity,
    ProductQuality? quality,
    Map<String, dynamic>? measurementData,
    bool? measurementApproved,
    String? supplierId,
    double? unitPrice,
    int? leadTime,
    String? status,
    int? pendingDecrementQuantity,
  }) {
    return Product(
      productName: productName ?? this.productName,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      quality: quality ?? this.quality,
      measurementData: measurementData ?? this.measurementData,
      measurementApproved: measurementApproved ?? this.measurementApproved,
      supplierId: supplierId ?? this.supplierId,
      unitPrice: unitPrice ?? this.unitPrice,
      leadTime: leadTime ?? this.leadTime,
      status: status ?? this.status,
      pendingDecrementQuantity:
      pendingDecrementQuantity ?? this.pendingDecrementQuantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.productName == productName &&
        other.productId 1  == productId &&
        other.quantity == quantity &&
        other.quality == quality &&
        mapEquals(other.measurementData, measurementData) &&
        other.measurementApproved == measurementApproved &&
        other.supplierId == supplierId &&
        other.unitPrice == unitPrice &&
        other.leadTime == leadTime &&
        other.status == status &&
        other.pendingDecrementQuantity == pendingDecrementQuantity;
  }

  @override
  int get hashCode {
    return productName.hashCode ^
    productId.hashCode ^
    quantity.hashCode ^
    quality.hashCode ^
    measurementData.hashCode ^
    measurementApproved.hashCode ^
    supplierId.hashCode ^
    unitPrice.hashCode ^
    leadTime.hashCode ^
    status.hashCode ^
    pendingDecrementQuantity.hashCode;
  }
}