
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/bloc/bloc.dart';
import 'package:picking_app/models/api_response_model.dart';
import 'package:picking_app/models/auth/resultado_login_model.dart';
import 'package:picking_app/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
    final AuthRepository authRepository;

    AuthBloc(this.authRepository) : super(AuthInitial()) {
        on<LoginRequested>(_onLoginRequested);
    }

    Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
        emit(AuthLoading());
        try {
            final ApiResponse<ResultadoLogin> response = await authRepository.login(event.data);
            if(response.isSuccessful && response.resultado != null){
                emit(AuthSuccess(response));
            }else {
                emit(AuthFailure(response.errorMessages?.first ?? "An unknow error ocurred"));
            }
        } catch (e){
            emit(AuthFailure(e.toString()));
        }
    }
}