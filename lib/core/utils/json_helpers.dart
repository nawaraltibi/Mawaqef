import 'dart:convert';

/// JSON Helpers
/// Utility functions for JSON operations
class JsonHelpers {
  /// Safely parse JSON string
  static dynamic parseJson(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    try {
      return json.decode(jsonString);
    } catch (e) {
      return null;
    }
  }

  /// Safely extract data from API response
  static dynamic extractData(dynamic response) {
    if (response is Map<String, dynamic>) {
      return response['data'] ?? response;
    }
    return response;
  }

  /// Parse PHP serialized array string to List<int>
  /// Example: "a:2:{i:0;s:1:\"1\";i:1;s:1:\"2\";}" -> [1, 2]
  static List<int> parsePhpSerializedArray(String? serializedString) {
    if (serializedString == null || serializedString.isEmpty) {
      return [];
    }

    try {
      // Check if it's a PHP serialized array format
      if (!serializedString.startsWith('a:')) {
        // If not PHP serialized, try to parse as regular string/int
        final value = int.tryParse(serializedString);
        if (value != null) {
          return [value];
        }
        return [];
      }

      // Extract values from PHP serialized format: a:2:{i:0;s:1:"1";i:1;s:1:"2";}
      // Pattern matches: s:length:"value"
      final regex = RegExp(r's:\d+:"(\d+)"');
      final matches = regex.allMatches(serializedString);
      final List<int> result = [];

      for (final match in matches) {
        final value = int.tryParse(match.group(1) ?? '');
        if (value != null) {
          result.add(value);
        }
      }

      return result;
    } catch (e) {
      return [];
    }
  }

  /// Serialize List<int> to PHP serialized array string
  /// Example: [1, 2] -> "a:2:{i:0;s:1:\"1\";i:1;s:1:\"2\";}"
  static String serializePhpArray(List<int> values) {
    if (values.isEmpty) {
      return 'a:0:{}';
    }

    final buffer = StringBuffer('a:${values.length}:{');
    for (int i = 0; i < values.length; i++) {
      final value = values[i].toString();
      buffer.write('i:$i;s:${value.length}:"$value";');
    }
    buffer.write('}');
    return buffer.toString();
  }
}

/// Alias for backward compatibility
class ApiResponseHelper extends JsonHelpers {}

