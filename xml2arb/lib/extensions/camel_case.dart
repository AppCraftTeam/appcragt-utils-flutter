extension CamelCase on String {

  String toCamelCase() {
    if (isEmpty) return this;

    List<String> parts = split("_");
    if (parts.length == 1) return this;

    StringBuffer sb = StringBuffer();

    for (var i = 0; i < parts.length; i++) {
      String p = parts[i];

      if (p.isNotEmpty) {
        if (i == 0) {
          sb.write(p.substring(0, 1).toLowerCase());
        } else {
          sb.write(p.substring(0, 1).toUpperCase());
        }
        sb.write(p.substring(1, p.length));
      }
    }

    return sb.toString();
  }
  
}