import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final _searchController = TextEditingController();
  String _searchText = "";

  @override
  void dispose() {
    _searchController.dispose(); // Controller'ı dispose etmek önemlidir
    super.dispose();
  }

  void _onSearchTextChanged(String value) {
    setState(() {
      _searchText = value;
    });
  }

  List<Product> _filterProducts(List<Product> products) {
    return products
        .where((product) =>
        product.productName!.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Ürün Ara',
                prefixIcon: Icon(Icons.search),
              ),
              controller: _searchController,
              onChanged: _onSearchTextChanged,
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                List<Product> inStockProducts = _filterProducts(
                    productProvider.products
                        .where((p) => p.status == 'Stokta')
                        .toList());

                if (inStockProducts.isEmpty) {
                  return const Center(
                    child: Text('Stokta ürün yok.'),
                  );
                }

                return ListView.builder(
                  itemCount: inStockProducts.length,
                  itemBuilder: (context, index) {
                    final product = inStockProducts[index];
                    return Card(
                      child: ListTile(
                        title: Text(product.productName ?? 'Ürün Adı Yok'),
                        subtitle: Text(
                            'Miktar: ${product.quantity}, Kalite: ${product.quality}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            // Stok çıkışı işlemleri için dialog veya yeni bir ekran açabilirsiniz
                            _showStockDecrementDialog(context, product, productProvider);
                          },
                        ),
                        onTap: () {
                          // Ürün detay ekranını aç
                          // ...
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showStockDecrementDialog(BuildContext context, Product product, ProductProvider productProvider) {
    int _decrementQuantity = 0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${product.productName} - Stok Çıkışı'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mevcut Stok: ${product.quantity}'),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Çıkış Miktarı'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen miktar girin';
                  }
                  int quantity = int.tryParse(value) ?? 0;
                  if (quantity <= 0 || quantity > product.quantity) {
                    return 'Geçersiz miktar';
                  }
                  return null;
                },
                onSaved: (value) {
                  _decrementQuantity = int.parse(value!);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Stok çıkışını onaylamak için bölüm müdürüne gönder
                  // ...
                  Navigator.pop(context);
                }
              },
              child: const Text('Onayla'),
            ),
          ],
        );
      },
    );
  }
}