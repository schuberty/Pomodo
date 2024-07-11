import 'package:pomodo_commons/pomodo_commons.dart';

const kUnitTestTag = 'unit';
const kIntegrationTestTag = 'integration';

HttpClient getTodoistIntegrationApiClient() {
  if (Constants.todoistTestToken.isEmpty) {
    throw Exception('''Integration tests require a Todoist API test token.
    
    Use the script inside the script folder to run the tests or to understand how to run them.
    ''');
  }

  return DioClient.baseUrl(
    Constants.todoistBaseUrl,
    interceptors: [ApiTokenInterceptor(apiToken: Constants.todoistTestToken)],
  );
}
