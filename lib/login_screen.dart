import 'package:clothingapp/admin_page.dart';
// import 'package:clothingapp/auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password.dart';
import 'package:flutter/material.dart';
import 'customer_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothingapp/login_bloc/login_bloc.dart';
import 'package:clothingapp/login_bloc/login_state.dart';
import 'package:clothingapp/login_bloc/login_event.dart';

void main() {
  runApp(const ClothingMain());
}

class ClothingMain extends StatefulWidget {
  const ClothingMain({super.key});

  @override
  State<ClothingMain> createState() => _ClothingMainState();
}

class _ClothingMainState extends State<ClothingMain> {
  bool _obscure = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // bool isLoading = false;
  // Future<void> loginUser()async{
  //   setState(() {
  //     isLoading = true;
  //   });
  //   AuthService authService = AuthService();
  //   User? user = await authService.signIn(emailController.text.trim(), passwordController.text.trim());
  //   if(user!=null){
  //     var userData = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
  //     String role = userData['role'];
  //     if(!mounted)return;
  //     if(role=="Admin"){
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const adminpage()));
  //     }
  //     else if(role=="Customer"){
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const GlassBottomNavExample()));
  //     }
  //   }
  //     else{
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Failed")));
  //     }
  //     if(mounted){setState(() {
  //       isLoading = false;
  //     });}
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          body:Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*1,
                height: MediaQuery.of(context).size.height*0.4,
                decoration:const BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Container(
                    width: MediaQuery.of(context).size.width*1,
                    height: MediaQuery.of(context).size.height*0.05,
                    decoration:const BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                    ),
                    child: Padding(padding: const EdgeInsets.only(bottom: 14),child: Container(
                      width: MediaQuery.of(context).size.width*1,
                      height: MediaQuery.of(context).size.height*0.05,
                      decoration:const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                      ),
                    ),),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text('Login',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.06,
                  fontWeight: FontWeight.bold,color: Colors.black),),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 6, horizontal: MediaQuery.of(context).size.width*0.055),
                child: TextFormField(
                  controller: emailController,
                  decoration:const InputDecoration(
                      labelText: 'Enter Email',
                      hintText: 'Email',
                      fillColor: Colors.grey,
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(20)))
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 6, horizontal: MediaQuery.of(context).size.width*0.055),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                      labelText: 'Enter Password',
                      hintText: 'Password',
                      fillColor: Colors.grey,
                      suffixIcon: IconButton(onPressed: (){setState(() {
                        _obscure=!_obscure;
                      });} , icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),),
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(20))),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(20)))
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6,horizontal: MediaQuery.of(context).size.width*0.3),
                child: Container(
                  width: double.infinity ,
                  height: MediaQuery.of(context).size.height*0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.orange
                  ),
                  child: BlocListener<loginbloc,loginstate>(
                    listener: (context,state){
                      if(state is loginsucceed){
                        if(state.role=="Admin"){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const adminpage()));
                        }
                        else if(state.role=="Customer"){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const GlassBottomNavExample()));
                      }
                      }
                      if(state is loginfailed){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    child: BlocBuilder<loginbloc , loginstate>(
                      builder: (context , state){
                        bool isLoading = state is loginloading;
                      return InkWell(
                          onTap: (){
                            context.read<loginbloc>().add(
                                loginbuttonpressed(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim()));},
                          child: Center(
                              child:isLoading ? const SizedBox(
                                  height: 22 , width: 22 ,
                                  child: CircularProgressIndicator(strokeWidth: 2,)) : Text('Login' ,
                                style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.035,color: Colors.white,),)));
                    }),
                  ),
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.06,),
                    child: TextButton(onPressed: (){Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const forgotpassword(),
                      ),
                    );}, child: const Text('Forget Password?' ,
                      style: TextStyle(color: Colors.blueAccent,decoration: TextDecoration.underline),)),
                  )
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Don\'t'' Have An Account'),
                  TextButton(onPressed: (){}, child: const Text('Sign Up' ,style: TextStyle(color: Colors.blueAccent),))
                ],
              )
            ],
          )
      ),
    );
  }
}