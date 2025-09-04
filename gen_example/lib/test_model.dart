// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'package:gen_annotation/gen_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

@genModel
abstract class $TestModel {
  String? index;
  @JsonKey(name: 'currentval')
  double? currentValue;
  double? nextValue;
}
