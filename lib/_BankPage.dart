import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab2/_ESignUpPage.dart';
import 'User.dart';
import 'main.dart';

class BankPage extends StatefulWidget {
  @override
  _BankPageState createState() => _BankPageState();
}

class _BankPageState extends State<BankPage>{
  final Future<List<Bank>> bankList = user.getBankList();

  Widget _buildbankList(){
    return FutureBuilder<List<Bank>>(
      future: bankList,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        } else if(user.id == -1){
          return Center(child: Text('请先登录'));
        } else if(snapshot.hasError){
          return Center(child: Text('获取银行列表失败'));
        } else if(snapshot.hasData){
          final List<Bank> banks = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.all(8.0),
            itemCount: banks.length,
            itemBuilder: (context, index) {
              final Bank bank = banks[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  leading: const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage("https://www.bing.com/images/search?view=detailV2&ccid=wDBVKFJx&id=E74EB7384AB1233BF829975A5913A00A085BC1A8&thid=OIP.wDBVKFJxPRuzmSBduP5w9QAAAA&mediaurl=https%3a%2f%2fp1.ssl.qhimg.com%2fdr%2f220__%2ft01d3d78424a31e4333.png&exph=61&expw=188&q=%e9%93%b6%e8%a1%8c&simid=607991018552524703&FORM=IRPRST&ck=CE49B415FA1670260A0BCD6C8B751CF3&selectedIndex=1&itb=0&qft=+filterui%3aimagesize-small")
                  ),
                  title: Text(
                    bank.BankName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text('${bank.BankName}:'),
                      Text('邮件: ${bank.BankMail}'),
                      Text('电话: ${bank.BankTel}'),
                      Text('地址: ${bank.BankAddress}'),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),
          );
        } else {
          return Center(child: Text('未知错误'));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              SizedBox(width: 40),
              Text("银行列表"),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ESignUpPage())
                  ).then((value){
                    setState(() {
                      user.getBankList();
                    });
                  });
                },
                child: Text("添加银行"),
              )
            ],
          ),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildbankList(),
      ),
    );
  }
}