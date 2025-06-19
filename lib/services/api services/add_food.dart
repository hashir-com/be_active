import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:thryv/models/food_model.dart/food_item.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

Future<void> fetchAndSaveFood(String query) async {
  final url = Uri.parse(
    'https://api.edamam.com/api/food-database/v2/parser?app_id=YOUR_APP_ID&app_key=YOUR_APP_KEY&ingr=$query',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['parsed'] != null && data['parsed'].isNotEmpty) {
      final parsedJson = data['parsed'][0]['food'];
      final foodItem = FoodItem.fromJson(parsedJson);
      final foodBox = Hive.box<FoodItem>('foodBox');
      await foodBox.add(foodItem);
    }
  }
}
