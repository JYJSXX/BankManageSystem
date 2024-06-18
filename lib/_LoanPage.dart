import 'dart:async';
import 'dart:convert';
import 'User.dart';
import '_LoanApplyPage.dart';
import 'main.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 用于日期格式化

class LoanPage extends StatefulWidget {
  @override
  _LoanPageState createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  Future<List<Loan>> _loanList = user.getLoanList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: user.isCustomer ? AppBar(
        title: 
        ElevatedButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoanApplyPage())
            ).then((value){
              setState(() {
                _loanList = user.getLoanList();
              });
            });
          },
          child: Text('贷款'),
        ),
      ): AppBar(
        title: Text('所有贷款'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildUserLoanList(),
      ),
    );
  }

  FutureBuilder<List<Loan>> _buildUserLoanList() {
    return FutureBuilder<List<Loan>>(
        future: _loanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if(user.id == -1){
            return Center(child: Text('请先登录'));
          }
          else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('加载数据时出错'));
          }
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('没有贷款信息'));
          }
          else {
            final loans = snapshot.data!;
            return ListView.separated(
              itemCount: loans.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final loan = loans[index];
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            '贷款总额: \$${loan.Amount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8.0),
                              Text('利率: ${(loan.InterestRate * 100).toStringAsFixed(2)}%'),
                              SizedBox(height: 8.0),
                              Text('贷款日期: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(loan.LoanDate))}'),
                              SizedBox(height: 8.0),
                              Text('还款日期: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(loan.RequestDate))}'),
                              SizedBox(height: 8.0),
                              Text(
                                '贷款状态: ${loan.Status == 0 ? '待还款' : loan.Status == -1 ? '未批款' : loan.Status == -2 ? '已拒绝' : '已还款'}',
                                style: TextStyle(
                                  color: loan.Status == 1 ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if(loan.Status != -1)
                                SizedBox(height: 8.0),
                              if(loan.Status != -1)
                                Text('审核人: ${loan.EmployeeName}')
                            ],
                          ),
                          trailing: _buildLoanActions(context, loan),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      );
  }

Widget _buildLoanActions(BuildContext context, Loan loan) {
    List<Widget> actions = [];

    if (loan.Status == 0 && user.isCustomer) {
      actions.add(
        ElevatedButton(
          onPressed: () async {
            var res = await user.payLoan(loan.LoanID);
            var response = jsonDecode(res.body);
            if (response['success'] == true) {
              setState(() {
                _loanList = user.getLoanList();
                user.getUserDetail();
              });
            }
            else{
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    // title: Text('出错：\n${response['msg'].toString()}'),
                    title: Text(response['msg']),
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
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text('还款'),
        ),
      );
    }

    if (loan.Status == -1 && user.isCustomer) {
      actions.add(
        ElevatedButton(
          onPressed: () async {
            var res = await user.cancelLoan(loan.LoanID);
            var response = jsonDecode(res.body);
            if (response['success'] == true) {
              setState(() {
                _loanList = user.getLoanList();
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text('取消'),
        ),
      );
    }

    if (loan.Status == -1 && !user.isCustomer) {
      actions.addAll([
        ElevatedButton(
          onPressed: () async {
            var res = await user.denyLoan(loan.LoanID);
            var response = jsonDecode(res.body);
            if (response['success'] == true) {
              setState(() {
                _loanList = user.getLoanList();
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text('拒绝'),
        ),
        SizedBox(width: 8.0), // 添加间距
        ElevatedButton(
          onPressed: () async {
            var res = await user.confirmLoan(loan.LoanID);
            var response = jsonDecode(res.body);
            if (response['success'] == true) {
              setState(() {
                _loanList = user.getLoanList();
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text('批准'),
        ),
      ]);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions,
    );
  }
}