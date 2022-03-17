import 'package:flutter/cupertino.dart';
import 'package:zadatak/services/api.dart';

class ApiProvider extends ChangeNotifier {
  Api api = Api();

  List _comments = [];

  List get comments => _comments;

  bool loadingComments = false;

  Future getComments() async {
    loadingComments = true;
    notifyListeners();
    _comments = await api.getComments();
    loadingComments = false;
    notifyListeners();
    return _comments;
  }
}
