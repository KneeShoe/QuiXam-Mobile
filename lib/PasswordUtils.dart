import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '';

class PasswordUtils{
    final Random _RANDOM = new Random.secure();
    final String _ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    final int _ITERATIONS = 10000;
    final int _KEY_LENGTH = 256;

    String getSalt(int length) {
      String returnValue;
      for (int i = 0; i < length; i++) {
        returnValue= returnValue+ _ALPHABET[(_RANDOM.nextInt(_ALPHABET.length))];
      }
    }

    List hash(String password){
      String salt = getSalt(128);
      var saltedPassword = salt + password;
      var bytes = utf8.encode(saltedPassword);
      var hash = sha256.convert(bytes);
      return [hash, salt];
    }

}