import 'dart:convert';

import 'package:flutter/material.dart';
import 'User.dart';
import 'main.dart';

class LoanApplyPage extends StatefulWidget {
  @override
  _LoanApplyPageState createState() => _LoanApplyPageState();
}

class _LoanApplyPageState extends State<LoanApplyPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('贷款申请'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: '贷款金额',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: '贷款期限',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async{
                // 打印用户名和密码
                print('贷款金额: ${_amountController.text}');
                print('贷款期限: ${_durationController.text}');
                var res = await user.applyLoan(double.parse(_amountController.text), int.parse(_durationController.text));
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
              child: Text('提交'),
            ),
          ],
        ),
      ),
    );
  }
}