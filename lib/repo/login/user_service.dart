import 'package:travelappui/repo/user_model.dart';

class UserService {
  UserModel? currentUser;

  void createUser({
    String? name,
    String? msisdn,
    int? groupId,
    String? email,
    bool? emailVerify,
    String? token,
    int? autoLogoutAt,
  }) {
    currentUser = UserModel.fromValues(
      name: name,
      msisdn: msisdn,
      groupId: groupId,
      email: email,
      emailVerify: emailVerify,
      token: token,
      autoLogoutAt: autoLogoutAt,
    );
  }

  void updateUser({
    String? name,
    String? email,
    bool? emailVerify,
    int? groupId,
    String? msisdn,
    String? token,
    int? autoLogoutAt,
  }) {
    if (currentUser != null) {
      currentUser = UserModel.copy(
        currentUser!,
        name: name,
        email: email,
        emailVerify: emailVerify,
        groupId: groupId,
        msisdn: msisdn,
        token: token,
        autoLogoutAt: autoLogoutAt,
      );
    }
  }

  Map<String, dynamic>? getCurrentUserJson() {
    return currentUser?.toJson();
  }
}
