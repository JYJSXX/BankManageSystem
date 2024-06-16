import 'dart:async';
import 'dart:convert';
import 'User.dart';
import 'package:flutter/material.dart';
import 'package:lab2/doc.dart';
import 'package:http/http.dart';
import '_BankPage.dart';
import 'to_server.dart';
import '_SignInPage.dart';
import '_ESignUpPage.dart';
import '_SignUpPage.dart';
import '_UserDetailPage.dart';
import '_LoanPage.dart';
import '_EmployeePage.dart';
User user =User(name: '', password: '');
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '银行管理系统',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '银行管理系统'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /**  
   * 0 for nothing
   * 1 for loan_check
   * 2 for employee_manage
  *////
  int page = 0;

  List<Widget> _buildVistorSight(Size size){
    return 
    [
      Container(
        height: 100,
        width: size.width/12,
        alignment: Alignment.topRight,
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            ).then((value){
              setState((){
              });
            });
          },
          child: const Text('Sign Up'),
        ),
      ),
      Container(
        height: 100,
        width: size.width/12,
        alignment: Alignment.topRight,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            ).then((value){
              setState((){
                page = 0;
              });
            });
          },
          child: const Text('Sign In'),
        ),
      ),
    ];
  }
  List<Widget> _buildCustomerSight(Size size){
    return 
    [
      if(!user.isCustomer && user.id == 1)
        Container(
          height: 50,
          width: size.width/12,
          alignment: Alignment.topRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: page == 3 ? Colors.blue : Colors.grey,
            ),
            onPressed: (){
              setState(() {
                page = 3;
              });
            },
            child: const Text('银行管理'),
          ),
        ),
      if(!user.isCustomer && user.id == 1)
        Container(
          height: 50,
          width: size.width/12,
          alignment: Alignment.topRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: page == 2 ? Colors.blue : Colors.grey,
            ),
            onPressed: (){
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ESignUpPage()),
              // ).then((value){
              //   setState((){
              //   });
              // });
              setState(() {
                page = 2;
              });
            },
            child: const Text('员工管理'),
          ),
        ),
      if(!user.isCustomer)
        SizedBox(width: 50,),
      Container(
        height: 50,
        width: size.width/12,
        alignment: Alignment.topLeft,
        child: ElevatedButton(
          onPressed: (){
            setState(() {
              page = 1;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: page == 1 ? Colors.blue : Colors.grey,
          ),
          child:  Text('贷款管理'),
        ),
      ),
      Container(
        height: 50,
        width: size.width/12,
        alignment: Alignment.topRight,
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserDetailPage()),
            ).then((value) {
              setState(() {
                page = 0;
              });
            });
          },
          child:  Text(user.name),
        ),
      ),
    ];
  }

  Widget _buildLoanCheck(Size size){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(0),

          color: Colors.redAccent.withOpacity(0.5),
        ),
      height: size.height*3/4,
      width: size.width*2/3,
      alignment: Alignment.center,
      child: LoanPage(),
    );
  }

  Widget _buildEmployeePage(Size size){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(0),

          color: Colors.redAccent.withOpacity(0.5),
        ),
      height: size.height*3/4,
      width: size.width*2/3,
      alignment: Alignment.center,
      child: EmployeePage(),
    );
  }

  Widget _buildBankPage(Size size){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(0),

          color: Colors.redAccent.withOpacity(0.5),
        ),
      height: size.height*3/4,
      width: size.width*5/6,
      alignment: Alignment.center,
      child: BankPage(),
    );
  }

  Widget _buildSavePage(Size size){
    TextEditingController controller = TextEditingController();
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(0),

          color: Colors.redAccent.withOpacity(0.5),
        ),
      height: size.height*3/4,
      width: size.width*5/6,
      alignment: Alignment.center,
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '请输入存款金额',
            ),
          ),
          ElevatedButton(
            onPressed: ()async{
              var res = await user.saveMoney(double.parse(controller.text));
            },
            child: const Text('存款'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: user.id != -1 ? _buildCustomerSight(size) : _buildVistorSight(size),
            ),
            if(page == 1) _buildLoanCheck(size),
            if(page == 2) _buildEmployeePage(size),
            if(page == 3) _buildBankPage(size),
          ],
        ),
      ),
    );
  }
}

