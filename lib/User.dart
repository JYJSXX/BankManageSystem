import 'package:http/http.dart';
import 'package:lab2/main.dart';
import 'dart:convert';
import 'to_server.dart';

class Loan{
  final int LoanID;
  final double Amount;
  final double InterestRate;
  final String LoanDate;//借款日期
  final String RequestDate;//还款日期
  final int AccountID;
  final String EmployeeName;
  int Status;
  Loan(this.LoanID, this.Amount, this.InterestRate, this.LoanDate, this.RequestDate, this.AccountID, { this.Status = -1, this.EmployeeName = ''});
}

class Bank{
  final int BankID;
  final String BankName;
  String BankAddress;
  String BankTel;
  String BankMail;

  Bank(this.BankID, this.BankName, {this.BankAddress = '', this.BankTel = '', this.BankMail = ''});
}

class User{
  final String name;
  final String password;
  int id;
  int bankID;
  String mail;
  String tel;
  String base64Avatar;

  //下面是用户的信息
  bool isCustomer = true;
  String accountType;
  double balance;
  bool isAuthenticated;
  String customerName;
  List<Loan> loanList = [];

  //下面是管理员的信息
  String departmentName;
  int departmentID;
  double salary;
  

  User({required this.name, required this.password, this.id = -1, this.isAuthenticated = false, 
        this.accountType = '', this.bankID = -1, this.balance = 0.0, this.departmentName = '', 
        this.departmentID = -1, this.salary = 0.0, this.mail = '', this.tel = '', this.customerName = '', this.base64Avatar = '', this.isCustomer  = true});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      name: json['name'],
      password: json['password']
    );
  }

  Future<Response> login() async{
    Map<String, dynamic> json = {
      'type': 'login',
      'AccountName': name,
      'password': password
    };
    var res = await Post_db(jsonEncode(json));
    var response = jsonDecode(res.body);
    if (response['success'] == true){
      isCustomer = response['isCustomer'];
      if(isCustomer){
        print(response);
        accountType = response['AccountType'][0];
        bankID = response['BankID'][0];
        balance = response['Balance'][0];
        id = response['AccountID'];
        isAuthenticated = response['isAuthenticated'];
      }
      else{
        print(response);
        departmentID = response['DepartmentID'][0];
        salary = response['Salary'][0];
        id = response['EmployeeID'][0];
        var res1 = await getEDB(departmentID);
        var response1 = jsonDecode(res1.body);
        print(response1);
        departmentName = response1['DepartmentName'][0];
        bankID = response1['BankID'][0];
        mail = response['EmployeeMail'][0] ?? '';
        tel = response['EmployeeTel'][0] ?? '';
        base64Avatar = response['EmployeeAvatar'][0] ?? '';
      }
    }
    return res;
  }

  Future<Response> register() async{
    Map<String, dynamic> json = {
      'type': 'register',
      'AccountName': name,
      'password': password,
      'AccountType': accountType,
      'BankID': bankID
    };
    return await Post_db(jsonEncode(json));
  }

  Future<Response> registerEmployee() async{
    Map<String, dynamic> json = {
      'type': 'registerEmployee',
      'EmployeeName': name,
      'password': password,
      'DepartmentID': departmentID,
      'Salary': salary
    };
    return await Post_db(jsonEncode(json));
  }

  Future<Response> getUserDetail() async{
    Map<String, dynamic> json = {
      'type': 'getUserDetail',
      'AccountID': id,
      'isCustomer': isCustomer
    };
    var res = await Post_db(jsonEncode(json));
    var response = jsonDecode(res.body);
    if (response['success'] == true){
      print(response);
      if(isCustomer){
        accountType = response['AccountType'][0];
        bankID = response['BankID'][0];
        balance = response['Balance'][0];
        id = response['AccountID'][0];
        isAuthenticated = response['isAuthenticated'];
        base64Avatar = response['AccountAvatar'][0] ?? '';
        if(isAuthenticated){
          mail = response['CustomerMail'][0] ?? '';
          tel = response['CustomerTel'][0] ?? '';
          customerName = response['CustomerName'][0];
        }
      }
      else{
        departmentID = response['DepartmentID'][0];
        salary = response['Salary'][0];
        id = response['EmployeeID'][0];
        var res1 = await getEDB(departmentID);
        var response1 = jsonDecode(res1.body);
        departmentName = response1['DepartmentName'][0];
        bankID = response1['BankID'][0];
        mail = response['EmployeeMail'][0] ?? '';
        tel = response['EmployeeTel'][0] ?? '';
        base64Avatar = response['EmployeeAvatar'][0] ?? '';
      }
    }
    return res;
  }

  Future<String> getEmployeeName(int EmployeeID){
    Map<String, dynamic> json = {
      'type': 'getEmployeeName',
      'ID': EmployeeID
    };
    return Post_db(jsonEncode(json)).then((value) => jsonDecode(value.body)['EmployeeName'][0]);
  }

  Future<List<Loan>> getLoanList({Map<String, dynamic>? search}) async{
    Map<String, dynamic> json = {
      'type': 'getLoanList',
      'AccountID': id,
      'isCustomer': isCustomer
    };
    if(search != null){
      json.addAll(search);
    }
    var res = await Post_db(jsonEncode(json));
    loanList.clear();
    if (jsonDecode(res.body)['success'] == true){
      var response = jsonDecode(res.body);
      for(int i = 0; i < response['count']; i++){
        String eName = '';
        if(response['Status'][i] != -1){
          eName = await getEmployeeName(response['EmployeeID'][i]);
        }

        loanList.add(Loan(response['LoanID'][i], response['Amount'][i], response['InterestRate'][i], 
                          DateTime.fromMillisecondsSinceEpoch(response['LoanDate'][i]).toString(),
                          DateTime.fromMillisecondsSinceEpoch(response['RequestDate'][i]).toString(),
                          response['AccountID'][i],
                          Status:  response['Status'][i], EmployeeName: eName
                          ));
      }
    }
    else{
      print(jsonDecode(res.body));
    }
    return loanList;
  }

  /**
   * @id the id of the department
   * @return a map contains the name of the department & the id of bank
   *////
  Future<Response> getEDB(int id) async{
    Map<String, dynamic> json = {
      'type': 'getEDB',
      'DepartmentID': id
    };
    return await Post_db(jsonEncode(json));
  }

  Future<Response> Authenticate(String CustomerName, String CustomerID)async{
    Map<String, dynamic> json = {
      'type': 'Authenticate',
      'AccountID': id,
      'CustomerName': CustomerName,
      'CustomerID': CustomerID
    };
    var res = await Post_db(jsonEncode(json));
    var msg = jsonDecode(res.body);
    if(msg['success'] == true){
      isAuthenticated = true;
    }
    else {
      print(msg);
    }
    return res;
  }
  Future<double> getInterestRate(double amount){
    Map<String, dynamic> json = {
      'type': 'getInterestRate',
      'Amount': amount,
      'AccountID': id
    };
    return Post_db(jsonEncode(json)).then((value) => jsonDecode(value.body)['InterestRate']);
  }
  Future<Response> applyLoan(double amount, int duration) async{
    Map<String, dynamic> json = {
      'type': 'applyLoan',
      'AccountID': id,
      'Amount': amount,
      'Duration': duration
    };
    return await Post_db(jsonEncode(json));
  }

  Future<Response> payLoan(int LoanID) async{
    Map<String, dynamic> json = {
      'type': 'repayLoan',
      'LoanID': LoanID
    };
    return await Post_db(jsonEncode(json));
  }

  Future<Response> cancelLoan(int LoanID) async{
    Map<String, dynamic> json = {
      'type': 'cancelLoan',
      'LoanID': LoanID
    };
    return await Post_db(jsonEncode(json));
  }

  Future<Response> confirmLoan(int LoanID) async{
    if(isCustomer) throw Exception('You are not an employee');
    Map<String, dynamic> json = {
      'type': 'confirmLoan',
      'LoanID': LoanID,
      'EmployeeID': id
    };
    return await Post_db(jsonEncode(json));
  }

  Future<Response> denyLoan(int LoanID) async{
    if(isCustomer) throw Exception('You are not an employee');
    Map<String, dynamic> json = {
      'type': 'denyLoan',
      'LoanID': LoanID,
      'EmployeeID': id
    };
    return await Post_db(jsonEncode(json));
  }

  Future<Response> modifyMail(String mail) async{
    Map<String, dynamic> json = {
      'type': 'modifyMail',
      'isCustomer': isCustomer,
      'ID':id,
      'Mail': mail
    };
    return await Post_db(jsonEncode(json));
  }

  Future<Response> modifyTel(String tel) async{
    Map<String, dynamic> json = {
      'type': 'modifyTel',
      'isCustomer': isCustomer,
      'ID':id,
      'Tel': tel
    };
    return await Post_db(jsonEncode(json));
  }

  Future<Response> uploadAvatar(String base64) async{
    Map<String, dynamic> json = {
      'type': 'uploadAvatar',
      'isCustomer': isCustomer,
      'ID':id,
      'Avatar': base64
    };
    return await Post_db(jsonEncode(json));
  }

  Future<List<User>> getEmployeeList() async{
    if(isCustomer || user.id != 1) throw Exception('You have no authority');
    Map<String, dynamic> json = {
      'type': 'getEmployeeList'
    };
    var res = await Post_db(jsonEncode(json));
    var response = jsonDecode(res.body);
    List<User> employeeList = [];
    if(response['success'] == true){
      for(int i = 0; i < response['count']; i++){
        if(response['EmployeeID'][i] == 1) continue;
        var temp = User(name: '${response['EmployeeName'][i]}', password: '', id: response['EmployeeID'][i], isCustomer:false);
        await temp.getUserDetail();
        employeeList.add(temp);
      }
    }
    return employeeList;
  }

  Future<List<Bank>> getBankList() async{
    if(isCustomer) throw Exception('You are not an employee');
    Map<String, dynamic> json = {
      'type': 'getBankListDetail'
    };
    var res = await Post_db(jsonEncode(json));
    var response = jsonDecode(res.body);
    List<Bank> bankList = [];
    if(response['success'] == true){
      for(int i = 0; i < response['count']; i++){
        bankList.add(Bank(response['BankID'][i], response['BankName'][i], BankAddress: response['BankAddress'][i], BankTel: response['BankTel'][i], BankMail: response['BankMail'][i]));
      }
    }
    return bankList;
  }

  Future<Response> saveMoney(double amount) async{
    Map<String, dynamic> json = {
      'type': 'saveMoney',
      'AccountID': id,
      'Amount': amount
    };
    return await Post_db(jsonEncode(json));
  }

  Future<Response> withdrawMoney(double amount) async{

      Map<String, dynamic> json = {
      'type': 'withdrawMoney',
      'AccountID': id,
      'Amount': amount
      };
      return await Post_db(jsonEncode(json));
  }

  Future<Response> modifyDepartment(int departmentID, String departmentname){
    if(isCustomer) throw Exception('You are not an employee');
    Map<String, dynamic> json = {
      'type': 'modifyDepartment',
      'DepartmentID': departmentID,
      'DepartmentName': departmentname
    };
    return Post_db(jsonEncode(json));
  }

  Future<String> getAccoutName(int AccountID)async{
    Map<String, dynamic> json = {
      'type': 'getAccountName',
      'AccountID': AccountID
    };
    var res = await Post_db(jsonEncode(json));
    print(res.body);
    return jsonDecode(res.body)['AccountName'];
  }

  Future<void> delEmployee(int EmployeeID){
    if(isCustomer || user.id!=1) throw Exception('You have no authority');
    Map<String, dynamic> json = {
      'type': 'delEmployee',
      'EmployeeID': EmployeeID
    };
    return Post_db(jsonEncode(json));
  }

  Future<List<User>> getCustomerList() async{
    if(isCustomer || user.id != 1) throw Exception('You have no authority');
    Map<String, dynamic> json = {
      'type': 'getCustomerList'
    };
    var value = await Post_db(jsonEncode(json));
      var response = jsonDecode(value.body);
      List<User> customerList = [];
      if(response['success'] == true){
        print(response);
        for(int i = 0; i < response['count']; i++){
          var temp = User(name: '${response['AccountName'][i]}', password: '', id: response['AccountID'][i]);
          await temp.getUserDetail();
          customerList.add(temp);
        }
      }
      return customerList;
    
  }
}