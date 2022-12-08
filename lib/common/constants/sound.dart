class AppSound {
  static AppSound? _appString;

  factory AppSound() => _appString ?? AppSound._internal();

  AppSound._internal();

  static AppSound get get => _appString ?? AppSound._internal();

  String init = _getSoundPathExt("init");
  String initSuccess = _getSoundPathExt("init_success");
  String initFailure = _getSoundPathExt("init_failure");
  String listenStart = _getSoundPathExt("listen_start");
  String listenStop = _getSoundPathExt("listen_stop");
  String textCopied = _getSoundPathExt("text_copied");
  String textCopyQuestion = _getSoundPathExt("text_copy_question");
  String textNotCopied = _getSoundPathExt("text_not_copied");
  String transcriptFailure = _getSoundPathExt("transcript_failure");
  String transcriptSuccess = _getSoundPathExt("transcript_success");
}

String _getSoundPathExt(String name) => "sound/$name.mp3";