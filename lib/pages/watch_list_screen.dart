import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stock_trading_data.dart';
import '../services/stock_controller.dart';
import '../utils/app_utils.dart';

class WatchlistScreen extends StatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  bool _isSearchVisible = false; // State to manage visibility of the search bar

  // Search text controller
  final TextEditingController _searchController =  TextEditingController();

  List<StockData>? _filteredStocks; // To store filtered search results

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearchVisible
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _filterStocks,
                // Call filter function on text change
                decoration: const InputDecoration(
                  hintText: 'Search stocks by date',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              )
            : const Text('Watchlist',style:  TextStyle(color: Colors.white70)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close : Icons.search,color: Colors.white70,),
            onPressed: () {
              setState(() {
                _isSearchVisible =
                    !_isSearchVisible; // Toggle search bar visibility
                if (!_isSearchVisible) {
                  _searchController.clear(); // Clear search text
                  _filteredStocks = null; // Clear filtered results
                }
              });
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
            return const Center(child: Text('No stocks available.'));
          }

          List<StockData> displayedStocks = _filteredStocks ??
              stockDataList; // Show filtered results if available

          return ListView.builder(
            itemCount: displayedStocks.length,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            itemBuilder: (context, index) {
              StockData stock = displayedStocks[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    'Date: ${stock.timestamp.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.stacked_bar_chart,
                              color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Text(
                            'Price: ${stock.high}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.percent, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'Percentage: ${stock.low}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Divider(color: Colors.grey[300]),
                      const SizedBox(height: 8),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Handle add stock action

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () {
                    AppUtils.navigateToChartScreen(context,);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Filter function to filter stock data based on search query
  void _filterStocks(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredStocks = null; // Reset filtered list if query is empty
      });
    } else {
      setState(() {
        _filteredStocks = Provider.of<StockController>(context, listen: false)
            .stockDataList
            ?.where((stock) => stock.timestamp
                .toLocal()
                .toString()
                .split(' ')[0]
                .contains(query))
            .toList();
      });
    }
  }
}
