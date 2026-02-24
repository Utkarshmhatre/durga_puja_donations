// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'दुर्गा पूजा दान';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get close => 'बंद करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get ok => 'ठीक है';

  @override
  String get add => 'जोड़ें';

  @override
  String get edit => 'संपादित करें';

  @override
  String get enabled => 'सक्षम';

  @override
  String get disabled => 'अक्षम';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get verify => 'सत्यापित करें';

  @override
  String get categoryAll => 'सभी';

  @override
  String get categoryReligious => 'धार्मिक';

  @override
  String get categoryCultural => 'सांस्कृतिक';

  @override
  String get categoryService => 'सेवा';

  @override
  String get categoryCelebration => 'उत्सव';

  @override
  String get categoryCommunity => 'समुदाय';

  @override
  String get categoryIdols => 'मूर्तियां';

  @override
  String get categoryGeneral => 'सामान्य';

  @override
  String get locationTbd => 'स्थान निर्धारित नहीं';

  @override
  String get pastBadge => 'बीता हुआ';

  @override
  String get noEventsFound => 'कोई कार्यक्रम नहीं मिला';

  @override
  String get splashTitle => 'दुर्गा पूजा';

  @override
  String get splashYear => '2026';

  @override
  String get splashBlessingBengali => '॥ शुभ दुर्गा पूजा ॥';

  @override
  String get splashLoading => 'लोड हो रहा है...';

  @override
  String get homeWelcomeTo => 'स्वागत है';

  @override
  String get homeTitle => 'दुर्गा पूजा 2026';

  @override
  String get homeSubtitle => 'दिव्य उत्सव में हमारे साथ जुड़ें';

  @override
  String get homeQuickActions => 'त्वरित कार्य';

  @override
  String get homeStatDonations => 'दान';

  @override
  String get homeStatCollected => 'एकत्रित';

  @override
  String get homeStatEvents => 'कार्यक्रम';

  @override
  String get homeUpcomingEvents => 'आगामी कार्यक्रम';

  @override
  String get homeViewAll => 'सभी देखें';

  @override
  String get homeNoUpcomingEvents => 'कोई आगामी कार्यक्रम नहीं';

  @override
  String get homeLearnAbout => 'दुर्गा पूजा के\nबारे में जानें';

  @override
  String get homeDiscoverHistory => 'इतिहास और परंपराएं जानें';

  @override
  String get homeDonate => 'दान करें';

  @override
  String get homeDrawerTitle => 'दुर्गा पूजा';

  @override
  String get homeDrawerSubtitle => 'दान और उत्सव';

  @override
  String get homeDrawerHome => 'होम';

  @override
  String get homeDrawerDonate => 'दान करें';

  @override
  String get homeDrawerEvents => 'कार्यक्रम';

  @override
  String get homeDrawerGallery => 'गैलरी';

  @override
  String get homeDrawerTrivia => 'क्विज़';

  @override
  String get homeDrawerPlaylist => 'प्लेलिस्ट';

  @override
  String get homeDrawerAbout => 'परिचय';

  @override
  String get homeDrawerSettings => 'सेटिंग्स';

  @override
  String get homeDrawerAdmin => 'व्यवस्थापक';

  @override
  String get homeCopyright => '© 2026 दुर्गा पूजा समिति';

  @override
  String get homeFeatureComingSoon => 'जल्द आ रहा है';

  @override
  String get homeInvalidEventData => 'अमान्य कार्यक्रम डेटा';

  @override
  String get homeUntitledEvent => 'बिना शीर्षक कार्यक्रम';

  @override
  String get homeFeatureDonate => 'दान करें';

  @override
  String get homeFeatureDonateSubtitle => 'उत्सव का समर्थन करें';

  @override
  String get homeFeatureGallery => 'गैलरी';

  @override
  String get homeFeatureGallerySubtitle => 'यादें देखें';

  @override
  String get homeFeatureEvents => 'कार्यक्रम';

  @override
  String get homeFeatureEventsSubtitle => 'आगामी उत्सव';

  @override
  String get homeFeatureTrivia => 'क्विज़';

  @override
  String get homeFeatureTriviaSubtitle => 'अपना ज्ञान परखें';

  @override
  String get donationPageTitle => 'दान करें';

  @override
  String get donationFullName => 'पूरा नाम *';

  @override
  String get donationNameValidation => 'कृपया अपना नाम दर्ज करें';

  @override
  String get donationLocation => 'स्थान *';

  @override
  String get donationLocationValidation => 'कृपया अपना स्थान दर्ज करें';

  @override
  String get donationPhone => 'फोन (वैकल्पिक)';

  @override
  String get donationEmail => 'ईमेल (वैकल्पिक)';

  @override
  String get donationChooseAmount => 'दान राशि चुनें';

  @override
  String get donationCustomAmount => 'कस्टम राशि';

  @override
  String get donationDonate => 'दान करें';

  @override
  String get donationFillNameLocation => 'कृपया अपना नाम और स्थान भरें';

  @override
  String get donationPaymentSuccessful => 'भुगतान सफल!';

  @override
  String donationPaymentStatus(String status) {
    return 'भुगतान $status';
  }

  @override
  String get donationThankYou => 'धन्यवाद!';

  @override
  String donationReceived(int amount) {
    return 'आपका ₹$amount का दान प्राप्त हुआ।';
  }

  @override
  String donationDonateAmount(int amount) {
    return '₹$amount दान करें';
  }

  @override
  String get donationEnterValidAmount => 'एक मान्य राशि दर्ज करें';

  @override
  String donationRsAmount(int amount) {
    return '₹$amount';
  }

  @override
  String get eventsPageTitle => 'कार्यक्रम';

  @override
  String eventsUpcomingCount(int count) {
    return '$count आगामी';
  }

  @override
  String get galleryPageTitle => 'गैलरी';

  @override
  String galleryPhotosCount(int count) {
    return '$count फोटो';
  }

  @override
  String get galleryNoCategoryPhotos => 'इस श्रेणी में कोई फोटो नहीं';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsAppearance => 'रूप';

  @override
  String get settingsDarkTheme => 'डार्क थीम (महाकाली रात्रि)';

  @override
  String get settingsReducedMotion => 'कम एनिमेशन';

  @override
  String get settingsReducedMotionSubtitle =>
      'कमजोर उपकरणों पर एनिमेशन कम करें';

  @override
  String get settingsSecurity => 'सुरक्षा';

  @override
  String get settingsBiometricLogin => 'बायोमेट्रिक लॉगिन';

  @override
  String get settingsBiometricSubtitle =>
      'व्यवस्थापक लॉगिन के लिए फिंगरप्रिंट/फेस प्रमाणीकरण';

  @override
  String get settingsPinLogin => 'PIN लॉगिन';

  @override
  String get settingsPinSubtitleActive =>
      'व्यवस्थापक त्वरित लॉगिन के लिए PIN उपयोग करें';

  @override
  String get settingsPinSubtitleSetFirst => 'पहले 4-अंकीय PIN सेट करें';

  @override
  String get settingsChangePin => 'PIN बदलें';

  @override
  String get settingsChangePinSubtitle =>
      'अपना व्यवस्थापक त्वरित-लॉगिन PIN सेट या अपडेट करें';

  @override
  String get settingsDisablePin => 'PIN अक्षम करें';

  @override
  String get settingsDisablePinSubtitle =>
      'संग्रहित PIN हटाएं और PIN लॉगिन बंद करें';

  @override
  String get settingsPinUpdated => 'PIN अपडेट हो गया';

  @override
  String get settingsPinRemoved => 'PIN हटा दिया गया';

  @override
  String get settingsSetPin => '4-अंकीय PIN सेट करें';

  @override
  String get settingsEnterNewPin => 'नया 4-अंकीय PIN दर्ज करें';

  @override
  String get settingsPinHint => 'PIN';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsLanguageSubtitle => 'अपनी पसंदीदा भाषा चुनें';

  @override
  String get triviaAppBarTitle => 'क्विज़';

  @override
  String get triviaHintDialogTitle => 'संकेत';

  @override
  String get triviaSubmitAnswer => 'उत्तर सबमिट करें';

  @override
  String get triviaShowHint => 'संकेत देखें';

  @override
  String get triviaCorrect => 'सही!';

  @override
  String get triviaRestartQuiz => 'क्विज़ पुनः आरंभ करें';

  @override
  String triviaWrongAnswer(String answer) {
    return 'गलत! सही उत्तर है $answer';
  }

  @override
  String triviaScoreResult(int score, int total) {
    return 'आपने $total में से $score अंक प्राप्त किए';
  }

  @override
  String triviaScoreDisplay(int score, int total) {
    return '$score/$total';
  }

  @override
  String get triviaQ1Question => 'दुर्गा पूजा में किस देवी की पूजा की जाती है?';

  @override
  String get triviaQ1Option1 => 'लक्ष्मी';

  @override
  String get triviaQ1Option2 => 'सरस्वती';

  @override
  String get triviaQ1Option3 => 'दुर्गा';

  @override
  String get triviaQ1Option4 => 'काली';

  @override
  String get triviaQ1Answer => 'दुर्गा';

  @override
  String get triviaQ1Hint => 'वह योद्धा देवी हैं।';

  @override
  String get triviaQ2Question => 'दुर्गा पूजा कितने दिन तक चलती है?';

  @override
  String get triviaQ2Option1 => '5';

  @override
  String get triviaQ2Option2 => '7';

  @override
  String get triviaQ2Option3 => '9';

  @override
  String get triviaQ2Option4 => '10';

  @override
  String get triviaQ2Answer => '5';

  @override
  String get triviaQ2Hint =>
      'यह आमतौर पर महालया से शुरू होती है और दशमी पर समाप्त होती है।';

  @override
  String get triviaQ3Question =>
      'कौन सा शहर सबसे बड़े दुर्गा पूजा उत्सव के लिए प्रसिद्ध है?';

  @override
  String get triviaQ3Option1 => 'कोलकाता';

  @override
  String get triviaQ3Option2 => 'मुंबई';

  @override
  String get triviaQ3Option3 => 'दिल्ली';

  @override
  String get triviaQ3Option4 => 'चेन्नई';

  @override
  String get triviaQ3Answer => 'कोलकाता';

  @override
  String get triviaQ3Hint =>
      'इसे भारत की सांस्कृतिक राजधानी के रूप में जाना जाता है।';

  @override
  String get triviaQ4Question =>
      'भारत में दुर्गा पूजा के बाद कौन सा त्योहार आता है?';

  @override
  String get triviaQ4Option1 => 'दिवाली';

  @override
  String get triviaQ4Option2 => 'होली';

  @override
  String get triviaQ4Option3 => 'ईद';

  @override
  String get triviaQ4Option4 => 'क्रिसमस';

  @override
  String get triviaQ4Answer => 'दिवाली';

  @override
  String get triviaQ4Hint => 'यह दीपों का त्योहार है।';

  @override
  String get triviaQ5Question => 'दुर्गा पूजा का विसर्जन किस दिन होता है?';

  @override
  String get triviaQ5Option1 => 'महा अष्टमी';

  @override
  String get triviaQ5Option2 => 'महा नवमी';

  @override
  String get triviaQ5Option3 => 'विजया दशमी';

  @override
  String get triviaQ5Option4 => 'महा सप्तमी';

  @override
  String get triviaQ5Answer => 'विजया दशमी';

  @override
  String get triviaQ5Hint => 'यह पूजा के अंत का प्रतीक है।';

  @override
  String get triviaQ6Question =>
      'दुर्गा पूजा में पारंपरिक रूप से कौन सा रंग पहना जाता है?';

  @override
  String get triviaQ6Option1 => 'लाल';

  @override
  String get triviaQ6Option2 => 'नीला';

  @override
  String get triviaQ6Option3 => 'हरा';

  @override
  String get triviaQ6Option4 => 'पीला';

  @override
  String get triviaQ6Answer => 'लाल';

  @override
  String get triviaQ6Hint => 'यह जुनून और ऊर्जा का प्रतीक है।';

  @override
  String get triviaQ7Question =>
      'दुर्गा पूजा में दस भुजाओं वाली देवी का नाम क्या है?';

  @override
  String get triviaQ7Option1 => 'सीता';

  @override
  String get triviaQ7Option2 => 'दुर्गा';

  @override
  String get triviaQ7Option3 => 'राधा';

  @override
  String get triviaQ7Option4 => 'पार्वती';

  @override
  String get triviaQ7Answer => 'दुर्गा';

  @override
  String get triviaQ7Hint => 'वह प्रत्येक हाथ में एक हथियार धारण करती हैं।';

  @override
  String get triviaQ8Question => 'दुर्गा पूजा में कौन सा फूल शुभ माना जाता है?';

  @override
  String get triviaQ8Option1 => 'गुलाब';

  @override
  String get triviaQ8Option2 => 'गेंदा';

  @override
  String get triviaQ8Option3 => 'कमल';

  @override
  String get triviaQ8Option4 => 'चमेली';

  @override
  String get triviaQ8Answer => 'गेंदा';

  @override
  String get triviaQ8Hint => 'यह पीले या नारंगी रंग का है।';

  @override
  String get triviaQ9Question =>
      'दुर्गा पूजा में दुर्गा के सिंह का नाम क्या है?';

  @override
  String get triviaQ9Option1 => 'सिंह';

  @override
  String get triviaQ9Option2 => 'शिव';

  @override
  String get triviaQ9Option3 => 'नंदी';

  @override
  String get triviaQ9Option4 => 'महिष';

  @override
  String get triviaQ9Answer => 'सिंह';

  @override
  String get triviaQ9Hint => 'इसे जंगल का राजा कहा जाता है।';

  @override
  String get triviaQ10Question => 'दुर्गा पूजा में \"महालया\" का क्या अर्थ है?';

  @override
  String get triviaQ10Option1 => 'नवरात्रि की शुरुआत';

  @override
  String get triviaQ10Option2 => 'दशहरे का अंत';

  @override
  String get triviaQ10Option3 => 'पूजा की तैयारी का आरंभ';

  @override
  String get triviaQ10Option4 => 'उपरोक्त में से कोई नहीं';

  @override
  String get triviaQ10Answer => 'पूजा की तैयारी का आरंभ';

  @override
  String get triviaQ10Hint => 'यह उत्सव की तैयारी की शुरुआत का प्रतीक है।';

  @override
  String get triviaQ11Question =>
      'दुर्गा पूजा की कथा में देवी दुर्गा किस राक्षस को पराजित करती हैं?';

  @override
  String get triviaQ11Option1 => 'रावण';

  @override
  String get triviaQ11Option2 => 'कुम्भकर्ण';

  @override
  String get triviaQ11Option3 => 'महिषासुर';

  @override
  String get triviaQ11Option4 => 'शुम्भ';

  @override
  String get triviaQ11Answer => 'महिषासुर';

  @override
  String get triviaQ11Hint => 'उसे भैंसा राक्षस के रूप में जाना जाता है।';

  @override
  String get triviaQ12Question =>
      'दुर्गा पूजा में \"सिंदूर खेला\" का क्या महत्व है?';

  @override
  String get triviaQ12Option1 => 'यह एक नृत्य अनुष्ठान है।';

  @override
  String get triviaQ12Option2 => 'यह उत्सव की समाप्ति का प्रतीक है।';

  @override
  String get triviaQ12Option3 => 'यह विवाहित महिलाओं की एक रीति है।';

  @override
  String get triviaQ12Option4 => 'यह हथियारों की पूजा है।';

  @override
  String get triviaQ12Answer => 'यह विवाहित महिलाओं की एक रीति है।';

  @override
  String get triviaQ12Hint => 'महिलाएं एक दूसरे को लाल पाउडर लगाती हैं।';

  @override
  String get triviaQ13Question =>
      'कौन सी पारंपरिक मिठाई दुर्गा पूजा से सबसे अधिक जुड़ी है?';

  @override
  String get triviaQ13Option1 => 'गुलाब जामुन';

  @override
  String get triviaQ13Option2 => 'रसगुल्ला';

  @override
  String get triviaQ13Option3 => 'बर्फी';

  @override
  String get triviaQ13Option4 => 'जलेबी';

  @override
  String get triviaQ13Answer => 'रसगुल्ला';

  @override
  String get triviaQ13Hint => 'यह एक गोल, रसीली मिठाई है।';

  @override
  String get triviaQ14Question =>
      'पारंपरिक दुर्गा पूजा समारोह में कौन सा खाद्य पदार्थ बलि दिया जाता है?';

  @override
  String get triviaQ14Option1 => 'खीरा';

  @override
  String get triviaQ14Option2 => 'पेठा';

  @override
  String get triviaQ14Option3 => 'कद्दू';

  @override
  String get triviaQ14Option4 => 'आलू';

  @override
  String get triviaQ14Answer => 'पेठा';

  @override
  String get triviaQ14Hint => 'यह एक लौकी से छोटा होता है।';

  @override
  String get triviaQ15Question =>
      'ग्रेगोरियन कैलेंडर के किस महीने में दुर्गा पूजा ज्यादातर मनाई जाती है?';

  @override
  String get triviaQ15Option1 => 'जनवरी';

  @override
  String get triviaQ15Option2 => 'मार्च';

  @override
  String get triviaQ15Option3 => 'अक्टूबर';

  @override
  String get triviaQ15Option4 => 'दिसंबर';

  @override
  String get triviaQ15Answer => 'अक्टूबर';

  @override
  String get triviaQ15Hint => 'यह आमतौर पर शरद ऋतु के आसपास होता है।';

  @override
  String get playlistPageTitle => 'दुर्गा पूजा वीडियो';

  @override
  String get playlistTapToPlay => 'चलाने के लिए टैप करें';

  @override
  String get playlistHdLabel => 'HD';

  @override
  String get playlistLoadingVideo => 'वीडियो लोड हो रहा है...';

  @override
  String playlistVideoCount(int count) {
    return '$count वीडियो • चलाने के लिए टैप करें';
  }

  @override
  String get videoTitle1 => 'दुर्गा पूजा यूनेस्को विरासत';

  @override
  String get videoDesc1 =>
      'मानवता की अमूर्त सांस्कृतिक विरासत के रूप में दुर्गा पूजा की यूनेस्को मान्यता';

  @override
  String get videoTitle2 => 'दुर्गा पूजा सांस्कृतिक कार्यक्रम';

  @override
  String get videoDesc2 =>
      'पारंपरिक दुर्गा पूजा उत्सव, अनुष्ठान और सांस्कृतिक कार्यक्रम';

  @override
  String get videoTitle3 => 'दुर्गा पूजा पंडाल भ्रमण';

  @override
  String get videoDesc3 =>
      'कोलकाता दुर्गा पूजा के सुंदर पंडाल और सजावट का अनुभव करें';

  @override
  String get videoTitle4 => 'धुनुची नाच';

  @override
  String get videoDesc4 => 'दुर्गा पूजा उत्सव में पारंपरिक धुनुची नृत्य';

  @override
  String get aboutMainTitle =>
      'दुर्गा पूजा: दिव्य शक्ति और सांस्कृतिक विरासत का उत्सव';

  @override
  String get aboutMainDesc =>
      'दुर्गा पूजा, मुख्य रूप से पश्चिम बंगाल में मनाया जाने वाला एक जीवंत और गहराई से निहित त्योहार है, जो आनंदमय उत्सव, आध्यात्मिक चिंतन और सामुदायिक बंधन का समय है। यह त्योहार देवी दुर्गा को श्रद्धांजलि देता है, जो शक्ति, सामर्थ्य और बुराई पर अच्छाई की जीत की प्रतीक हैं।';

  @override
  String get aboutOriginTitle => 'दुर्गा पूजा की उत्पत्ति और इतिहास';

  @override
  String get aboutOriginDesc =>
      'दुर्गा पूजा की जड़ें प्राचीन हिंदू शास्त्रों में मिलती हैं, विशेषकर देवी भागवत पुराण में, जो राक्षस महिषासुर पर देवी दुर्गा की विजय की कथा सुनाता है। माना जाता है कि इस त्योहार की शुरुआत 16वीं शताब्दी में मुगल सम्राट अकबर के शासनकाल में \'डाकेर साज\' (यात्रा करती मूर्तियों) की शुरुआत के साथ हुई।';

  @override
  String get aboutSignificanceTitle => 'देवी दुर्गा का महत्व';

  @override
  String get aboutSignificanceDesc =>
      'देवी दुर्गा, जिन्हें महिषासुरमर्दिनी भी कहा जाता है, परम स्त्री शक्ति, बल और लचीलेपन का प्रतिनिधित्व करती हैं। उन्हें दस भुजाओं में विभिन्न हथियार धारण करते हुए और सिंह पर सवार चित्रित किया गया है, जो उनकी वीरता और शक्ति का प्रतीक है।';

  @override
  String get aboutPreparationTitle => 'तैयारी और उत्सव';

  @override
  String get aboutPreparationDesc =>
      'दुर्गा पूजा की तैयारी हफ्तों पहले शुरू हो जाती है। लोग अपने घरों की सफाई, पंडालों की सजावट और देवी दुर्गा की विस्तृत मूर्तियां बनाने में लग जाते हैं। त्योहार आधिकारिक रूप से \'महालया\' (पूर्वज पूजा) से शुरू होता है और \'विजया दशमी\' (विजय दिवस) पर समाप्त होता है।';

  @override
  String get aboutRitualsTitle => 'अनुष्ठान और रीतिरिवाज';

  @override
  String get aboutRitualsDesc =>
      'दुर्गा पूजा का मूल अनुष्ठान देवी दुर्गा की दैनिक पूजा है, जिसे \'पूजा\' कहा जाता है। इसमें फूल, धूप और प्रसाद (धन्य भोजन) का अर्पण शामिल है। \'आरती\', जिसमें देवता के सामने दीपक लहराए जाते हैं, पूजा का एक आवश्यक हिस्सा है।';

  @override
  String get aboutPandalsTitle => 'दुर्गा पूजा पंडाल और मूर्तियां';

  @override
  String get aboutPandalsDesc =>
      'दुर्गा पूजा पंडाल शहर भर में बनाए गए अस्थायी ढांचे हैं, जो त्योहार के केंद्र बिंदु के रूप में काम करते हैं। स्थानीय कलाकारों की रचनात्मकता और कलात्मकता को प्रदर्शित करते हुए इन्हें रोशनी, फूलों और पारंपरिक कलाकृतियों से भव्य रूप से सजाया जाता है।';

  @override
  String get aboutProcessionsTitle => 'दुर्गा पूजा जुलूस और विसर्जन';

  @override
  String get aboutProcessionsDesc =>
      'त्योहार के अंतिम दिन, देवी दुर्गा की मूर्तियों को संगीत, नृत्य और उल्लसित भीड़ के साथ सड़कों पर भव्य जुलूस में ले जाया जाता है। यह दुर्गा की स्वर्ग लोक वापसी का प्रतीक है। विसर्जन समारोह एक मार्मिक और भावनात्मक आयोजन है जो उत्सव के अंत को चिह्नित करता है।';

  @override
  String get aboutBengaliCultureTitle => 'दुर्गा पूजा और बंगाली संस्कृति';

  @override
  String get aboutBengaliCultureDesc =>
      'दुर्गा पूजा सामुदायिक भावना को बढ़ावा देती है। सभी वर्गों के लोग, अपनी सामाजिक स्थिति या धार्मिक विश्वासों की परवाह किए बिना, इस त्योहार को मनाने के लिए एक साथ आते हैं। यह सामाजिक बंधनों को मजबूत करती है और सद्भाव को बढ़ावा देती है।';

  @override
  String get aboutConclusionTitle =>
      'निष्कर्ष: बुराई पर अच्छाई की जीत का उत्सव';

  @override
  String get aboutConclusionDesc =>
      'दुर्गा पूजा केवल एक धार्मिक त्योहार नहीं है; यह आशा, लचीलेपन और बुराई पर अच्छाई की जीत की एक शक्तिशाली सांस्कृतिक अभिव्यक्ति है। अपने अनुष्ठानों, रीतिरिवाजों और जीवंत उत्सवों के माध्यम से, दुर्गा पूजा शक्ति, धार्मिकता और एकता के मूल्यों को मजबूत करती है।';

  @override
  String get adminPortalTitle => 'व्यवस्थापक पोर्टल';

  @override
  String get adminPortalSubtitle =>
      'दुर्गा पूजा प्रबंधित करने के लिए साइन इन करें';

  @override
  String get adminUsernameLabel => 'उपयोगकर्ता नाम';

  @override
  String get adminPasswordLabel => 'पासवर्ड';

  @override
  String get adminUsernameValidation => 'कृपया उपयोगकर्ता नाम दर्ज करें';

  @override
  String get adminPasswordValidation => 'कृपया पासवर्ड दर्ज करें';

  @override
  String get adminSignIn => 'साइन इन';

  @override
  String get adminDemoCredentials => 'डेमो क्रेडेंशियल';

  @override
  String get adminDemoCredentialsDetail =>
      'उपयोगकर्ता: admin  |  पासवर्ड: admin123';

  @override
  String get adminBackToHome => 'होम पर वापस जाएं';

  @override
  String get adminBiometricUnavailable =>
      'बायोमेट्रिक प्रमाणीकरण उपलब्ध नहीं है';

  @override
  String get adminBiometricReason =>
      'व्यवस्थापक के रूप में लॉगिन करने के लिए प्रमाणित करें';

  @override
  String get adminInvalidPin => 'अमान्य PIN';

  @override
  String get adminEnterPin => '4-अंकीय PIN दर्ज करें';

  @override
  String get adminPinHint => 'PIN';

  @override
  String get adminBiometricLabel => 'बायोमेट्रिक';

  @override
  String get adminPinLogin => 'PIN लॉगिन';

  @override
  String adminBiometricFailed(String error) {
    return 'बायोमेट्रिक प्रमाणीकरण विफल: $error';
  }

  @override
  String get adminNavLabel => 'व्यवस्थापक';

  @override
  String get adminNavDashboard => 'डैशबोर्ड';

  @override
  String get adminNavDonations => 'दान';

  @override
  String get adminNavEvents => 'कार्यक्रम';

  @override
  String get adminNavGallery => 'गैलरी';

  @override
  String get adminNavUsers => 'उपयोगकर्ता';

  @override
  String get adminNavLogout => 'लॉगआउट';

  @override
  String get adminLogoutTooltip => 'लॉगआउट';

  @override
  String get dashboardTitle => 'डैशबोर्ड';

  @override
  String get dashboardWelcome => 'स्वागत है, व्यवस्थापक';

  @override
  String get dashboardTotalDonations => 'कुल दान';

  @override
  String get dashboardActiveEvents => 'सक्रिय कार्यक्रम';

  @override
  String get dashboardGalleryItems => 'गैलरी आइटम';

  @override
  String get dashboardThisMonth => 'इस महीने';

  @override
  String get dashboardSubtitleUpcoming => 'आगामी';

  @override
  String get dashboardSubtitlePhotos => 'फोटो';

  @override
  String get dashboardSubtitleCollected => 'एकत्रित';

  @override
  String get dashboardRecentDonations => 'हालिया दान';

  @override
  String get dashboardViewAll => 'सभी देखें';

  @override
  String get dashboardNoDonationsYet => 'अभी तक कोई दान नहीं';

  @override
  String get dashboardUpcomingEvents => 'आगामी कार्यक्रम';

  @override
  String get dashboardNoUpcomingEvents => 'कोई आगामी कार्यक्रम नहीं';

  @override
  String dashboardDonorsCount(int count) {
    return '$count दाता';
  }

  @override
  String get donationsTrendTitle => 'दान प्रवृत्ति';

  @override
  String get donationsPurposeBreakdown => 'उद्देश्य विभाजन';

  @override
  String get logoutDialogTitle => 'लॉगआउट';

  @override
  String get logoutDialogMessage => 'क्या आप लॉगआउट करना चाहते हैं?';

  @override
  String get donationsTitle => 'दान';

  @override
  String get donationsStatTotal => 'कुल';

  @override
  String get donationsStatCount => 'गिनती';

  @override
  String get donationsSearchHint => 'खोजें...';

  @override
  String get donationsSortByDate => 'तारीख के अनुसार';

  @override
  String get donationsSortByAmount => 'राशि के अनुसार';

  @override
  String get donationsSortByName => 'नाम के अनुसार';

  @override
  String get donationsNoDonationsYet => 'अभी तक कोई दान नहीं';

  @override
  String get donationsNoDonationsFound => 'कोई दान नहीं मिला';

  @override
  String get donationsDeleteDialogTitle => 'दान हटाएं';

  @override
  String get donationsDeletedSnackbar => 'दान हटा दिया गया';

  @override
  String donationsDeleteConfirmMessage(String name) {
    return 'क्या आप $name का दान हटाना चाहते हैं?';
  }

  @override
  String get donationsEditTitle => 'दान संपादित करें';

  @override
  String get donationsChangeStatus => 'स्थिति बदलें';

  @override
  String get donationsNoDataToExport => 'निर्यात करने के लिए कोई डेटा नहीं';

  @override
  String get donationsStatFiltered => 'फ़िल्टर किया';

  @override
  String get donationsFilterAll => 'सभी';

  @override
  String get donationsDateRange => 'तिथि सीमा';

  @override
  String get donationsSortByStatus => 'स्थिति के अनुसार';

  @override
  String get donationsUpdatedSnackbar => 'दान अपडेट हो गया';

  @override
  String donationsStatusUpdated(String status) {
    return 'स्थिति $status में बदली';
  }

  @override
  String donationsExportSuccess(String path) {
    return '$path में निर्यात हो गया';
  }

  @override
  String get donationsExportFailed => 'निर्यात विफल';

  @override
  String get donorNameLabel => 'नाम';

  @override
  String get donorLocationLabel => 'स्थान';

  @override
  String get donationAmountLabel => 'राशि';

  @override
  String get donorPhoneLabel => 'फोन';

  @override
  String get donorEmailLabel => 'ईमेल';

  @override
  String get donationPurposeLabel => 'उद्देश्य';

  @override
  String get userManagementTitle => 'उपयोगकर्ता प्रबंधन';

  @override
  String userManagementSubtitle(int count) {
    return '$count उपयोगकर्ता';
  }

  @override
  String get userManagementNoUsers => 'कोई उपयोगकर्ता नहीं मिला';

  @override
  String get userManagementYou => 'आप';

  @override
  String get userManagementInactive => 'अक्षम';

  @override
  String get userManagementLastLogin => 'अंतिम लॉगिन';

  @override
  String get userManagementAddUser => 'उपयोगकर्ता जोड़ें';

  @override
  String get userManagementEmail => 'ईमेल';

  @override
  String get userManagementEmailValidation => 'कृपया एक मान्य ईमेल दर्ज करें';

  @override
  String get userManagementRole => 'भूमिका';

  @override
  String get userManagementCreate => 'बनाएं';

  @override
  String userManagementCreated(String username) {
    return '$username सफलतापूर्वक बनाया गया';
  }

  @override
  String get userManagementEditUser => 'उपयोगकर्ता संपादित करें';

  @override
  String userManagementUpdated(String username) {
    return '$username सफलतापूर्वक अपडेट हो गया';
  }

  @override
  String get userManagementNewPassword => 'नया पासवर्ड';

  @override
  String get userManagementResetPassword => 'पासवर्ड रीसेट करें';

  @override
  String userManagementResetPasswordFor(String username) {
    return '$username का पासवर्ड रीसेट';
  }

  @override
  String get userManagementDeactivateTitle => 'उपयोगकर्ता अक्षम करें';

  @override
  String get userManagementDeactivate => 'अक्षम करें';

  @override
  String get userManagementReactivate => 'पुनः सक्रिय करें';

  @override
  String userManagementReactivated(String username) {
    return '$username पुनः सक्रिय हो गया';
  }

  @override
  String get userManagementPasswordValidation =>
      'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String userManagementPasswordReset(String username) {
    return '$username का पासवर्ड रीसेट हो गया';
  }

  @override
  String userManagementDeactivateConfirm(String username) {
    return 'क्या आप $username को अक्षम करना चाहते हैं?';
  }

  @override
  String userManagementDeactivated(String username) {
    return '$username अक्षम कर दिया गया';
  }

  @override
  String get adminEventsTitle => 'कार्यक्रम';

  @override
  String get adminEventsAddEvent => 'कार्यक्रम जोड़ें';

  @override
  String get adminEventsNoEventsFound => 'कोई कार्यक्रम नहीं मिला';

  @override
  String get adminEventsAddNewEventTitle => 'नया कार्यक्रम जोड़ें';

  @override
  String get adminEventsEditEventTitle => 'कार्यक्रम संपादित करें';

  @override
  String get adminEventsFieldTitle => 'शीर्षक';

  @override
  String get adminEventsFieldDescription => 'विवरण';

  @override
  String get adminEventsFieldLocation => 'स्थान';

  @override
  String get adminEventsFieldDate => 'तारीख';

  @override
  String get adminEventsFieldCategory => 'श्रेणी';

  @override
  String get adminEventsDeleteDialogTitle => 'कार्यक्रम हटाएं';

  @override
  String adminEventsDeleteConfirmMessage(String title) {
    return 'क्या आप \"$title\" को हटाना चाहते हैं?';
  }

  @override
  String get adminGalleryTitle => 'गैलरी';

  @override
  String get adminGalleryAddButton => 'जोड़ें';

  @override
  String get adminGalleryNoImagesFound => 'कोई छवि नहीं मिली';

  @override
  String get adminGalleryTapToAdd =>
      'छवियां अपलोड करने के लिए \"जोड़ें\" पर टैप करें';

  @override
  String get adminGalleryAddImageTitle => 'छवि जोड़ें';

  @override
  String get adminGalleryChooseSource => 'छवि स्रोत चुनें';

  @override
  String get adminGallerySourceCamera => 'कैमरा';

  @override
  String get adminGallerySourceGallery => 'गैलरी';

  @override
  String get adminGalleryAddImageDetailsTitle => 'छवि विवरण जोड़ें';

  @override
  String get adminGalleryFieldTitle => 'शीर्षक (वैकल्पिक)';

  @override
  String get adminGalleryFieldDescription => 'विवरण (वैकल्पिक)';

  @override
  String get adminGalleryFieldCategory => 'श्रेणी';

  @override
  String get adminGalleryAddImage => 'छवि जोड़ें';

  @override
  String get adminGalleryImageAddedSuccess => 'छवि सफलतापूर्वक जोड़ी गई!';

  @override
  String get adminGalleryFailedToSave => 'छवि सहेजने में विफल';

  @override
  String get adminGalleryDeleteDialogTitle => 'छवि हटाएं';

  @override
  String get adminGalleryDeleteDialogMessage =>
      'क्या आप इस छवि को हटाना चाहते हैं?';

  @override
  String adminGalleryPickError(String error) {
    return 'छवि चुनने में त्रुटि: $error';
  }

  @override
  String get settingsNotifications => 'सूचनाएं';

  @override
  String get settingsNotificationsToggle => 'पुश सूचनाएं';

  @override
  String get settingsNotificationsSubtitle =>
      'कार्यक्रम और घोषणाओं की सूचना प्राप्त करें';

  @override
  String get settingsPujaCountdown => 'पूजा काउंटडाउन';

  @override
  String get settingsPujaCountdownSubtitle => 'महालया से पहले दैनिक अनुस्मारक';

  @override
  String get settingsEventReminders => 'कार्यक्रम अनुस्मारक';

  @override
  String get settingsEventRemindersSubtitle =>
      'कार्यक्रम शुरू होने से पहले याद दिलाएं';

  @override
  String get eventAddToCalendar => 'कैलेंडर';

  @override
  String get eventSetReminder => 'रिमाइंडर';

  @override
  String get eventReminderOn => 'चालू';

  @override
  String get eventReminderSet => 'रिमाइंडर सेट हो गया';

  @override
  String get eventReminderRemoved => 'रिमाइंडर हटा दिया गया';

  @override
  String get eventShare => 'शेयर';

  @override
  String get homeDrawerCommunity => 'समुदाय';

  @override
  String get communityTitle => 'समुदाय';

  @override
  String get communityAnnouncements => 'घोषणाएं';

  @override
  String get communityNoAnnouncements => 'अभी तक कोई घोषणा नहीं';

  @override
  String get communityBhogSchedule => 'भोग/प्रसाद अनुसूची';

  @override
  String get communityBhogSaptami => 'महा सप्तमी';

  @override
  String get communityBhogSaptamiItems => 'खिचड़ी, बेगुनी, टमाटर चटनी';

  @override
  String get communityBhogAshtami => 'महा अष्टमी';

  @override
  String get communityBhogAshtamiItems => 'लूची, छोलार दाल, पायेश';

  @override
  String get communityBhogNavami => 'महा नवमी';

  @override
  String get communityBhogNavamiItems => 'मिक्स्ड राइस, पनीर, बासंती पुलाव';

  @override
  String get communityBhogDashami => 'विजया दशमी';

  @override
  String get communityBhogDashamiItems => 'रसगुल्ला, मिष्टी दोई, संदेश';

  @override
  String get communityVolunteer => 'स्वयंसेवक पंजीकरण';

  @override
  String get communityVolunteerSubtitle =>
      'हमारी सेवा टीम में शामिल हों और उत्सव में योगदान दें';

  @override
  String get communityVolunteerName => 'पूरा नाम';

  @override
  String get communityVolunteerPhone => 'फोन नंबर';

  @override
  String get communityVolunteerAvailability => 'उपलब्धता';

  @override
  String get communityVolunteerRegister => 'स्वयंसेवक के रूप में पंजीकरण करें';

  @override
  String get communityVolunteerValidation => 'कृपया नाम और फोन भरें';

  @override
  String get communityVolunteerSuccess =>
      'पंजीकरण सफल! स्वयंसेवा के लिए धन्यवाद।';

  @override
  String get communityAvailMorning => 'सुबह';

  @override
  String get communityAvailAfternoon => 'दोपहर';

  @override
  String get communityAvailEvening => 'शाम';

  @override
  String get communityAvailFullDay => 'पूरा दिन';

  @override
  String get communityEmergency => 'आपातकालीन संपर्क';

  @override
  String get communityEmergencyCommittee => 'पूजा समिति';

  @override
  String get communityEmergencyMedical => 'चिकित्सा सहायता';

  @override
  String get communityEmergencySecurity => 'सुरक्षा';

  @override
  String get adminNavCommunity => 'समुदाय';

  @override
  String get adminCommunityTitle => 'समुदाय';

  @override
  String get adminCommunitySubtitle => 'घोषणाएं और स्वयंसेवक प्रबंधन';

  @override
  String get adminCommunityAnnouncements => 'घोषणाएं';

  @override
  String get adminCommunityVolunteers => 'स्वयंसेवक';

  @override
  String get adminCommunityNoAnnouncements => 'कोई घोषणा नहीं बनाई गई';

  @override
  String get adminCommunityAddFirst => 'पहली घोषणा बनाएं';

  @override
  String get adminCommunityNoVolunteers => 'अभी तक कोई स्वयंसेवक पंजीकृत नहीं';

  @override
  String adminCommunityVolunteerCount(int count) {
    return '$count स्वयंसेवक पंजीकृत';
  }

  @override
  String get adminCommunityInactive => 'अक्षम';

  @override
  String get adminCommunityPin => 'पिन करें';

  @override
  String get adminCommunityUnpin => 'अनपिन करें';

  @override
  String get adminCommunityActivate => 'सक्रिय करें';

  @override
  String get adminCommunityDeactivate => 'अक्षम करें';

  @override
  String get adminCommunityDelete => 'हटाएं';

  @override
  String get adminCommunityDeleteConfirm => 'यह घोषणा हटाएं?';

  @override
  String get adminCommunityNewAnnouncement => 'नई घोषणा';

  @override
  String get adminCommunityTitleField => 'शीर्षक';

  @override
  String get adminCommunityBodyField => 'संदेश';

  @override
  String get adminCommunityCategoryField => 'श्रेणी';

  @override
  String get adminCommunityPinned => 'शीर्ष पर पिन करें';

  @override
  String get adminCommunityPublish => 'प्रकाशित करें';

  @override
  String get adminCommunityAnnouncementAdded => 'घोषणा प्रकाशित हो गई!';

  @override
  String get homeDrawerFeedback => 'प्रतिक्रिया';

  @override
  String get feedbackPageTitle => 'प्रतिक्रिया';

  @override
  String get feedbackSubtitle =>
      'दुर्गा पूजा के अनुभव के बारे में हम आपकी राय सुनना चाहेंगे';

  @override
  String get feedbackRateExperience => 'अपने अनुभव को रेट करें';

  @override
  String get feedbackSelectRating => 'कृपया रेटिंग चुनें';

  @override
  String get feedbackNameLabel => 'आपका नाम *';

  @override
  String get feedbackNameRequired => 'कृपया अपना नाम दर्ज करें';

  @override
  String get feedbackEmailLabel => 'ईमेल (वैकल्पिक)';

  @override
  String get feedbackCategoryLabel => 'श्रेणी';

  @override
  String get feedbackMessageLabel => 'आपकी प्रतिक्रिया *';

  @override
  String get feedbackMessageRequired => 'कृपया अपनी प्रतिक्रिया साझा करें';

  @override
  String get feedbackSubmit => 'प्रतिक्रिया जमा करें';

  @override
  String get feedbackSubmitSuccess => 'आपकी प्रतिक्रिया के लिए धन्यवाद!';

  @override
  String get feedbackRating1 => 'खराब';

  @override
  String get feedbackRating2 => 'ठीक-ठाक';

  @override
  String get feedbackRating3 => 'अच्छा';

  @override
  String get feedbackRating4 => 'बहुत अच्छा';

  @override
  String get feedbackRating5 => 'उत्कृष्ट';

  @override
  String get feedbackCatGeneral => 'सामान्य';

  @override
  String get feedbackCatSuggestion => 'सुझाव';

  @override
  String get feedbackCatBug => 'बग रिपोर्ट';

  @override
  String get feedbackCatPraise => 'प्रशंसा';

  @override
  String get adminNavFeedback => 'प्रतिक्रिया';

  @override
  String get adminFeedbackTitle => 'प्रतिक्रिया';

  @override
  String get adminFeedbackSubtitle => 'उपयोगकर्ता प्रतिक्रिया और रेटिंग';

  @override
  String get adminFeedbackTotalLabel => 'कुल';

  @override
  String get adminFeedbackAvgRating => 'औसत रेटिंग';

  @override
  String get adminFeedbackEmpty => 'अभी तक कोई प्रतिक्रिया नहीं मिली';

  @override
  String get adminFeedbackDeleteTitle => 'प्रतिक्रिया हटाएं';

  @override
  String get adminFeedbackDeleteConfirm =>
      'क्या आप इस प्रतिक्रिया को हटाना चाहते हैं?';

  @override
  String get onboardingSkip => 'छोड़ें';

  @override
  String get onboardingNext => 'अगला';

  @override
  String get onboardingGetStarted => 'शुरू करें';

  @override
  String get onboardingTitle1 => 'दुर्गा पूजा में आपका स्वागत है';

  @override
  String get onboardingDesc1 =>
      'भारत के सबसे प्रसिद्ध त्योहारों में से एक की भव्यता का अनुभव करें';

  @override
  String get onboardingTitle2 => 'उत्सव में सहयोग करें';

  @override
  String get onboardingDesc2 =>
      'आसानी से दान करें और त्योहार को जीवंत बनाने में मदद करें';

  @override
  String get onboardingTitle3 => 'जुड़े रहें';

  @override
  String get onboardingDesc3 =>
      'कार्यक्रमों को ट्रैक करें, गैलरी देखें और समुदाय से जुड़ें';
}
