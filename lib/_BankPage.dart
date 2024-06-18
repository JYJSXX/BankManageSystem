import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:lab2/_ESignUpPage.dart';
import 'to_server.dart';
import 'User.dart';
import 'main.dart';

class BankPage extends StatefulWidget {
  @override
  _BankPageState createState() => _BankPageState();
}

class _BankPageState extends State<BankPage>{
  Future<List<Bank>> bankList = user.getBankList();
  int bankID = 0;

  @override
  void initState(){
    super.initState();
    bankID = 0;
  }

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
              return GestureDetector(
                onTap: ()async{
                  bankID = bank.BankID;
                  setState(() {
                  });
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('images/bank2.png'),
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

  Widget _buildDepartmentList(int bankID){
    TextEditingController _departmentController = TextEditingController();
    return FutureBuilder<List<String>>(
      future: getDepartmentList(bankID),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        } else if(user.id == -1){
          return Center(child: Text('请先登录'));
        } else if(snapshot.hasError){
          return Center(child: Text('获取部门列表失败'));
        } else if(snapshot.hasData){
          final List<String> departments = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.all(8.0),
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final String department = departments[index];
              return GestureDetector(
                onTap: ()async{
                  changeDepartmentname(context, _departmentController, department).then((value){setState(() {
                    user.getBankList();
                  });});

                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    title: Text(
                      ((index+1).toString()),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text('${department}'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
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

  Future<dynamic> changeDepartmentname(BuildContext context, TextEditingController _departmentController, String department) {
    return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('修改部门名称'),
                      content: TextField(
                        controller: _departmentController,
                        decoration: const InputDecoration(
                          labelText: '部门名称',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('取消'),
                        ),
                        TextButton(
                          onPressed: () async{
                            int id = await getDepartmentID(department);
                            var res = await user.modifyDepartment(id, _departmentController.text);
                            print(res.body);
                            if(jsonDecode(res.body)['success'] == false){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('出错：\n${jsonDecode(res.body)['msg'].toString()}'),
                                    content: Text(jsonDecode(res.body)['msg']),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('确定'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            else{
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('确定'),
                        ),
                      ],
                    );
                  },
                );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        child: Row(
          children: [
            Container(height: size.height, width: size.width/3, child: _buildbankList()),
            SizedBox(width: 16),
            Container(height: size.height, width: size.width/3, child: _buildDepartmentList(bankID)),
          ],
        ),
      ),
    );
  }
}