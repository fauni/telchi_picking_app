import 'package:equatable/equatable.dart';

abstract class AlmacenEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class LoadAlmacenesForUser extends AlmacenEvent {}