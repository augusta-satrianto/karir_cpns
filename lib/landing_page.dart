import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.goNamed('login');
            },
            child: const Text('Login'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              context.goNamed('register');
            },
            child: const Text('Register'),
          ),
          const SizedBox(
            height: 20,
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     try {
          //       final user = await GoogleSignInService.login();
          //       await user?.authentication;
          //       // log(user!.displayName.toString());
          //       // log(user.email);
          //       // log(user.id);
          //       // log(user.photoUrl.toString());
          //       print(user!.email.toString());
          //       print(user);
          //       // if (context.mounted && user != null) {
          //       //   Navigator.pushAndRemoveUntil(
          //       //     context,
          //       //     MaterialPageRoute(
          //       //         builder: (context) => HomePage(
          //       //               user: user,
          //       //             )),
          //       //     (Route<dynamic> route) => false,
          //       //   );
          //       // }
          //     } catch (exception) {
          //       // log(exception.toString());
          //     }
          //   },
          //   child: Text('Login'),
          // )
        ],
      ),
    );
  }
}
