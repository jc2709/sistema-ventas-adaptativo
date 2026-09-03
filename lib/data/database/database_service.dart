/// Contrato base para persistencia local.
abstract interface class DatabaseService {
  Future<void> initialize();
  Future<void> close();
}
