import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:collection/collection.dart';

class FeatureEntry {
  FeatureEntry._({
    required this.description,
    required this.scenarios,
    this.skip,
  });

  factory FeatureEntry.fromConfiguration(File file) {
    final json = jsonDecode(file.readAsStringSync());
    final description =
        json['description'] ?? path.basenameWithoutExtension(file.path);
    final scenarios = json['scenarios']
        .map((e) => ScenarioEntry.fromConfiguration(e))
        .whereType<ScenarioEntry>()
        .toList();
    final skip = json['skip'];
    return FeatureEntry._(
      description: description,
      scenarios: scenarios,
      skip: skip,
    );
  }

  final String description;
  final List<ScenarioEntry> scenarios;
  final bool? skip;
}

class ScenarioEntry {
  ScenarioEntry._({
    required this.description,
    required this.screen,
    this.requests,
    this.steps = const [],
    this.skip,
    this.session,
  });

  factory ScenarioEntry.fromConfiguration(Map<String, dynamic> scenario) {
    final description = scenario['description'];
    final List<dynamic>? requests = scenario['requests'];
    final screen = scenario['screen'];
    final skip = scenario['skip'];
    return ScenarioEntry._(
      description: description,
      requests: requests?.map((e) => HttpEntry.fromConfiguration(e)).toList(),
      screen: screen,
      skip: skip,
      steps: scenario['steps']?.cast<String>(),
      session: scenario['session'],
    );
  }

  final String description;
  final String screen;
  final List<String> steps;
  final List<HttpEntry>? requests;
  final bool? skip;
  final Map<String, dynamic>? session;
}

class HttpEntry {
  HttpEntry._(this.method,
      this.path,
      this.statusCode, [
        this._response,
        this.delay,
      ]);

  factory HttpEntry.fromConfiguration(String input) {
    final request = input.split(' ');
    final method = request[0];
    final path = request[1];
    final status = int.parse(
      request
          .firstWhereOrNull((element) => element.startsWith('status='))
          ?.split('=')
          .lastOrNull ??
          '200',
    );
    final delayMilliseconds = int.tryParse(
      request
          .firstWhereOrNull((element) => element.startsWith('delay='))
          ?.split('=')
          .lastOrNull ??
          '',
    );
    final response = request
        .firstWhereOrNull((element) => element.startsWith('response='))
        ?.split('=')
        .lastOrNull;
    final delay = delayMilliseconds != null
        ? Duration(milliseconds: delayMilliseconds)
        : null;
    return HttpEntry._(
      method,
      path,
      status,
      response,
      delay,
    );
  }

  final String method;
  final String path;
  final int statusCode;
  final String? _response;
  final Duration? delay;

  dynamic get response {
    final overrides = _response?.split('<<') ?? [];
    if (overrides.length > 1) {
      final original = jsonDecode(File(overrides.first).readAsStringSync());
      for (var i = 1; i < overrides.length; i++) {
        final path = overrides[i];
        final merge = jsonDecode(File(path).readAsStringSync());
        if (merge is Map) {
          for (final jsonPath in merge.keys) {
            final keys = jsonPath.split('.');
            dynamic current = original;
            for (var j = 0; j < keys.length - 1; j++) {
              current = current[keys[j]];
            }
            current[keys.last] = merge[jsonPath];
          }
        }
      }
      return original;
    }
    final response = _response;
    if (response != null) {
      return jsonDecode(File(response).readAsStringSync());
    }
    return null;
  }
}

class SocketEntry {
  SocketEntry._(this.event, [
    this._response,
    this.delay,
  ]);

  factory SocketEntry.fromConfiguration(String input) {
    final message = input.split(' ');
    final delayMilliseconds = int.tryParse(
      message
          .firstWhereOrNull((element) => element.startsWith('delay='))
          ?.split('=')
          .lastOrNull ??
          '',
    );
    final body = message
        .firstWhereOrNull((element) => element.startsWith('message='))
        ?.split('=')
        .lastOrNull;
    final delay = delayMilliseconds != null
        ? Duration(milliseconds: delayMilliseconds)
        : null;
    return SocketEntry._(message[0], body, delay);
  }

  final String event;
  final String? _response;
  final Duration? delay;

  dynamic get response {
    final overrides = _response?.split('<<') ?? [];
    if (overrides.length > 1) {
      final original = jsonDecode(File(overrides.first).readAsStringSync());
      for (var i = 1; i < overrides.length; i++) {
        final path = overrides[i];
        final merge = jsonDecode(File(path).readAsStringSync());
        if (merge is Map) {
          for (final jsonPath in merge.keys) {
            final keys = jsonPath.split('.');
            dynamic current = original;
            for (var j = 0; j < keys.length - 1; j++) {
              current = current[keys[j]];
            }
            current[keys.last] = merge[jsonPath];
          }
        }
      }
      return original;
    }
    final response = _response;
    if (response != null) {
      return jsonDecode(File(response).readAsStringSync());
    }
    return null;
  }
}
