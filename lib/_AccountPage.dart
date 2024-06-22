import 'dart:convert';
import 'package:flutter/material.dart';
import 'User.dart';
import 'main.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  Future<List<User>> customerList = user.getCustomerList();


  Widget _buildCustomerList() {
    return FutureBuilder<List<User>>(
      future: customerList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (user.id == -1) {
          return Center(child: Text('请先登录'));
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text('获取客户列表失败'));
        } else if (snapshot.hasData) {
          final List<User> customers = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.all(8.0),
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final User customer = customers[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: MemoryImage(
                      base64Decode(customer.base64Avatar),
                    ),
                  ),
                  title: Text(
                    customer.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text('邮件: ${customer.mail}'),
                      Text('电话: ${customer.tel}'),
                      Text('余额: ${customer.balance}'), // 假设客户有地址属性
                      Text('实名:${customer.isAuthenticated?'是':'否'}')
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
              Text("客户列表"),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildCustomerList(),
      ),
    );
  }
}