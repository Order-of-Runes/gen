// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: sort_unnamed_constructors_first, unused_element

import 'dart:convert';

// TODO (Ishwor) Revert
// import 'package:corekit/corekit.dart';
// TODO (Ishwor) Remove
import 'package:gen_example/base_model.dart';
// TODO (Ishwor) Remove
import 'package:gen_example/failure.dart';
import 'package:json_annotation/json_annotation.dart';
// TODO (Ishwor) Revert
// import 'package:resources/resources.dart';
import 'package:rusty_dart/rusty_dart.dart';

part 'models.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true, includeIfNull: false, anyMap: false)
class TestModel extends BaseModel {
  const TestModel({this.index, this.currentValue, this.nextValue});

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return _$TestModelFromJson(json);
  }

  final String? index;
  @JsonKey(name: 'currentval')
  final double? currentValue;
  final double? nextValue;

  @override
  Map<String, dynamic> toJson() {
    return _$TestModelToJson(this);
  }

  TestModel copyWith({String? index, double? currentValue, double? nextValue}) {
    return TestModel(index: index ?? this.index, currentValue: currentValue ?? this.currentValue, nextValue: nextValue ?? this.nextValue);
  }

  @override
  String? get primaryKey => null;

  @override
  List<Object?> get props {
    return [index, currentValue, nextValue];
  }

  @override
  String toString() {
    return '''
TestModel {
 "index": "$index",
 "currentValue": "$currentValue",
 "nextValue": "$nextValue"
}
          ''';
  }
}

class TestModelFields {
  static const String INDEX = 'index';
  static const String CURRENT_VALUE = 'currentval';
  static const String NEXT_VALUE = 'nextValue';
}

Result<BaseModel, Failure> _deserialize<BaseModel>(Map<String, dynamic> map) {
  try {
    return switch (BaseModel) {
      TestModel => Ok(TestModel.fromJson(map) as BaseModel),

      Type() => Err(Failure.model('Cannot create model for type :: $BaseModel')),
    };
  } on CheckedFromJsonException catch (e) {
    return Err(
      Failure.model(
        'Deserialization Error Detail:\n\tKey: \'${e.key}\'\n\tDescription: ${e.innerError}\n\tClass Name: ${e.className}\n\tSource: ${e.map}',
      ),
    );
  }
}

String modelToStoreName<BaseModel>() {
  return switch (BaseModel) {
    TestModel => 'TestModel',

    Type() => '$BaseModel',
  };
}

extension ModelMapper on Map<String, dynamic> {
  Result<BaseModel, Failure> toModel<BaseModel>() => _deserialize<BaseModel>(this);
}

String _stringify(Object? data) {
  if (data is Map || data is Iterable) return jsonEncode(data);
  return data?.toString() ?? '';
}
