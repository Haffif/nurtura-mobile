// ignore_for_file: avoid_print, import_of_legacy_library_into_null_safe

import 'package:dio/dio.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 200;
}
