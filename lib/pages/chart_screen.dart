import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stock_trading_data.dart';
import '../services/stock_controller.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  // Customizable color theme options
  static const Color purple = Colors.deepPurple;
  static const Color backgroundColor = Colors.white;

  // Customizable button size
  final double buttonHeight = 50;
  final double buttonWidth = 150;

  // Watchlist state
  // To track the button state
  bool isAddedToWatchlist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Price Trends',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ],
      ),
      body: Consumer<StockController>(
        builder: (context, stockController, child) {
          List<StockData>? stockDataList = stockController.stockDataList;

          if (stockDataList == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (stockDataList.isEmpty) {
            return const Center(child: Text('No data available for the stock.'));
          }

          // Convert StockData to FlSpot list
          List<FlSpot> spots = stockDataList.asMap().entries.map((entry) {
            int index = entry.key;
            StockData data = entry.value;
            return FlSpot(index.toDouble(), data.close);
          }).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stock Header Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ICICI Bank',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: purple),
                      ),
                      Text(
                        'ICICIBANK',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '51.17 INR',
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: purple),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '+0.11 (0.22%)',
                            style: TextStyle(fontSize: 18, color: Colors.greenAccent),
                          ),
                        ],
                      ),
                      const Text(
                        '10 Mar, 3:30 pm IST',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildActionButton('Watchlist', Icons.favorite_border, isAddedToWatchlist ? Colors.red : purple),  // Change icon color conditionally
                          _buildActionButton('Notify', Icons.notifications_outlined, purple),
                          _buildActionButton('Compare', Icons.compare_arrows, purple),
                        ],
                      ),
                    ],
                  ),
                ),

                // Stock Chart Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: purple,
                            barWidth: 4,
                            belowBarData: BarAreaData(
                              show: true,
                              color: purple.withOpacity(0.15),
                            ),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 10,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < stockDataList.length) {
                                  final date = stockDataList[index].timestamp.toString().split(' ')[0]; // Get full date
                                  final day = date.split('-')[2]; // Extract day
                                  return Text(
                                    day,
                                    style: const TextStyle(fontSize: 12, color: Colors.black),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 10, // Adjusted interval for clarity
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12, color: Colors.black),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.shade300,
                              strokeWidth: 1,
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.grey.shade300,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                ),

                // Buy/Sell Button Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: Size(buttonWidth, buttonHeight), // Set desired size
                        ),
                        child: const Text(
                          'Buy',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: Size(buttonWidth, buttonHeight), // Set desired size
                        ),
                        child: const Text(
                          'Sell',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
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
  }

  Widget _buildActionButton(String title, IconData icon, Color iconColor) {
    return ElevatedButton.icon(
      onPressed: () {
        if (title == 'Watchlist') {
          setState(() {
            isAddedToWatchlist = !isAddedToWatchlist;  // Toggle watchlist state
          });
        }
      },
      icon: Icon(icon, color: iconColor),
      label: Text(title, style: TextStyle(color: purple)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: purple),
        ),
      ),
    );
  }
}
