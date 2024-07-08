import 'package:converter/constants.dart';
import 'package:converter/extensions/camel_case.dart';
import 'package:converter/parsers/parser.dart';
import 'package:converter/string_pattern.dart';
import 'package:xml/xml.dart';

final class StringParser extends Parser<XmlElement> {
  const StringParser();

  @override
  Map<String, dynamic> parse(XmlElement input) {
    final nameAttribute = input.getAttribute(Constants.name);
    final name = nameAttribute?.toCamelCase() ?? '';
    var value = input.innerText;

    if (name.isEmpty || value.isEmpty) return {};

    Map<String, dynamic> placeholders = {};

    void replaceAll(StringPattern pattern) {
      final regExp = pattern.regExp;
      var match = regExp.firstMatch(value);

      while (match != null) {
        final parameter = '${pattern.prefix}${placeholders.length}';
        placeholders[parameter] = {'type': pattern.type};
        value = value.replaceRange(match.start, match.end, '{$parameter}');
        match = regExp.firstMatch(value);
      }
    }

    replaceAll(StringPattern.orderedString());
    replaceAll(StringPattern.orderedInt());
    replaceAll(StringPattern.string());
    replaceAll(StringPattern.int());

    Map<String, dynamic> metadata = {
      'type': 'text',
      'description': nameAttribute ?? ''
    };

    if (placeholders.isNotEmpty) {
      metadata['placeholders'] = placeholders;
    }

    return {
      name: value,
      '@$name': metadata
    };
  }
}