// ignore_for_file: dead_code

import '../../../../core/api/requester_config.dart';
import '../enums/note_type.dart';
import '../models/shift_report_model.dart';

part '../mock/shift_handover_mock.dart';

abstract interface class ShiftHandoverDataSource {
  static const String endpoint = "shift-handover";

  /// Calls the shift handover API endpoints.
  FutureRequestResult<ShiftReportDATO> getShiftReport(String caregiverId);
}

final class ShiftHandoverDataSourceImpl extends RequestPerformer
    implements ShiftHandoverDataSource {
  final ConnectivityMonitor _connectivityMonitor;

  ShiftHandoverDataSourceImpl({
    required Dio client,
    required CacheManager cacheManager,
    required ConnectivityMonitor connectivityMonitor,
  }) : _connectivityMonitor = connectivityMonitor,
       super(client);

  @override
  FutureRequestResult<ShiftReportDATO> getShiftReport(String caregiverId) async =>
      _connectivityMonitor.isConnected
      ? await performDecodingRequest(
          decodableModel: ShiftReportDATO.empty(),
          method: RestfulMethods.get,
          path: "${ShiftHandoverDataSource.endpoint}/$caregiverId",
          mockingData: _mockShiftReport(notesCount: AppEnvironment.testing ? 1 : 5),
          mockIt: true,
          simulateFailure: false,
        )
      : Left(Exception('No internet connection'));
}
