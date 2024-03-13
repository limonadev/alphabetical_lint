import 'package:alphabetical_lint/src/helpers/helpers.dart';
import 'package:analyzer/dart/ast/ast.dart';

final class MethodParametersSorter {
  const MethodParametersSorter({
    required AlphabeticalHelper alphabeticalHelper,
  }) : _alphabeticalHelper = alphabeticalHelper;

  final AlphabeticalHelper _alphabeticalHelper;

  List<FormalParameter> getSortedParameters({
    required List<FormalParameter> parameters,
  }) {
    final requiredPositionalParametersNames = <FormalParameter>[];
    final requiredNamedParametersNames = <FormalParameter>[];
    final optionalNamedParametersNames = <FormalParameter>[];
    final optionalPositionalParametersNames = <FormalParameter>[];

    for (final parameter in parameters) {
      if (parameter.isRequiredPositional) {
        requiredPositionalParametersNames.add(parameter);
      } else if (parameter.isRequiredNamed) {
        requiredNamedParametersNames.add(parameter);
      } else if (parameter.isOptionalNamed) {
        optionalNamedParametersNames.add(parameter);
      } else {
        optionalPositionalParametersNames.add(parameter);
      }
    }

    return [
      ...requiredPositionalParametersNames,
      ..._alphabeticalHelper.sortParametersAlphabetically(
        parameters: requiredNamedParametersNames,
      ),
      ..._alphabeticalHelper.sortParametersAlphabetically(
        parameters: optionalNamedParametersNames,
      ),
      ...optionalPositionalParametersNames,
    ];
  }

  /// Order should be:
  /// 1. Required positional parameters
  /// 2. Required named parameters
  /// 3. Optional named parameters
  /// 4. Optional positional parameters
  ///
  /// 2-3 and 4 are mutually exclusive, as there is no way to have a constructor
  /// with named and optional positioned parameters are the same time.
  ///
  /// Each group should be ordered alphabetically, except #1 and #4.

  bool areParametersSorted({
    required List<FormalParameter> parameters,
  }) {
    final sortedParameters = getSortedParameters(
      parameters: parameters,
    );

    if (sortedParameters.length != parameters.length) {
      return false;
    }

    for (var i = 0; i < parameters.length; i++) {
      if (parameters[i].name != sortedParameters[i].name) {
        return false;
      }
    }

    return true;
  }
}
