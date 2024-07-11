import '../pomodo_commons.dart';
import 'client/client.dart';

typedef Result<S> = Future<Either<ClientError, S>>;

typedef Response = ClientResponse;
