import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart';

class SecurityHelper {
  // ignore: constant_identifier_names
  static const String STORAGE_PUBLICKEY = 'p-u-b-l-1-c-k-3-y-s-t-0-r-4-g-3';

  // ignore: constant_identifier_names
  static const String COOKIE_HEADER = "cookieHeader";

  Function? threatCallback;

  set setThreatCallback(Function cb) {
    threatCallback = cb;
  }



  static String encrypt(String plain, String key) {
    BigInt modulus = BigInt.parse(key, radix: 16);
    BigInt exponent = BigInt.parse("10001", radix: 16);
    RSAPublicKey pubKey = RSAPublicKey(modulus, exponent);
    AsymmetricKeyParameter<RSAPublicKey> params = PublicKeyParameter(pubKey);
    AsymmetricBlockCipher cipher = PKCS1Encoding(RSAEngine())
      ..init(true, params);
    Uint8List plainText = Uint8List.fromList(plain.codeUnits);
    Uint8List encryptText = cipher.process(plainText);
    return base64Encode(encryptText);
  }

  static Future<String?> encryptv2(String plain) async {
    String? key = await readPublicKey();
    if (key == null) {
      return null;
    }
    BigInt modulus = BigInt.parse(key, radix: 16);
    BigInt exponent = BigInt.parse("10001", radix: 16);
    RSAPublicKey pubKey = RSAPublicKey(modulus, exponent);
    AsymmetricKeyParameter<RSAPublicKey> params = PublicKeyParameter(pubKey);
    AsymmetricBlockCipher cipher = PKCS1Encoding(RSAEngine())
      ..init(true, params);
    Uint8List plainText = Uint8List.fromList(plain.codeUnits);
    Uint8List encryptText = cipher.process(plainText);
    return base64Encode(encryptText);
  }

  static void savePublicKey(String? key) {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    storage
        .write(key: STORAGE_PUBLICKEY, value: key)
        .onError((error, stackTrace) {
      if (kDebugMode) {
        print('_savePublicKey onError = $error');
      }
    }).whenComplete(() {
      if (kDebugMode) {
        //print('_savePublicKey Completed');
      }
    });
  }

  static Future<String?> readPublicKey() async {
    String? retValue;
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.read(key: STORAGE_PUBLICKEY).then((value) {
      retValue = value;
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('_readPublicKey onError = $error');
      }
    }).whenComplete(() {
      if (kDebugMode) {
        //print('_readPublicKey Completed');
      }
    });

    return retValue;
  }

  static void saveCookie(String? cookie) {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    storage
        .write(key: COOKIE_HEADER, value: cookie)
        .onError((error, stackTrace) {
      if (kDebugMode) {
        print('_saveCookie onError = $error');
      }
    }).whenComplete(() {
      if (kDebugMode) {
        //print('_savePublicKey Completed');
      }
    });
  }

  static Future<String?> readCookie() async {
    String? retValue;
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.read(key: COOKIE_HEADER).then((value) {
      retValue = value;
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('_readCookie onError = $error');
      }
    }).whenComplete(() {
      if (kDebugMode) {
        //print('_readPublicKey Completed');
      }
    });

    return retValue;
  }

  String decryptCCM(String ciphertextBase64, String password) {
    final ciphertextBytes = base64.decode(ciphertextBase64);
    final passwordBytes = Uint8List.fromList(utf8.encode(password));

    // Extract salt from combined data
    final salt = ciphertextBytes.sublist(ciphertextBytes.length - 16);
    final encryptedData = ciphertextBytes.sublist(0, ciphertextBytes.length - 16);

    // Derive key using PBKDF2
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    final params = Pbkdf2Parameters(salt, 1000, 32);
    pbkdf2.init(params);
    final key = pbkdf2.process(passwordBytes);

    // Extract IV from combined data
    final iv = encryptedData.sublist(encryptedData.length - 12);
    final encryptedText = encryptedData.sublist(0, encryptedData.length - 12);

    // Decrypt using AES in CCM mode
    final aesEngine = AESEngine();
    final ccm = CCMBlockCipher(aesEngine);
    final parameters = AEADParameters(KeyParameter(key), 16 * 8, iv, Uint8List(0));
    ccm.init(false, parameters);
    final decrypted = ccm.process(encryptedText);

    // Return plaintext
    return utf8.decode(decrypted);
  }

  String hmacSha256Signature(String message, String key) {
    var hmacSha256 = Hmac(sha256, utf8.encode(key)); 
    var bytes = hmacSha256.convert(utf8.encode(message)).bytes;
    return base64Encode(bytes);
  }


  static String openString(String stringToOpen) {

      String c8a2e0d414e44d89eff1849bb9b3998b0cf7bdb9 =
          const String.fromEnvironment(
              'c8a2e0d414e44d89eff1849bb9b3998b0cf7bdb9');

      String d1ff17be98cd6f96758d7dcd6e13ec4864f10b7d =
          SecurityHelper().decryptCCM(
              const String.fromEnvironment(
                  'd1ff17be98cd6f96758d7dcd6e13ec4864f10b7d'),
              c8a2e0d414e44d89eff1849bb9b3998b0cf7bdb9);

      return
          SecurityHelper().decryptCCM(
              stringToOpen,
              d1ff17be98cd6f96758d7dcd6e13ec4864f10b7d);
  }


}
