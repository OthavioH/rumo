import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnvironment {
  static String get placesAPIAgentName {
    return dotenv.env['PLACES_API_AGENT_NAME'] ?? 'RumoApp';
  }
}