sealed class Either<F, S> {
  const Either();

  bool get isFailure;
  bool get isSuccess;

  F get failure => fold(
        (f) => f,
        (s) => throw StateError('Cannot access failure value on Success'),
      );

  S get success => fold(
        (f) => throw StateError('Cannot access success value on Failure'),
        (s) => s,
      );

  T fold<T>(T Function(F) failureFn, T Function(S) successFn);

  Either<F, S2> map<S2>(S2 Function(S) f);
  Either<F2, S> mapFailure<F2>(F2 Function(F) f);

  Either<F, S2> flatMap<S2>(Either<F, S2> Function(S) f);
}

class Failure<F, S> extends Either<F, S> {
  const Failure(this.value);

  final F value;

  @override
  bool get isFailure => true;

  @override
  bool get isSuccess => false;

  @override
  T fold<T>(T Function(F p1) failureFn, T Function(S p1) successFn) => failureFn(value);

  @override
  Either<F, S2> map<S2>(S2 Function(S p1) f) => Failure(value);

  @override
  Either<F2, S> mapFailure<F2>(F2 Function(F p1) f) => Failure(f(value));

  @override
  Either<F, S2> flatMap<S2>(Either<F, S2> Function(S p1) f) => Failure(value);
}

class Success<F, S> extends Either<F, S> {
  const Success(this.value);

  final S value;

  @override
  bool get isFailure => false;

  @override
  bool get isSuccess => true;

  @override
  T fold<T>(T Function(F p1) failureFn, T Function(S p1) successFn) => successFn(value);

  @override
  Either<F, S2> map<S2>(S2 Function(S p1) f) => Success(f(value));

  @override
  Either<F2, S> mapFailure<F2>(F2 Function(F p1) f) => Success(value);

  @override
  Either<F, S2> flatMap<S2>(Either<F, S2> Function(S p1) f) => f(value);
}
