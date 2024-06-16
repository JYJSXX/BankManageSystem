import 'main.dart' as main;
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'User.dart';
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _customernameController = TextEditingController();
  // final TextEditingController _customeridController = TextEditingController();


  Widget _buildAccount(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: '用户名',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: '密码',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
      ],
    );
  }


  Widget _buildCommitButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async{
            // 打印用户名和密码
            print('用户名: ${_usernameController.text}');
            print('密码: ${_passwordController.text}');
            main.user = User(name: _usernameController.text, password: _passwordController.text);
            var response = await main.user.login();
            print(response.body);
            if(jsonDecode(response.body)['success']){
              await main.user.getUserDetail();
            }
            // Map<String, dynamic> msg = {"type":"login", "AccountName":"Tom", "password":"123456aA."};
            // final test = await Post_db(jsonEncode(msg));
            print(response.body);
            if(jsonDecode(response.body)['success']){
              Navigator.pop(context, {'AccountID': main.user.id});
            }
            else{
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('登录失败'),
                    content: Text(jsonDecode(response.body)['msg']),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
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
    );
  }

  Widget _buildSignUpInterface(Size size){
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 500, width: size.width/2, child: _buildAccount(),),
              // Container(
              //   width: size.width/2,
              //   child: Column(
              //     children: [
              //       SizedBox(width: size.width/2, height: 20, child: Text("人证核验*", maxLines: 1, style: TextStyle(fontStyle: FontStyle.italic), textDirection: TextDirection.ltr,),),
              //       SizedBox(height: 150, width: size.width/2 - 10, child: _buildCustomer()),
              //     ],
              //   ),
              //   decoration: BoxDecoration(
              //     // border: Border.all(color: Colors.black, width: 1),
              //     borderRadius: BorderRadius.circular(10),
              //     color: Colors.redAccent.withOpacity(0.5),
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(height: 16),
        _buildCommitButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录账户'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildSignUpInterface(size),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    // _customernameController.dispose();
    // _customeridController.dispose();
    super.dispose();
  }
}
