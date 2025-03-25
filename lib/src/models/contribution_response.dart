import './contribution.dart';

/// Contribution response object.
class ContributionResponse {
  /// Indicates if the operation was successful.
  final bool success;

  /// Message from the operation.
  late String message;

  /// Redirect URL.
  late String? redirect;

  /// Contribution object.
  late Contribution contribution;

  /// Reference of the contribution.
  late String? reference;

  /// Status of the contribution.
  late String status; // 'SUCCESS' | 'FAILED' | 'PENDING'

  ContributionResponse(Map<String, dynamic> data)
      : success = data['success'] {
    message = data['message'];
    redirect = data['redirect'];
    contribution = Contribution(data['contribution']);
    reference = data['reference'];
    status = data['status'];
  }

  bool isOperationSuccess() {
    return success;
  }

  bool isContributionSuccess() {
    return contribution.isSuccess();
  }
}
