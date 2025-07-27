// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

export 'annotations/doc.dart';
export 'annotations/model.dart';
export 'annotations/state.dart';

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:gen/codegen/model/model_gen.dart';
import 'package:gen/codegen/model/model_merger.dart';
import 'package:gen/codegen/state/state_gen.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:source_gen/source_gen.dart';

DartFormatter formatter(Version version) {
  return DartFormatter(languageVersion: version, pageWidth: 140);
}

Builder stateGenerator(BuilderOptions options) {
  return SharedPartBuilder(
    [StateGenerator()],
    'state',
    formatOutput: (code, version) {
      return formatter(version).format(code);
    },
  );
}

Builder modelGenerator(BuilderOptions options) {
  return LibraryBuilder(
    ModelGenerator(),
    generatedExtension: '.model.part',
    header: '',
    formatOutput: (code, version) {
      return formatter(version).format(code);
    },
  );
}

Builder modelMerger(BuilderOptions options) => ModelMerger();

// TODO (Ishwor) Part files are not removed
PostProcessBuilder temporaryFileCleanup(BuilderOptions options) {
  return FileDeletingBuilder(const ['.model.part', '.theme.part'], isEnabled: options.config['enabled'] as bool? ?? false);
}
