// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'package:json_annotation/json_annotation.dart';

class GenModel {
  const GenModel({
    this.json = true,
    this.fieldRename = FieldRename.none,
    this.fields = true,
    this.createToString = true,
    this.includeIfNull = false,
    this.anyMap = false,
  });

  /// Defines whether or not to generate json conversion methods
  ///
  /// i.e. toJson() and fromJson()
  ///
  /// Default is true.
  final bool json;

  /// Defines the automatic naming strategy when converting class field names
  /// into JSON map keys.
  ///
  /// With a value [FieldRename.none], the name of the field is
  /// used without modification.
  ///
  /// See [FieldRename] for details on the other options.
  ///
  /// Note: the value for [JsonKey.name] takes precedence over this option for
  /// fields annotated with [JsonKey].
  ///
  /// Default is [FieldRename.snake].
  final FieldRename fieldRename;

  /// Whether the generator should generate separate fields class or not.
  ///
  /// Default is true.
  final bool fields;

  /// Whether the generator should override toString() or not.
  ///
  /// Default is true.
  final bool createToString;

  /// Whether the generator should include fields with `null` values in the
  /// serialized output.
  ///
  /// If `true`, all fields are written to JSON, even if they are
  /// `null`.
  ///
  /// If a field is annotated with `JsonKey` with a non-`null` value for
  /// `includeIfNull`, that value takes precedent.
  ///
  /// Default is false.
  final bool includeIfNull;

  /// If `true`, [Map] types are *not* assumed to be [Map<String, dynamic>]
  /// – which is the default type of [Map] instances return by JSON decode in
  /// `dart:convert`.
  ///
  /// This will increase the code size, but allows [Map] types returned
  /// from other sources, such as `package:yaml`.
  ///
  /// *Note: in many cases the key values are still assumed to be [String]*.
  ///
  /// Default is false.
  final bool anyMap;
}

const genModel = GenModel();

class Stringify {
  const Stringify._();
}

const stringify = Stringify._();

class PrimaryKey {
  const PrimaryKey();
}

const primaryKey = PrimaryKey();
