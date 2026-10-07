import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/core/network/api_client.dart';
import 'package:kastelli/core/network/api_endpoints.dart';
import 'package:kastelli/core/network/response_wrapper.dart';
import 'package:kastelli/features/home/data/models/dashboard_model.dart';

class DashboardRepository {
  final ApiConsumer apiConsumer;

  DashboardRepository({
    required this.apiConsumer,
  });

  Future<DashboardModel> getDashboard() async {
    final ResponseWrapper response = await apiConsumer.get(
      ApiEndpoints.dashboard,
      queryParameters: {'platform': 'android'},
    );

    final data = response.data;
    if (data is! List || data.isEmpty || data.first is! Map<String, dynamic>) {
      throw Exception(AppStrings.loadHomeFailed);
    }

    return DashboardModel.fromJson(data.first as Map<String, dynamic>);
  }
}
