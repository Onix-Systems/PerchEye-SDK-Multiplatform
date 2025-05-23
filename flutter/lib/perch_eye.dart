import 'dart:typed_data';

import 'package:flutter/services.dart';

class PerchEye {
  static const MethodChannel _channel = MethodChannel('perch_eye_method_channel');

  static Future<void> init() => _channel.invokeMethod('init');

  static Future<void> destroy() => _channel.invokeMethod('destroy');

  static Future<void> openTransaction() => _channel.invokeMethod('openTransaction');

  static Future<String> addImage(String base64) async {
    final result = await _channel.invokeMethod('addImage', {'img': base64});
    return result;
  }

  static Future<String> addImageRaw(Uint8List rgba, int width, int height) async {
    final result = await _channel.invokeMethod('addImageRaw', {
      'pixels': rgba,
      'width': width,
      'height': height,
    });
    return result;
  }

  static Future<String> enroll() async {
    final hash = await _channel.invokeMethod('enroll');
    return hash as String;
  }

  static Future<double> verify(String hash) async {
    final sim = await _channel.invokeMethod('verify', {'hash': hash});
    return sim;
  }

  static Future<String> evaluate(List<String> base64Images) async {
    final hash = await _channel.invokeMethod('evaluate', {'images': base64Images});
    return hash;
  }

  static Future<double> compareList(List<String> base64Images, String hash) async {
    final sim = await _channel.invokeMethod('compareList', {
      'images': base64Images,
      'hash': hash,
    });
    return sim;
  }

  static Future<double> compareFaces(String base64_1, String base64_2) async {
    final sim = await _channel.invokeMethod('compareFaces', {
      'img1': base64_1,
      'img2': base64_2,
    });
    return sim;
  }

  static Future<List<String>> addImagesWithLogging(List<String> base64Images) async {
    final successful = <String>[];

    for (int i = 0; i < base64Images.length; i++) {
      final result = await _channel.invokeMethod<String>('addImage', {'img': base64Images[i]});
      print('addImage[$i] = $result');
      if (result == 'SUCCESS') {
        successful.add(base64Images[i]);
      }
    }

    return successful;
  }
}