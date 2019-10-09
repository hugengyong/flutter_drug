import 'package:flutter/material.dart';
import 'package:flutter_drug/config/resource_mananger.dart';
import 'package:flutter_drug/model/address.dart';
import 'package:flutter_drug/provider/provider_widget.dart';
import 'package:flutter_drug/provider/view_state_widget.dart';
import 'package:flutter_drug/ui/widget/titlebar.dart';
import 'package:flutter_drug/view_model/address_model.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class AddressManagePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.buildCommonAppBar(context, '地址管理',
          actionText: '添加新地址', onActionPress: () => print("点击了添加新地址")),
      body: ProviderWidget<AddressModel>(
        model: AddressModel(),
        onModelReady: (addressModel) {
          addressModel.initData();
        },
        builder: (context, addressModel, child) {
          return addressModel.busy
              ? Center(child: CircularProgressIndicator())
              : EasyRefresh(
                  controller: addressModel.refreshController,
                  onRefresh: addressModel.refresh,
                  enableControlFinishRefresh: true,
                  emptyWidget:
                      addressModel.empty ? ViewStateEmptyWidget() : null,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  maxLines: 1,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      border: InputBorder.none,
                                      hintText: '请输入姓名或手机查询',
                                      hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFFcccccc))),
                                  onSubmitted: (text) {
                                    print("搜索$text");
                                  },
                                ),
                              ),
                              Container(
                                color: Colors.grey,
                                width: 1,
                                height: 18,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Image.asset(
                                    ImageHelper.wrapAssets('ic_ss.png'),
                                    width: 20,
                                    height: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: addressModel.list?.length ?? 0,
                        itemBuilder: (context, index) {
                          return _buildAddressItem(
                              context, addressModel.list[index]);
                        },
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget _buildAddressItem(BuildContext context, Address address) {
    return Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                width: 40,
                height: 40,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                child: Center(
                  child: Text(address.name.substring(0, 1),
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 10, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Text(address.name, style: TextStyle(fontSize: 18)),
                    SizedBox(width: 10),
                    Text(address.phone, style: TextStyle(color: Colors.grey))
                  ]),
                  SizedBox(height: 3),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Offstage(
                        offstage: address.isDefault != 1,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            color: Color(0xFFDDFAF8),
                            child: Text('默认',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text('${address.area}--${address.address}'),
                      )
                    ],
                  )
                ],
              ),
            )),
            Container(
              color: Colors.grey,
              width: 1,
              height: 25,
            ),
            GestureDetector(
              onTap: () => print('编辑'),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text('编辑',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            )
          ],
        ));
  }
}
