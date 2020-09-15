import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';

class Service{
  Handler get handler {
    final router = Router();

    router.get('', (Request request, String id){
      
      
    });

    return router.handler;
  }
}
