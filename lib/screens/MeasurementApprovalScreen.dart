import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MeasurementApprovalScreen extends StatefulWidget {
  const MeasurementApprovalScreen({Key? key}) : super(key: key);

  @override
  State<MeasurementApprovalScreen> createState() =>
      _MeasurementApprovalScreenState();
}

class _MeasurementApprovalScreenState
    extends State<MeasurementApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ölçüm Onaylama'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          List<Product> pendingMeasurementApproval = productProvider.products
              .where((p) =>
          p.status == 'Beklemede' &&
              p.measurementData != null &&
              !p.measurementApproved)
              .toList();

          if (pendingMeasurementApproval.isEmpty) {
            return const Center(
              child: Text('Onay bekleyen ölçüm yok.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => productProvider.fetchProducts(),
            child: ListView.builder(
              itemCount: pendingMeasurementApproval.length,
              itemBuilder: (context, index) {
                final product = pendingMeasurementApproval[index];
                return Card(
                  child: ExpansionTile( // Genişletilebilir liste öğesi
                    title: Text(product.productName ?? 'Ürün Adı Yok'),
                    subtitle: Text(
                        'Miktar: ${product.quantity}, Kalite: ${product.quality}'),
                    children: [
                      ListTile(
                        title: const Text('Ölçüm Verileri'),
                        subtitle: _buildMeasurementDataWidget(product), // Ölçüm verilerini göster
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                _approveMeasurement(productProvider, product);
                              },
                              child: const Text('Onayla'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                _rejectMeasurement(productProvider, product);
                              },
                              child: const Text('Reddet'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMeasurementDataWidget(Product product) {
    // Ölçüm verilerini uygun şekilde göster
    // Örneğin:
    if (product.measurementData is Map) {
      Map<String, dynamic> data = product.measurementData as Map<String, dynamic>;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.entries.map((entry) {
          return Text('${entry.key}: ${entry.value}');
        }).toList(),
      );
    } else {
      return Text(product.measurementData.toString());
    }
  }

  void _approveMeasurement(
      ProductProvider productProvider, Product product) {
    productProvider.updateProduct(product.copyWith(measurementApproved: true));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ölçüm onaylandı.')),
    );
  }

  void _rejectMeasurement(ProductProvider productProvider, Product product) {
    // Ölçümü reddet ve ürünü sil veya düzenleme için geri gönder
    // ...
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ölçüm reddedildi.')),
    );
  }
}