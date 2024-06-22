import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
final url = Uri(host: "127.0.0.1", port: 8080, path: "/test");

Future<Response> Post_db(String json) async {
  Response? response;
  try{
    response = await post(url, body: json);
  }catch(e){
    print(e);
  }
  return response!;
  // print(response!.body);
  
}

Future<List<String>> getBankList() async{
  List<String> banks = [];
  Map<String, dynamic> json = {'type': 'getBankList'};
  var response = await Post_db(jsonEncode(json));
  var data = jsonDecode(response.body);
  if(data['success'] == 0){
    return banks;
  }
  banks = data['BankName'].cast<String>();
  print(data);
  return banks;
}

Future<List<String>> getDepartmentList(int ?bankID) async{
  List<String> departments = [];
  Map<String, dynamic> json = {'type': 'getDepartmentList'};
  if(bankID != null){
    json['BankID'] = bankID;
  }
  var response = await Post_db(jsonEncode(json));
  var data = jsonDecode(response.body);
  if(data['success'] == 0){
    return departments;
  }
  departments = data['DepartmentName'].cast<String>();
  print(data);
  return departments;

}

Future<int> getBankID(String BankName) async{
  var BankList = await getBankList();
  return BankList.indexOf(BankName) + 1;
}

Future<int> getDepartmentID(String DepartmentName) async{
  var DepartmentList = await getDepartmentList(null);
  return DepartmentList.indexOf(DepartmentName) + 1;
}


