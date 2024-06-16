import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab2/_ESignUpPage.dart';
import 'User.dart';
import 'main.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage>{
  final Future<List<User>> employeeList = user.getEmployeeList();

  Widget _buildEmployeeList(){
    return FutureBuilder<List<User>>(
      future: employeeList,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        } else if(user.id == -1){
          return Center(child: Text('请先登录'));
        } else if(snapshot.hasError){
          return Center(child: Text('获取员工列表失败'));
        } else if(snapshot.hasData){
          final List<User> employees = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.all(8.0),
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final User employee = employees[index];
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
                      base64Decode(employee.base64Avatar),
                    ),
                  ),
                  title: Text(
                    employee.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text('${employee.name}:'),
                      Text('邮件: ${employee.mail}'),
                      Text('电话: ${employee.tel}'),
                      Text('部门: ${employee.departmentName}'),
                      Text('工资: \$${employee.salary.toStringAsFixed(2)}'),
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
              Text("员工列表"),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ESignUpPage())
                  ).then((value){
                    setState(() {
                      user.getEmployeeList();
                    });
                  });
                },
                child: Text("添加员工"),
              )
            ],
          ),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildEmployeeList(),
      ),
    );
  }
}