import 'package:connectivity_plus/connectivity_plus.dart';

import 'check_internet_connection_interface.dart';

class CheckInternetConnection implements ICheckInternetConnection {
  @override
  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    return connectivityResult != ConnectivityResult.none;
  }
}
