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
    TextEditingController _searchController = TextEditingController();

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
            return 
              Container(
                height: 100,
                child: Column(
                  children: [
                    SearchLoan(_searchController, context),
                    Text('没有找到符合条件的贷款'),
                  ],
                ),
              );
          }
          else {
            final loans = snapshot.data!;
            return Container(
              height: 1000,
              child: Column(
                children: [
                  SearchLoan(_searchController, context),
                  Container(
                    height: 450,
                    child: ListView.separated(
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
                                      if(!user.isCustomer)
                                        FutureBuilder(
                                          future: user.getAccoutName(loan.AccountID),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Center(child: CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              print(snapshot.error);
                                              return Center(child: Text('加载数据时出错001'));
                                            } else if (!snapshot.hasData) {
                                              return Center(child: Text('没有数据'));
                                            } else {
                                              return Text('账户名: ${snapshot.data}');
                                            }
                                          },
                                        ),
                                      if(!user.isCustomer)
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
                    ),
                  ),
                ],
              ),
            );
          }
        },
      );
  }

  Container SearchLoan(TextEditingController searchController, BuildContext context) {
    return Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: '\$name=xxx or \$amount=xxx or \$status=xxx',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async{
                          if(searchController.text.trim()==""){
                            setState(() {
                            _loanList = user.getLoanList();
                          });
                          return;
                          }
                          var tokens = searchController.text.split("\$");
                          Map<String, dynamic> search = {};
                          for(var token in tokens){
                            if(token.trim()=="")continue;
                            var pair = token.split("=");
                            if(pair.length != 2) {
                              ShowSearchDialog(context);
                            }
                            else if(pair[0].trim() == "name" && !user.isCustomer){
                              search["name"] = pair[1].trim();
                            }
                            else if(pair[0].trim() == "amount"){
                              try{
                                search["amount"] = double.parse(pair[1].trim());
                              } catch(e){
                                ShowSearchDialog(context);
                              }
                            }
                            else if(pair[0].trim() == "status"){
                              try {
                                search["status"] = int.parse(pair[1].trim());
                              } catch (e) {
                                ShowSearchDialog(context);
                              }
                            }
                            else{
                              ShowSearchDialog(context);
                            }
                          }
                          setState(() {
                            _loanList = user.getLoanList(search: search);
                          });
                        },
                      ),
                    ),
                  ),
                );
  }

  Future<dynamic> ShowSearchDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text('搜索条件错误'),
                                  content: Text('请按照\$name=xxx or \$amount=xxx or \$status=xxx的格式输入'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('确定'),
                                    ),
                                  ],
                                );
                            });
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