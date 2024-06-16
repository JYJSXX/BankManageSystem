import 'dart:convert';


import 'package:flutter/material.dart';
import 'main.dart';

class AuthenticatePage extends StatefulWidget {
  @override
  _AuthenticatePageState createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage>{
  final TextEditingController _customernameController = TextEditingController();
  final TextEditingController _customeridController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('实名认证'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildCustomer(),
      ),
    );
  }
  Widget _buildCustomer(){
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _customernameController,
              decoration: const InputDecoration(
                labelText: '姓名',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _customeridController,
              decoration: const InputDecoration(
                labelText: '身份证号',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async{
                    // 打印用户名和密码
                    print('客户姓名: ${_customernameController.text}');
                    print('客户ID: ${_customeridController.text}');
                    var res = await user.Authenticate(_customernameController.text, _customeridController.text);
                    var response = jsonDecode(res.body);
                    if(response['success'] == false){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('认证失败'),
                            content: Text('请检查您的姓名和身份证号是否正确'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    else{
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Commit'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // 使用 Navigator.pop 方法返回上一个页面
                    Navigator.pop(context);
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          ],
        );
  }
}