// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'QorLab Paneli';

  @override
  String get useGlovesWrapper => 'Eldiven Kullanın!';

  @override
  String get newExperiment => 'YENİ DENEY';

  @override
  String get openExperiment => 'DENEY AÇ (ID 1)';

  @override
  String get timers => 'SAYAÇLAR';

  @override
  String get inVivoSafety => 'IN-VIVO GÜVENLİK';

  @override
  String get chemistry => 'KİMYA';

  @override
  String get molarityCalculator => 'Molarite Hesaplayıcı';

  @override
  String get selectChemical => 'Envanterden Kimyasal Seç';

  @override
  String get molecularWeight => 'Moleküler Ağırlık';

  @override
  String get volume => 'Hacim';

  @override
  String get desiredMolarity => 'Hedef Molarite';

  @override
  String get requiredMass => 'Gerekli Kütle';

  @override
  String get logThis => 'LOG\'A KAYDET';

  @override
  String get savedToLog => 'Log\'a Kaydedildi';

  @override
  String get safetyCalculator => 'Güvenlik Hesaplayıcı';

  @override
  String get species => 'Tür';

  @override
  String get route => 'Yol';

  @override
  String get weight => 'Ağırlık';

  @override
  String get dose => 'Doz';

  @override
  String get concentration => 'Konsantrasyon';

  @override
  String get calculate => 'HESAPLA';

  @override
  String get saveToLog => 'LOG\'A KAYDET';

  @override
  String get savedToExperimentLog => 'Deney Loguna Kaydedildi';

  @override
  String get invalidNumbers => 'Geçersiz Değerler';

  @override
  String get noActiveExperiment =>
      'Aktif deney yok. Loglamak için bir deney aç.';

  @override
  String get pubChemPremium => 'Premium';

  @override
  String get pubChemSectionTitle => 'Bileşik İstihbaratı';

  @override
  String get pubChemSelectChemicalHint =>
      'Molekül yapısı ve fizikokimyasal özellikleri getirmek için bir kimyasal seçin.';

  @override
  String pubChemLoading(Object chemical) {
    return '$chemical için bileşik profili getiriliyor...';
  }

  @override
  String get pubChemLoadFailed => 'Bileşik verisi şu anda alınamıyor.';

  @override
  String get pubChemRetry => 'Tekrar Dene';

  @override
  String get pubChemNoData => 'Bu kimyasal için bileşik kaydı bulunamadı.';

  @override
  String get pubChemFormula => 'Formül';

  @override
  String get pubChemMw => 'MA';

  @override
  String get pubChemApplyMw => 'Moleküler Ağırlığı Uygula';

  @override
  String get pubChemIupac => 'IUPAC';

  @override
  String get pubChemSmiles => 'SMILES';

  @override
  String get pubChemInchiKey => 'InChIKey';

  @override
  String get pubChemXlogp => 'XLogP';

  @override
  String get pubChemTpsa => 'TPSA';

  @override
  String get pubChemHbondDonor => 'H-Bağı Donörü';

  @override
  String get pubChemHbondAcceptor => 'H-Bağı Akseptörü';

  @override
  String get pubChemRotatableBonds => 'Döner Bağ';

  @override
  String get pubChemComplexity => 'Karmaşıklık';

  @override
  String get pubChemCharge => 'Yük';

  @override
  String get pubChemSynonyms => 'Eşanlamlılar';

  @override
  String get pubChemPremiumLocked =>
      'Tüm tanımlayıcıları ve eşanlamlı istihbaratını açmak için Premium\'a yükseltin.';

  @override
  String get chemicalInventoryTitle => 'Kimyasal Envanteri';

  @override
  String get searchChemicals => 'Kimyasal Ara';

  @override
  String get inventoryLocalSection => 'Yerel Envanter';

  @override
  String get inventoryNoLocalMatch => 'Yerel kimyasal eşleşmesi yok.';

  @override
  String get inventoryPubChemSection => 'Çevrimiçi Bileşik Arama';

  @override
  String get inventoryPubChemHint =>
      'Bileşik veritabanında arama için en az 3 karakter girin.';

  @override
  String get inventoryPubChemMwMissing =>
      'Bileşik kaydında moleküler ağırlık yok.';

  @override
  String get inventoryPubChemLoadFailed => 'Bileşik sonucu yüklenemedi.';

  @override
  String get inventoryPubChemRetry => 'Aramayı Tekrar Dene';

  @override
  String get inventoryPubChemNoMatch => 'Bu sorgu için sonuç yok.';

  @override
  String get inventoryPubChemUseCompound => 'Bu bileşiği kullan';

  @override
  String get pubChemExplorerTitle => 'Bileşik Gezgini';

  @override
  String get pubChemExplorerSubtitle =>
      'Bir bileşik ara, geometri ve zengin descriptor bilgilerini incele.';

  @override
  String get pubChemExplorerSearchLabel => 'Bileşik Adı';

  @override
  String get pubChemExplorerSearchHint =>
      'örn. caffeine, dopamine, acetaminophen';

  @override
  String get pubChemExplorerPrompt =>
      'Bileşik araması için en az 2 karakter girin.';

  @override
  String get pubChemExplorerSuggestions => 'Öneriler';

  @override
  String get pubChemExplorerSearching => 'Öneriler aranıyor...';

  @override
  String get pubChemExplorerSuggestionsHint =>
      'En az 2 karakter yazın, ardından bir öneri seçin veya arayın.';

  @override
  String get pubChemExplorerNoResult => 'Bu sorgu için bileşik bulunamadı.';

  @override
  String get pubChemExplorerGeometry => 'Moleküler Geometri';

  @override
  String get pubChemExplorerGeometry2d => '2D';

  @override
  String get pubChemExplorerGeometry3d => '3D';

  @override
  String get pubChemExplorerGeometry3dLoading =>
      'Etkileşimli 3D model hazırlanıyor...';

  @override
  String get pubChemExplorerGeometry3dUnavailable =>
      'Bu bileşik için 3D geometri mevcut değil.';

  @override
  String get pubChemExplorerDescriptors => 'Bileşik Tanımlayıcıları';

  @override
  String get pubChemExactMass => 'Tam Kütle';

  @override
  String get pubChemMonoisotopicMass => 'Monoisotopik Kütle';

  @override
  String get pubChemHeavyAtomCount => 'Ağır Atom Sayısı';

  @override
  String get pubChemIsotopeAtomCount => 'İzotop Atom Sayısı';

  @override
  String get pubChemAtomStereoCount => 'Atom Stereo Sayısı';

  @override
  String get pubChemDefinedAtomStereoCount => 'Tanımlı Atom Stereo';

  @override
  String get pubChemUndefinedAtomStereoCount => 'Tanımsız Atom Stereo';

  @override
  String get pubChemBondStereoCount => 'Bağ Stereo Sayısı';

  @override
  String get pubChemDefinedBondStereoCount => 'Tanımlı Bağ Stereo';

  @override
  String get pubChemUndefinedBondStereoCount => 'Tanımsız Bağ Stereo';

  @override
  String get pubChemCovalentUnitCount => 'Kovalent Birim Sayısı';

  @override
  String get statWizardToolTitle => 'Stat Wizard';

  @override
  String get statWizardToolSubtitle => 'Test seçici';

  @override
  String get statWizardTitle => 'İstatistik Test Sihirbazı';

  @override
  String get statWizardSubtitle =>
      'Deney tasarımınızı seçin ve önerilen hipotez testini alın.';

  @override
  String statWizardProgress(Object current, Object total) {
    return 'Adım $current / $total';
  }

  @override
  String get statWizardReset => 'Sihirbazı sıfırla';

  @override
  String get statWizardBack => 'Geri';

  @override
  String get statWizardQuestionScenarioTitle => 'Ana analiz hedefiniz nedir?';

  @override
  String get statWizardQuestionScenarioSubtitle =>
      'Grupları karşılaştırmayı mı yoksa ilişki gücünü mü değerlendirdiğinizi seçin.';

  @override
  String get statWizardQuestionCovariateTitle =>
      'Kovaryat kontrolü gerekiyor mu?';

  @override
  String get statWizardQuestionCovariateSubtitle =>
      'Başlangıç farkları veya karıştırıcı etkiler ayarlanacaksa bunu seçin.';

  @override
  String get statWizardQuestionGroupCountTitle => 'Kaç grup karşılaştırılıyor?';

  @override
  String get statWizardQuestionGroupCountSubtitle =>
      'Bu seçim iki grup ve çok grup test ailesini belirler.';

  @override
  String get statWizardQuestionDependencyTitle =>
      'Örneklemler bağımsız mı eşleştirilmiş mi?';

  @override
  String get statWizardQuestionDependencySubtitleTwo =>
      '2 grup için eşleştirilmiş, aynı deneklerin iki kez ölçülmesi veya eşleştirilmiş çiftler demektir.';

  @override
  String get statWizardQuestionDependencySubtitleMulti =>
      '3+ grup için eşleştirilmiş, aynı deneklerde tekrarlı ölçüm demektir.';

  @override
  String get statWizardQuestionDistributionTitle =>
      'Dağılım varsayımınız nedir?';

  @override
  String get statWizardQuestionDistributionSubtitle =>
      'Normal dağılımı yalnızca tanı testleri yaklaşık normalliği destekliyorsa seçin.';

  @override
  String get statWizardQuestionVariableTypeTitle =>
      'Hangi değişken türleri ilişkili?';

  @override
  String get statWizardQuestionVariableTypeSubtitle =>
      'Sürekli/sıralı değerler için sayısal, frekans tabloları için kategorik seçin.';

  @override
  String get statWizardQuestionSmallSampleTitle =>
      'Beklenen hücre sayıları düşük mü?';

  @override
  String get statWizardQuestionSmallSampleSubtitle =>
      'Beklenen herhangi bir hücre 5 altındaysa Fisher Exact Test tercih edilir.';

  @override
  String get statWizardOptionCompareGroups => 'Grupları karşılaştır';

  @override
  String get statWizardOptionCompareGroupsDesc =>
      'Gruplar arasında ortalama/dağılım farkı var mı test et.';

  @override
  String get statWizardOptionCorrelation => 'Korelasyon / ilişki';

  @override
  String get statWizardOptionCorrelationDesc =>
      'Değişkenler arası ilişki gücünü ölç.';

  @override
  String get statWizardOptionCovariateYes => 'Evet, kovaryat kontrolü gerekli';

  @override
  String get statWizardOptionCovariateYesDesc =>
      'Grup etkisini bir veya daha fazla kovaryat için düzelt.';

  @override
  String get statWizardOptionCovariateNo => 'Hayır, kovaryat kontrolü yok';

  @override
  String get statWizardOptionCovariateNoDesc =>
      'Doğrudan grup karşılaştırması ile devam et.';

  @override
  String get statWizardOptionTwoGroups => '2 grup';

  @override
  String get statWizardOptionTwoGroupsDesc =>
      'Tam olarak iki koşul veya kohort.';

  @override
  String get statWizardOptionMoreThanTwoGroups => '3+ grup';

  @override
  String get statWizardOptionMoreThanTwoGroupsDesc =>
      'Üç veya daha fazla koşul veya kohort.';

  @override
  String get statWizardOptionIndependent => 'Bağımsız örneklemler';

  @override
  String get statWizardOptionIndependentDesc =>
      'Her grup farklı deneklerden oluşur.';

  @override
  String get statWizardOptionPaired => 'Eşleştirilmiş / tekrarlı';

  @override
  String get statWizardOptionPairedDesc =>
      'Aynı denekler çoklu ölçülür veya eşleştirilmiş çiftler kullanılır.';

  @override
  String get statWizardOptionNormal => 'Normal dağılım';

  @override
  String get statWizardOptionNormalDesc =>
      'Varsayımlar normal artık dağılımını destekliyor.';

  @override
  String get statWizardOptionNonNormal => 'Normal değil / sıralama temelli';

  @override
  String get statWizardOptionNonNormalDesc =>
      'Normallik varsayımları sağlanmıyor veya sıralama temelli yaklaşım tercih ediliyor.';

  @override
  String get statWizardOptionNumerical => 'Sayısal değişkenler';

  @override
  String get statWizardOptionNumericalDesc =>
      'Sürekli veya sıralı sayısal değerler.';

  @override
  String get statWizardOptionCategorical => 'Kategorik değişkenler';

  @override
  String get statWizardOptionCategoricalDesc =>
      'Frekans tablosu / kontenjans sayımları.';

  @override
  String get statWizardOptionSmallSampleYes => 'Evet, örneklem küçük';

  @override
  String get statWizardOptionSmallSampleYesDesc =>
      'Bir veya daha fazla beklenen hücre sayısı düşük.';

  @override
  String get statWizardOptionSmallSampleNo => 'Hayır, örneklem yeterli';

  @override
  String get statWizardOptionSmallSampleNoDesc =>
      'Beklenen hücre sayıları yeterince büyük.';

  @override
  String get statWizardResultTitle => 'Önerilen Test';

  @override
  String get statWizardResultRecommendedTest => 'Kullanmanız gereken test';

  @override
  String get statWizardResultWhy => 'Neden bu seçim?';

  @override
  String get statWizardResultProTip => 'Pro İpucu';

  @override
  String get statWizardResultRestart => 'Yeni Seçime Başla';

  @override
  String get statWizardTestIndependentSamplesT => 'Independent Samples t-Test';

  @override
  String get statWizardTestMannWhitneyU => 'Mann-Whitney U Test';

  @override
  String get statWizardTestPairedSamplesT => 'Paired Samples t-Test';

  @override
  String get statWizardTestWilcoxonSignedRank => 'Wilcoxon Signed-Rank Test';

  @override
  String get statWizardTestOneWayAnova => 'One-Way ANOVA';

  @override
  String get statWizardTestKruskalWallis => 'Kruskal-Wallis H Test';

  @override
  String get statWizardTestRepeatedMeasuresAnova => 'Repeated Measures ANOVA';

  @override
  String get statWizardTestFriedman => 'Friedman Test';

  @override
  String get statWizardTestAncova => 'ANCOVA';

  @override
  String get statWizardTestPearson => 'Pearson Correlation';

  @override
  String get statWizardTestSpearman => 'Spearman Correlation';

  @override
  String get statWizardTestChiSquare => 'Chi-Square Test';

  @override
  String get statWizardTestFishersExact => 'Fisher Exact Test';

  @override
  String get statWizardWhyAncova =>
      'Kovaryat düzeltmesi gerektiği için, grup farklarını karıştırıcı etkileri kontrol ederek karşılaştırmada doğru model ANCOVA\'dır.';

  @override
  String statWizardWhyDifference(
    Object dependency,
    Object distribution,
    Object groups,
  ) {
    return 'Tasarımınız $groups için $dependency yapıda ve $distribution varsayımı altında grup karşılaştırması yapıyor.';
  }

  @override
  String statWizardWhyCorrelationNumerical(Object distribution) {
    return 'Sayısal değişkenler ve $distribution varsayımını seçtiniz.';
  }

  @override
  String get statWizardWhyCorrelationCategorical =>
      'Kategorik değişkenler ve yeterli beklenen hücre sayıları seçildiği için Chi-Square yaklaşımı uygundur.';

  @override
  String get statWizardWhyCorrelationCategoricalSmall =>
      'Kategorik değişkenlerde beklenen hücre sayıları küçük olduğundan Fisher Exact, Chi-Square testinden daha güvenlidir.';

  @override
  String get statWizardTipParametricGroup =>
      'Nihai p-değerlerini raporlamadan önce varyans homojenliğini ve artık grafiklerini kontrol edin.';

  @override
  String get statWizardTipNonParametricGroup =>
      'p-değeri ile birlikte medyanları ve sağlam etki büyüklüğünü (ör. rank-biserial, epsilon squared) raporlayın.';

  @override
  String get statWizardTipAncova =>
      'Düzeltilmiş grup farklarını yorumlamadan önce regresyon eğimlerinin homojenliğini doğrulayın.';

  @override
  String get statWizardTipPearson =>
      'Önce doğrusal ilişkiyi ve aykırı değerleri inceleyin. Pearson etkileyici noktalardan sapabilir.';

  @override
  String get statWizardTipSpearman =>
      'Spearman monoton eğilimleri yakalar; rapora rho ve güven aralıklarını ekleyin.';

  @override
  String get statWizardTipCategorical =>
      'Kontenjans tablosu beklenen hücre sayılarını kontrol edin ve etki büyüklüğü (phi/Cramer\'s V veya odds ratio) raporlayın.';

  @override
  String get logNewEvent => 'Yeni Olay Kaydet';

  @override
  String get voiceNote => 'Sesli Not';

  @override
  String get voiceNoteSaved => 'Sesli not kaydedildi';

  @override
  String get doseCalc => 'Doz Hesabı';

  @override
  String get photo => 'Fotoğraf';

  @override
  String get photoSaved => 'Fotoğraf çekildi ve kaydedildi';

  @override
  String get photoFailed => 'Fotoğraf çekilemedi';

  @override
  String get molarity => 'Molarite';

  @override
  String get textNote => 'Metin';

  @override
  String get measurement => 'Ölçüm';

  @override
  String get graphs => 'Grafikler';

  @override
  String get addNote => 'Not Ekle';

  @override
  String get enterObservation => 'Gözlem gir...';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get saveFailed => 'Kaydetme başarısız';

  @override
  String get logMeasurement => 'Ölçüm Kaydet';

  @override
  String get measurementType => 'Tür';

  @override
  String get measurementLabel => 'Etiket';

  @override
  String get measurementUnit => 'Birim';

  @override
  String get measurementValue => 'Değer';

  @override
  String get measurementNote => 'Not (opsiyonel)';

  @override
  String get measurementPresetTemperature => 'Sıcaklık';

  @override
  String get measurementPresetAbsorbance => 'Absorbans';

  @override
  String get measurementPresetPh => 'pH';

  @override
  String get measurementPresetCustom => 'Özel';

  @override
  String get noMeasurementSeries => 'Henüz ölçüm serisi yok';

  @override
  String get noMeasurementPoints => 'Henüz ölçüm noktası yok';

  @override
  String get latestValue => 'Son Değer';

  @override
  String get noUnit => 'Birim yok';

  @override
  String get archive => 'Arşiv';

  @override
  String get archiveSubtitle =>
      'Cihazlar arası şifreli yedek (.ql). Hesap gerekmez.';

  @override
  String get archiveExportSection => 'DIŞA AKTAR';

  @override
  String get archiveExportDescription =>
      'Başka bir cihaza/masaüstü okuyucuya aktarabileceğiniz şifreli bir .ql arşivi oluşturun.';

  @override
  String get archiveExportAll => 'Tüm Deneyleri Dışa Aktar (.ql)';

  @override
  String get archiveExportExperiment => 'Deneyi Dışa Aktar (.ql)';

  @override
  String get archiveImportSection => 'İÇE AKTAR';

  @override
  String get archiveImportDescription =>
      'Şifreli bir .ql arşivini kopya olarak içe aktarın (güvenli). Mevcut veriler korunur.';

  @override
  String get archiveImportAsCopy => 'Arşivi Kopya Olarak İçe Aktar';

  @override
  String get archiveImportReplaceDevice => 'Cihaz Verisini Değiştir';

  @override
  String get archiveReplaceWarningTitle => 'Cihaz verisi değiştirilsin mi?';

  @override
  String get archiveReplaceWarningBody =>
      'Bu işlem, arşivi içe aktarmadan önce yerel deneyleri kalıcı olarak siler.';

  @override
  String get archiveWorking => 'Çalışıyor…';

  @override
  String get archiveExporting => 'Dışa aktarılıyor…';

  @override
  String get archiveImporting => 'İçe aktarılıyor…';

  @override
  String get archiveShareSubject => 'QorLab Arşivi';

  @override
  String get archiveShareText => 'Şifreli QorLab Arşivi (.ql)';

  @override
  String get archiveExported => 'Arşiv dışa aktarıldı';

  @override
  String get archiveNoFileSelected => 'Dosya seçilmedi';

  @override
  String get archiveFileTypeLabel => 'QorLab arşivi (.ql)';

  @override
  String get archivePassword => 'Şifre';

  @override
  String get archiveConfirmPassword => 'Şifreyi doğrula';

  @override
  String get archiveShowPassword => 'Şifreyi göster';

  @override
  String get archivePasswordHint =>
      'Bu şifreyi güvenle saklayın. Geri getirilemez.';

  @override
  String get archivePasswordRequired => 'Şifre gerekli';

  @override
  String get archivePasswordTooShort => 'En az 8 karakter kullanın';

  @override
  String get archivePasswordMismatch => 'Şifreler eşleşmiyor';

  @override
  String archiveExportFailed(Object error) {
    return 'Dışa aktarma başarısız: $error';
  }

  @override
  String archiveImportFailed(Object error) {
    return 'İçe aktarma başarısız: $error';
  }

  @override
  String archiveImportedSummary(
    Object blobs,
    Object events,
    Object experiments,
  ) {
    return '$experiments deney, $events olay ve $blobs ek içe aktarıldı.';
  }

  @override
  String get archiveReaderTitle => 'Arşiv Okuyucu';

  @override
  String get archiveReaderSubtitle =>
      'Şifreli .ql arşivleri için salt-okunur görüntüleyici.';

  @override
  String get archiveReaderOpen => '.ql Aç (Salt-okunur)';

  @override
  String get archiveReaderNoArchive => 'Açılmış arşiv yok';

  @override
  String get archiveReaderOpenHint =>
      'Deney ve zaman çizelgesi verilerini içe aktarmadan incelemek için bir .ql dosyası seçip şifre girin.';

  @override
  String get archiveReaderViewOnly => 'Salt-okunur mod (içe aktarma yok)';

  @override
  String get archiveReaderExperiments => 'Deney';

  @override
  String get archiveReaderEvents => 'Olay';

  @override
  String get archiveReaderSeries => 'Seri';

  @override
  String get archiveReaderPoints => 'Nokta';

  @override
  String get archiveReaderNoEvents => 'Bu deneyde olay yok.';

  @override
  String get archiveReaderNoSeries => 'Bu deneyde ölçüm serisi yok.';

  @override
  String archiveReaderOpenFailed(Object error) {
    return 'Arşiv açma başarısız: $error';
  }

  @override
  String get premium => 'Premium';

  @override
  String get premiumManageSubtitle =>
      'Lisans durumunu yönetin, satın alımları geri yükleyin ve çevrimdışı erişimi sürdürün.';

  @override
  String get premiumStatusPremium => 'Durum: Premium aktif';

  @override
  String get premiumStatusGrace => 'Durum: Çevrimdışı geçiş aktif';

  @override
  String get premiumStatusFree => 'Durum: Ücretsiz mod';

  @override
  String get premiumHasAccess => 'Premium özellikler açık.';

  @override
  String get premiumNoAccess => 'Premium özellikler kilitli.';

  @override
  String get premiumGraceUntil => 'Geçiş süresi bitişi';

  @override
  String get premiumRefresh => 'Lisansı yenile';

  @override
  String get premiumRestore => 'Satın alımları geri yükle';

  @override
  String get premiumUnlockLocal => 'Yerel aç (geliştirme)';

  @override
  String get premiumStartGrace => '7 gün geçiş başlat';

  @override
  String get premiumRevoke => 'Premiumu kaldır';

  @override
  String experimentLogTitle(Object id) {
    return 'Deney $id Kayıtları';
  }

  @override
  String get exportLogs => 'Kayıtları Dışa Aktar';

  @override
  String get exportCsv => 'CSV Dışa Aktar';

  @override
  String get exportCsvDescription =>
      'Ham zaman çizelgesi ve metaveriyi CSV olarak dışa aktarır.';

  @override
  String get exportPdfReport => 'PDF Raporu Dışa Aktar';

  @override
  String get exportPdfDescription =>
      'Zaman çizelgesi ve ölçüm grafikleri içeren yazdırmaya uygun rapor.';

  @override
  String get exportNoLogs => 'Dışa aktarılacak kayıt yok.';

  @override
  String get exportPreparing => 'Dışa aktarma hazırlanıyor…';

  @override
  String get exportComplete => 'Dışa aktarma tamamlandı';

  @override
  String exportFailed(Object error) {
    return 'Dışa aktarma başarısız: $error';
  }

  @override
  String get statusActive => 'Aktif';

  @override
  String get statusCompleted => 'Tamamlandı';

  @override
  String get completeExperiment => 'Deneyi Tamamla';

  @override
  String get completeExperimentMessage =>
      'Bu işlem deneyi tamamlanmış olarak işaretler ve aktif durumdan çıkarır.';

  @override
  String get resumeExperiment => 'Deneyi Devam Ettir';

  @override
  String get resumeExperimentMessage =>
      'Bu işlem deneyi tekrar aktif duruma alır.';

  @override
  String get experimentCompleted => 'Deney tamamlandı olarak işaretlendi.';

  @override
  String get experimentResumed => 'Deney tekrar aktif edildi.';

  @override
  String get openLabTools => 'Lab Araçlarını Aç';

  @override
  String get newProject => 'Yeni Proje';

  @override
  String get newProjectSubtitle => 'Özel bir proje çalışma alanı başlat';

  @override
  String get createProject => 'Proje Oluştur';

  @override
  String get projectNameLabel => 'Proje Adı';

  @override
  String get projectNameHint => 'örn. Nörotoksisite Çalışması';

  @override
  String get firstExperimentTitleOptional => 'İlk Deney Başlığı (Opsiyonel)';

  @override
  String get firstExperimentHint => 'örn. Başlangıç analizi';

  @override
  String get projectDescriptionOptional => 'Açıklama (Opsiyonel)';

  @override
  String get projectDescriptionHint => 'Proje hedefleri ve kapsamı...';

  @override
  String createProjectFailed(Object error) {
    return 'Proje oluşturulamadı: $error';
  }
}
