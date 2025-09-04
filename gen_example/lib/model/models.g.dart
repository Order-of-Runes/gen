// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestModel _$TestModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TestModel', json, ($checkedConvert) {
      final val = TestModel(
        index: $checkedConvert('index', (v) => v as String?),
        currentValue: $checkedConvert(
          'currentval',
          (v) => (v as num?)?.toDouble(),
        ),
        nextValue: $checkedConvert('nextValue', (v) => (v as num?)?.toDouble()),
      );
      return val;
    }, fieldKeyMap: const {'currentValue': 'currentval'});

Map<String, dynamic> _$TestModelToJson(TestModel instance) => <String, dynamic>{
  if (instance.index case final value?) 'index': value,
  if (instance.currentValue case final value?) 'currentval': value,
  if (instance.nextValue case final value?) 'nextValue': value,
};
