import 'package:hive/hive.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CredentialService {
  static const String _credentialsBox = 'credentialsBox';
  static const String _credentialKey = 'googleUser';

  // Store credential
  static Future<void> storeCredential(GoogleSignInAccount user) async {
    final box = Hive.box(_credentialsBox);
    await box.put(_credentialKey, {
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'id': user.id,
    });
  }

  // Get credential
  static Map<String, dynamic>? getCredential() {
    final box = Hive.box(_credentialsBox);
    return box.get(_credentialKey);
  }

  // Clear credential
  static Future<void> clearCredential() async {
    final box = Hive.box(_credentialsBox);
    await box.delete(_credentialKey);
  }
}
