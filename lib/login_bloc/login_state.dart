import 'package:equatable/equatable.dart';

abstract class loginstate extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class logininitial extends loginstate{}

class loginloading extends loginstate{} //those function which are not required to get values of new state after event can be replaced with enums which are used to assign values to variable in copywith method then i have to use success also in enum and take all variable in copywith which will get new value from bloc in form of state.

class loginsucceed extends loginstate{ // we can also build copywith function in loginstate but class is also well because the-
  final String role;                  // purpose of this to return new state when event is called as bloc from bloc the new state-
  loginsucceed({required this.role});//is returned from this copywith also create the new instance for for values with new.

  @override
  // TODO: implement props
  List<Object?> get props => [role];
}

class loginfailed extends loginstate{
  final String message;
  loginfailed({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}