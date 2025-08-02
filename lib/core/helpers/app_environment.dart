import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnvironment {
  static String get placesAPIAgentName {
    return dotenv.env['PLACES_API_AGENT_NAME'] ?? 'RumoApp';
  }

  static String get supabaseAnonKey {
    return dotenv.env['SUPABASE_ANON_KEY'] ?? '<SUPABASE_ANON_KEY>';
  }

  static String get supabaseProjectUrl {
    return dotenv.env['SUPABASE_PROJECT_URL'] ?? '<SUPABASE_PROJECT_URL>';
  }
}