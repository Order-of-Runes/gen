// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:gen/gen.dart';
import 'package:glob/glob.dart';
import 'package:pub_semver/pub_semver.dart';

class Merger extends Builder {
  ///Location where the code is generated
  final String genLocation = 'model/models.dart';

  // Imports
  final String imports = '''
import 'dart:convert';

import 'package:corekit/corekit.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:resources/resources.dart';
import 'package:rusty_dart/rusty_dart.dart';
  ''';

  // Part Files
  final String parts = 'part \'models.g.dart\';\n';

  List<String> deserializeCases = [];
  List<String> storeCases = [];

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final exports = await buildStep.findAssets(Glob('**/*.model.part')).toList();
    final modelsBuffer = StringBuffer()
      ..writeln(header)
      ..writeln(imports)
      ..writeln()
      ..writeln(parts)
      ..writeln();

    // Generates actual `Model` classes along with `Fields` classes.
    for (final export in exports) {
      final model = (await buildStep.readAsString(export)).replaceAll(RegExp('(//.*\n)+\n'), '');
      final modelNames = _modelName(model);
      for (final name in modelNames) {
        deserializeCases.add(_case(name));
        storeCases.add(_storeCase(name));
      }
      modelsBuffer.writeln(model);
    }

    final deserializeCasesBuffer = StringBuffer()..writeAll(deserializeCases);
    final storeCasesBuffer = StringBuffer()..writeAll(storeCases);

    const deserializationError =
        r"Failure.model('Deserialization Error Detail:\n\tKey: \'${e.key}\'\n\tDescription: ${e.innerError}\n\tClass Name: ${e.className}\n\tSource: ${e.map}'),";

    final deserialize =
        '''
Result<BaseModel, Failure> _deserialize<BaseModel>(Map<String, dynamic> map) {
  try {
    return switch (BaseModel) {
      $deserializeCasesBuffer
      Type() => Err(
         Failure.model('Cannot create model for type :: \$BaseModel'),
       ),     
    };
  } on CheckedFromJsonException catch (e) {
    return Err(
      $deserializationError
    );
  }
}
    ''';

    final modelToStoreName =
        '''
String modelToStoreName<BaseModel>() {
  return switch (BaseModel) {
    $storeCasesBuffer
    Type() => '\$BaseModel',   
  };
}
    ''';

    const extension = '''
extension ModelMapper on Map<String, dynamic> {
  Result<BaseModel, Failure> toModel<BaseModel>() => _deserialize<BaseModel>(this);
}
    ''';

    const stringify = '''
String _stringify(Object? data) {
  if (data is Map || data is Iterable) return jsonEncode(data);
  return data?.toString() ?? '';
}
''';

    // Generates ModelMapper extension
    modelsBuffer
      ..writeln(deserialize)
      ..writeln(modelToStoreName)
      ..writeln(extension)
      ..writeln(stringify);

    final dartVersion = Version.parse(Platform.version.split(' ').first);
    final dartFormatter = formatter(dartVersion);

    // Writes strings from [modelsBuffer] to the file in [genLocation].
    buildStep.writeAsString(AssetId(buildStep.inputId.package, 'lib/$genLocation'), dartFormatter.format(modelsBuffer.toString()));
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      r'$lib$': [genLocation],
    };
  }

  String get header => '''
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: sort_unnamed_constructors_first, unused_element

''';

  // Adds model
  List<String> _modelName(String model) {
    final matches = RegExp(r'factory (.*).fromJson').allMatches(model);
    return matches.map((m) => m.group(1) ?? '').toList(growable: false);
  }

  // Each case in switch case for ModelMapper.
  String _case(String model) {
    return '$model => Ok($model.fromJson(map) as BaseModel),\n';
  }

  // Each case in switch case for modelToStoreName.
  String _storeCase(String model) {
    return "$model => '$model',\n";
  }
}
