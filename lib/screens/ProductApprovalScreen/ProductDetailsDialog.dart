
import 'package:flutter/material.dart';

class ProductDetailsDialog extends StatefulWidget {
  final Product product;
  final Function(Product) onSave;

  const ProductDetailsDialog({
    Key? key,
    required this.product,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ProductDetailsDialog> createState() => _ProductDetailsDialogState();
}

class _ProductDetailsDialogState extends State<ProductDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  late double _unitPrice;
  late int _leadTime;

  @override
  void initState() {
    super.initState();
    _unitPrice = widget.product.unitPrice ?? 0.0;
    _leadTime = widget.product.leadTime ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product.productName ?? 'Ürün Detayları'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _unitPrice.toString(),
                decoration: const InputDecoration(labelText: 'Birim Fiyat'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  // ... fiyat doğrulama
                },
                onSaved: (value) => _unitPrice = double.parse(value!),
              ),
              TextFormField(
                initialValue: _leadTime.toString(),
                decoration:
                const InputDecoration(labelText: 'Teslim Süresi (gün)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  // ... teslim süresi doğrulama
                },
                onSaved: (value) => _leadTime = int.parse(value!),
              ),
              // ... diğer detaylar (ölçüm verileri vb.)
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kapat'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onSave(
                widget.product.copyWith(
                  unitPrice: _unitPrice,
                  leadTime: _leadTime,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}