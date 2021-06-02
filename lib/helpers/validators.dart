bool emailValid(String email) {
  final RegExp regex = RegExp(
      r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$");
  return regex.hasMatch(email);
}

bool nameValid(String name) {
  bool result = false;
  if (name.length > 5 && name.trim().contains(" ")) {
    result = true;
  } else {
    result = false;
  }
  return result;
}

bool phoneValid(String phoneNumber) {
  bool result = false;

  if (phoneNumber.length == 16) {
    result = true;
  } else {
    result = false;
  }
  return result;
}
