final class StringPattern {
  const StringPattern(this.regExp, this.type, this.prefix);

  final RegExp regExp;
  final String type;
  final String prefix;

  StringPattern.orderedString() :
    regExp = RegExp(r'%[0-9]{1}\$s'),
    type = 'String',
    prefix = 's';

  StringPattern.orderedInt() :
    regExp = RegExp(r'%[0-9]{1}\$d'),
    type = 'int',
    prefix = 'n';

  StringPattern.string() :
    regExp = RegExp(r'%s'),
    type = 'String',
    prefix = 's';

  StringPattern.int() :
    regExp = RegExp(r'%d'),
    type = 'int',
    prefix = 'n';
    
}