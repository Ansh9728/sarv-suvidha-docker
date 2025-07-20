class Permissions {
  static const List<String> admin = ['s2 admin', 'railway admin'];
  static const List<String> write = ['s2 admin', 'railway admin', 'write read'];
  static const List<String> read = [
    's2 admin',
    'railway admin',
    'write read',
    'EHK',
    'coach attendent',
    'OBHS',
    'railway officer',
    'contractor',
    'war room user',
    'Passenger'
  ];

  static const List<String> mccToObhsHandoverPermissions = [
    's2 admin',
    'railway admin',
    'write read',
    'EHK',
    'coach attendent',
    'OBHS',
    'railway officer',
    'contractor',
    'war room user',
  ];

  static const List<String> obhsToMccHandover = [
    's2 admin',
    'railway admin',
    'write read',
    'EHK',
    'coach attendent',
    'OBHS',
    'railway officer',
    'contractor',
    'war room user',
  ];

  static const List<String> contractAdmin = [
    'contractor admin',
  ];

  static List<String> getWritePermissions() {
    return write;
  }

  static List<String> getReadPermissions() {
    return read;
  }

  static List<String> getAdminPermissions() {
    return admin;
  }

  static List<String> getContractAdminPermissions() {
    return contractAdmin;
  }
}
