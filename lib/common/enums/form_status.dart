enum FormStatus {
  initial,
  success,
  error,
  loading;

  bool get isInitial => this == initial;
  bool get isSuccess => this == success;
  bool get isError => this == error;
  bool get isLoading => this == loading;
}
