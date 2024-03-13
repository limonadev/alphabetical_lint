import 'package:alphabetical_lint/src/sorters/sorters.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class SortConstructorParameters extends DartLintRule {
  SortConstructorParameters({
    required ConstructorParametersSorter sorter,
  })  : _sorter = sorter,
        super(code: _code);

  static const _code = LintCode(
    name: 'sort_constructor_parameters',
    problemMessage:
        'All constructors parameters should follow an alphabetical order',
  );

  final ConstructorParametersSorter _sorter;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addConstructorDeclaration((node) {
      final parameters = node.parameters.parameters;
      final areSorted = _sorter.areParametersSorted(parameters: parameters);

      if (!areSorted && node.declaredElement != null) {
        reporter.reportErrorForElement(
          code,
          node.declaredElement!,
        );
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        _MakeConstructorParametersSortedFix(
          sorter: _sorter,
        ),
      ];
}

class _MakeConstructorParametersSortedFix extends DartFix {
  _MakeConstructorParametersSortedFix({
    required ConstructorParametersSorter sorter,
  }) : _sorter = sorter;

  final ConstructorParametersSorter _sorter;

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addConstructorDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final parameters = node.parameters.parameters;
      final sortedParameters = _sorter.getSortedParameters(
        parameters: parameters,
      );

      if (parameters.length != sortedParameters.length) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Sort constructor parameters',
        priority: 1,
      );

      changeBuilder.addDartFileEdit((builder) {
        for (var i = 0; i < parameters.length; i++) {
          final parameter = parameters[i];
          builder.addSimpleReplacement(
            SourceRange(
              parameter.beginToken.offset,
              parameter.endToken.offset -
                  parameter.beginToken.offset +
                  parameter.endToken.length,
            ),
            sortedParameters[i].toString(),
          );
        }
      });
    });
  }
}
