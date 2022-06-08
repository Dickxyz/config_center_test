import 'package:dio/dio.dart';

const BASEURL = "http://localhost:8082";
final OPTIONS = BaseOptions(
  baseUrl: BASEURL,
  followRedirects: true,
);
final dio = Dio(OPTIONS);

String? md5;

Future<String> getConfig(String tenant, config) async {
  final res = await dio
      .get("/$tenant/$config/listen", queryParameters: {"md5": md5});
  md5 = res.data["md5"];
  print(res.data);
  return res.data["content"];
}
