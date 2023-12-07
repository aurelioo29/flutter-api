import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:latihan_restapi/stock.dart';
import 'package:http/http.dart' as http;

final url = 'http://10.0.2.2/flutter-api/';

Future<List<Stock>> fetchStock(http.Client client) async {
  final response = await client.get(Uri.parse('${url}list.php'));
  return compute(parseStock, response.body);
}

List<Stock> parseStock(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Stock>((json) => Stock.fromJson(json)).toList();
}
