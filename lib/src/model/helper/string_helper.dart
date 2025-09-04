// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

String convertCase(String input, String caseType) {
  final words = <String>[];

  final buffer = StringBuffer();

  for (var i = 0; i < input.length; i++) {
    final char = input[i];

    // Treat separators as word breaks
    if (char == '_' || char == '-' || char == ' ') {
      if (buffer.isNotEmpty) {
        words.add(buffer.toString());
        buffer.clear();
      }
      continue;
    }

    // Split camel/pascalCase
    if (i > 0 && char.toUpperCase() == char && char.toLowerCase() != char && input[i - 1].toLowerCase() == input[i - 1]) {
      if (buffer.isNotEmpty) {
        words.add(buffer.toString());
        buffer.clear();
      }
    }

    buffer.write(char);
  }

  if (buffer.isNotEmpty) {
    words.add(buffer.toString());
  }

  // Build output
  return switch (caseType) {
    'FieldRename.kebab' => words.map((w) => w.toLowerCase()).join('-'),
    'FieldRename.snake' => words.map((w) => w.toLowerCase()).join('_'),
    'FieldRename.pascal' => words.map((w) {
      final lower = w.toLowerCase();
      return '${lower[0].toUpperCase()}${lower.substring(1)}';
    }).join(),
    'FieldRename.screamingSnake' => words.map((w) => w.toUpperCase()).join('_'),
    'FieldRename.none' || String() => input,
  };
}
