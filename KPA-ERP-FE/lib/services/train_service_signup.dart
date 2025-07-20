
import 'package:kpa_erp/services/api_services/api_exception.dart';
import 'package:kpa_erp/services/api_services/api_service.dart';
import 'package:kpa_erp/types/zone_division_type.dart';

class TrainServiceSignup {
  static Future<List<String>> getDepot(
    final String division,
  ) async {
    try {
      final responseJson = await ApiService.get(
          '/api/depot-of-division/?division=$division', {});
      List<String> depotList = (responseJson['depo'] as List<dynamic>)
          .map((depot) => depot.toString())
          .toList();
      return depotList;
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<ZoneDivision>> getZones() async {
    try {
      final responseJson = await ApiService.get('/api/all_zones/', {});

      List<ZoneDivision> zoneList = (responseJson['zones'] as List<dynamic>)
          .map((zone) => ZoneDivision.fromJson(zone))
          .toList();

      return zoneList;
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<ZoneDivision>> getDivisions(
    final String zones,
  ) async {
    try {
      final responseJson = await ApiService.get('/api/divisions-of-zone/?zone=$zones', {});

      List<ZoneDivision> divisionList = (responseJson['divisions'] as List<dynamic>)
          .map((div) => ZoneDivision.fromJson(div))
          .toList();

      return divisionList;
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<Map<String, dynamic>> getTrainList(
    final String depot,
  ) async {
    try {
      final responseJson =
          await ApiService.get('/api/trains-of-depo/?depo=$depot', {});

      List<String> trainList = (responseJson['trains'] as List<dynamic>)
          .map((train) => train.toString())
          .toSet()
          .toList();

      List<String> empNumbersList = (responseJson['emp_numbers'] as List<dynamic>)
          .where((empNumber) => empNumber != null) // Remove null emp_numbers
          .map((empNumber) => empNumber.toString())
          .toSet()
          .toList();

      // print("Trains: $trainList");
      // print("Emp IDs: $empNumbersList");

      return {
        'trains': trainList,
        'emp_numbers': empNumbersList,
      };
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      print(e);
      return {};
    }
  }

  //coaches-of-train/?trains=2391
  static Future<List<String>> getCoaches(final String trainNumber) async {
    try {
      final responseJson = await ApiService.get(
          '/api/coaches-of-train/?trains=$trainNumber', {});
      List<String> coachList = (responseJson['coaches'] as List<dynamic>)
          .map((train) => train.toString())
          .toSet()
          .toList();
      print(coachList);
      return coachList;
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      print(e);
      return [];
    }
  }
}
