
import 'package:kpa_erp/services/api_services/api_exception.dart';
import 'package:kpa_erp/services/api_services/api_service.dart';
import 'package:kpa_erp/types/user_types/approve_deny_request.dart';
import 'package:kpa_erp/types/user_types/requested_user_request.dart';
import 'package:kpa_erp/types/user_types/user_request_response.dart';

class RequestedUserService {
  static Future<List<RequestedUserResponse>> showRequests(
    final String token,
  ) async {
      //List<AccessHanleResponse> userArray = [];
    try{
      final request =RequestedUserRequest(token:token);
        final responseJson =await ApiService.get('/api/users/show_requested_user/', request.toJson());
        final List<dynamic> data = responseJson['user_requested'];
        final List<RequestedUserResponse> userArray = data.map((item) {
          return RequestedUserResponse.fromJson(item);
        }).toList();
        return userArray; 
    }
    on ApiException catch (e) {
      throw (e.message);
    }
    catch(e){
      print(e);
      print("Error Occourded while sending Otp");
      return [];
    }

  }

  static Future<String> approveUser(
    final String q,
    final String id,
    final String token,
  ) async {
    try{
      final request =ApproveDenyRequest(token:token,q:q);
      final responseJson =await ApiService.post('/api/users/user_requested/$id/', request.toJson());
      print(responseJson);
      return responseJson['message'];
    }
    on ApiException catch (e) {
      throw (e.message);
    }
    catch(e){
      print(e);
      print("Error Occourded while sending Otp");
      return 'Error Occourded while sending Otp';
    }
  } 
  
}