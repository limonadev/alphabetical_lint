import 'package:alphabetical_lint/src/helpers/helpers.dart';
import 'package:alphabetical_lint/src/linters/linters.dart';
import 'package:alphabetical_lint/src/sorters/sorters.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _VariablesOrderLint(
      alphabeticalHelper: const AlphabeticalHelper(),
    );

class _VariablesOrderLint extends PluginBase {
  _VariablesOrderLint({
    required AlphabeticalHelper alphabeticalHelper,
  })  : _constructorParametersSorter = ConstructorParametersSorter(
          alphabeticalHelper: alphabeticalHelper,
        ),
        _methodParametersSorter = MethodParametersSorter(
          alphabeticalHelper: alphabeticalHelper,
        );

  final ConstructorParametersSorter _constructorParametersSorter;
  final MethodParametersSorter _methodParametersSorter;

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        SortMethodParameters(
          sorter: _methodParametersSorter,
        ),
        SortConstructorParameters(
          sorter: _constructorParametersSorter,
        ),
      ];

  @override
  List<Assist> getAssists() => [];
}
