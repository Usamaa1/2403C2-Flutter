import '../models/user_model.dart';
import 'dio_client.dart';

class ApiService {
  static Future<List<UserModel>> fetchUsers() async {
    final response = await DioClient.dio.get("/users");

    final List data = response.data;

    return data.map((e) => UserModel.fromJson(e)).toList();
  }
}
