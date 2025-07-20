class ApproveDenyRequest {
  final String token;
  final String q;
  ApproveDenyRequest({required this.token,  required this.q});

  Map<String, dynamic> toJson() {
      return{
        'token':token,
        'q':q,
      };
    
  }
}