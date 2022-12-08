class AppString {
  static AppString? _appString;

  factory AppString() => _appString ?? AppString._internal();

  AppString._internal();

  static AppString get get => _appString ?? AppString._internal();

  String appName = "Proto BM2";
  String tts = "Text to Speech";
  String stt = "Speech to Text";
}
