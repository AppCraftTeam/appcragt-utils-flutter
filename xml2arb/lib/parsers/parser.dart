abstract class Parser<Input> {
  const Parser();

  Map<String, dynamic> parse(Input input);
}