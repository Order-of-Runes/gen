// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

const genState = GenState();

class GenState {
  const GenState({this.extendsBaseState = true});

  final bool extendsBaseState;
}

class Default {
  const Default(this.value);

  final Object value;
}
