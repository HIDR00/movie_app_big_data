import 'package:mongo_dart/mongo_dart.dart';
import 'package:movies_app/core/data/network/api_constants.dart';

class MongoDB {
  static var db;
  static connect() async {
    db = await Db.create(ApiConstants.mongoUrl);
    await db.open();
  }
}