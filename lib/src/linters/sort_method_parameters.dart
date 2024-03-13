import 'package:alphabetical_lint/src/sorters/sorters.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class SortMethodParameters extends DartLintRule {
  SortMethodParameters({
    required MethodParametersSorter sorter,
  })  : _sorter = sorter,
        super(code: _code);

  static const _code = LintCode(
    name: 'sort_method_parameters',
    problemMessage: 'All method parameters should follow an alphabetical order',
  );

  final MethodParametersSorter _sorter;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodDeclaration((node) {
      final parameters = node.parameters?.parameters;

      if (parameters == null || parameters.isEmpty) {
        return;
      }

      final areSorted = _sorter.areParametersSorted(parameters: parameters);

      if (!areSorted && node.declaredElement != null) {
        reporter.reportErrorForElement(
          code,
          node.declaredElement!,
        );
      }
    });
    context.registry.addFunctionDeclaration((node) {
      final parameters = node.functionExpression.parameters?.parameters;

      if (parameters == null || parameters.isEmpty) {
        return;
      }

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
        _MakeMethodParametersSortedFix(
          sorter: _sorter,
        ),
      ];
}

class _MakeMethodParametersSortedFix extends DartFix {
  _MakeMethodParametersSortedFix({
    required MethodParametersSorter sorter,
  }) : _sorter = sorter;

  final MethodParametersSorter _sorter;

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addMethodDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final parameters = node.parameters?.parameters;

      if (parameters == null || parameters.isEmpty) {
        return;
      }

      final sortedParameters = _sorter.getSortedParameters(
        parameters: parameters,
      );

      if (parameters.length != sortedParameters.length) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Sort method parameters',
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

    context.registry.addFunctionDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final parameters = node.functionExpression.parameters?.parameters;

      if (parameters == null || parameters.isEmpty) {
        return;
      }

      final sortedParameters = _sorter.getSortedParameters(
        parameters: parameters,
      );

      if (parameters.length != sortedParameters.length) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Sort function parameters',
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
