import 'package:flutter/material.dart';
import 'package:proto_bm2/common/constants.dart';
import 'package:proto_bm2/model/app/singleton_model.dart';
import 'package:proto_bm2/page/stt_page.dart';
import 'package:proto_bm2/tool/helper.dart';
import 'package:proto_bm2/widget/app_bar_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Helper _helper;

  @override
  void initState() {
    super.initState();
    SingletonModel.withContext(context);
    _helper = Helper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppString.get.appName,
        subTitle: "${AppString.get.tts} & ${AppString.get.stt}",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buttonView(
              text: AppString.get.tts,
              onTap: () => _helper.showSnackBar(context, text: "On Going!"),
            ),
            const SizedBox(height: 16),
            _buttonView(
              text: AppString.get.stt,
              onTap: () => _helper.jumpToPage(context, page: const SttPage()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonView({required String text, required Function() onTap}) {
    return MaterialButton(
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: onTap,
      child: Text(text),
    );
  }
}
