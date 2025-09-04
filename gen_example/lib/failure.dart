// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'dart:convert';

import 'package:equatable/equatable.dart';

class Failure extends Equatable implements Exception {
  const Failure._(
    this.message, {
    this.source,
    this.code = FailureCode.none,
    this.detail,
    this.stackTrace,
    this.auxCode = 0,
  });

  factory Failure.api(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.api.name,
      code: code ?? FailureCode.none,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  factory Failure.biometric(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.biometric.name,
      code: code ?? FailureCode.none,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  factory Failure.connectionTimeout(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.connectionTimeout.name,
      code: code ?? FailureCode.none,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  factory Failure.dao(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.dao.name,
      code: code ?? FailureCode.none,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  factory Failure.io(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.io.name,
      code: code ?? FailureCode.none,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  factory Failure.model(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.model.name,
      code: code ?? FailureCode.none,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  factory Failure.network(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.network.name,
      code: code ?? FailureCode.none,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  factory Failure.parse(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.parse.name,
      code: code ?? FailureCode.cannotParse,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  factory Failure.permission(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.permission.name,
      code: code ?? FailureCode.none,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  factory Failure.remote(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.remote.name,
      code: code ?? FailureCode.none,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  factory Failure.repository(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.repository.name,
      code: code ?? FailureCode.none,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  factory Failure.viewModel(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.viewModel.name,
      code: code ?? FailureCode.none,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  factory Failure.unknown(
    String message, {
    String? detail,
    FailureCode? code,
    StackTrace? stackTrace,
  }) {
    return Failure._(
      message,
      source: FailureSource.unknown.name,
      code: code ?? FailureCode.none,
      detail: detail,
      stackTrace: stackTrace,
    );
  }

  final String message;
  final String? source;
  final FailureCode code;
  final String? detail;
  final StackTrace? stackTrace;
  final int auxCode;

  Failure copyWith({
    String? message,
    String? detail,
    FailureCode? code,
    FailureSource? source,
    StackTrace? stackTrace,
    int? auxCode,
  }) {
    return Failure._(
      message ?? this.message,
      detail: detail ?? this.detail,
      code: code ?? this.code,
      source: source?.name ?? this.source,
      stackTrace: stackTrace ?? this.stackTrace,
      auxCode: auxCode ?? this.auxCode,
    );
  }

  @override
  List<Object?> get props => [message, detail, code, source, stackTrace, auxCode];

  @override
  String toString() {
    final map = {
      'source': source,
      'code': code,
      'message': message,
      if (detail != null) 'detail': detail,
      if (stackTrace != null) 'stack_trace': stackTrace,
      'aux_code': auxCode,
    };

    return const JsonEncoder.withIndent(' ').convert(map);
  }
}

enum FailureCode {
  none(0),
  noInternet(10),
  networkUnreachable(11),
  connectionRefused(12),
  userCanceled(100),
  badRequest(400),
  unAuthorized(401),
  forbidden(403),
  notFound(404),
  internalServerError(500),
  notImplemented(501),
  badGateway(502),
  serviceUnavailable(503),
  tokenExpired(601),
  sessionExpired(602),
  noResponse(603),
  permissionPermanentlyDenied(604),
  cannotParse(605);

  const FailureCode(this.code);

  final int code;

  static FailureCode fromCode(int? code) {
    return switch (code) {
      10 => FailureCode.noInternet,
      11 => FailureCode.networkUnreachable,
      12 => FailureCode.connectionRefused,
      100 => FailureCode.userCanceled,
      400 => FailureCode.badRequest,
      401 => FailureCode.unAuthorized,
      403 => FailureCode.forbidden,
      404 => FailureCode.notFound,
      500 => FailureCode.internalServerError,
      501 => FailureCode.notImplemented,
      502 => FailureCode.badGateway,
      503 => FailureCode.serviceUnavailable,
      601 => FailureCode.tokenExpired,
      602 => FailureCode.sessionExpired,
      603 => FailureCode.noResponse,
      604 => FailureCode.permissionPermanentlyDenied,
      605 => FailureCode.cannotParse,
      0 || int() || null => FailureCode.none,
    };
  }
}

enum FailureSource {
  api,
  biometric,
  connectionTimeout,
  dao,
  io,
  model,
  network,
  parse,
  permission,
  remote,
  repository,
  unknown,
  viewModel,
}
