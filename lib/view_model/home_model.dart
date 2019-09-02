

import 'package:flutter_drug/model/banner.dart';
import 'package:flutter_drug/provider/view_state_refresh_list_model.dart';
import 'package:flutter_drug/service/wan_android_repository.dart';

class HomeModel extends ViewStateRefreshListModel {
  List<Banner> _banners;

  List<Banner> get banners => _banners;

  @override
  Future<List> loadData({int pageNum}) async {
    List<Future> futures = [];
    if (pageNum == ViewStateRefreshListModel.pageNumFirst) {
      futures.add(WanAndroidRepository.fetchBanners());
//      futures.add(WanAndroidRepository.fetchTopArticles());
    }
//    futures.add(WanAndroidRepository.fetchArticles(pageNum));

    var result = await Future.wait(futures);
    if (pageNum == ViewStateRefreshListModel.pageNumFirst) {
      _banners = result[0];
//      _topArticles = result[1];
      return result[0];
    } else {
      return result[0];
    }

//    if (pageNum == BaseListModel.pageNumFirst) {
//      _banners = await WanAndroidRepository.fetchBanners();
//      _topArticles = await WanAndroidRepository.fetchTopArticles();
//    }
//    return await WanAndroidRepository.fetchArticles(pageNum);
  }
}
