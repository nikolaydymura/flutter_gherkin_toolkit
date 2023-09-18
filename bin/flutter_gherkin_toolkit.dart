import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:args/args.dart';
import 'package:shelf_router/shelf_router.dart';

const port = 'port';
const host = 'host';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand(
        'serve',
        ArgParser()
          ..addOption(port, abbr: 'p', defaultsTo: '35353')
          ..addOption(host, abbr: 'h', defaultsTo: 'localhost'));

  ArgResults argResults = parser.parse(arguments);
  final command = argResults.command;
  if (command != null && command.name == 'serve') {
    var app = Router();

    app.get('/sync', _syncResources);
    app.post('/sync', _exportResources);

    final handler =
        const Pipeline().addMiddleware(logRequests()).addHandler(app);

    final server =
        await shelf_io.serve(handler, command[host], int.parse(command[port]));

    // Enable content compression
    server.autoCompress = true;

    stdout.writeln(
        'Serving at ${Uri(scheme: 'http', host: server.address.host, port: server.port)}');
  }
}

Future<Response> _exportResources(Request request) async {
  final destination = request.headers['Golden-Destination'];
  if (destination == null) {
    return Response.badRequest(headers: request.headers);
  }
  final goldenFile = File(destination);
  await goldenFile.parent.create(recursive: true);
  await for (final data in request.read()) {
    await goldenFile.writeAsBytes(data, flush: true, mode: FileMode.append);
  }
  return Response.ok(goldenFile.path);
}

Future<Response> _syncResources(Request request) async {
  final destination = request.headers['Golden-Destination'];
  if (destination == null) {
    return Response.badRequest(headers: request.headers);
  }
  final goldenFile = File(destination);
  return Response.ok(await goldenFile.readAsBytes());
}
