// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:gen/src/model/helper/string_helper.dart';
import 'package:gen_annotation/gen_annotation.dart';
import 'package:source_gen/source_gen.dart';

class ModelGenerator extends GeneratorForAnnotation<GenModel> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final generateJson = annotation.read('json').boolValue;
    final fieldRename = processEnum(annotation.read('fieldRename'));
    final generateFieldClass = annotation.read('fields').boolValue;
    final createToString = annotation.read('createToString').boolValue;
    final includeIfNull = annotation.read('includeIfNull').boolValue;
    final anyMap = annotation.read('anyMap').boolValue;

    final classElement = element as ClassElement;
    final fields = classElement.fields;

    final className = classElement.name.substring(1);

    final metaData = _MetaData(
      generateJson: generateJson,
      fieldRename: fieldRename,
      generateFieldsClass: generateFieldClass,
      createToString: createToString,
      includeIfNull: includeIfNull,
      anyMap: anyMap,
      className: className,
      fields: fields,
    )..process();

    final annotationsBuffer = StringBuffer()..writeAll(annotateClass(classElement.metadata));

    final constructorParamsBuffer = StringBuffer()..writeAll(metaData.constructorParams);
    final classFieldsBuffer = StringBuffer()..writeAll(metaData.classFields);
    final propsBuffer = StringBuffer()..writeAll(metaData.props);
    final copyWithFuncParamsBuffer = StringBuffer()..writeAll(metaData.copyWithFuncParams);
    final copyWithObjArgsBuffer = StringBuffer()..writeAll(metaData.copyWithObjArgs);

    String fieldClass = '';
    String toString = '';

    if (generateFieldClass) {
      final fieldClassBuffer = StringBuffer()..writeAll(metaData.fieldClassFields);

      fieldClass =
          '''
      
class ${className}Fields {
  $fieldClassBuffer
}
    ''';
    }

    if (createToString) {
      final toStringArgs = const JsonEncoder.withIndent(' ').convert(metaData.toStringArgs);

      toString =
          '''
      
      @override
        String toString() {
          return \'''
$className $toStringArgs
          \''';
        }''';
    }

    return '''
    ${metaData.annotation}
    $annotationsBuffer
    class $className extends BaseModel {
      const $className({
        $constructorParamsBuffer
      });
      
      ${metaData.fromJson}
      
      $classFieldsBuffer
      
      ${metaData.toJson}
      
      $className copyWith({
        $copyWithFuncParamsBuffer
      }) {
        return $className($copyWithObjArgsBuffer);
      }      
      
      ${metaData.primaryKeyOverride}
     
      @override
      List<Object?> get props {
        return [
          $propsBuffer
        ];
      }
      $toString
    }
    $fieldClass
    ''';
  }

  Iterable<String> annotateClass(List<ElementAnnotation> annotations) {
    return annotations
        .where((a) {
          return !a.toString().toLowerCase().contains('genmodel');
        })
        .map((a) {
          return '${a.toSource()}\n';
        });
  }

  String processEnum(ConstantReader enumReader) {
    final enumObject = enumReader.revive();
    return enumObject.toString().split('::').last;
  }
}

class _MetaData {
  _MetaData({
    required this.generateJson,
    required this.fieldRename,
    required this.generateFieldsClass,
    required this.createToString,
    required this.includeIfNull,
    required this.anyMap,
    required this.className,
    required this.fields,
  });

  final bool generateJson;
  final String fieldRename;
  final bool generateFieldsClass;
  final bool createToString;
  final bool includeIfNull;
  final bool anyMap;
  final String className;
  final List<FieldElement> fields;

  Map<String, String> jsonFields = {};
  String? primaryKeyFieldName;

  String annotation = '';
  String fromJson = '';
  String toJson = '';
  String primaryKeyOverride = '';

  /// Fields of the class
  List<String> classFields = [];

  /// Items to be placed in the constructor
  List<String> constructorParams = [];

  /// Prop objects
  List<String> props = [];

  /// Parameters required for the copyWith function
  final List<String> copyWithFuncParams = [];

  /// Arguments to be passed to instantiate the State object
  /// inside the copyWith function
  final List<String> copyWithObjArgs = [];

  /// Field class fields
  ///
  /// For accessing fields through <class_name>Fields.<field>
  List<String> fieldClassFields = [];

  /// toString state args
  final Map<String, String> toStringArgs = {};

  void process() {
    jsonFields.clear();
    primaryKeyFieldName = null;

    annotation =
        '''
@JsonSerializable(
  fieldRename: $fieldRename,
  explicitToJson: true,
  includeIfNull: $includeIfNull,
  anyMap: $anyMap,
)
    ''';

    for (final field in fields) {
      final name = field.name;
      final type = getFieldType(field);

      classFields.add(buildField(field));

      if (isFieldNullable(field)) {
        constructorParams.add('this.$name,');
      } else {
        constructorParams.add('required this.$name,');
      }

      props.add('$name,');

      copyWithFuncParams.add('${type.contains('?') ? type : '$type?'} $name,');

      copyWithObjArgs.add('$name: $name ?? this.$name,');

      if (generateFieldsClass) {
        fieldClassFields.add('static const String ${name.toConstantCase()} = \'${jsonFields[name] ?? convertCase(name, fieldRename)}\';\n');
      }

      if (createToString) {
        toStringArgs[name] = '\$$name';
      }
    }

    if (generateJson) {
      fromJson =
          '''
  factory $className.fromJson(Map<String, dynamic> json){
    return _\$${className}FromJson(json);
  }
''';

      toJson =
          '''
  @override
  Map<String, dynamic> toJson() {
    return _\$${className}ToJson(this);
  }    
''';
    }

    primaryKeyOverride =
        '''
  @override
  String? get primaryKey => $primaryKeyFieldName;
    ''';
  }

  String buildField(FieldElement field) {
    String annotations = '';
    final List<String> commentDocs = [];

    if (field.metadata.isNotEmpty) {
      final hasStringifyAnnotation = field.metadata.any((ann) => ann.has('@stringify'));
      for (final ann in field.metadata) {
        if (ann.has('@JsonKey')) {
          final jsonKeyReader = ConstantReader(ann.computeConstantValue());
          final nameVal = jsonKeyReader.peek('name')?.stringValue;
          if (nameVal != null) {
            jsonFields[field.name] = nameVal;
          }
          if (hasStringifyAnnotation) {
            final _annotation = ann.toSource().replaceAll('const', '');
            annotations += '${_annotation.replaceFirst(')', ', fromJson: _stringify)')} ';
            continue;
          }
        }
        if (ann.has('@primaryKey')) {
          primaryKeyFieldName = field.name;
          continue;
        }
        if (ann.has('@stringify')) {
          annotations += '@JsonKey(fromJson: _stringify)';
          continue;
        }
        if (ann.has('@GenDoc')) {
          final reader = ConstantReader(ann.computeConstantValue());
          final content = reader.peek('content')?.stringValue;
          if (content != null) {
            commentDocs.add('/// $content\n');
          }
          continue;
        }
        // ignore: use_string_buffers
        annotations += '${ann.toSource().replaceAll('const', '')} ';
      }
    }
    return '${commentDocs.join('///\n')} $annotations final ${getFieldType(field)} ${field.name};\n';
  }

  String getFieldType(FieldElement field) {
    return field.type.getDisplayString().replaceAllMapped(RegExp(r'\$([A-Z]([a-z])*)+'), (match) => match.group(0)?.substring(1) ?? '');
  }

  bool isFieldNullable(FieldElement field) {
    return field.type.getDisplayString().endsWith('?');
  }
}

extension on ElementAnnotation {
  bool has(String annotation) => toString().toLowerCase().contains(annotation.toLowerCase());
}

extension on String {
  String toConstantCase() => replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m[0]}').toUpperCase();
}
