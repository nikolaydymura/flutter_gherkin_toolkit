import 'package:gherkin/gherkin.dart';
import '../../flutter_gherkin_toolkit.dart';

class _GetHttpRequestStep1
    extends Given2WithWorld<String, String, WidgetTesterWorld> {
  @override
  Future<void> executeStep(String input1, String input2) async {
    // a functionality will be changed later

    print("api is '$input1' and response is '$input2'");
  }

  @override
  Pattern get pattern => RegExp(r'api\s\/(\w*\/\d*)\sreturns\s(\w*\.json)');
}

class _GetHttpRequestStep2
    extends Given3WithWorld<String, String, String, WidgetTesterWorld> {
  @override
  Future<void> executeStep(String input1, String input2, String input3) async {
    // a functionality will be changed later

    print(
        "api is '$input1', configuration is '$input2' and response is '$input3'");
  }

  @override
  Pattern get pattern => RegExp(
      r'api\s(\/\w*\/\d*)\swith\sconfiguration\s(\w*\.json)\sreturns\s(\w*\.json)');
}

class GetHttpRequestFactory {
  final String separator;

  GetHttpRequestFactory({this.separator = '->'});

  Iterable<StepDefinitionGeneric> get stepDefinitions => [
        _GetHttpRequestStep1(),
        _GetHttpRequestStep2(),
      ].reversed;
}
