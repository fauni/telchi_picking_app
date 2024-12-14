
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/api_response_model.dart';
import 'package:picking_app/models/auth/resultado_login_model.dart';
import 'package:picking_app/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
    final AuthRepository authRepository;

    AuthBloc(this.authRepository) : super(AuthInitial()) {
        on<LoginRequested>(_onLoginRequested);
        on<LoginEvent>(_onLogin);
        on<LogoutEvent>(_onLogout);
        on<ChangeTokenSapEvent>(_onChangeTokenSap);
        on<CheckAuthEvent>(_onCheckAuth); // Nuevo evento para verificar autenticación

    }

    Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
        emit(AuthLoading());
        try {
            final ApiResponse<ResultadoLogin> response = await authRepository.login(event.data);
            if(response.isSuccessful && response.resultado != null){
                await authRepository.saveUserData(
                  response.resultado!.usuario!, 
                  response.resultado!.token!, 
                  response.resultado!.sapSessionId!
                );
                emit(Authenticated(response.resultado!.usuario!));
                emit(AuthSuccess(response));
            }else {
                emit(AuthFailure(response.errorMessages?.first ?? "An unknow error ocurred"));
            }
        } catch (e){
            emit(AuthFailure(e.toString()));
        }
    }

    Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
      await authRepository.saveUserData(event.usuario, event.token, event.tokenSap);
      emit(Authenticated(event.usuario));
    }

    Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async
    {
      await authRepository.clearUserData();
      emit(Unauthenticated());
    }

    Future<void> _onChangeTokenSap(ChangeTokenSapEvent event, Emitter<AuthState> emit) async
    {
      await authRepository.setOtherTokenSap();
      emit(ChangeTokenSapSuccess());
    }

    Future<void> checkUserSession()async{
      final user = await authRepository.getUserData();
      final token = await authRepository.getToken();
      final tokenSap = await authRepository.getTokenSap();
      if (user != null && token != null && tokenSap != null) {
        add(LoginEvent(user, token, tokenSap));
      } else {
        // ignore: invalid_use_of_visible_for_testing_member
        emit(Unauthenticated());
      }
    }

    Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Emitimos un estado de carga mientras verificamos
    try {
      final isAuthenticated = await authRepository.checkAuthentication();
      if (isAuthenticated) {
        final user = await authRepository.getUserData();
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthFailure("Error checking authentication: $e"));
    }
  }
}