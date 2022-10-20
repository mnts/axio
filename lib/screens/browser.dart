import 'package:flutter/material.dart';
import 'package:flutter_macos_webview/flutter_macos_webview.dart';
import 'package:dropdown_search/dropdown_search.dart';

class BrowserScreen extends StatefulWidget {
  BrowserScreen({Key? key}) : super(key: key);

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  @override
  void initState() {
    //initWeb();
    super.initState();
  }

  /*
  Future<void> initWeb() async {
    final url = "https://www.google.com";
    final view = Webview(true)
        .setTitle("title")
        .setSize(1280, 800, SizeHint.none)
        .navigate(url)
        .run();

    view.
  }
  */

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
