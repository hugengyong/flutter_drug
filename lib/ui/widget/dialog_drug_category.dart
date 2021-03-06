import 'package:flutter/material.dart';
import 'package:flutter_drug/config/resource_mananger.dart';
import 'package:flutter_drug/config/router_manager.dart';
import 'package:flutter_drug/model/category.dart';
import 'package:flutter_drug/view_model/category_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DialogDrugCategory extends StatelessWidget {
  final double price;

  DialogDrugCategory({this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: ScreenUtil().setWidth(580),
      child: Consumer<CategoryModel>(builder: (context,model,child) => Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(child: Text('选择药房及处方剂型',style: TextStyle(fontSize: ScreenUtil().setSp(14)))),
                GestureDetector(
                  child: Text('确定',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,fontSize: ScreenUtil().setSp(14))),
                  onTap: () {
                    model.selectedCategory = model.currentCategory;
                    model.selectedDrugStore = model.currentDrugStore;
                    Navigator.maybePop(context);
                  })
              ],
            ),
            color: Colors.grey[200],
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20),ScreenUtil().setWidth(12),ScreenUtil().setWidth(20),ScreenUtil().setWidth(12)),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                new Container(
                  color: Colors.grey[200],
                  width: ScreenUtil().setWidth(100),
                  child: ListView.builder(
                    itemCount: model.list.length,
                    itemBuilder: (context, index) =>
                      _buildCategoryItem(model, index))),
                new Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), ScreenUtil().setWidth(5), ScreenUtil().setWidth(15), ScreenUtil().setWidth(5)),
                    child: ListView.builder(
                      itemCount: model
                        .list[model.currentCategory].child.length,
                      itemBuilder: (context, index) =>
                        _buildDrugStoreItem(
                          context, model, index)),
                  ))
              ],
            )
          )
        ],
      ))
    );
  }

  Widget _buildCategoryItem(CategoryModel model, int i) {
    return GestureDetector(
      onTap: () {
        if (model.currentCategory != i) {
          model.currentDrugStore = 0;
          model.currentCategory = i;
        }
      },
      child: Container(
          alignment: Alignment.center,
          child: Text(model.list[i].name,style: TextStyle(fontSize: ScreenUtil().setSp(13))),
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(15)),
          color: model.currentCategory == i ? Colors.white : Colors.grey[200]),
    );
  }

  Widget _buildDrugStoreItem(BuildContext context, CategoryModel model, int i) {
    DrugStore data = model.list[model.currentCategory].child[i];
    return GestureDetector(
        onTap: () {
          model.currentDrugStore = i;
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(5)),
          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Row(
                    children: <Widget>[
                      Text(data.name, style: TextStyle(fontSize: ScreenUtil().setSp(16))),
                      Offstage(
                        offstage: data.id !=1 && data.id !=2 && data.id != 3,
                        child: Container(
                          margin: EdgeInsets.only(left:2,bottom: 10),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left:2,bottom:2),
                          width: ScreenUtil().setWidth(52),
                          height: ScreenUtil().setWidth(18),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(ImageHelper.wrapAssets('pzyc.png'))
                            )
                          ),
                          child: Text(data.id ==1 ?'特供药材':data.id == 2 ? '上乘药材' :data.id == 3 ? '中乘药材':'',style: TextStyle(fontSize: ScreenUtil().setSp(10),color: Colors.white)),
                        ),
                      )
                    ],
                  )),
                  GestureDetector(
                    onTap: (){
                      Map map = Map();
                      map['title'] = '品牌介绍';
                      map['url'] = data.detailUrl;
                      map['share'] = false;
                      Navigator.of(context).pushNamed(RouteName.webView, arguments: map);
                    },
                    child: Text('查看详情',style: TextStyle(fontSize: ScreenUtil().setSp(12),color: Color(0xff798fb7))),
                  )
                ],
              ),
              SizedBox(height: ScreenUtil().setWidth(8)),
              Offstage(
                offstage: price == 0,
                child: Padding(padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(3)),child: Text('每剂：￥$price',style: TextStyle(color: Color(0xffeaaf4c),fontSize: ScreenUtil().setSp(12)))),
              ),
              Text(data.label, style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(12))),
              SizedBox(height: ScreenUtil().setWidth(3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(data.desc, style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(12))),
                  Image.asset(ImageHelper.wrapAssets(model.currentDrugStore == i?'icon_xz.png':'icon_wxz.png'),width: ScreenUtil().setWidth(18),height:ScreenUtil().setWidth(18))
                ],
              )

            ],
          ),
        ));
  }
}
