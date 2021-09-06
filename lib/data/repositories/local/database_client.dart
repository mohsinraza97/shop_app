class DatabaseClient {
  const DatabaseClient._internal();

  static final DatabaseClient _instance = DatabaseClient._internal();

  static DatabaseClient get instance => _instance;
}
