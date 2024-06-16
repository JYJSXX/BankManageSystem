import 'package:flutter/material.dart';
import 'User.dart';
import 'main.dart';
import 'package:http/http.dart';
import 'to_server.dart';
import 'dart:convert';
import 'dart:async';
import 'package:lab2/doc.dart';
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
        const SizedBox(height: 16),
        DropdownInputBank(),
        const SizedBox(height: 16),
        DropdownInputAccountType(),
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
            user = User(name: _usernameController.text, password: _passwordController.text, accountType: user.accountType, bankID: user.bankID);
            var response = await user.register();
            // Map<String, dynamic> msg = {"type":"login", "AccountName":"Tom", "password":"123456aA."};
            // final test = await Post_db(jsonEncode(msg));
            print(response.body);
            if(jsonDecode(response.body)['success']){
              await user.login();
              await user.getUserDetail();
              Navigator.pop(context, {'AccountID': user.id});
            }
            else{
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('注册失败'),
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
        title: const Text('注册账户'),
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

class DropdownInputAccountType extends StatefulWidget {
  @override
  _DropdownInputAccountTypeState createState() => _DropdownInputAccountTypeState();
}

class _DropdownInputAccountTypeState extends State<DropdownInputAccountType> {
  TextEditingController _controller = TextEditingController();
  final List<String> _options = commonBankAccountTypes;
  bool _isDropdownVisible = false;

  void _toggleDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
    });
  }

  void _selectOption(String option) {
    _controller.text = option;
    user.accountType = option;
    setState(() {
      _isDropdownVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: AbsorbPointer(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: _controller.text.isEmpty ? '请选择账户类型' : '账户类型',
                suffixIcon: Icon(
                  _isDropdownVisible
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                ),
              ),
            ),
          ),
        ),
        if (_isDropdownVisible)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 200.0, // 设置下拉菜单的最大高度
            ),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  children: _options.map((option) {
                    return ListTile(
                      title: Text(option),
                      onTap: () => _selectOption(option),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class DropdownInputBank extends StatefulWidget {
  @override
  _DropdownInputBankState createState() => _DropdownInputBankState();
}

class _DropdownInputBankState extends State<DropdownInputBank> {
  TextEditingController _controller = TextEditingController();
  bool _isDropdownVisible = false;
  late Future<List<String>> _optionsFuture;

  @override
  void initState() {
    super.initState();
    _optionsFuture = getBankList();
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
    });
  }

  void _selectOption(String option) async{
    _controller.text = option;
    user.bankID = await getBankID(option);
    setState(() {
      _isDropdownVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: AbsorbPointer(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: _controller.text.isEmpty ? '请选择开户行' : '开户行',
                suffixIcon: Icon(
                  _isDropdownVisible
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                ),
              ),
            ),
          ),
        ),
        if (_isDropdownVisible)
          FutureBuilder<List<String>>(
            future: _optionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No options available');
              } else {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    children: snapshot.data!.map((option) {
                      return ListTile(
                        title: Text(option),
                        onTap: () => _selectOption(option),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}