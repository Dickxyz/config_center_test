import 'dart:async';

import 'package:config_center_test/requests.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
        debugLogDiagnostics: true,
        initialLocation: "/err",
        routes: <GoRoute>[
          GoRoute(
              path: '/err',
              builder: (BuildContext context, GoRouterState state) {
                return Text("请转到/detail?tenant=xxx&config=xxx");
              }),
          GoRoute(
              path: '/detail',
              builder: (BuildContext context, GoRouterState state) {
                final tenant = state.queryParams['tenant'];
                final config = state.queryParams["config"];

                return MyHomePage(tenant: tenant!, config: config!);
              }),
        ],
        redirect: (state) {
          if (state.subloc.startsWith("/detail")) {
            final tenant = state.queryParams['tenant'];
            if (tenant == null) {
              return "/err";
            }
            final config = state.queryParams["config"];
            if (config == null) {
              return "/err";
            }
          }
        });
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: "config_center_test",
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.tenant, required this.config})
      : super(key: key);

  final String tenant, config;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String content = "";

  void startTimer() {
    md5 = null;

    Timer.periodic(const Duration(seconds: 3), (timer) async {
      final String res = await getConfig(widget.tenant, widget.config);
      setState(() {
        content = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    startTimer();
    return Scaffold(
      appBar: AppBar(
        title: Text("配置中心测试"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              content,
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
