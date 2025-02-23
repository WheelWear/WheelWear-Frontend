import 'package:flutter/cupertino.dart';
import 'signup_model.dart';
import 'signup_service.dart';

class SignupViewModel extends ChangeNotifier {
  final SignupService _service = SignupService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<bool> signUp(String username, String password, String confirmPassword,
      String realname) async {
    print("[SignupViewModel] 회원가입 시도: $username / $realname");

    if (password != confirmPassword) {
      _errorMessage = "비밀번호가 일치하지 않습니다.";
      notifyListeners();
      print("[SignupViewModel] 비밀번호 불일치 에러");
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = User(
          username: username, password: password, realname: realname);
      bool success = await _service.signUp(user);

      _isLoading = false;
      notifyListeners();

      print("[SignupViewModel] 회원가입 결과: $success");
      return success;
    } catch (e) {
      _errorMessage = "회원가입 실패: $e";
      _isLoading = false;
      notifyListeners();

      print("[SignupViewModel] 회원가입 실패: $e");
      return false;
    }
  }
}
