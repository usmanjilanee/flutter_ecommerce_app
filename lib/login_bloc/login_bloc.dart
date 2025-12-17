import 'package:equatable/equatable.dart';
import 'package:clothingapp/login_bloc/login_event.dart';
import 'package:clothingapp/login_bloc/login_state.dart';
import 'package:clothingapp/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class loginbloc extends Bloc<loginevent,loginstate>{
  final AuthService authService;

  loginbloc(this.authService) : super(logininitial()){
    on<loginbuttonpressed>(_onloginpressed);
  }
  Future<void> _onloginpressed(loginbuttonpressed event, Emitter<loginstate> emit)async{
    emit(loginloading()); //emitting new state.
    try{
      final user = await authService.signIn(event.email, event.password);
      if(user==null){
        emit(loginfailed(message: "Invalid Email or Password")); //emitting new state.
      }
      final userdata =await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
      if (!userdata.exists) {
        emit(loginfailed(message:"User profile not found"));
        return;}
      final role = await userdata['role'];
      if (role == null) {
        emit(loginfailed(message: "User role missing"));
        return;
      }
      emit(loginsucceed(role: role));
    } catch(e){
      emit(loginfailed(message: "Something wents wrong : ${e}"));
    }
  }
}