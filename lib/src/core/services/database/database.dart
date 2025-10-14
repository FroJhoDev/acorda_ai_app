/// Interface genérica para banco de dados
abstract class Database<T> {
  Future<void> initialize();
  Future<String> insert(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
  Future<T?> findById(String id);
  Future<List<T>> findAll();
  Future<List<T>> findByCondition(bool Function(T) condition);
  Future<void> close();
}
