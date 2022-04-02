class LanguageData {
  final String flag;
  final String name;
  final String languageCode;

  LanguageData(this.flag, this.name, this.languageCode);

  static List<LanguageData> languageList() {
    return <LanguageData>[
      LanguageData("🇺🇸", "English", 'en'), //English (en)
      //LanguageData("🇸🇦", "عربى", 'ar'), //Arabic (ar)
      //LanguageData("🇨🇳", "中国人", 'zh'), //Chinese (zh)
      //LanguageData("🇺🇸", "English", 'en'), //English (en)
      //LanguageData("🇫🇷", "français", 'fr'), //French (fr)
      //LanguageData("🇩🇪", "Deutsche", 'de'), //German (de)
      //LanguageData("🇮🇳", "हिंदी", 'hi'), //Hindi (hi)
      //LanguageData("🇯🇵", "日本", 'ja'), //Japanese (ja)
      //LanguageData("🇵🇹", "português", 'pt'), //Portuguese (pt)
      //LanguageData("🇷🇺", "русский", 'ru'), //Russian (ru)
      //LanguageData("🇪🇸", "Español", 'es'), //Spanish (es)
      //LanguageData("🇵🇰", "اردو", "ur"), //Urdu (ur)
      //LanguageData("🇻🇳", "Tiếng Việt", 'vi'), //Vietnamese (vi)
    ];
  }
}
