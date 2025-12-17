import 'package:equatable/equatable.dart';

abstract class loginevent extends Equatable{
  @override

  List<Object?> get props => [];
}

class loginbuttonpressed extends loginevent{
  final String email,password;
  loginbuttonpressed({required this.email,required this.password});
  @override
  // TODO: implement props
  List<Object?> get props => [email,password];
}