
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'; // Barkod/RFID tarama
import 'package:provider/provider.dart'; // State yönetimi (örnek olarak Provider)

//import '../data/models/product.dart'; // Ürün modeli
//import '../providers/product_provider.dart'; // Provider örneği

class ProductRegistrationScreen extends StatefulWidget {
  const ProductRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<ProductRegistrationScreen> createState() =>
      _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _productId = '';
  int _quantity = 0;
  int productQuality = 5;
  List<String> _qualityOptions = ['İyi', 'Orta', 'Kötü'];
  // ... diğer değişkenler (ölçüm verileri vb.)

  Future<void> _scanRFID() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      setState(() {
        _productId = barcodeScanRes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('RFID okuma hatası: $e')),
      );
    }
  }

  /*void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newProduct = Product(
        productId: _productId,
        quantity: _quantity,
        quality: _selectedQuality,
        // ... diğer veriler
        status: 'Beklemede', // Başlangıç durumu
      );
      Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün kaydedildi, onay bekleniyor.')),
      );
      _formKey.currentState!.reset(); // Formu temizle
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Kaydı'),
      ),
      body: SingleChildScrollView( // Uzun formlar için kaydırma eklendi
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _scanRFID,
                  child: const Text('RFID Oku'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Ürün ID'),
                  initialValue: _productId, // Okunan RFID'yi göster
                  enabled: false, // Sadece okuma için
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Ürün Miktarı'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen miktar girin';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _quantity = int.parse(value!);
                  },
                ),
                Row(
                  children: [
                    Text('Product Quality:'),
                    Expanded(
                      child: Slider(
                        value: productQuality.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: productQuality.toString(),
                        onChanged: (value) {
                          setState(() {
                            productQuality = value.toInt();
                          });
                        },
                      ),
                    ),
                    Text(productQuality.toString()),
                  ],
                ),
                // ... diğer alanlar (ölçüm verileri vb.)
                /*ElevatedButton(
                  onPressed: _saveProduct,
                  child: const Text('Kaydet'),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}