import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

void main() => runApp(const MyApp());

// ==================== مدل داده ====================
class PestInfo {
  final String name;
  final String commonName;
  final String order;
  final String distribution;
  final String hosts;
  final String damage;
  final String symptoms;
  final String controlMethods;
  final String quarantineStatus;

  PestInfo({
    required this.name,
    required this.commonName,
    required this.order,
    required this.distribution,
    required this.hosts,
    required this.damage,
    required this.symptoms,
    required this.controlMethods,
    required this.quarantineStatus,
  });
}

// ==================== دیتابیس آفات ====================
class PestDatabase {
  static List<String> _labels = [];
  static final Map<String, PestInfo> _pestsMap = {
    'Acherontia atropos': PestInfo(name:'Acherontia atropos',commonName:'پروانه مرگ',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا، آفریقا',hosts:'سیب‌زمینی، گوجه‌فرنگی',damage:'برگ‌خواری',symptoms:'سوراخ شدن برگ',controlMethods:'کنترل بیولوژیک',quarantineStatus:'آفت مهم'),
    'Acherontia atropos (Larve)': PestInfo(name:'Acherontia atropos (Larve)',commonName:'لارو پروانه مرگ',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا، آفریقا',hosts:'سیب‌زمینی، گوجه‌فرنگی',damage:'برگ‌خواری شدید',symptoms:'لخت شدن گیاه',controlMethods:'جمع‌آوری دستی',quarantineStatus:'آفت مهم'),
    'Acrosternum millierei': PestInfo(name:'Acrosternum millierei',commonName:'سنه میله‌ای',order:'Hemiptera - نیم‌بالان',distribution:'ایران، ترکیه',hosts:'بادام، پسته',damage:'مکیدن شیره',symptoms:'چروکیدگی میوه',controlMethods:'سم‌پاشی',quarantineStatus:'آفت مهم'),
    'Adoxophyes orana': PestInfo(name:'Adoxophyes orana',commonName:'کرم برگ‌پیچ درختان میوه',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا و آسیا',hosts:'درختان میوه',damage:'خسارت به برگ و میوه',symptoms:'برگ‌های پیچیده',controlMethods:'تله فرمونی و Bt',quarantineStatus:'آفت قرنطینه‌ای'),
    'Agrilus hastulifer': PestInfo(name:'Agrilus hastulifer',commonName:'سوسک چوب‌خوار',order:'Coleoptera - قاب‌بالان',distribution:'اروپا، آسیا',hosts:'بلوط، راش',damage:'خسارت به چوب',symptoms:'دالان در تنه',controlMethods:'بهداشت جنگل',quarantineStatus:'آفت جنگلی'),
    'Amrasca biguttula': PestInfo(name:'Amrasca biguttula',commonName:'زنجرک پنبه',order:'Hemiptera - نیم‌بالان',distribution:'آسیا',hosts:'پنبه و سبزیجات',damage:'مکیدن شیره گیاهی',symptoms:'زردی و پیچیدگی برگ',controlMethods:'کنترل بیولوژیک و سموم',quarantineStatus:'آفت مهم کشاورزی'),
    'Anarsia lineatella': PestInfo(name:'Anarsia lineatella',commonName:'شپشک شاخه هلو',order:'Lepidoptera - پروانه‌سانان',distribution:'جهان‌گستر',hosts:'هلو، زردآلو',damage:'خسارت به شاخه و میوه',symptoms:'خشکیدگی شاخه',controlMethods:'هرس و سم‌پاشی',quarantineStatus:'آفت مهم'),
    'Anastrepha fraterculus': PestInfo(name:'Anastrepha fraterculus',commonName:'مگس میوه آمریکای جنوبی',order:'Diptera - دوبالان',distribution:'آمریکای جنوبی',hosts:'میوه‌های گرمسیری',damage:'پوسیدگی میوه',symptoms:'سوراخ میوه',controlMethods:'تله‌گذاری',quarantineStatus:'قرنطینه‌ای'),
    'Anastrepha ludens': PestInfo(name:'Anastrepha ludens',commonName:'مگس میوه مکزیکی',order:'Diptera - دوبالان',distribution:'آمریکای مرکزی',hosts:'مرکبات و انبه',damage:'پوسیدگی میوه',symptoms:'سوراخ تخم‌ریزی',controlMethods:'تله و طعمه‌پاشی',quarantineStatus:'آفت قرنطینه‌ای'),
    'Anastrepha suspensa': PestInfo(name:'Anastrepha suspensa',commonName:'مگس میوه کارائیب',order:'Diptera - دوبالان',distribution:'کارائیب',hosts:'میوه‌های گرمسیری',damage:'خسارت به میوه',symptoms:'ریزش میوه',controlMethods:'تله‌گذاری',quarantineStatus:'آفت قرنطینه‌ای'),
    'Anoplophora chinensis': PestInfo(name:'Anoplophora chinensis',commonName:'سوسک شاخک‌بلند مرکبات',order:'Coleoptera - قاب‌بالان',distribution:'شرق آسیا',hosts:'مرکبات و درختان زینتی',damage:'خسارت به تنه',symptoms:'سوراخ خروجی',controlMethods:'حذف درخت آلوده',quarantineStatus:'قرنطینه‌ای'),
    'Anoplophora glabripennis': PestInfo(name:'Anoplophora glabripennis',commonName:'سوسک شاخک‌بلند آسیایی',order:'Coleoptera - قاب‌بالان',distribution:'آسیا',hosts:'درختان پهن‌برگ',damage:'مرگ درخت',symptoms:'خشکیدگی شاخه',controlMethods:'ریشه‌کنی',quarantineStatus:'قرنطینه‌ای'),
    'Apantesis vittata': PestInfo(name:'Apantesis vittata',commonName:'پروانه راه‌راه',order:'Lepidoptera - پروانه‌سانان',distribution:'آمریکای شمالی',hosts:'گیاهان مختلف',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'کنترل بیولوژیک',quarantineStatus:'آفت معمولی'),
    'Arctia caja (Adult)': PestInfo(name:'Arctia caja (Adult)',commonName:'پروانه خرسی بالغ',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'گیاهان مختلف',damage:'برگ‌خواری لارو',symptoms:'خسارت برگی',controlMethods:'Bt',quarantineStatus:'آفت معمولی'),
    'Arctia caja (Larve)': PestInfo(name:'Arctia caja (Larve)',commonName:'لارو پروانه خرسی',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'گیاهان مختلف',damage:'برگ‌خواری',symptoms:'لخت شدن گیاه',controlMethods:'جمع‌آوری دستی',quarantineStatus:'آفت معمولی'),
    'Argema mittrei': PestInfo(name:'Argema mittrei',commonName:'پروانه ماه ماداگاسکار',order:'Lepidoptera - پروانه‌سانان',distribution:'ماداگاسکار',hosts:'درختان گرمسیری',damage:'برگ‌خواری',symptoms:'خسارت برگی',controlMethods:'محافظت زیستگاه',quarantineStatus:'گونه نادر'),
    'Argema mittrei (Larve)': PestInfo(name:'Argema mittrei (Larve)',commonName:'لارو پروانه ماه',order:'Lepidoptera - پروانه‌سانان',distribution:'ماداگاسکار',hosts:'درختان گرمسیری',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'محافظت',quarantineStatus:'گونه نادر'),
    'Attacus atlas': PestInfo(name:'Attacus atlas',commonName:'پروانه اطلس',order:'Lepidoptera - پروانه‌سانان',distribution:'آسیای جنوب شرقی',hosts:'درختان گرمسیری',damage:'برگ‌خواری لارو',symptoms:'خسارت برگی',controlMethods:'حفاظت',quarantineStatus:'گونه بزرگ'),
    'Bactrocera cucurbitae': PestInfo(name:'Bactrocera cucurbitae',commonName:'مگس جالیز',order:'Diptera - دوبالان',distribution:'گرمسیری',hosts:'کدوییان',damage:'خسارت به میوه',symptoms:'پوسیدگی',controlMethods:'تله فرمونی',quarantineStatus:'قرنطینه‌ای'),
    'Bactrocera dorsalis': PestInfo(name:'Bactrocera dorsalis',commonName:'مگس میوه شرقی',order:'Diptera - دوبالان',distribution:'آسیا و آفریقا',hosts:'بیش از 300 گونه گیاهی',damage:'پوسیدگی میوه',symptoms:'لکه و سوراخ',controlMethods:'متیل اوژنول',quarantineStatus:'قرنطینه‌ای'),
    'Bactrocera tryoni': PestInfo(name:'Bactrocera tryoni',commonName:'مگس میوه کوئینزلند',order:'Diptera - دوبالان',distribution:'استرالیا',hosts:'انواع میوه',damage:'خسارت میوه',symptoms:'ریزش زودرس',controlMethods:'تله‌گذاری',quarantineStatus:'قرنطینه‌ای'),
    'Blitopertha orientalis': PestInfo(name:'Blitopertha orientalis',commonName:'سوسک شرقی',order:'Coleoptera - قاب‌بالان',distribution:'آسیا',hosts:'چمن و ریشه گیاهان',damage:'تغذیه از ریشه',symptoms:'زردی گیاه',controlMethods:'مدیریت خاک',quarantineStatus:'آفت مهم'),
    'Cabera variolaria': PestInfo(name:'Cabera variolaria',commonName:'پروانه خط‌دار',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'درختان جنگلی',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'کنترل طبیعی',quarantineStatus:'آفت جنگلی'),
    'Cacoecimorpha pronubana': PestInfo(name:'Cacoecimorpha pronubana',commonName:'برگ‌پیچ مدیترانه‌ای',order:'Lepidoptera - پروانه‌سانان',distribution:'مدیترانه',hosts:'گیاهان زراعی و زینتی',damage:'خسارت برگی',symptoms:'برگ پیچیده',controlMethods:'Bt',quarantineStatus:'آفت مهم'),
    'Cerambyx cerdo': PestInfo(name:'Cerambyx cerdo',commonName:'سوسک شاخک‌بلند بلوط',order:'Coleoptera - قاب‌بالان',distribution:'اروپا، آسیا',hosts:'بلوط',damage:'خسارت به چوب',symptoms:'دالان در تنه',controlMethods:'حفاظت جنگل',quarantineStatus:'گونه محافظت‌شده'),
    'Ceratitis cosyra': PestInfo(name:'Ceratitis cosyra',commonName:'مگس انبه',order:'Diptera - دوبالان',distribution:'آفریقا',hosts:'انبه',damage:'پوسیدگی میوه',symptoms:'سوراخ میوه',controlMethods:'تله و طعمه',quarantineStatus:'قرنطینه‌ای'),
    'Cerroneuroterus lanuginosus': PestInfo(name:'Cerroneuroterus lanuginosus',commonName:'زنبور گال‌ساز',order:'Hymenoptera - بال‌غشاییان',distribution:'اروپا، آسیا',hosts:'بلوط',damage:'تشکیل گال',symptoms:'برآمدگی برگ',controlMethods:'کنترل طبیعی',quarantineStatus:'آفت جنگلی'),
    'Cicadulina mbila': PestInfo(name:'Cicadulina mbila',commonName:'زنجرک ذرت',order:'Hemiptera - نیم‌بالان',distribution:'آفریقا',hosts:'ذرت',damage:'انتقال بیماری',symptoms:'کوتولگی',controlMethods:'کنترل ناقل',quarantineStatus:'آفت مهم'),
    'Conotrachelus nenuphar': PestInfo(name:'Conotrachelus nenuphar',commonName:'سرخرطومی آلو',order:'Coleoptera - قاب‌بالان',distribution:'آمریکای شمالی',hosts:'آلو و هلو',damage:'خسارت میوه',symptoms:'زخم هلالی',controlMethods:'سم‌پاشی',quarantineStatus:'قرنطینه‌ای'),
    'Cosmopolites sordidus': PestInfo(name:'Cosmopolites sordidus',commonName:'سوسک موز',order:'Coleoptera - قاب‌بالان',distribution:'مناطق موزکاری',hosts:'موز',damage:'خسارت ریزوم',symptoms:'ضعف بوته',controlMethods:'بهداشت مزرعه',quarantineStatus:'آفت مهم'),
    'Cryptoblabes gnidiella': PestInfo(name:'Cryptoblabes gnidiella',commonName:'بید خرما',order:'Lepidoptera - پروانه‌سانان',distribution:'مدیترانه',hosts:'خرما و انگور',damage:'خسارت خوشه',symptoms:'تار و فضولات',controlMethods:'تله فرمونی',quarantineStatus:'آفت مهم'),
    'Cryptolaemus montrouzieri': PestInfo(name:'Cryptolaemus montrouzieri',commonName:'کفشدوزک استرالیایی',order:'Coleoptera - قاب‌بالان',distribution:'استرالیا',hosts:'شپشک‌ها',damage:'شکار آفت',symptoms:'کنترل بیولوژیک',controlMethods:'رهاسازی',quarantineStatus:'دشمن طبیعی'),
    'Curculio glandium': PestInfo(name:'Curculio glandium',commonName:'سرخرطومی بلوط',order:'Coleoptera - قاب‌بالان',distribution:'اروپا، آسیا',hosts:'بلوط',damage:'خسارت به میوه',symptoms:'سوراخ بلوط',controlMethods:'جمع‌آوری',quarantineStatus:'آفت جنگلی'),
    'Cydia latiferreana': PestInfo(name:'Cydia latiferreana',commonName:'کرم گلوگاه انار',order:'Lepidoptera - پروانه‌سانان',distribution:'آسیا',hosts:'انار',damage:'خسارت میوه',symptoms:'پوسیدگی گلوگاه',controlMethods:'بهداشت باغ',quarantineStatus:'آفت مهم'),
    'Cydia pomonella': PestInfo(name:'Cydia pomonella',commonName:'کرم سیب',order:'Lepidoptera - پروانه‌سانان',distribution:'جهان‌گستر',hosts:'سیب، گلابی',damage:'خسارت میوه',symptoms:'کرم‌زدگی میوه',controlMethods:'تله فرمونی',quarantineStatus:'آفت مهم'),
    'Danaus plexippus': PestInfo(name:'Danaus plexippus',commonName:'پروانه شاه‌پروانه',order:'Lepidoptera - پروانه‌سانان',distribution:'آمریکای شمالی',hosts:'آسکلپیاس',damage:'برگ‌خواری',symptoms:'خسارت برگی',controlMethods:'حفاظت',quarantineStatus:'گونه مهاجر'),
    'Deilephila elpenor': PestInfo(name:'Deilephila elpenor',commonName:'پروانه بید فیل',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'انگلستان، فوکسیا',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'کنترل طبیعی',quarantineStatus:'آفت معمولی'),
    'Dendroctonus micans': PestInfo(name:'Dendroctonus micans',commonName:'سوسک پوست‌خوار صنوبر',order:'Coleoptera - قاب‌بالان',distribution:'اروپا و آسیا',hosts:'کاج و صنوبر',damage:'مرگ درخت',symptoms:'رزین و سوراخ',controlMethods:'کنترل بیولوژیک',quarantineStatus:'قرنطینه‌ای'),
    'Diatraea saccharalis': PestInfo(name:'Diatraea saccharalis',commonName:'کرم ساقه‌خوار نیشکر',order:'Lepidoptera - پروانه‌سانان',distribution:'قاره آمریکا',hosts:'نیشکر، ذرت',damage:'خسارت به ساقه',symptoms:'پوسیدگی و شکستگی ساقه',controlMethods:'کنترل بیولوژیک و زراعی',quarantineStatus:'آفت مهم'),
    'Dicranura ulmi': PestInfo(name:'Dicranura ulmi',commonName:'پروانه بید چنار',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'چنار',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'کنترل طبیعی',quarantineStatus:'آفت شهری'),
    'Dicycla oo': PestInfo(name:'Dicycla oo',commonName:'پروانه جغد',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا',hosts:'گیاهان علفی',damage:'برگ‌خواری',symptoms:'خسارت برگی',controlMethods:'طبیعی',quarantineStatus:'معمولی'),
    'Dinoptera collaris': PestInfo(name:'Dinoptera collaris',commonName:'سوسک چوب‌خوار',order:'Coleoptera - قاب‌بالان',distribution:'اروپا',hosts:'درختان جنگلی',damage:'خسارت چوب',symptoms:'دالان',controlMethods:'بهداشت جنگل',quarantineStatus:'جنگلی'),
    'Diprion pini': PestInfo(name:'Diprion pini',commonName:'اره‌مگس کاج',order:'Hymenoptera - بال‌غشاییان',distribution:'اروپا، آسیا',hosts:'کاج',damage:'برگ‌خواری',symptoms:'ریزش سوزن',controlMethods:'کنترل بیولوژیک',quarantineStatus:'آفت جنگلی'),
    'Earias fabia': PestInfo(name:'Earias fabia',commonName:'کرم غوزه بامیه',order:'Lepidoptera - پروانه‌سانان',distribution:'آسیا',hosts:'بامیه و پنبه',damage:'خسارت میوه',symptoms:'سوراخ و ریزش',controlMethods:'تله فرمونی',quarantineStatus:'آفت مهم'),
    'Epicometis hirta': PestInfo(name:'Epicometis hirta',commonName:'سوسک کرک‌دار',order:'Coleoptera - قاب‌بالان',distribution:'اروپا، آسیا',hosts:'گل‌ها',damage:'تغذیه از گل',symptoms:'خسارت گلبرگ',controlMethods:'جمع‌آوری',quarantineStatus:'معمولی'),
    'Epiphyas postvittana': PestInfo(name:'Epiphyas postvittana',commonName:'برگ‌پیچ استرالیایی',order:'Lepidoptera - پروانه‌سانان',distribution:'استرالیا',hosts:'بیش از 500 گیاه',damage:'خسارت برگ و میوه',symptoms:'پیچیدگی برگ',controlMethods:'Bt',quarantineStatus:'قرنطینه‌ای'),
    'Epitrix tuberis': PestInfo(name:'Epitrix tuberis',commonName:'کک سیب‌زمینی',order:'Coleoptera - قاب‌بالان',distribution:'آمریکا',hosts:'سیب‌زمینی',damage:'خسارت غده',symptoms:'سوراخ سطحی',controlMethods:'مدیریت زراعی',quarantineStatus:'قرنطینه‌ای'),
    'Eudocima fullonia': PestInfo(name:'Eudocima fullonia',commonName:'شب‌پره میوه‌خوار',order:'Lepidoptera - پروانه‌سانان',distribution:'گرمسیری',hosts:'مرکبات و انبه',damage:'مکیدن شیره میوه',symptoms:'زخم میوه',controlMethods:'تله نوری',quarantineStatus:'آفت مهم'),
    'Euproctis chrysorrhoea': PestInfo(name:'Euproctis chrysorrhoea',commonName:'پروانه دم‌طلایی',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'درختان میوه',damage:'برگ‌خواری',symptoms:'لخت شدن درخت',controlMethods:'Bt',quarantineStatus:'آفت مهم'),
    'Gilpinia hercyniae': PestInfo(name:'Gilpinia hercyniae',commonName:'اره‌مگس صنوبر',order:'Hymenoptera - بال‌غشاییان',distribution:'اروپا',hosts:'صنوبر',damage:'برگ‌خواری',symptoms:'ریزش سوزن‌ها',controlMethods:'کنترل بیولوژیک',quarantineStatus:'آفت جنگلی'),
    'Gonipterus scutellatus': PestInfo(name:'Gonipterus scutellatus',commonName:'سرخرطومی اکالیپتوس',order:'Coleoptera - قاب‌بالان',distribution:'استرالیا',hosts:'اکالیپتوس',damage:'برگ‌خواری',symptoms:'کاهش رشد',controlMethods:'زنبور پارازیتوئید',quarantineStatus:'قرنطینه‌ای'),
    'Gypsonoma aceriana': PestInfo(name:'Gypsonoma aceriana',commonName:'برگ‌پیچ افرا',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا',hosts:'افرا',damage:'برگ‌خواری',symptoms:'پیچیدگی برگ',controlMethods:'Bt',quarantineStatus:'آفت شهری'),
    'Harpyia milhauseri': PestInfo(name:'Harpyia milhauseri',commonName:'پروانه جغد بزرگ',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'درختان',damage:'برگ‌خواری لارو',symptoms:'خسارت برگی',controlMethods:'طبیعی',quarantineStatus:'معمولی'),
    'Helicoverpa zea': PestInfo(name:'Helicoverpa zea',commonName:'کرم بلال ذرت',order:'Lepidoptera - پروانه‌سانان',distribution:'قاره آمریکا',hosts:'ذرت و پنبه',damage:'خسارت زایشی',symptoms:'سوراخ بلال',controlMethods:'Bt',quarantineStatus:'آفت مهم'),
    'Hesperophanes sericeus': PestInfo(name:'Hesperophanes sericeus',commonName:'سوسک ابریشمی',order:'Coleoptera - قاب‌بالان',distribution:'اروپا',hosts:'درختان',damage:'خسارت چوب',symptoms:'دالان',controlMethods:'بهداشت جنگل',quarantineStatus:'جنگلی'),
    'Hyles lineata': PestInfo(name:'Hyles lineata',commonName:'پروانه بید خط‌دار',order:'Lepidoptera - پروانه‌سانان',distribution:'آمریکا',hosts:'گیاهان مختلف',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'طبیعی',quarantineStatus:'معمولی'),
    'Hylesinus varius': PestInfo(name:'Hylesinus varius',commonName:'سوسک پوست‌خوار',order:'Coleoptera - قاب‌بالان',distribution:'اروپا',hosts:'زیتون',damage:'خسارت به تنه',symptoms:'دالان',controlMethods:'هرس',quarantineStatus:'آفت زیتون'),
    'Lachnus roboris': PestInfo(name:'Lachnus roboris',commonName:'شپشک بلوط',order:'Hemiptera - نیم‌بالان',distribution:'اروپا',hosts:'بلوط',damage:'مکیدن شیره',symptoms:'ضعف درخت',controlMethods:'کنترل طبیعی',quarantineStatus:'جنگلی'),
    'Lampetis mimosa': PestInfo(name:'Lampetis mimosa',commonName:'سوسک چوب‌خوار',order:'Coleoptera - قاب‌بالان',distribution:'آسیا',hosts:'درختان',damage:'خسارت چوب',symptoms:'دالان',controlMethods:'بهداشت',quarantineStatus:'جنگلی'),
    'Liriomyza huidobrensis': PestInfo(name:'Liriomyza huidobrensis',commonName:'مینوز برگ',order:'Diptera - دوبالان',distribution:'جهان‌گستر',hosts:'سبزیجات و گل‌ها',damage:'مینوز برگ',symptoms:'دالان سفید',controlMethods:'کنترل بیولوژیک',quarantineStatus:'قرنطینه‌ای'),
    'Lyctus brunneus': PestInfo(name:'Lyctus brunneus',commonName:'سوسک پودرچوب',order:'Coleoptera - قاب‌بالان',distribution:'جهان‌گستر',hosts:'چوب خشک',damage:'خسارت به چوب',symptoms:'سوراخ ریز',controlMethods:'سم‌پاشی چوب',quarantineStatus:'آفت انباری'),
    'Lymantria dispar': PestInfo(name:'Lymantria dispar',commonName:'پروانه کولی',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'درختان جنگلی',damage:'برگ‌خواری شدید',symptoms:'لخت شدن درخت',controlMethods:'Bt',quarantineStatus:'قرنطینه‌ای'),
    'Lymantria monacha': PestInfo(name:'Lymantria monacha',commonName:'پروانه راهبه',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا و آسیا',hosts:'درختان جنگلی',damage:'برگ‌خواری شدید',symptoms:'لخت شدن درخت',controlMethods:'Bt',quarantineStatus:'قرنطینه‌ای'),
    'Macroglossum stellatarum': PestInfo(name:'Macroglossum stellatarum',commonName:'پروانه بید ستاره‌ای',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'گل‌ها',damage:'تغذیه از شهد',symptoms:'خسارت گل',controlMethods:'طبیعی',quarantineStatus:'معمولی'),
    'Metamasius hemipterus': PestInfo(name:'Metamasius hemipterus',commonName:'سرخرطومی نخل',order:'Coleoptera - قاب‌بالان',distribution:'گرمسیری',hosts:'نخل',damage:'خسارت به تنه',symptoms:'پوسیدگی',controlMethods:'تله فرمونی',quarantineStatus:'آفت نخل'),
    'Monochamus alternatus': PestInfo(name:'Monochamus alternatus',commonName:'سوسک کاج ژاپنی',order:'Coleoptera - قاب‌بالان',distribution:'شرق آسیا',hosts:'کاج',damage:'ناقل نماتد کاج',symptoms:'خشکیدگی',controlMethods:'قطع درخت آلوده',quarantineStatus:'قرنطینه‌ای'),
    'Monochamus urussovi': PestInfo(name:'Monochamus urussovi',commonName:'سوسک شاخک‌بلند مخروطیان',order:'Coleoptera - قاب‌بالان',distribution:'روسیه و آسیا',hosts:'مخروطیان',damage:'خسارت چوب',symptoms:'سوراخ تنه',controlMethods:'مدیریت جنگل',quarantineStatus:'آفت جنگلی'),
    'Nezara viridula': PestInfo(name:'Nezara viridula',commonName:'سنه سبز',order:'Hemiptera - نیم‌بالان',distribution:'جهان‌گستر',hosts:'حبوبات',damage:'مکیدن شیره',symptoms:'لکه میوه',controlMethods:'کنترل بیولوژیک',quarantineStatus:'آفت مهم'),
    'Nycteola asiatica': PestInfo(name:'Nycteola asiatica',commonName:'پروانه بید آسیایی',order:'Lepidoptera - پروانه‌سانان',distribution:'آسیا',hosts:'درختان',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'طبیعی',quarantineStatus:'معمولی'),
    'Nymphalis antiopa': PestInfo(name:'Nymphalis antiopa',commonName:'پروانه سوگواری',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'درختان',damage:'برگ‌خواری لارو',symptoms:'خسارت برگی',controlMethods:'طبیعی',quarantineStatus:'معمولی'),
    'Opodiphthera astrophela': PestInfo(name:'Opodiphthera astrophela',commonName:'پروانه اطلس استرالیایی',order:'Lepidoptera - پروانه‌سانان',distribution:'استرالیا',hosts:'درختان',damage:'برگ‌خواری',symptoms:'خسارت برگی',controlMethods:'حفاظت',quarantineStatus:'گونه بزرگ'),
    'Opodiphthera eucalypti': PestInfo(name:'Opodiphthera eucalypti',commonName:'پروانه اکالیپتوس',order:'Lepidoptera - پروانه‌سانان',distribution:'استرالیا',hosts:'اکالیپتوس',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'حفاظت',quarantineStatus:'بومی'),
    'Osphranteria coerulescens': PestInfo(name:'Osphranteria coerulescens',commonName:'سوسک آبی',order:'Coleoptera - قاب‌بالان',distribution:'اروپا',hosts:'گیاهان مختلف',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'جمع‌آوری',quarantineStatus:'معمولی'),
    'Otiorhynchus sulcatus': PestInfo(name:'Otiorhynchus sulcatus',commonName:'سرخرطومی شیاردار',order:'Coleoptera - قاب‌بالان',distribution:'اروپا',hosts:'درختان میوه',damage:'خسارت میوه و ریشه',symptoms:'سوراخ و لکه',controlMethods:'سم‌پاشی و کنترل بیولوژیک',quarantineStatus:'آفت میوه'),
    'Palpita unionalis': PestInfo(name:'Palpita unionalis',commonName:'پروانه زیتون',order:'Lepidoptera - پروانه‌سانان',distribution:'آسیا',hosts:'زیتون',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'Bt',quarantineStatus:'آفت زیتون'),
    'Papilio glaucus': PestInfo(name:'Papilio glaucus',commonName:'پروانه دم‌چلچله‌ای',order:'Lepidoptera - پروانه‌سانان',distribution:'آمریکای شمالی',hosts:'درختان',damage:'برگ‌خواری',symptoms:'خسارت برگی',controlMethods:'حفاظت',quarantineStatus:'زیبا'),
    'Perkinsiella saccharicida': PestInfo(name:'Perkinsiella saccharicida',commonName:'زنجرک نیشکر',order:'Hemiptera - نیم‌بالان',distribution:'اقیانوسیه',hosts:'نیشکر',damage:'انتقال ویروس',symptoms:'ضعف گیاه',controlMethods:'کنترل ناقل',quarantineStatus:'آفت مهم'),
    'Pissodes castaneus': PestInfo(name:'Pissodes castaneus',commonName:'سرخرطومی کاج',order:'Coleoptera - قاب‌بالان',distribution:'اروپا',hosts:'کاج',damage:'خسارت ساقه',symptoms:'خشکیدگی',controlMethods:'بهداشت جنگل',quarantineStatus:'قرنطینه‌ای'),
    'Platypus cylindrus': PestInfo(name:'Platypus cylindrus',commonName:'سوسک استوانه‌ای',order:'Coleoptera - قاب‌بالان',distribution:'اروپا',hosts:'بلوط',damage:'خسارت چوب',symptoms:'دالان',controlMethods:'بهداشت',quarantineStatus:'جنگلی'),
    'Popillia japonica': PestInfo(name:'Popillia japonica',commonName:'سوسک ژاپنی',order:'Coleoptera - قاب‌بالان',distribution:'ژاپن و آمریکا',hosts:'بیش از 300 گیاه',damage:'برگ‌خواری',symptoms:'اسکلت برگ',controlMethods:'تله و کنترل بیولوژیک',quarantineStatus:'قرنطینه‌ای'),
    'Prays oleae': PestInfo(name:'Prays oleae',commonName:'بید زیتون',order:'Lepidoptera - پروانه‌سانان',distribution:'مدیترانه',hosts:'زیتون',damage:'خسارت گل و میوه',symptoms:'ریزش میوه',controlMethods:'تله فرمونی',quarantineStatus:'آفت مهم'),
    'Pristiphora abietina': PestInfo(name:'Pristiphora abietina',commonName:'اره‌مگس صنوبر نروژی',order:'Hymenoptera - بال‌غشاییان',distribution:'اروپا',hosts:'صنوبر',damage:'برگ‌خواری',symptoms:'قهوه‌ای شدن سوزن',controlMethods:'کنترل بیولوژیک',quarantineStatus:'آفت جنگلی'),
    'Psalmocharias alhageos': PestInfo(name:'Psalmocharias alhageos',commonName:'پروانه بید',order:'Lepidoptera - پروانه‌سانان',distribution:'آسیا',hosts:'گیاهان مختلف',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'طبیعی',quarantineStatus:'معمولی'),
    'Rhagoletis pomonella': PestInfo(name:'Rhagoletis pomonella',commonName:'مگس سیب',order:'Diptera - دوبالان',distribution:'آمریکای شمالی',hosts:'سیب',damage:'خسارت میوه',symptoms:'کرم‌زدگی',controlMethods:'تله',quarantineStatus:'قرنطینه‌ای'),
    'Saturnia pavonia': PestInfo(name:'Saturnia pavonia',commonName:'پروانه چشم‌طاووسی کوچک',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'درختان',damage:'برگ‌خواری',symptoms:'خسارت برگی',controlMethods:'حفاظت',quarantineStatus:'زیبا'),
    'Schinia arcigera': PestInfo(name:'Schinia arcigera',commonName:'پروانه گل‌خوار',order:'Lepidoptera - پروانه‌سانان',distribution:'آمریکا',hosts:'گل‌ها',damage:'تغذیه از گل',symptoms:'خسارت گلبرگ',controlMethods:'طبیعی',quarantineStatus:'معمولی'),
    'Sirex noctilio': PestInfo(name:'Sirex noctilio',commonName:'زنبور چوب‌خوار',order:'Hymenoptera - بال‌غشاییان',distribution:'اروپا، آسیا',hosts:'کاج',damage:'خسارت به چوب',symptoms:'دالان',controlMethods:'کنترل بیولوژیک',quarantineStatus:'قرنطینه‌ای'),
    'Smerinthus ocellata': PestInfo(name:'Smerinthus ocellata',commonName:'پروانه بید چشم‌دار',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'درختان',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'طبیعی',quarantineStatus:'معمولی'),
    'Sphrageidus similis': PestInfo(name:'Sphrageidus similis',commonName:'شب‌پره زرد',order:'Lepidoptera - پروانه‌سانان',distribution:'آسیا',hosts:'گیاهان مختلف',damage:'برگ‌خواری لارو',symptoms:'خسارت برگی',controlMethods:'کنترل طبیعی',quarantineStatus:'معمولی'),
    'Spodoptera eridania': PestInfo(name:'Spodoptera eridania',commonName:'کرم برگ‌خوار جنوبی',order:'Lepidoptera - پروانه‌سانان',distribution:'آمریکا',hosts:'سبزیجات',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'Bt',quarantineStatus:'آفت مهم'),
    'Spodoptera exigua': PestInfo(name:'Spodoptera exigua',commonName:'کرم برگ‌خوار چغندر',order:'Lepidoptera - پروانه‌سانان',distribution:'جهان‌گستر',hosts:'سبزیجات',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'Bt',quarantineStatus:'آفت مهم'),
    'Spodoptera frugiperda': PestInfo(name:'Spodoptera frugiperda',commonName:'کرم برگخوار پاییزه',order:'Lepidoptera - پروانه‌سانان',distribution:'جهان‌گستر',hosts:'ذرت و غلات',damage:'خسارت شدید مزرعه',symptoms:'پارگی برگ',controlMethods:'IPM و Bt',quarantineStatus:'قرنطینه‌ای'),
    'Spoladea recurvalis': PestInfo(name:'Spoladea recurvalis',commonName:'پروانه چغندر',order:'Lepidoptera - پروانه‌سانان',distribution:'گرمسیری',hosts:'چغندر',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'Bt',quarantineStatus:'آفت مهم'),
    'Sternochetus mangiferae': PestInfo(name:'Sternochetus mangiferae',commonName:'سرخرطومی هسته انبه',order:'Coleoptera - قاب‌بالان',distribution:'مناطق انبه‌خیز',hosts:'انبه',damage:'خسارت هسته',symptoms:'کاهش کیفیت',controlMethods:'قرنطینه و بهداشت',quarantineStatus:'قرنطینه‌ای'),
    'Stromatium auratum': PestInfo(name:'Stromatium auratum',commonName:'سوسک طلایی',order:'Coleoptera - قاب‌بالان',distribution:'آسیا',hosts:'درختان',damage:'خسارت چوب',symptoms:'دالان',controlMethods:'بهداشت',quarantineStatus:'جنگلی'),
    'Stromatium fulvum': PestInfo(name:'Stromatium fulvum',commonName:'سوسک قهوه‌ای',order:'Coleoptera - قاب‌بالان',distribution:'آسیا',hosts:'درختان',damage:'خسارت چوب',symptoms:'دالان',controlMethods:'بهداشت',quarantineStatus:'جنگلی'),
    'Synanthedon pyri': PestInfo(name:'Synanthedon pyri',commonName:'پروانه شفاف گلابی',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا',hosts:'گلابی',damage:'خسارت به تنه',symptoms:'دالان',controlMethods:'تله فرمونی',quarantineStatus:'آفت میوه'),
    'Synanthedon tipuliformis': PestInfo(name:'Synanthedon tipuliformis',commonName:'پروانه شفاف انگور',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا',hosts:'انگور',damage:'خسارت به ساقه',symptoms:'خشکیدگی',controlMethods:'تله فرمونی',quarantineStatus:'آفت انگور'),
    'Tabanus atratus': PestInfo(name:'Tabanus atratus',commonName:'مگس اسب',order:'Diptera - دوبالان',distribution:'جهان‌گستر',hosts:'دام',damage:'نیش زدن',symptoms:'آزار دام',controlMethods:'تله',quarantineStatus:'آفت دام'),
    'Thaumatopoea pityocampa': PestInfo(name:'Thaumatopoea pityocampa',commonName:'پروانه ابریشم‌باف کاج',order:'Lepidoptera - پروانه‌سانان',distribution:'مدیترانه',hosts:'کاج',damage:'برگ‌خواری',symptoms:'لانه‌های ابریشمی',controlMethods:'Bt',quarantineStatus:'آفت جنگلی'),
    'Thaumetopoea processionea': PestInfo(name:'Thaumetopoea processionea',commonName:'پروانه فرآیندی بلوط',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا',hosts:'بلوط',damage:'برگ‌خواری',symptoms:'لانه ابریشمی',controlMethods:'Bt',quarantineStatus:'آفت جنگلی'),
    'Tortrix viridana': PestInfo(name:'Tortrix viridana',commonName:'برگ‌پیچ سبز بلوط',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا',hosts:'بلوط',damage:'برگ‌خواری',symptoms:'پیچیدگی برگ',controlMethods:'Bt',quarantineStatus:'آفت جنگلی'),
    'Trirachys sartus': PestInfo(name:'Trirachys sartus',commonName:'سوسک چوب‌خوار',order:'Coleoptera - قاب‌بالان',distribution:'آسیا',hosts:'درختان',damage:'خسارت چوب',symptoms:'دالان',controlMethods:'بهداشت',quarantineStatus:'جنگلی'),
    'Tyria jacobaeae': PestInfo(name:'Tyria jacobaeae',commonName:'پروانه زنگ‌وله',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا',hosts:'زنگ‌وله',damage:'برگ‌خواری',symptoms:'خسارت برگی',controlMethods:'حفاظت',quarantineStatus:'زیبا'),
    'Tyria jacobaeae (Adult)': PestInfo(name:'Tyria jacobaeae (Adult)',commonName:'پروانه زنگ‌وله بالغ',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا',hosts:'زنگ‌وله',damage:'برگ‌خواری',symptoms:'خسارت برگی',controlMethods:'حفاظت',quarantineStatus:'زیبا'),
    'Vanessa atalanta': PestInfo(name:'Vanessa atalanta',commonName:'پروانه دریاسالار',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'گیاهان مختلف',damage:'برگ‌خواری',symptoms:'خسارت برگی',controlMethods:'حفاظت',quarantineStatus:'مهاجر'),
    'Vanessa cardui': PestInfo(name:'Vanessa cardui',commonName:'پروانه رنگین‌کمان',order:'Lepidoptera - پروانه‌سانان',distribution:'جهان‌گستر',hosts:'گیاهان مختلف',damage:'برگ‌خواری',symptoms:'خسارت برگی',controlMethods:'حفاظت',quarantineStatus:'مهاجر'),
    'Vanessa tameamea': PestInfo(name:'Vanessa tameamea',commonName:'پروانه هاوایی',order:'Lepidoptera - پروانه‌سانان',distribution:'هاوایی',hosts:'گیاهان بومی',damage:'برگ‌خواری',symptoms:'خسارت برگی',controlMethods:'حفاظت',quarantineStatus:'بومی'),
    'Vespa crabro': PestInfo(name:'Vespa crabro',commonName:'زنبور سرخ',order:'Hymenoptera - بال‌غشاییان',distribution:'اروپا، آسیا',hosts:'حشرات دیگر',damage:'شکار زنبور عسل',symptoms:'حمله به کندو',controlMethods:'تخریب لانه',quarantineStatus:'آفت زنبورداری'),
    'Vespula germanica': PestInfo(name:'Vespula germanica',commonName:'زنبور زرد آلمانی',order:'Hymenoptera - بال‌غشاییان',distribution:'اروپا',hosts:'حشرات، میوه',damage:'آزار انسان',symptoms:'نیش زدن',controlMethods:'تخریب لانه',quarantineStatus:'آفت شهری'),
    'Vespula maculifrons': PestInfo(name:'Vespula maculifrons',commonName:'زنبور زرد',order:'Hymenoptera - بال‌غشاییان',distribution:'آمریکای شمالی',hosts:'حشرات، میوه',damage:'آزار انسان',symptoms:'نیش زدن',controlMethods:'تخریب لانه',quarantineStatus:'آفت شهری'),
    'Viteus vitifoliae': PestInfo(name:'Viteus vitifoliae',commonName:'فیلوکسرا مو',order:'Hemiptera - نیم‌بالان',distribution:'جهان‌گستر',hosts:'انگور',damage:'خسارت ریشه',symptoms:'گره‌های ریشه',controlMethods:'پایه مقاوم',quarantineStatus:'قرنطینه‌ای'),
    'Xanthogaleruca luteola': PestInfo(name:'Xanthogaleruca luteola',commonName:'سوسک زرد چنار',order:'Coleoptera - قاب‌بالان',distribution:'اروپا',hosts:'چنار',damage:'برگ‌خواری',symptoms:'اسکلت برگ',controlMethods:'سم‌پاشی',quarantineStatus:'آفت شهری'),
    'Xylocopa valga': PestInfo(name:'Xylocopa valga',commonName:'زنبور درشت نجار',order:'Hymenoptera - بال‌غشاییان',distribution:'اروپا، آسیا',hosts:'چوب',damage:'حفر لانه در چوب',symptoms:'سوراخ چوب',controlMethods:'پر کردن سوراخ',quarantineStatus:'مفید'),
    'Xylotrechus arvicola': PestInfo(name:'Xylotrechus arvicola',commonName:'سوسک چوب‌خوار',order:'Coleoptera - قاب‌بالان',distribution:'اروپا',hosts:'درختان میوه',damage:'خسارت چوب',symptoms:'دالان',controlMethods:'بهداشت باغ',quarantineStatus:'آفت میوه'),
    'Yponomeuta padella': PestInfo(name:'Yponomeuta padella',commonName:'پروانه چادر سیب',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'سیب',damage:'برگ‌خواری',symptoms:'چادر ابریشمی',controlMethods:'Bt',quarantineStatus:'آفت میوه'),
    'Yponomeuta padella (Larve)': PestInfo(name:'Yponomeuta padella (Larve)',commonName:'لارو پروانه چادر',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'سیب',damage:'برگ‌خواری',symptoms:'چادر ابریشمی',controlMethods:'جمع‌آوری',quarantineStatus:'آفت میوه'),
    'Zeuzera pyrina': PestInfo(name:'Zeuzera pyrina',commonName:'پروانه چوب‌خوار',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا، آسیا',hosts:'درختان میوه',damage:'خسارت به شاخه',symptoms:'خشکیدگی شاخه',controlMethods:'هرس',quarantineStatus:'آفت مهم'),
    'Spodoptera litura': PestInfo(name:'Spodoptera litura',commonName:'کرم برگ‌خوار تنباکو',order:'Lepidoptera - پروانه‌سانان',distribution:'آسیا',hosts:'تنباکو، پنبه',damage:'برگ‌خواری شدید',symptoms:'لخت شدن گیاه',controlMethods:'Bt و سم‌پاشی',quarantineStatus:'آفت مهم'),
  };

  static Future<void> loadLabels() async {
    try {
      String labelsText = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsText.split('\n').where((s) => s.trim().isNotEmpty).map((s) => s.trim()).toList();
      print('✅ تعداد برچسب‌ها بارگذاری شده: ${_labels.length}');
    } catch (e) {
      throw Exception('خطا در بارگذاری فایل labels.txt: $e');
    }
  }

  static PestInfo? getPestByIndex(int index) {
    if (index < 0 || index >= _labels.length) return null;
    String label = _labels[index];
    return _pestsMap[label];
  }

  static int get length => _labels.length;
}

// ==================== نتایج تشخیص ====================
class ClassificationResult {
  final PestInfo pestInfo;
  final double confidence;
  final int rank;

  ClassificationResult({
    required this.pestInfo,
    required this.confidence,
    required this.rank,
  });
}

class TopPredictions {
  final List<ClassificationResult> predictions;
  TopPredictions(this.predictions);
  ClassificationResult? get top => predictions.isNotEmpty ? predictions.first : null;
}

// ==================== سرویس تشخیص ====================
class ClassifierService {
  Interpreter? _interpreter;
  final int _inputSize = 224;
  final int _numClasses = 119;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/QU_Pests_119Classes_float16.tflite');
      await PestDatabase.loadLabels();
    } catch (e) {
      throw Exception('خطا در بارگذاری مدل: $e');
    }
  }

  Future<TopPredictions?> classifyImage(File imageFile) async {
    if (_interpreter == null) return null;

    try {
      img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
      if (image == null) return null;

      img.Image resized = img.copyResize(image, width: _inputSize, height: _inputSize);

      var input = List.filled(1 * _inputSize * _inputSize * 3, 0.0)
          .reshape([1, _inputSize, _inputSize, 3]);
      for (int y = 0; y < _inputSize; y++) {
        for (int x = 0; x < _inputSize; x++) {
          var pixel = resized.getPixel(x, y);
          input[0][y][x][0] = pixel.r / 255.0;
          input[0][y][x][1] = pixel.g / 255.0;
          input[0][y][x][2] = pixel.b / 255.0;
        }
      }

      var output = List.filled(1 * _numClasses, 0.0).reshape([1, _numClasses]);
      _interpreter!.run(input, output);

      List<MapEntry<int, double>> allPredictions = [];
      for (int i = 0; i < _numClasses; i++) {
        allPredictions.add(MapEntry(i, output[0][i]));
      }
      allPredictions.sort((a, b) => b.value.compareTo(a.value));

      List<ClassificationResult> top3 = [];
      for (int i = 0; i < 3 && i < allPredictions.length; i++) {
        int index = allPredictions[i].key;
        double confidence = allPredictions[i].value;
        PestInfo? pest = PestDatabase.getPestByIndex(index);
        if (pest != null) {
          top3.add(ClassificationResult(
            pestInfo: pest,
            confidence: confidence,
            rank: i + 1,
          ));
        }
      }

      return TopPredictions(top3);
    } catch (e) {
      throw Exception('خطا در پردازش: $e');
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}

// ==================== اپلیکیشن ====================
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تشخیص حشرات چهارمحال و بختیاری',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ==================== صفحه اصلی ====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ClassifierService _classifier = ClassifierService();
  File? _imageFile;
  bool _isProcessing = false;
  bool _modelLoaded = false;
  TopPredictions? _predictions;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await _classifier.loadModel();
      setState(() => _modelLoaded = true);
    } catch (e) {
      _showError('خطا در بارگذاری مدل: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (!_modelLoaded) {
      _showError('مدل هنوز آماده نیست. لطفاً صبر کنید.');
      return;
    }

    final pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 95);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isProcessing = true;
        _predictions = null;
      });

      try {
        final result = await _classifier.classifyImage(_imageFile!);
        if (!mounted) return;

        if (result != null && result.top != null) {
          setState(() {
            _predictions = result;
            _isProcessing = false;
          });
        } else {
          _showError('تشخیص ممکن نبود. لطفاً تصویر بهتری انتخاب کنید.');
        }
      } catch (e) {
        _showError(e.toString());
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _classifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'بخش تحقیقات جنگل و مرتع\nچهارمحال و بختیاری',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'تشخیص ۱۱۹ گونه حشره',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _imageFile != null
                                ? Image.file(_imageFile!, height: 280, width: double.infinity, fit: BoxFit.cover)
                                : Container(
                                    height: 280,
                                    color: Colors.green.shade50,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.bug_report_outlined, size: 100, color: Colors.green.shade300),
                                        const SizedBox(height: 16),
                                        Text('تصویر حشره را انتخاب کنید', style: TextStyle(color: Colors.green.shade700)),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _isProcessing || !_modelLoaded ? null : () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt, size: 20),
                              label: const Text('دوربین'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _isProcessing || !_modelLoaded ? null : () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library, size: 20),
                              label: const Text('گالری'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (_isProcessing) ...[
                          const CircularProgressIndicator(color: Colors.green),
                          const SizedBox(height: 12),
                          const Text('در حال تحلیل تصویر...', style: TextStyle(fontSize: 16, color: Colors.green)),
                          const SizedBox(height: 20),
                        ],
                        if (_predictions != null && !_isProcessing) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.green.shade400, Colors.green.shade600],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.verified, color: Colors.white, size: 28),
                                    const SizedBox(width: 8),
                                    Text(
                                      'تشخیص اول (${(_predictions!.top!.confidence * 100).toStringAsFixed(1)}%)',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _predictions!.top!.pestInfo.commonName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  _predictions!.top!.pestInfo.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white70,
                                  ),
                                ),
                                const Divider(color: Colors.white30, height: 24),
                                _buildDetailRow(Icons.category, 'راسته', _predictions!.top!.pestInfo.order),
                                _buildDetailRow(Icons.public, 'پراکنش', _predictions!.top!.pestInfo.distribution),
                                _buildDetailRow(Icons.eco, 'میزبان‌ها', _predictions!.top!.pestInfo.hosts),
                                _buildDetailRow(Icons.warning_amber, 'خسارت', _predictions!.top!.pestInfo.damage),
                                _buildDetailRow(Icons.visibility, 'علائم', _predictions!.top!.pestInfo.symptoms),
                                _buildDetailRow(Icons.shield, 'کنترل', _predictions!.top!.pestInfo.controlMethods),
                                _buildDetailRow(Icons.gavel, 'قرنطینه', _predictions!.top!.pestInfo.quarantineStatus),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_predictions!.predictions.length > 1)
                            _buildSecondaryPrediction(_predictions!.predictions[1]),
                          const SizedBox(height: 8),
                          if (_predictions!.predictions.length > 2)
                            _buildSecondaryPrediction(_predictions!.predictions[2]),
                          const SizedBox(height: 20),
                        ],
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade300, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb_outline, color: Colors.amber.shade700, size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('💡 نکته مهم:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                                    const SizedBox(height: 4),
                                    Text(
                                      'برای تشخیص دقیق‌تر، از حشره با کیفیت بالا و نور مناسب عکس بگیرید. حشره باید واضح و در مرکز تصویر باشد.',
                                      style: TextStyle(fontSize: 13, color: Colors.amber.shade800, height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: const Text(
                  'توسعه دهنده: تورج مختارپور',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryPrediction(ClassificationResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: result.rank == 2 ? Colors.blue.shade100 : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                '${result.rank}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: result.rank == 2 ? Colors.blue.shade700 : Colors.orange.shade700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.pestInfo.commonName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  result.pestInfo.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: result.rank == 2 ? Colors.blue.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: result.rank == 2 ? Colors.blue.shade200 : Colors.orange.shade200,
              ),
            ),
            child: Text(
              '${(result.confidence * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: result.rank == 2 ? Colors.blue.shade700 : Colors.orange.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
