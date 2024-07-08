import 'package:converter/constants.dart';
import 'package:converter/extensions/camel_case.dart';
import 'package:converter/parsers/parser.dart';
import 'package:converter/string_pattern.dart';
import 'package:xml/xml.dart';

final class PluralsParser extends Parser<XmlElement> {
  const PluralsParser();

  @override
  Map<String, dynamic> parse(XmlElement input) {
    final nameAttribute = input.getAttribute(Constants.name);
    final name = nameAttribute?.toCamelCase() ?? '';
    const param = 'n';
    final values = ['$param, plural,'];

    for (final item in input.children) {
      if (item is! XmlElement) continue;
      final quantity = item.getAttribute(Constants.quantity) ?? '';

      var value = item.innerText;

      void replace(StringPattern pattern) {
        final regExp = pattern.regExp;
        final match = regExp.firstMatch(value);
        if (match == null) return;
        value = value.replaceRange(match.start, match.end, '{$param}');
      }

      replace(StringPattern.orderedInt());
      replace(StringPattern.int());

      var prefix = '';

      switch (quantity) {
        case Constants.one:
          prefix = '=1';
        default:
          prefix = quantity;
      }

      values.add('$prefix{$value}');
    }

    return {
      name: '{${values.join(' ')}}',
      '@$name': {
        'description': nameAttribute ?? '',
        'placeholders': {
          param: {
            'type': 'int'
          }
        }
      }
    };
  }
}