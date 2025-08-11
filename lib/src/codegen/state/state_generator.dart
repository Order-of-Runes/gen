// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:gen/src/annotations/state.dart';
import 'package:gen/src/codegen/state/base_field.dart';
import 'package:gen/src/codegen/state/helper.dart';
import 'package:source_gen/source_gen.dart';

const _baseClassFields = [
  BaseClassField('Loading', 'loading'),
  BaseClassField('String', 'loadingTitle'),
  BaseClassField('String', 'loadingSubtitle'),
  BaseClassField('bool', 'canDismissLoading'),
  BaseClassField('Failure', 'failure'),
  BaseClassField('FailureDisplay', 'failureDisplay'),
];

class StateGenerator extends GeneratorForAnnotation<GenState> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final classElement = element as ClassElement;
    final fields = classElement.fields;

    final shouldExtendBaseState = annotation.read('extendsBaseState').boolValue;

    // The class name prefixed with $
    // This is the name set when defining the class
    final classNameWithPrefix = classElement.name;

    // This is the name which is not prefixed by $
    // This will be the generated class
    final className = classNameWithPrefix.substring(1);

    final fieldData = _FieldData(fields, shouldExtendBaseState: shouldExtendBaseState)..process();

    final classFieldBuffer = StringBuffer()..writeAll(fieldData.classFields);
    final constructorFieldBuffer = StringBuffer()..writeAll(fieldData.constructorFields);
    final copyWithFuncParamsBuffer = StringBuffer()..writeAll(fieldData.copyWithFuncParams);
    final copyWithObjArgsBuffer = StringBuffer()..writeAll(fieldData.copyWithObjArgs);
    final stateObjArgsBuffer = StringBuffer()..writeAll(fieldData.stateObjArgs);
    final propsBuffer = StringBuffer()..writeAll(fieldData.props);

    final toStringArgs = const JsonEncoder.withIndent(' ').convert(fieldData.toStringArgs);

    final copyWithContent = copyWithFuncParamsBuffer.isEmpty
        ? ''
        : '''
        $className copyWith({
          $copyWithFuncParamsBuffer
        }) {
          return $className($copyWithObjArgsBuffer);
        }
        ''';

    return '''
    class $className ${shouldExtendBaseState ? 'extends BaseState ' : 'extends Equatable'}{
      const $className({
        $constructorFieldBuffer
      });
      
      $classFieldBuffer
      
      $copyWithContent
      
      ${shouldExtendBaseState ? '''
      @override
      $className setLoading({
        Loading loading = Loading.inline,
        String? title,
        String? subtitle,
        bool canDismissLoading = false,
      }) {
        return $className(
          loading: loading,
          loadingTitle: title,
          loadingSubtitle: subtitle,
          canDismissLoading: canDismissLoading,
          failure: null,
          $stateObjArgsBuffer
        );
      }
      
      @override
      $className setFailure(Failure failure) {
        return $className(
          loading: Loading.none,
          loadingTitle: null,
          loadingSubtitle: null,
          canDismissLoading: false,
          failure: failure,
          failureDisplay: failureDisplay,
          $stateObjArgsBuffer
        );
      }
      
      @override
      $className setFailureDisplay(FailureDisplay display) {
        return $className(
          loading: loading,
          loadingTitle: loadingTitle,
          loadingSubtitle: loadingSubtitle,
          canDismissLoading: canDismissLoading,
          failure: failure,
          failureDisplay: display,
          $stateObjArgsBuffer
        );
      }
      ''' : ''}
      
      @override
      List<Object?> get props {
        return [
          $propsBuffer
        ];
      }
      
      @override
      String toString() {
        return \'''
$className $toStringArgs
        \''';
      }
      
    }''';
  }
}

class _FieldData {
  _FieldData(this.fields, {required this.shouldExtendBaseState});

  final bool shouldExtendBaseState;

  final List<FieldElement> fields;

  /// Items to be placed in the constructor
  final List<String> constructorFields = [];

  /// Fields of the class
  final List<String> classFields = [];

  /// Parameters required for the copyWith function
  final List<String> copyWithFuncParams = [];

  /// Arguments to be passed to instantiate the State object
  /// inside the copyWith function
  final List<String> copyWithObjArgs = [];

  /// Class field arguments to be passed to instantiate the State object
  final List<String> stateObjArgs = [];

  /// Prop objects
  final List<String> props = [];

  /// toString state args
  final Map<String, String> toStringArgs = {};

  void process() {
    // Process Super fields
    if (shouldExtendBaseState) {
      for (final field in _baseClassFields) {
        final name = field.name;
        constructorFields.add('super.$name,');
        props.add('$name,');
        toStringArgs[name] = '\$$name';
      }

      copyWithObjArgs.add('loading: loading,');
    }

    // Process class fields
    for (final field in fields) {
      final type = field.type.getDisplayString();
      final name = field.name;

      // Get value from @Default annotation
      final defaultValue = extractDefaultValueFromMetadata(field.metadata);

      // Process class fields
      classFields.add('final $type $name;');

      // Process constructor fields
      if (defaultValue != null) {
        constructorFields.add('this.$name = $defaultValue,');
      } else {
        constructorFields.add('this.$name,');
      }

      copyWithFuncParams.add('${type.contains('?') ? type : '$type?'} $name,');

      copyWithObjArgs.add('$name: $name ?? this.$name,');

      stateObjArgs.add('$name: $name,');

      props.add('$name,');

      toStringArgs[name] = '\$$name';
    }
  }
}
