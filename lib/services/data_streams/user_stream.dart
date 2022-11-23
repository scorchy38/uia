import 'package:uia/services/database/user_database_helper.dart';


import 'data_stream.dart';

class UserStream extends DataStream<List<String>> {

  @override
  void reload() {
    final userFuture =
        UserDatabaseHelper().getUserDataFromId();
    userFuture?.then((data) {

    }).catchError((e) {
      addError(e);
    });
  }

}
