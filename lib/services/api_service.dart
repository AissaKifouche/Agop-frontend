import "dart:convert";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";
  //static const String baseUrl = "http://11.11(my pcs ip:8000"

  //auth
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/users/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final decoded = jsonDecode(res.body);

    if (res.statusCode == 200) {
      return decoded;
    } else {
      // This triggers the 'catch' block in your UI
      throw Exception(decoded["detail"] ?? "Login failed");
    }
  }

  static Future<Map<String, dynamic>> register(String username, String email, String password) async{
    final res = await http.post(
      Uri.parse("$baseUrl/users/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "email": email, "password": password}),
    );

    return jsonDecode(res.body);
  }

  Future<bool> verifyEmail(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/verify?email=$email&code=$code'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return true; // Verification success
      } else {
        print("Verification error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Connection error: $e");
      return false;
    }
  }

  static Future<List> getCrops(int farmerId) async {
    final prefs = await SharedPreferences.getInstance();
    // Retrieve the token we saved during login
    final String? token = prefs.getString("token");

    final res = await http.get(
      Uri.parse("$baseUrl/crops/?farmer_id=$farmerId"),
      headers: {
        "Content-Type": "application/json",
        // This line is the "Key" that unlocks the 401 error
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print("Error fetching crops: ${res.body}");
      return []; // Return an empty list if it fails
    }
  }

  static Future<Map<String, dynamic>> createCrop(int farmerId, Map<String, dynamic> cropData) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    final res = await http.post(
      Uri.parse("$baseUrl/crops/?farmer_id=$farmerId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Add this line!
      },
      body: jsonEncode(cropData),
    );

    final decoded = jsonDecode(res.body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return decoded;
    } else {
      print("Error creating crop: ${res.body}");
      throw Exception(decoded["detail"] ?? "Failed to create crop");
    }
  }

  static Future<void> deleteCrop(int cropId) async {
    await http.delete(Uri.parse("$baseUrl/crops/$cropId"));
  }

  static Future<Map<String, dynamic>> submitLog(int cropId, double water, double fertilizer) async {
    final res = await http.post(
      Uri.parse("$baseUrl/logs/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"crop_id": cropId, "water_quantity": water, "fertilizer_qty": fertilizer}),
      );

    return jsonDecode(res.body);
  }

    static Future<List> getLogs(int cropId) async {
    final res = await http.get(Uri.parse('$baseUrl/logs/$cropId'));
    return jsonDecode(res.body);
    }

    // TASKS
  static Future<List> getTasks(int cropId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    final res = await http.get(
      Uri.parse('$baseUrl/tasks/$cropId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Add this!
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print("Error fetching tasks: ${res.body}");
      return [];
    }
  }

  static Future<Map<String, dynamic>> updateTask(int taskId, bool isDone) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    final res = await http.put(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // The missing link!
      },
      body: jsonEncode({'is_done': isDone}),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print("Error updating task: ${res.body}");
      throw Exception("Failed to update task");
    }
  }

  static Future<void> deleteTask(int taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    final res = await http.delete(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // This unlocks the 401 error
      },
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      print("Delete error: ${res.body}");
      throw Exception("Failed to delete task from server");
    }
  }

    // RECOMMENDATIONS
    static Future<List> getRecommendations(int cropId) async {
    final res = await http.get(Uri.parse('$baseUrl/recommendations/$cropId'));
    return jsonDecode(res.body);
    }



  static Future<Map<String, dynamic>> createTask({
    required int cropId,
    required String description,
    required DateTime dueDate,
  }) async {
    // 1. Get the token from memory
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    // 2. Send the request with the Authorization header
    final res = await http.post(
      Uri.parse("$baseUrl/tasks/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // The "Key"
      },
      body: jsonEncode({
        "crop_id": cropId,
        "description": description,
        "due_date": dueDate.toIso8601String(),
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)["detail"] ?? "Failed to create task");
    }
    return jsonDecode(res.body);
  }



}