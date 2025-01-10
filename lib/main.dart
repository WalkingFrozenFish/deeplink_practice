import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("ЭЦП"),
          elevation: 5,
        ),
        body: const Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Some content"),
              DynamicLinkBuilder(
                link: "https://flutter.dev",
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DynamicLinkBuilder extends StatefulWidget {
  const DynamicLinkBuilder({super.key, required this.link});

  final String link;

  @override
  State<DynamicLinkBuilder> createState() => _DynamicLinkBuilderState();
}

class _DynamicLinkBuilderState extends State<DynamicLinkBuilder> {
  final String _urlPrefix = "https://mgovsign.page.link";
  final String _urlParam = "?link=";
  final String _androidRedirectParams = "&apn=kz.mobile.mgov";
  final String _iosRedirectParams = "&isi=1476128386&ibi=kz.egov.mobile";
  late String _encodedLink = widget.link;
  String _finalLink = "";

  @override
  void initState() {
    super.initState();
    _encodeUrlParams(widget.link);
    _createFinalLink();
  }

  void _encodeUrlParams(String link) {
    _encodedLink = link
        .replaceAll("&", "%26")
        .replaceAll("=", "%3D")
        .replaceAll("?", "%3F");

    setState(() {});
  }

  void _createFinalLink() {
    // TODO сделать ссылку в зависимости от платформы пользователя
    _finalLink = _urlPrefix + _urlParam + _encodedLink + _androidRedirectParams;
    setState(() {});
  }

  void _openDeepLink() async {
    final Uri uri = Uri.parse(_finalLink);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
        final response = await Dio().get(uri.toString());
        print(response);
    } else {
      print('Не удалось открыть ссылку');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _openDeepLink(),
      child: const Text("Link"),
    );
  }
}
