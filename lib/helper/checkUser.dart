
import 'Database.dart';
import '../models/Constant.dart';

checkUser()async {
 await DBProvider.db.checkExistdb().then((value)async{
    if(value.toString()=="0"){
      Constant.id = "null";
      Constant.token = "null";
      print("sqlLite no user found "+value.toString());
      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LogIn()));
    }else{
      print("sqlLite user found ");
      if(Constant.id==null)Constant.id = "exist";
      await DBProvider.db.getEmail(0).then((email){
        Constant.email=email.toString().trim();
        // print("email: "+Constant.userEmail);
      });
      await DBProvider.db.getuserPhone(0).then((userphone){
        Constant.userPhone=userphone.toString().trim();
      });
      await DBProvider.db.getUsername(0).then((username){
          Constant.userName=username.toString().trim();
      });
      await DBProvider.db.getUserpassword(0).then((pass){
        Constant.userPassword=pass.toString().trim();
      });
      await DBProvider.db.getuserCountry(0).then((country){
        Constant.country =  country.toString().trim();
        print("countryID: ${Constant.country}");
      });
      await DBProvider.db.getUserpassword(0).then((userid){
        Constant.id=userid.toString().trim();
        print("userID: ${Constant.id}");
      });
      await DBProvider.db.getCurrentLang(0).then((currentLang){
        Constant.lang=currentLang.toString().trim();
        print("current language: "+currentLang);
      });
      await DBProvider.db.getUserToken(0).then((token)async{
        Constant.token=token.toString().trim();
        if(Constant.token=="discover"){
          Constant.id = 'null';
          print("discover user ");
        }
        print("token: "+Constant.token.toString());
      });
    }
  });
}