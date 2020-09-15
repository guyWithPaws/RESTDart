import 'dart:async';
import 'dart:core';
import 'package:postgres/postgres.dart';

import 'record.dart';

///Simple sigleton for PostgreSQL connection and operations
class PostgresProvider {
  PostgresProvider._();
  static final PostgresProvider provider = PostgresProvider._();

  final PostgreSQLConnection _connection = PostgreSQLConnection(
    'ec2-54-247-79-178.eu-west-1.compute.amazonaws.com',
    5432,
    'dctajnhub6f3eb',
    username: 'vetnaopdjeyogg',
    useSSL: true,
    password:
        'ebc3c2db44d10e2b1efaa1313edda54b0cdae7c7045982bdcc11fcd4e38d4ae6',
  );

  Future<void> init() async {
    await _connection.open();
  }


  FutureOr<List<Record>> read() async {
    final result = await _connection.query('SELECT * FROM records;');
    return result
        .toList()
        .map((element) => Record()
          ..id = element.toColumnMap()['id'] as String
          ..timestamp = element.toColumnMap()['timestamp'] as double
          ..message = element.toColumnMap()['message'] as String)
        .toList();
  }

  FutureOr<bool> create(Record record) async {
    final dynamic result = await _connection.transaction(
      (trx) => trx.query(
          'INSERT INTO records VALUES (@id, @message, @timestamp);',
          substitutionValues: <String, dynamic>{
            'id': record.id,
            'message': record.message,
            'timestamp': record.timestamp
          }),
    );
    return result.toString() == 'null' ? false : true;
  }

  FutureOr<dynamic> readById(String id) async {
    final result = await _connection.query(
        'SELECT * FROM records WHERE id = @val;',
        substitutionValues: <String, dynamic>{
          'val': id,
        });
    return result.isNotEmpty == true
        ? result
            .toList()
            .map((element) => Record()
              ..id = element.toColumnMap()['id'] as String
              ..timestamp = element.toColumnMap()['timestamp'] as double
              ..message = element.toColumnMap()['message'] as String)
            .toList()
            .first
        : false;
  }

  FutureOr<bool> update(String message, String id) async {
    final result = await _connection.query(
        'UPDATE records SET message = @message WHERE id = @id;',
        substitutionValues: <String, dynamic>{
          'message': message,
          'id': id,
        });
    return result.isEmpty ? true : false;
  }

  FutureOr<bool> delete(String id) async {
    final result = await _connection.query(
        'DELETE FROM records WHERE id = @id;',
        substitutionValues: <String, dynamic>{
          'id': id,
        });
    return result.isEmpty ? true : false;
  }

  FutureOr<bool> clean() async {
    final result = await _connection.query('DELETE FROM records;');
    return result.isEmpty ? true : false;
  }
}
