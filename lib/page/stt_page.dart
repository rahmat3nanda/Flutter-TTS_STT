import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:proto_bm2/common/constants.dart';
import 'package:proto_bm2/common/constants/sound.dart';
import 'package:proto_bm2/tool/helper.dart';
import 'package:proto_bm2/widget/app_bar_widget.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttPage extends StatefulWidget {
  const SttPage({Key? key}) : super(key: key);

  @override
  State<SttPage> createState() => _SttPageState();
}

class _SttPageState extends State<SttPage> {
  late AudioPlayer _player;
  late SpeechToText _stt;
  late String _transcript;
  late bool _hasInit;
  late bool _onListening;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _stt = SpeechToText();
    _transcript = "";
    _hasInit = false;
    _onListening = false;
    _initStt();
  }

  void _initStt() async {
    _player.play(AssetSource(AppSound.get.init));
    await _stt.initialize(onError: (_) {
      _player.play(AssetSource(AppSound.get.initFailure));
    });
    setState(() {
      _hasInit = true;
    });
    _player.play(AssetSource(AppSound.get.initSuccess));
  }

  void _onButtonTapped() {
    if (!_hasInit) return;
    if (_onListening) {
      _stop();
    } else {
      _record();
    }
  }

  void _record() async {
    _stt.errorListener = _onErrorRecognizing;
    setState(() {
      _transcript = "";
      _onListening = true;
    });
    await _player.play(AssetSource(AppSound.get.listenStart));
    Duration d = await _player.getDuration() ?? Duration.zero;
    await Future.delayed(d);
    _stt.listen(
      localeId: "in_ID",
      onResult: _onResultRecognizing,
      cancelOnError: true,
      partialResults: false,
    );
  }

  void _stop() async {
    await _stt.stop();
    setState(() {
      _onListening = false;
    });
    _player.play(AssetSource(AppSound.get.listenStop));
  }

  void _onErrorRecognizing(SpeechRecognitionError error) async {
    setState(() {
      _onListening = false;
    });
    _player.play(AssetSource(AppSound.get.transcriptFailure));
  }

  void _onResultRecognizing(SpeechRecognitionResult result) async {
    setState(() {
      _transcript = result.recognizedWords;
      _onListening = false;
    });
    await _player.play(AssetSource(AppSound.get.listenStop));
    Duration d1 = await _player.getDuration() ?? Duration.zero;
    await Future.delayed(d1);
    await _player.play(AssetSource(AppSound.get.transcriptSuccess));
    Duration d2 = await _player.getDuration() ?? Duration.zero;
    await Future.delayed(d2);
    await _player.play(AssetSource(AppSound.get.textCopyQuestion));
    Duration d3 = await _player.getDuration() ?? Duration.zero;
    await Future.delayed(d3);
    _stt.errorListener = _onErrorCopy;
    _stt.listen(
      localeId: "in_ID",
      onResult: _onResultCopy,
      cancelOnError: true,
      partialResults: false,
    );
  }

  void _onResultCopy(SpeechRecognitionResult result) {
    String answer = result.recognizedWords;
    if ((answer.contains("yes") || answer.contains("ya")) &&
        (!answer.contains("tidak") || !answer.contains("no"))) {
      Helper().copyClipboard(_transcript, onCopied: () {
        _player.play(AssetSource(AppSound.get.textCopied));
      });
    } else {
      _player.play(AssetSource(AppSound.get.textNotCopied));
    }
  }

  void _onErrorCopy(SpeechRecognitionError error) {
    _player.play(AssetSource(AppSound.get.textNotCopied));
  }

  @override
  void dispose() {
    _player.dispose();
    _stt.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppString.get.stt,
        subTitle: AppString.get.appName,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _mainView(),
      ),
    );
  }

  Widget _mainView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: Text(_transcript),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: MaterialButton(
            color: _hasInit ? Colors.red : Colors.grey,
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () async {
              bool canVibrate = await Vibrate.canVibrate;
              if (canVibrate) {
                await Vibrate.vibrate();
              }
              _onButtonTapped();
            },
            child: Icon(
              _onListening ? Icons.stop : Icons.fiber_manual_record,
              color: Colors.white,
              size: 64,
            ),
          ),
        ),
      ],
    );
  }
}
