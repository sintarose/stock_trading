class StockData {
  final DateTime timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  StockData({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  // Factory constructor to create an instance from JSON
  factory StockData.fromJson(Map<String, dynamic> json, String date) {
    return StockData(
      timestamp: DateTime.parse(date),
      open: double.parse(json['1. open']),
      high: double.parse(json['2. high']),
      low: double.parse(json['3. low']),
      close: double.parse(json['4. close']),
      volume: int.parse(json['5. volume']),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      '1. open': open.toString(),
      '2. high': high.toString(),
      '3. low': low.toString(),
      '4. close': close.toString(),
      '5. volume': volume.toString(),
    };
  }

  // Static method to convert a list of StockData from JSON map
  static List<StockData> listFromJson(Map<String, dynamic> json) {
    return json.entries.map((entry) => StockData.fromJson(entry.value, entry.key)).toList();
  }

  // Static method to convert a list of StockData to a JSON map
  static Map<String, dynamic> listToJson(List<StockData> data) {
    return {
      for (var stock in data) stock.timestamp.toIso8601String(): stock.toJson(),
    };
  }
}
