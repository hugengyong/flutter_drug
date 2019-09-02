import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_drug/ui/page/add_patient_page.dart';
import 'package:flutter_drug/ui/page/prescription/prescription_sample_page.dart';
import 'package:flutter_drug/ui/page/prescription/take_prescription_page.dart';
import 'package:flutter_drug/ui/page/setting_page.dart';
import 'package:flutter_drug/ui/page/splash.dart';
import 'package:flutter_drug/ui/page/tab/tab_navigator.dart';
import 'package:flutter_drug/ui/page/test.dart';
import 'package:flutter_drug/ui/page/user/decoct_manage_page.dart';
import 'package:flutter_drug/ui/page/user/my_account_page.dart';
import 'package:flutter_drug/ui/page/user/packet_rule_page.dart';
import 'package:flutter_drug/ui/page/user/user_info_page.dart';
import 'package:flutter_drug/ui/widget/page_route_anim.dart';


class RouteName {
  static const String splash = 'splash';
  static const String tab = '/';
  static const String addPatient = 'addPatient';
  static const String takePrescription = 'takePrescription';
  static const String prescriptionSample = 'prescriptionSample';
  static const String test = 'test';
  static const String homeSecondFloor = 'homeSecondFloor';
  static const String login = 'login';
  static const String register = 'register';
  static const String myAccount = 'myAccount';
  static const String packetRule = 'packetRule';
  static const String userInfo = 'userInfo';
  static const String decoct = 'decoct';
  static const String articleDetail = 'articleDetail';
  static const String structureList = 'structureList';
  static const String favouriteList = 'favouriteList';
  static const String setting = 'setting';
  static const String coinRecordList = 'coinRecordList';
  static const String coinRankingList = 'coinRankingList';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return NoAnimRouteBuilder(SplashPage());
      case RouteName.tab:
        return NoAnimRouteBuilder(TabNavigator());
      case RouteName.addPatient:
        return CupertinoPageRoute(builder: (_) => AddPatientPage());
      case RouteName.takePrescription:
        return CupertinoPageRoute(builder: (_) => TakePrescriptionPage());
      case RouteName.prescriptionSample:
        return CupertinoPageRoute(builder: (_) => PrescriptionSamplePage());
      case RouteName.test:
        return NoAnimRouteBuilder(TestPage());
//      case RouteName.homeSecondFloor:
//        return SlideTopRouteBuilder(MyBlogPage());
//      case RouteName.login:
//        return CupertinoPageRoute(
//            fullscreenDialog: true, builder: (_) => LoginPage());
//      case RouteName.register:
//        return CupertinoPageRoute(builder: (_) => RegisterPage());
//      case RouteName.articleDetail:
//        var article = settings.arguments as Article;
//        return CupertinoPageRoute(builder: (_) {
//          // 根据配置调用页面
//          return StorageManager.sharedPreferences.getBool(kUseWebViewPlugin) ??
//                  false
//              ? ArticleDetailPluginPage(
//                  article: article,
//                )
//              : ArticleDetailPage(
//                  article: article,
//                );
//        });
//      case RouteName.structureList:
//        var list = settings.arguments as List;
//        Tree tree = list[0] as Tree;
//        int index = list[1];
//        return CupertinoPageRoute(
//            builder: (_) => ArticleCategoryTabPage(tree, index));
      case RouteName.packetRule:
        return CupertinoPageRoute(builder: (_) => PacketRulePage(url: settings.arguments as String));
      case RouteName.myAccount:
        return CupertinoPageRoute(builder: (_) => MyAccountPage());
      case RouteName.decoct:
        return CupertinoPageRoute(builder: (_) => DecoctManagePage());
      case RouteName.setting:
        return CupertinoPageRoute(builder: (_) => SettingPage());
      case RouteName.userInfo:
        return CupertinoPageRoute(builder: (_) => UserInfoPage());
//      case RouteName.coinRankingList:
//        return CupertinoPageRoute(builder: (_) => CoinRankingListPage());
      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

/// Pop路由
class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
