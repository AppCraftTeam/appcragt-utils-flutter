import 'package:converter/constants.dart';
import 'package:converter/parsers/parser.dart';
import 'package:converter/parsers/plurals_parser.dart';
import 'package:converter/parsers/string_array_parser.dart';
import 'package:converter/parsers/string_parser.dart';
import 'package:xml/xml.dart';

final class DocumentParser extends Parser<XmlDocument> {
  const DocumentParser(this.locale);

  final String locale;

  @override
  Map<String, dynamic> parse(XmlDocument input) {
    Map<String, dynamic> output = {'@@locale': locale};

    for (var item in input.rootElement.children) {
      if (item is! XmlElement) continue;
      Parser? parser;

       switch (item.name.qualified) {
        case Constants.string:
          parser = const StringParser();
        case Constants.stringArray:
          parser = const StringArrayParser();
        case Constants.plurals:
          parser = const PluralsParser();
        default:
          break;
      }

      output.addAll(parser?.parse(item) ?? {});
    }

    return output;
  }
}