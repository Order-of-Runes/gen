// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'package:analyzer/dart/element/element.dart';
import 'package:gen/annotations/state.dart';
import 'package:source_gen/source_gen.dart';

extension DefaultAnnotationExtension on ElementAnnotation {
  bool get hasDefault => toString().toLowerCase().contains('@default');
}

String? extractDefaultValueFromMetadata(List<ElementAnnotation> metadata) {
  ElementAnnotation ann;
  try {
    ann = metadata.firstWhere((ann) => ann.hasDefault);
    // ignore: avoid_catching_errors
  } on StateError catch (_) {
    return null;
  }

  const matcher = TypeChecker.fromRuntime(Default);
  final objectType = ann.computeConstantValue()?.type;
  if (objectType != null && matcher.isExactlyType(objectType)) {
    final source = ann.toSource();
    final res = source.substring('@Default('.length, source.length - 1);

    final needsConstModifier = !res.trimLeft().startsWith('const') && (res.contains('(') || res.contains('[') || res.contains('{'));
    final defaultValue = needsConstModifier ? 'const $res' : res;

    return defaultValue.startsWith('const')
        ? '${defaultValue.substring(0, 5)}${defaultValue.substring(5).replaceAll('const', '')}'
        : defaultValue;
  }
  return null;
}
