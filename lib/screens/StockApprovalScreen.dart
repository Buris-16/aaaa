import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class StockApprovalScreen extends StatefulWidget {
  const StockApprovalScreen({Key? key}) : super(key: key);

  @override
  State<StockApprovalScreen> createState() => _StockApprovalScreenState();
}

class _StockApprovalScreenState extends State<StockApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Çıkış Onayı'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          // Stok çıkışı bekleyen ürünleri filtrele
          List<Product> pendingStockDecrements = productProvider.products
              .where((p) => p.pendingDecrementQuantity != null && p.pendingDecrementQuantity! > 0)
              .toList();

          if (pendingStockDecrements.isEmpty) {
            return const Center(
              child: Text('Onay bekleyen stok çıkışı yok.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => productProvider.fetchProducts(),
            child: ListView.builder(
              itemCount: pendingStockDecrements.length,
              itemBuilder: (context, index) {
                final product = pendingStockDecrements[index];
                return Card(
                  child: ListTile(
                    title: Text(product.productName ?? 'Ürün Adı Yok'),
                    subtitle: Text(
                      'Talep Edilen Çıkış: ${product.pendingDecrementQuantity}, Mevcut Stok: ${product.quantity}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            _approveStockDecrement(productProvider, product);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            _rejectStockDecrement(productProvider, product);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _approveStockDecrement(ProductProvider productProvider, Product product) {
    // Stok çıkışını onayla ve ürün miktarını güncelle
    productProvider.decrementProductQuantity(product, product.pendingDecrementQuantity!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stok çıkışı onaylandı.')),
    );
  }

  void _rejectStockDecrement(ProductProvider productProvider, Product product) {
    // Stok çıkışını reddet
    productProvider.cancelDecrementRequest(product);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stok çıkışı reddedildi.')),
    );
  }
}