import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/stock_trading_data.dart';
import 'package:stoack_trade/utils/constants.dart';

class StockController extends ChangeNotifier {
  List<StockData>? _stockDataList;
  List<StockData>? get stockDataList => _stockDataList;

  StockController() {
    fetchStockData();
  }
// fetching live data from api
  Future<void> fetchStockData() async {
    final url = Uri.parse(AppConstants.url);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);

          if (jsonResponse.containsKey('Time Series (Daily)')) {
            final timeSeries = jsonResponse['Time Series (Daily)'] as Map<String, dynamic>;

            _stockDataList = StockData.listFromJson(timeSeries);
            notifyListeners(); // Notify listeners when data is fetched and updated
          } else {
            throw Exception('Invalid response format: "Time Series (Daily)" key not found.');
          }
        } catch (e) {
          throw Exception('Failed to parse stock data: ${e.toString()}');
        }
      } else {
        throw Exception('Failed to load stock data. Status code: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw Exception('No Internet connection: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Bad response format: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
