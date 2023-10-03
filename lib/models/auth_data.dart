class AuthData{
  String userName;
  String password;
  bool isError;
  bool isLoading;

  AuthData({
    required this.userName,
    required this.password,
    required this.isError,
    required this.isLoading
  });
}