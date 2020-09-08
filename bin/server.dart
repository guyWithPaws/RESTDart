import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = '0.0.0.0';

void main(List<String> args) async {
  final parser = ArgParser()..addOption('port', abbr: 'p');
  final result = parser.parse(args);

  // For Google Cloud Run, we respect the PORT environment variable
  final portStr = result['port'].toString() ?? Platform.environment['PORT'].toString() ?? '8080';
  final port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_echoRequest);

  final server = await io.serve(handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}

Response _echoRequest(Request request){
  return Response.ok('It works!');
}
