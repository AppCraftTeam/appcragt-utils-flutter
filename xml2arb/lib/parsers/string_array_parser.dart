import 'package:converter/constants.dart';
import 'package:converter/extensions/camel_case.dart';
import 'package:converter/parsers/parser.dart';
import 'package:xml/xml.dart';

final class StringArrayParser extends Parser<XmlElement> {
  const StringArrayParser();

  @override
  Map<String, dynamic> parse(XmlElement input) {
    final nameAttribute = input.getAttribute(Constants.name);
    final name = nameAttribute?.toCamelCase() ?? '';
    Map<String, dynamic> output = {};

    final items = input.children
      .map((e) => e.innerText)
      .where((e) => e.isNotEmpty);

    for (final item in items.indexed) {
      final i = item.$1;
      final value = item.$2;

      output.addAll({
        '$name$i': value,
        '@$name$i': {
          'type': 'text',
          'description': nameAttribute ?? ''
        }
      });
    }

    return output;
  }
}