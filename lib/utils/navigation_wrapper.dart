import 'package:flutter/material.dart';
import 'package:nurtura_grow/screens/dashboard_screens.dart';
import 'package:nurtura_grow/screens/detection_screens.dart';
import 'package:nurtura_grow/screens/feature_screens.dart';
import 'package:nurtura_grow/screens/history_screens.dart';

class DashboardScreenWrapper extends StatelessWidget {
  final Function refresh;

  const DashboardScreenWrapper({required this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        refresh();
        return true;
      },
      child: const DashboardScreens(),
    );
  }
}

class FeatureScreenWrapper extends StatelessWidget {
  final Function refresh;

  const FeatureScreenWrapper({required this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        refresh();
        return true;
      },
      child: const FeatureScreen(),
    );
  }
}

class DetectionScreenWrapper extends StatelessWidget {
  final Function refresh;

  const DetectionScreenWrapper({required this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        refresh();
        return true;
      },
      child: const DetectionScreen(),
    );
  }
}

class HistoryScreenWrapper extends StatelessWidget {
  final Function refresh;

  const HistoryScreenWrapper({required this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        refresh();
        return true;
      },
      child: const HistoryScreen(),
    );
  }
}
