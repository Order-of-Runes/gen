// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'package:equatable/equatable.dart';

abstract class BaseModel extends Equatable {
  const BaseModel();

  String? get primaryKey;

  Map<String, dynamic> toJson();
}
