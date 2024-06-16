import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lab2/User.dart';
import 'package:lab2/to_server.dart';
import '_AuthenticatePage.dart';
import '_ImageLoad.dart';
import 'main.dart';

class UserDetailPage extends StatefulWidget {
  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final Future<List<String>> _optionsFuture = getBankList();
  ScrollController detail = ScrollController();
  @override
  void initState() {
    super.initState();
    user.getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户详情'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              controller: detail,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:user.isCustomer ? _buildCustomerDetail(context) :_buildEmployeeDetail(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCustomerDetail(BuildContext context) {
  return [
    GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ImageLoad())).then((value) async {
          var res = await user.getUserDetail();
          var response = jsonDecode(res.body);
          if (response['success'] == false) {
            alert(context, response);
          } else {
            setState(() {});
          }
        });
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: ListTile(
          leading: Icon(Icons.picture_in_picture, color: Theme.of(context).primaryColor),
          title: Text('点击更换头像'),
          subtitle: Container(
            alignment: Alignment.centerLeft,
            width: 60,
            height: 60,
            child: user.base64Avatar.isNotEmpty
                ? ClipOval(
                    child: Image.memory(
                      base64Decode(user.base64Avatar),
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  )
                : Text("无头像"),
          ),
        ),
      ),
    ),
    Divider(),
    Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
        title: Text('用户名'),
        subtitle: Text(user.name),
      ),
    ),
    Divider(),
    Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(Icons.account_balance_wallet, color: Theme.of(context).primaryColor),
        title: Text('账户类型'),
        subtitle: Text(user.accountType),
      ),
    ),
    Divider(),
    FutureBuilder<List<String>>(
      future: _optionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No options available'));
        } else {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: ListTile(
              leading: Icon(Icons.account_balance, color: Theme.of(context).primaryColor),
              title: Text('银行'),
              subtitle: Text(snapshot.data![user.bankID - 1]),
            ),
          );
        }
      },
    ),
    Divider(),
    Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(Icons.attach_money, color: Theme.of(context).primaryColor),
        title: Text('余额'),
        subtitle: Text(user.balance.toStringAsFixed(2)),
      ),
    ),
    Divider(),
    GestureDetector(
      onTap: () => _showEmailEditDialog(context),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: ListTile(
          leading: Icon(Icons.email, color: Theme.of(context).primaryColor),
          title: Text('邮箱'),
          subtitle: Text(user.mail),
        ),
      ),
    ),
    Divider(),
    GestureDetector(
      onTap: () => _showPhoneEditDialog(context),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: ListTile(
          leading: Icon(Icons.phone, color: Theme.of(context).primaryColor),
          title: Text('电话'),
          subtitle: Text(user.tel),
        ),
      ),
    ),
    Divider(),
    Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(Icons.verified, color: Theme.of(context).primaryColor),
        title: Text('认证状态'),
        subtitle: Text(user.isAuthenticated ? '已认证' : '未认证'),
      ),
    ),
    if (!user.isAuthenticated)
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AuthenticatePage()),
            ).then((value) {
              setState(() {});
            });
          },
          child: Text('进行认证'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    Divider(),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          user = User(name: '', password: '');
          Navigator.pop(context);
        },
        child: Text('退出登录'),
      ),
    ),
  ];
}

List<Widget> _buildEmployeeDetail(BuildContext context) {
  return [
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageLoad()),
        ).then((value) async {
          var res = await user.getUserDetail();
          var response = jsonDecode(res.body);
          if (response['success'] == false) {
            alert(context, response);
          } else {
            setState(() {});
          }
        });
      },
      child: ListTile(
        leading: Icon(
          Icons.picture_in_picture,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('点击更换头像'),
        subtitle: Container(
          alignment: Alignment.centerLeft,
          width: 60,
          height: 60,
          child: user.base64Avatar != ''
              ? Image.memory(
                  base64Decode(user.base64Avatar),
                  fit: BoxFit.contain,
                )
              : Text("无头像"),
        ),
      ),
    ),
    Divider(),
    ListTile(
      leading: Icon(
        Icons.perm_identity,
        color: Theme.of(context).primaryColor,
      ),
      title: Text('用户名'),
      subtitle: Text(user.name),
    ),
    Divider(),
    GestureDetector(
      onTap: () => _showEmailEditDialog(context),
      child: ListTile(
        leading: Icon(
          Icons.email,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('邮箱'),
        subtitle: Text(user.mail),
      ),
    ),
    Divider(),
    GestureDetector(
      onTap: () => _showPhoneEditDialog(context),
      child: ListTile(
        leading: Icon(
          Icons.phone,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('电话'),
        subtitle: Text(user.tel),
      ),
    ),
    Divider(),
    ListTile(
      leading: Icon(
        Icons.account_balance_wallet,
        color: Theme.of(context).primaryColor,
      ),
      title: Text('部门'),
      subtitle: Text(user.departmentName),
    ),
    Divider(),
    FutureBuilder(
      future: _optionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No options available');
        } else {
          return ListTile(
            leading: Icon(
              Icons.account_balance,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('银行'),
            subtitle: Text(snapshot.data![user.bankID - 1]),
          );
        }
      },
    ),
    Divider(),
    ListTile(
      leading: Icon(
        Icons.attach_money,
        color: Theme.of(context).primaryColor,
      ),
      title: Text('工资'),
      subtitle: Text(user.salary.toStringAsFixed(2)),
    ),
    Divider(),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          user = User(name: '', password: '');
          Navigator.pop(context);
        },
        child: Text('退出登录'),
      ),
    ),
  ];
}

  void _showEmailEditDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController(text: user.mail);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('编辑邮箱'),
          content: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: '邮箱',
              hintText: '请输入新的邮箱地址',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('确认'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () async{
                var res = await user.modifyMail(emailController.text);
                var response = jsonDecode(res.body);
                if(response['success'] == false){
                  alert(context, response);
                }
                else{
                  res = await user.getUserDetail();
                  response = jsonDecode(res.body);
                  if(response['success'] == false){
                    alert(context, response);
                  }
                  else{
                    setState(() {});
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showPhoneEditDialog(BuildContext context) {
    TextEditingController phoneController = TextEditingController(text: user.tel);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('编辑电话'),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: '电话',
              hintText: '请输入新的电话号码',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('确认'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () async{
                var res = await user.modifyTel(phoneController.text);
                var response = jsonDecode(res.body);
                if(response['success'] == false){
                  alert(context, response);
                }
                else{
                  res = await user.getUserDetail();
                  response = jsonDecode(res.body);
                  if(response['success'] == false){
                    alert(context, response);
                  }
                  else{
                    setState(() {});
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
  Future<dynamic> alert(BuildContext context, dynamic response){
    return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('出错：\n${response['msg'].toString()}'),
                        content: Text(response['msg']),
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
}