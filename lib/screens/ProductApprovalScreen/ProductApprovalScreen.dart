import 'package:flutter/material.dart';
import 'package:istanbullumert/screens/ProductApprovalScreen/ProductDetailsDialog.dart';
import 'package:provider/provider.dart';

//import '../data/models/product.dart';
//import '../providers/product_provider.dart';
//import '../widgets/product_details_dialog.dart'; // Özel dialog widget'ı

class ProductApprovalScreen extends StatefulWidget {
  const ProductApprovalScreen({Key? key}) : super(key: key);

  @override
  State<ProductApprovalScreen> createState() => _ProductApprovalScreenState();
}

class _ProductApprovalScreenState extends State<ProductApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Onaylama'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          List<Product> pendingProducts = productProvider.pendingProducts;

          if (pendingProducts.isEmpty) {
            return const Center(
              child: Text('Onay bekleyen ürün yok.'),
            );
          }

          return RefreshIndicator( // Yenileme özelliği eklendi
            onRefresh: () => productProvider.fetchProducts(), // Ürünleri yenile
            child: ListView.builder(
              itemCount: pendingProducts.length,
              itemBuilder: (context, index) {
                final product = pendingProducts[index];
                return Dismissible( // Kaydırma ile silme özelliği
                  key: Key(product.productId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    // Silme işlemini onayla
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Ürünü Sil?'),
                        content: const Text('Bu ürünü silmek istediğinizden emin misiniz?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('İptal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Sil'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    _rejectProduct(productProvider, product);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(product.productName ?? 'Ürün Adı Yok'),
                      subtitle: Text(
                          'Miktar: ${product.quantity}, Kalite: ${product.quality}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          _approveProduct(productProvider, product);
                        },
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ProductDetailsDialog(
                            product: product,
                            onSave: (updatedProduct) {
                              productProvider.updateProduct(updatedProduct);
                            },
                          ),
                        );
                      },
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

  void _approveProduct(ProductProvider productProvider, Product product) {
    productProvider.updateProduct(product.copyWith(status: 'Stokta'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ürün onaylandı ve stoğa eklendi.')),
    );
  }

  void _rejectProduct(ProductProvider productProvider, Product product) {
    productProvider.deleteProduct(product);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ürün reddedildi.')),
    );
  }
}