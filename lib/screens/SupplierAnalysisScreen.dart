import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SupplierAnalysisScreen extends StatelessWidget {
  const SupplierAnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tedarikçi Analizi'),
      ),
      body: Consumer<SupplierProvider>(
        builder: (context, supplierProvider, child) {
          // AHP hesaplamalarını ve tedarikçi performans verilerini alın
          Map<String, dynamic> ahpResults = supplierProvider.ahpResults;
          Map<String, dynamic> supplierPerformance =
              supplierProvider.supplierPerformance;

          if (ahpResults.isEmpty || supplierPerformance.isEmpty) {
            return const Center(
              child: Text('Tedarikçi analizi verileri yükleniyor...'),
            );
          }

          // Tedarikçileri AHP puanına göre sırala
          List<String> sortedSuppliers = ahpResults.keys.toList()
            ..sort((a, b) =>
                ahpResults[b].compareTo(ahpResults[a])); // Azalan sıralama

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AHP Sonuçları
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'AHP Sonuçları',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                _buildBarChart(ahpResults, sortedSuppliers),

                // Tedarikçi Performansı
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Tedarikçi Performansı',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                _buildPerformanceTable(supplierPerformance, sortedSuppliers),
              ],
            ),
          );
        },
      ),
    );
  }

  // AHP sonuçlarını görselleştirmek için bar chart
  Widget _buildBarChart(
      Map<String, dynamic> ahpResults, List<String> sortedSuppliers) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: sortedSuppliers.map((supplier) {
            return BarChartGroupData(
              x: sortedSuppliers.indexOf(supplier),
              barRods: [
                BarChartRodData(
                  toY: ahpResults[supplier].toDouble(),
                  width: 20,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 16,
                    child: Text(sortedSuppliers[value.toInt()]),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barTouchData: BarTouchData(
            enabled: false,
          ),
        ),
      ),
    );
  }

  // Tedarikçi performansını tablo şeklinde göster
  Widget _buildPerformanceTable(
      Map<String, dynamic> supplierPerformance, List<String> sortedSuppliers) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Yatay kaydırma
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Tedarikçi')),
          DataColumn(label: Text('Teslimat Süresi')),
          DataColumn(label: Text('Kalite')),
          // ... diğer performans kriterleri
        ],
        rows: sortedSuppliers.map((supplier) {
          return DataRow(
            cells: [
              DataCell(Text(supplier)),
              DataCell(Text(supplierPerformance[supplier]['teslimatSuresi']
                  .toString())),
              DataCell(Text(supplierPerformance[supplier]['kalite'].toString())),
              // ... diğer performans verileri
            ],
          );
        }).toList(),
      ),
    );
  }
}