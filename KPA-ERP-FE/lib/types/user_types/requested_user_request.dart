class RequestedUserRequest {
  final String token;
  RequestedUserRequest({required this.token});

  Map<String, dynamic> toJson() {
      return{
        'token':token
      };
    
  }
}