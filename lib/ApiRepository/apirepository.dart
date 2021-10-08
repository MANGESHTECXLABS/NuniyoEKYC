/*This class file consists of calls to API Endpoints*/
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiRepo {

  var headers = {
    'Content-Type': 'application/json'
  };

  //BASE URL : When Run In Android Emulators
  //final String BASE_API_URL = 'https://10.0.2.2:5001';

  //BASE URL : When Run In Web
  final String BASE_API_URL = 'https://localhost:5001';

  String API_TOKEN = "";

  final String BASE_API_URL_2 = 'http://localhost:44333';

  final String BASE_API_URL_3 = 'http://localhost:44330';

  final String BASE_API_LINK_URL = 'https://api.nuniyo.tech';

  SharedPreferences? preferences;

  //NEW APIS
  //Send Mobile Number to Database
  Future<bool> SendMobileNumber(String phoneNumber) async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/lead/Read_Lead'));
    request.body = json.encode({
      "mobile_No": phoneNumber,
      "method_Name": "Check_Mobile_No"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<bool> VerifyOTP(String phoneNumber,String userEnteredOTP) async{

    var headers = {
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/lead/Verify_OTP'));
    request.body = json.encode({
      "mobile_No": "$phoneNumber",
      "otp": "$userEnteredOTP",
      "method_Name": "Check_OTP",
      "org_Id": "S001",
      "flow_Id": "M001001",
      "current_Stage_Id": "715439"
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      int result_Id = valueMap["res_Output"][0]["result_Id"];
      String result_Description = valueMap["res_Output"][0]["result_Description"];
      print("Your OTP IS VERIFIED OR NOT DEPENDS ON "+result_Id.toString());
      API_TOKEN = result_Description;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("API_TOKEN", API_TOKEN);
      print("YOUR JWT TOKEN :"+API_TOKEN);
      if(result_Id==1){
        return true;
      }
      else{
        return false;
      }
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<void> CVLKRAGetPanStatus(String panCardNumber) async{
    String JWT_TOKEN= await GetCurrentJWTToken();
    print("Calling Verify PAN KRA Using API"+JWT_TOKEN);
    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/cvlkra/Get_PanStatus'));
    request.body = json.encode({
      "pan_No": panCardNumber,
      "method_Name": "Get_PanStatus"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      int result_Id = valueMap["res_Output"][0]["result_Id"];
      print("STATUS : "+result_Id.toString());
      if(result_Id==1){
        return;
      }
      else{
        return;
      }
    }
    else {
      print(response.reasonPhrase);
      return;
    }
  }

  Future<bool> PostPersonalDetails(String phoneNumber , String fatherName, String motherName , String income,String gender,String maritial_Status,
      String politicalExposed , String occupation , String tradingExperience , String education) async{

    String JWT_TOKEN= await GetCurrentJWTToken();
    print("Posting Personal Details Using API :"+JWT_TOKEN);

    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/personal/Personal_Details'));

    request.body = json.encode({
      "mobile_No": phoneNumber,
      "father_Name": fatherName,
      "mother_Name": motherName,
      "income": income,
      "gender": gender,
      "marital_Status": maritial_Status,
      "politicalExposed": politicalExposed,
      "occupation": occupation,
      "trading_Experience": tradingExperience,
      "education": education
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }
  
  Future<void> SolicitFetch() async{
    String JWT_TOKEN= await GetCurrentJWTToken();

    print("SOLICIT FETCH Using API TOKEN :"+JWT_TOKEN);
    
    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };
    
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/cvlkra/SolicitPANDetailsFetchALLKRA'));
    request.body = json.encode({
      "apP_PAN_NO": "hocpk1290f",
      "apP_DOB_INCORP": "19/08/1998"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }
  }

  Future<String> GetCurrentJWTToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String JWT_TOKEN= prefs.getString('API_TOKEN');
    print("AWT STORED INSIDE SHARED PREFERENCES :" + JWT_TOKEN);
    return JWT_TOKEN;
  }

  Future<Map<dynamic,dynamic>> searchIFSCCodes(String branchName , String branchLocation) async{
    Map valueMap = Map();
    String JWT_TOKEN= await GetCurrentJWTToken();

    print("Calling IFSC Search Using API"+JWT_TOKEN);

    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/ifscmaster/IFSC_Master_Search'));
    request.body = json.encode({
      "bank": branchName,
      "ifsc": "string",
      "branch": branchLocation
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      valueMap = jsonDecode(result);
      print(valueMap);
      print(result);

      return valueMap;

    }
    else {
      print(response.reasonPhrase);
      return valueMap;
    }
  }

  Future<String> isValidIFSC(String ifscCode) async{
    var request = http.Request('GET', Uri.parse('https://ifsc.razorpay.com/$ifscCode'));
    //var request = http.Request('GET', Uri.parse('https://ifsc.razorpay.com/BARB0DBGHTW'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      return result;
    }
    else {
      print(response.reasonPhrase);
      return "Not Found";
    }
  }

  Future<void> leadLocation(String phoneNumber,String ipAddress,String city,String country,String state,String latitude,String longitude) async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/lead/Lead_Location'));
    request.body = json.encode({
      "mobile_No": phoneNumber,
      "ip": ipAddress,
      "city": city,
      "country": country,
      "state": state,
      "latitude": latitude,
      "longitude": longitude,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }
  }

  Future<void> OnPaymentSuccessPostToDatabase(int paymentPrice, String phoneNumber,String paymentID) async{
    String JWT_TOKEN= await GetCurrentJWTToken();
    print("Calling POST PAYMENT SUCCESS Using API"+JWT_TOKEN);
    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/RazorPay/RazorPayStatus'));
    request.body = json.encode({
      "inr": paymentPrice,
      "currency": "INR",
      "mobile_No": phoneNumber,
      "merchantTransactionId": paymentID
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<bool> VerifyEmail(String phoneNumber , String emailID) async{
    String JWT_TOKEN= await GetCurrentJWTToken();
    print("Calling Verify Email Using API"+JWT_TOKEN);
    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/email/Email_Status'));
    request.body = json.encode({
      "mobile_No": phoneNumber,
      "email": emailID,
      "method_Name": ""
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      int status = valueMap["status"];
      print("STATUS : "+status.toString());
      if(status==200){
        return true;
      }
      else{
        return false;
      }
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<bool> VerifyPAN(String phoneNumber , String panNumber) async{
    String JWT_TOKEN= await GetCurrentJWTToken();
    print("Calling Verify PAN Using API"+JWT_TOKEN);
    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$BASE_API_LINK_URL/api/NsdlPan/NSDLeKYCPanAuthentication'));
    request.body = json.encode({
      "pan_No": panNumber,
      "mobile_No": phoneNumber,
      "method_Name": "PAN_details"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      int result_Id = valueMap["res_Output"][0]["result_Id"];
      print("STATUS : "+result_Id.toString());
      if(result_Id==1){
        return true;
      }
      else{
        return false;
      }
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }


  //////////LOCAL BACKEND APIS TO BIND
  Future<bool> PostPersonalDetailsLOCAL(String phoneNumber , String fatherName, String motherName , String income,String gender,String maritial_Status,
      String politicalExposed , String occupation , String tradingExperience , String education) async{

    var headers = {
      'Content-Type': 'application/json',
    };

    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/personal/Personal_Details'));
    request.body = json.encode({
      "mobile_No": phoneNumber,
      "father_Name": fatherName,
      "mother_Name": motherName,
      "income": income,
      "gender": gender,
      "marital_Status": maritial_Status,
      "politically_Exposed": politicalExposed,
      "occupation": occupation,
      "trading_Experience": tradingExperience,
      "education": education
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      int result_Id = valueMap["res_Output"][0]["result_Id"];
      if(result_Id == 1){
        return true;
      }
      return false;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }


  Future<void> KRALOCAL(String panNumber,String phoneNumber) async{
    print("Calling KRA LOCAL USING");
    print(panNumber);
    print(phoneNumber);

    String JWT_TOKEN= await GetCurrentJWTToken();
    print("Calling Verify PAN Using API"+JWT_TOKEN);
    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/api/cvlkra/Get_PanStatus'));
    request.body = json.encode({
      "pan_No": panNumber,
      "mobile_No": phoneNumber
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("KRA LOCAL");
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> SolicitLocal(String panNumber,String dOB) async{
    print("Calling Solicit LOCAL USING");
    print(panNumber);
    print(dOB);

    String JWT_TOKEN= await GetCurrentJWTToken();
    print("Calling Verify SOLICIT Using API"+JWT_TOKEN);
    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/api/cvlkra/SolicitPANDetailsFetchALLKRA'));
    request.body = json.encode({
      "apP_PAN_NO": "HCAPK4259Q",
      "apP_DOB_INCORP": "31-03-2000"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("SOLICIT LOCAL");
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<void> postStageIDLocal() async{

    String JWT_TOKEN= await GetCurrentJWTToken();
    print("Calling Stage ID Using API"+JWT_TOKEN);

    var headers = {
      'Authorization': 'Bearer $JWT_TOKEN',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/lead/Update_StageId'));
    request.body = json.encode({
      "stageId": 1,
      "mobile_No": "8268405887"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }
  }

  ///Verify Bank Details

  Future<bool> verifyBankAccountLocal(String accountNo,String ifscNo) async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/bank/VerifyBankAccount'));
    request.body = json.encode({
      "beneficiary_account_no": "39981374255",
      "beneficiary_ifsc": "SBIN0003671"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
      Map valueMap = jsonDecode(result);
      print(valueMap);
      print(result);
      bool verified = valueMap["verified"];
      print("VERIFIED : "+verified.toString());
      if(verified){
        return true;
      }
      return false;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }



  Future<void> DocumentUploadPANLocal(String phoneNumber,File panCardImage) async{
    var request = http.MultipartRequest('POST', Uri.parse('http://localhost:44330/v1/api/documentupload/Document_Upload_PAN'));
    request.fields.addAll({
      'Mobile_No': phoneNumber
    });
    request.files.add(await http.MultipartFile.fromPath('front_part', '/C:/Users/Tohiba/Downloads/WhatsApp Image 2021-08-15 at 11.50.49 PM.jpeg'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<void> DocumentUploadSignatureLocal() async{}
  Future<void> UpdateEmailLocal() async{}
  Future<void> EmailStatusLocal() async{}
  Future<void> IFSCMasterSearchLocal() async{}
  Future<void> IPVOTPLocal() async{}
  Future<void> VerifyIPVOTPLocal() async{}
  Future<void> SaveIPVVideoLocal() async{}



  Future<void> ReadLeadLocal(String mobileNo,String currentStageId) async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://localhost:44330/v1/api/lead/Read_Lead'));
    request.body = json.encode({
      "mobile_No": "$mobileNo",
      "method_Name": "Check_Mobile_No",
      "org_Id": "S001",
      "flow_Id": "M001001",
      "current_Stage_Id": "C002001"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }


  Future<void> VerifyOTPLocal() async{}
  Future<void> LeadLocationLocal() async{}
  Future<void> UpdateStageIdLocal() async{}
  Future<void> NSDLeKYCPanAuthenticationLocal() async{}
  Future<void> PanAuthenticationLocal() async{}
  Future<void> PersonalDetailsLocal() async{}

  Future<void> RazorPayStatusLocal(int amountPayed,String currency , String mobileNumber, String merchantTransactionID) async{
    var headers = {
      'Content-Type': 'text/plain'
    };
    var request = http.Request('GET', Uri.parse('http://localhost:44330/v1/api/razorpay/RazorPayStatus'));
    request.body = '''{\r\n  "inr": 0,\r\n  "currency": "string",\r\n  "mobile_No": "string",\r\n  "merchantTransactionId": "string"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }







  ///Bank Validation API - NEW
  Future<bool> fetchIsBankValid(String bankAccountNumber,String ifscCode) async {
    var request = http.Request('POST', Uri.parse('$BASE_API_URL/VerifyBankAccount?beneficiary_account_no=$bankAccountNumber&beneficiary_ifsc=$ifscCode'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  ///PAN Validation API
  Future<bool> fetchIsPanValid(String fullName,String dOB,String panNumber) async {
    fullName = fullName.replaceAll(' ', '%20');
    var request = http.Request('POST', Uri.parse(
        '$BASE_API_URL/PanAuthentication?'
            'pan_no=$panNumber&full_name=$fullName&date_of_birth=$dOB'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      Map valueMap = jsonDecode(result);
      print(result);
      if (valueMap["is_pan_dob_valid"] && valueMap["name_matched"]) {
        print("YOUR PAN CARD IS VALID");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        fullName = fullName.replaceAll('%20',' ');
        await prefs.setString('full_name', fullName);
        print("Full Name Has Been Set To :" + prefs.getString('full_name'));
        return true;
      }
      else {
        print("Something went wrong");
        return false;
      }
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  ///OCR Validation API
  Future<bool> PanOCRValidation(String imagePath,var imageP) async{
    List<int> _selectedFile = await imageP.readAsBytes();
    var request;
    if(kIsWeb){
      request = http.MultipartRequest('POST', Uri.parse(BASE_API_URL+'/api/DocumentOCR/OCR'));
      request.files.add(await http.MultipartFile.fromBytes('front_part', _selectedFile,
          contentType: new MediaType('application', 'octet-stream'),
          filename: "file_up"));
      request.headers.addAll(headers);
    }
    else{
      request = http.MultipartRequest('POST', Uri.parse('http://localhost:44300/api/user/login/OCR'));
      request.headers.addAll(headers);
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  ///Digital Pad Signature Upload API - (INCOMPLETE)
  Future<bool> DigitalSignatureUploadAPI(String imagePath,var imageP) async{
    List<int> _selectedFile = await imageP.readAsBytes();
    var request;
    if(kIsWeb){
      request = http.MultipartRequest('POST', Uri.parse(BASE_API_URL+'/api/DocumentOCR/OCR'));
      request.files.add(await http.MultipartFile.fromBytes('front_part', _selectedFile,
          contentType: new MediaType('application', 'octet-stream'),
          filename: "file_up"));
      request.headers.addAll(headers);
    }
    else{
      request = http.MultipartRequest('POST', Uri.parse('http://localhost:44300/api/user/login/OCR'));
      request.headers.addAll(headers);
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  UploadDocumentForOCR() async {
    var request = http.MultipartRequest('POST', Uri.parse('http://localhost:44330/v1/api/documentupload/Document_Upload_PAN'));
    request.fields.addAll({
      'Mobile_No': '8268405887'
    });
    request.files.add(await http.MultipartFile.fromPath('front_part', '/C:/Users/admin/Downloads/WhatsApp Image 2021-09-12 at 11.57.00 PM.jpeg'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }
  }
}