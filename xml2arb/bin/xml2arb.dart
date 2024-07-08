import 'dart:convert';
import 'dart:io';

import 'package:converter/parsers/document_parser.dart';
import 'package:path/path.dart';
import 'package:xml/xml.dart';

Future<void> main(List<String> arguments) async {
  try {
    final currentDir = dirname(Platform.script.path);
    final inputDir = Directory(join(currentDir, '../input'));
    if (!inputDir.existsSync()) throw Exception('dir "input" is no exsist');
    final inputEntries = inputDir.listSync();

    final outputDir = Directory(join(currentDir, '../output'));
    if (outputDir.existsSync()) outputDir.deleteSync(recursive: true);
    outputDir.createSync();

    for (final inputEntry in inputEntries) {
      final path = inputEntry.path;
      final locale = basename(path);

      final xmlDir = Directory(path);
      if (!xmlDir.existsSync()) continue;
      final xmlEntries = xmlDir.listSync();

      Map<String, dynamic> json = {};

      for (final xmlEntry in xmlEntries) {
        final ext = extension(xmlEntry.path);
        if (ext != '.xml') continue;

        final file = File(xmlEntry.path);
        final string = await file.readAsString();
        final document = XmlDocument.parse(string);
        
        json.addAll(DocumentParser(locale).parse(document));
      }

      final encoder = JsonEncoder.withIndent("   ");
      final content = encoder.convert(json);
      final outputPath = join(outputDir.path, 'app_$locale.arb');

      final outputFile = File(outputPath);
      await outputFile.writeAsString(content);
    }
  } catch (e) {
    print(e);
  }
  
}
