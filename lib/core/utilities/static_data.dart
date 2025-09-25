class StaticData {
  static String token = '';
  static String userId = '';
  static bool isAuth = false;
  static String name = '';

  static String capitalizeEachWord(String name) {
    if (name.isEmpty) {
      return '';
    }
    var x = name
        .split(' ')
        .map((word) {
          if (word.trim().isEmpty) {
            return '';
          }
          if (word.isNotEmpty) {
            return word[0].toUpperCase() + word.substring(1);
          }
        })
        .join(' ');
    return x;
  }
}
