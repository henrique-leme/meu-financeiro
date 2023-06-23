import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with AutomaticKeepAliveClientMixin<ReportsPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    log('disposed');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    log('init');
    timer;
  }

  Timer timer = Timer(const Duration(seconds: 2), () => log('finished'));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Scaffold(
      body: Center(
        child: Text('Stats'),
      ),
    );
  }
}
