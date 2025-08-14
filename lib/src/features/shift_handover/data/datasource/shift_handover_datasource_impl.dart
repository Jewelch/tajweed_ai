import '../../../../core/api/requester_config.dart';
import '../enums/note_type.dart';
import '../models/shift_report_do.dart';

part '../mock/shift_handover_mock.dart';

abstract interface class ShiftHandoverDataSource {
  static const String endpoint = "shift-handover";

  /// Calls the shift handover API endpoints.
  FutureRequestResult<ShiftReportDO> getShiftReport(String caregiverId);
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

  final responseMock = ResponseMock.success;

  @override
  FutureRequestResult<ShiftReportDO> getShiftReport(String caregiverId) async =>
      switch (responseMock) {
        //! Failure
        ResponseMock.failure => Future.delayed(
          const Duration(milliseconds: 500),
          () => Left(Exception('Failure')),
        ),
        //$ No internet
        ResponseMock.noInternet => Future.delayed(
          const Duration(milliseconds: 500),
          () => Left(Exception('No internet connection')),
        ),
        //? No data
        ResponseMock.noData => Future.delayed(
          const Duration(milliseconds: 500),
          () => Right(ShiftReportDO.empty()),
        ),
        //+ Success
        ResponseMock.success => await performDecodingRequest(
          decodableModel: ShiftReportDO.empty(),
          method: RestfulMethods.get,
          path: "${ShiftHandoverDataSource.endpoint}/$caregiverId",
          mockingData: _mockShiftReport(notesCount: AppEnvironment.testing ? 1 : 5),
          mockIt: true,
          simulateFailure: false,
        ),
      };
}

enum ResponseMock { noInternet, noData, success, failure }
