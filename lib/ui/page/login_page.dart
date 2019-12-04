import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drug/config/resource_mananger.dart';
import 'package:flutter_drug/config/router_manager.dart';
import 'package:flutter_drug/model/user.dart';
import 'package:flutter_drug/ui/widget/dialog_loading.dart';
import 'package:flutter_drug/ui/widget/titlebar.dart';
import 'package:flutter_drug/view_model/user_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{

  bool isVerify = true;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _verifyCodeController = TextEditingController();

  //定义变量
  Timer _timer;

  //倒计时数值
  var countdownTime = -1;

  //倒计时方法
  void startCountdown() {
    countdownTime = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(this.mounted){
        setState(() {
          if (countdownTime < 1) {
            _timer.cancel();
          } else {
            countdownTime -= 1;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: TitleBar.buildCommonAppBar(context, ''),
        body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('登录药匣子',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 40,
                      child: Center(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            border: InputBorder.none,
                            hintText: '请输入手机号',
                            hintStyle: TextStyle(color: Colors.grey,
                              fontSize: 13),
                            counterText:''),
                          controller: _phoneController,
                          maxLines: 1,
                          maxLength: 11,
                          textInputAction: TextInputAction.newline,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ),
                  Offstage(
                    offstage: !isVerify,
                    child: GestureDetector(
                      onTap: () {
                        if (countdownTime == 0) {
                          startCountdown();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: countdownTime>0?Colors.grey:Theme
                            .of(context)
                            .primaryColor, width: 1)
                        ),
                        child: Text(countdownTime > 0
                          ? '${countdownTime}s后重发'
                          : countdownTime==0? '重新获取':'获取验证码', style: TextStyle(color:countdownTime>0?Colors.grey: Theme
                          .of(context)
                          .primaryColor, fontSize: 13)),
                      ),
                    ),
                  )
                ],
              ),
              Divider(height: 1, color: Colors.grey),
              SizedBox(height: 5),
              Offstage(
                offstage: !isVerify,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  child: Center(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        border: InputBorder.none,
                        hintText: '请输入验证码',
                        hintStyle: TextStyle(color: Colors.grey,
                          fontSize: 13),
                        counterText:''),
                      controller: _verifyCodeController,
                      maxLines: 1,
                      maxLength: 6,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                )
              ),
              Offstage(
                offstage: isVerify,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  child: Center(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        border: InputBorder.none,
                        hintText: '请输入密码',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13)
                      ),
                      controller: _passwordController,
                      maxLines: 1,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                )
              ),
              Divider(height: 1, color: Colors.grey),
              SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                  if(_phoneController.text.isEmpty){
                    showToast('请输入手机号');
                  }else if (_phoneController.text.length < 11){
                    showToast('请输入正确的手机号');
                  }else if(_verifyCodeController.text.isEmpty && isVerify){
                    showToast('请输入验证码');
                  } else if(_verifyCodeController.text.length < 6 && isVerify){
                    showToast('请输入正确的验证码');
                  } else if(_passwordController.text.isEmpty  && !isVerify){
                    showToast('请输入密码');
                  }else{
                    showDialog(context: context,builder:(context){
                      return LoadingDialog(text:'登录中...');
                    });
                    Future.delayed(Duration(seconds: 2), (){
                      Navigator.of(context).pop();
                      Provider.of<UserModel>(context).saveUser(User(1,"http://img2.woyaogexing.com/2019/08/30/3c02345e50aa4fbbadce736ae72d9313!600x600.jpeg","许洪亮","内科","主任医师"));
                      Navigator.of(context).pushNamed(RouteName.tab);
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme
                      .of(context)
                      .primaryColor,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text(
                    '登录',
                    style: TextStyle(color: Colors.white),
                  )
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isVerify = !isVerify;
                      });
                    },
                    child: Text(isVerify?'账号密码登录':'手机快捷登录',style: TextStyle(fontSize: 12,color: Colors.grey)),
                  ),
                  Offstage(
                    offstage: isVerify,
                    child:GestureDetector(
                      onTap: (){},
                      child: Text('忘记密码?',style: TextStyle(fontSize: 12,color: Colors.grey)),
                    ),
                  )
                ],
              ),
              Expanded(child: SizedBox()),
              SafeArea(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child: Divider(height: 1,color: Colors.grey[400])),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text('第三方登录',style: TextStyle(fontSize: 13,color: Colors.grey))
                        ),
                        Expanded(child: Divider(height: 1,color: Colors.grey[400]))
                      ],
                    ),
                    SizedBox(height: 15),
                    Image.asset(ImageHelper.wrapAssets('icon_weixin.png'),width: 42,height: 42),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('注册/登录即表示同意',style: TextStyle(fontSize: 12)),
                        GestureDetector(
                          onTap: (){
                            Map map = Map();
                            map['title'] = '服务协议';
                            map['url'] = 'http://www.zgzydb.com/app/doctorReg.html';
                            map['share'] = false;
                            Navigator.of(context).pushNamed(RouteName.webView, arguments: map);
                          },
                          child: Text('《药匣子服务协议》',style: TextStyle(fontSize: 12,color: Theme.of(context).primaryColor)),
                        ),
                        Text('《免责条款》',style: TextStyle(fontSize: 12,color: Theme.of(context).primaryColor))
                      ],
                    )
                  ],
                ),
                bottom: true
              ),
            ],
          ),
        )
      )
    );
  }


  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }
}