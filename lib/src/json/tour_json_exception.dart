/// Thrown when tour JSON is malformed or references unknown values.
class TourJsonException implements Exception {
  /// Creates a [TourJsonException] with [message].
  const TourJsonException(this.message, {this.path});

  /// Human-readable error description.
  final String message;

  /// JSON path where the error occurred, e.g. `steps[2].requiredAction`.
  final String? path;

  @override
  String toString() {
    if (path == null) return 'TourJsonException: $message';
    return 'TourJsonException at $path: $message';
  }
}
