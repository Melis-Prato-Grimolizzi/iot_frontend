import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user.g.dart';

@riverpod
class UserState extends _$UserState {
  @override
  String? build() {
    return null;
  }

  void logIn(String token) {
    state = token;
  }

  void signUp(String token){
    state = token;
  }

  void logOut() {
    state = null;
  }
}
