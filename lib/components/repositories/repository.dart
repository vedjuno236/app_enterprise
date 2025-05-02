// import 'dart:convert';
//
// import 'package:candlesticks/candlesticks.dart';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// class BinanceRepository {
//   Future<List<Candle>> fetchCandles(
//       {required String symbol, required String interval, int? endTime}) async {
//     final uri = Uri.parse(
//         "https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval${endTime != null ? "&endTime=$endTime" : ""}");
//     final res = await http.get(uri);
//     return (jsonDecode(res.body) as List<dynamic>)
//         .map((e) => Candle.fromJson(e))
//         .toList()
//         .reversed
//         .toList();
//   }
//
//   ///ticker history
//   Future<List<String>> fetchSymbols() async {
//     final uri = Uri.parse("https://api.binance.com/api/v3/ticker/price");
//     final res = await http.get(uri);
//     return (jsonDecode(res.body) as List<dynamic>)
//         .map((e) => e["symbol"] as String)
//         .toList();
//   }
//
//   Future<dynamic> fetchSymbolsPrice() async {
//     final uri = Uri.parse("https://api.binance.com/api/v3/ticker/price");
//     final response = await http.get(uri);
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body) as List<dynamic>;
//       return data;
//     } else {
//       throw Exception('Failed to fetch symbols');
//     }
//   }
//
//   ///kline
//   WebSocketChannel establishConnection(String symbol, String interval) {
//     final channel = WebSocketChannel.connect(
//       Uri.parse('wss://stream.binance.com/stream'),
//     );
//     channel.sink.add(
//       jsonEncode(
//         {
//           "method": "SUBSCRIBE",
//           "params": ["$symbol@kline_$interval"],
//           "id": 1
//         },
//       ),
//     );
//     return channel;
//   }
//
//   ///depth ask & bids
//   WebSocketChannel depthDataConnection(String symbol) {
//     final channel = WebSocketChannel.connect(
//       Uri.parse('wss://stream.binance.com/stream'),
//     );
//     channel.sink.add(
//       jsonEncode(
//         {
//           "method": "SUBSCRIBE",
//           "params": [
//             "$symbol@depth20",
//           ],
//           "id": 1
//         },
//       ),
//     );
//     return channel;
//   }
//
//   WebSocketChannel tickerDataConnection() {
//     final channel = WebSocketChannel.connect(
//       Uri.parse('wss://fstream.binance.com/stream'),
//     );
//     channel.sink.add(
//       jsonEncode(
//         {
//           "method": "SUBSCRIBE",
//           "params": [
//             "btcusdt@ticker",
//             "ethusdt@ticker",
//             "bnbusdt@ticker",
//           ],
//           "id": 1
//         },
//       ),
//     );
//     return channel;
//   }
//
//   WebSocketChannel tickerAllDataConnection() {
//     final channel = WebSocketChannel.connect(
//       Uri.parse('wss://fstream.binance.com/stream'),
//     );
//     channel.sink.add(
//       jsonEncode(
//         {
//           "method": "SUBSCRIBE",
//           "params": [
//             "!ticker@arr",
//           ],
//           "id": 1
//         },
//       ),
//     );
//     return channel;
//   }
//
//   WebSocketChannel aggTradeConnection(String symbol) {
//     final channel = WebSocketChannel.connect(
//       Uri.parse('wss://fstream.binance.com/stream'),
//     );
//     channel.sink.add(
//       jsonEncode(
//         {
//           "method": "SUBSCRIBE",
//           "params": [
//             "$symbol@aggTrade",
//           ],
//           "id": 1
//         },
//       ),
//     );
//     return channel;
//   }
// }
