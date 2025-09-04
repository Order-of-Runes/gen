// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'package:gen_example/model/models.dart';

void main() {
  const model = TestModel(index: 'x', currentValue: 25);
  print(model.toJson());
}