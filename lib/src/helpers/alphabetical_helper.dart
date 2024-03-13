import 'package:analyzer/dart/ast/ast.dart';

final class AlphabeticalHelper {
  const AlphabeticalHelper();

  List<FormalParameter> sortParametersAlphabetically({
    required List<FormalParameter> parameters,
  }) {
    final result = List<FormalParameter>.from(parameters);
    result.sort((a, b) => a.name.toString().compareTo(b.name.toString()));

    return result;
  }
}
