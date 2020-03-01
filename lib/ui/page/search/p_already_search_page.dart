import 'package:flutter/material.dart';
import 'package:flutter_drug/provider/provider_widget.dart';
import 'package:flutter_drug/provider/view_state_widget.dart';
import 'package:flutter_drug/ui/page/prescription/p_list_page.dart';
import 'package:flutter_drug/ui/widget/search_bar.dart';
import 'package:flutter_drug/view_model/prescription_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PrescriptionAlreadySearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<PrescriptionListModel>(
      model: PrescriptionListModel(0),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        return WillPopScope(
          child: Scaffold(
            appBar: SearchBar(
              hintText: "按患者姓名或手机号搜索",
              onPressed: (text) {
                model.filterData(text);
              },
              onChanged: (String text) {
                if (text.isEmpty) {
                  model.filterData(text);
                }
              },
            ),
            body: model.isBusy
              ? Center(child: CircularProgressIndicator())
              : model.isError
              ? ViewStateWidget(onPressed: model.initData)
              : SmartRefresher(
              controller: model.refreshController,
              onRefresh: model.refresh,
              onLoading: model.loadMore,
              enablePullUp: true,
              child: model.isEmpty ? ViewStateEmptyWidget(
                image: 'wssjg.png', message: '搜索无结果') : ListView.builder(
                itemCount: model.filterList.length,
                itemBuilder: (context, index) {
                  return PrescriptionItem(model,model.filterList[index]);
                })
            ),
          ),
          onWillPop: (){
            model.filterData('');
            return Future.value(true);
          }
        );
      }
    );
  }
}
