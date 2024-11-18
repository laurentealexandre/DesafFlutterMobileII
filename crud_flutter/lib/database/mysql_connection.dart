import 'package:mysql1/mysql1.dart';

class DatabaseConnection {
  static Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: '127.0.0.1', 
      port: 3306,
      user: 'root',
      password: '',  
      db: 'crud_flutter'
    );
    
    return await MySqlConnection.connect(settings);
  }
}