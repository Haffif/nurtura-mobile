// main.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nurtura/provider/detect_provider.dart';
import 'package:nurtura/provider/irrigation_provider.dart';
import 'package:nurtura/provider/lahan_provider.dart';
import 'package:nurtura/provider/pemupukan_provider.dart';
import 'package:nurtura/provider/penanaman_provider.dart';
import 'package:nurtura/provider/sensor_provider.dart';
import 'package:nurtura/repository/detect_repository.dart';
import 'package:nurtura/repository/irrigation_repository.dart';
import 'package:nurtura/repository/lahan_repository.dart';
import 'package:nurtura/repository/pemupukan_repository.dart';
import 'package:nurtura/repository/penanaman_repository.dart';
import 'package:nurtura/repository/sensor_repository.dart';
import 'package:nurtura/theme/theme.dart';
import 'package:nurtura/view/auth_screen.dart';
import 'package:nurtura/view/login_page.dart';
import 'package:nurtura/view/map_sample.dart';
import 'package:provider/provider.dart';
import 'data/dio/dio_client.dart';
import 'data/dio/logging_interceptor.dart';
import 'provider/auth_provider.dart';
import 'repository/auth_repository.dart';

void main() {
  final Dio dio = Dio();
  final DioClient dioClient = DioClient(
    'http://103.183.75.231',
    dio,
    loggingInterceptor: LoggingInterceptor(),
  );
  final AuthRepository authRepository = AuthRepository(dioClient: dioClient);
  final LahanRepository lahanRepository = LahanRepository(dioClient: dioClient);
  final SensorRepository sensorRepository = SensorRepository(dioClient: dioClient);
  final PenanamanRepository penanamanRepository = PenanamanRepository(dioClient: dioClient);
  final DetectRepository detectRepository = DetectRepository(dioClient: dioClient);
  final PemupukanRepository pemupukanRepository = PemupukanRepository(dioClient: dioClient);
  final IrrigationRepository irrigationRepository = IrrigationRepository(dioClient: dioClient);

  runApp(MyApp(
    authRepository: authRepository,
    lahanRepository: lahanRepository,
    sensorRepository: sensorRepository,
    penanamanRepository: penanamanRepository,
    detectRepository: detectRepository,
    pemupukanRepository: pemupukanRepository,
    irrigationRepository: irrigationRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final LahanRepository lahanRepository;
  final SensorRepository sensorRepository;
  final PenanamanRepository penanamanRepository;
  final DetectRepository detectRepository;
  final PemupukanRepository pemupukanRepository;
  final IrrigationRepository irrigationRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.lahanRepository,
    required this.sensorRepository,
    required this.penanamanRepository,
    required this.detectRepository,
    required this.pemupukanRepository,
    required this.irrigationRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository: authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => LahanProvider(lahanRepository: lahanRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => SensorProvider(sensorRepository: sensorRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => PenanamanProvider(penanamanRepository: penanamanRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => DetectProvider(detectRepository: detectRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => PemupukanProvider(pemupukanRepository: pemupukanRepository),
        ),
        ChangeNotifierProvider(
            create: (_) => IrrigationProvider(irrigationRepository: irrigationRepository)),
      ],
      child: MaterialApp(
        home: const AuthPage(),
        theme: AppTheme.projectTheme,
      ),
    );
  }
}
