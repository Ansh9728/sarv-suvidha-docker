import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kpa_erp/models/auth_model.dart';
import 'package:kpa_erp/routes.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';



class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadAndNavigate(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        }
        return Container();
      },
    );
  }

  Future<void> _loadAndNavigate(BuildContext context) async {
    final authModel = Provider.of<AuthModel>(context, listen: false);
    await authModel.loadAuthState();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastRoute = prefs.getString('lastRoute');
    print(lastRoute);
    if (kIsWeb) {
      if (authModel.isAuthenticated && lastRoute != null) {
        if(lastRoute =='/'){
          Navigator.pushReplacementNamed(context, Routes.login);
        }
        else{
          Navigator.pushReplacementNamed(context, lastRoute);
        }
      } else {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    }
    else{
      if (authModel.isAuthenticated) {
          Navigator.pushReplacementNamed(context, Routes.home);
       
      }else {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    }
  }

  Widget _buildLoadingIndicator() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage('assets/image.png'), 
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
