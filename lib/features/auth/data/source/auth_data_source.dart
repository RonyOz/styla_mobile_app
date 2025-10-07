import 'package:supabase_flutter/supabase_flutter.dart';

class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, {this.code});

  @override
  String toString() =>
      'AuthException: $message ${code != null ? '(code: $code)' : ''}';
}

abstract class AuthDataSource {
  Future<String> signUp(String email, String password);
}

class AuthDataSourceImpl extends AuthDataSource {
  final SupabaseClient _supabaseClient;

  AuthDataSourceImpl({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  @override
  Future<String> signUp(String email, String password) async {
    try {
      final AuthResponse response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthException('No se pudo crear el usuario');
      }

      return response.user!.id;
    } on AuthApiException catch (e) {
      throw AuthException(_parseSupabaseError(e.message), code: e.code);
    } catch (e) {
      throw AuthException('Error de conexión: ${e.toString()}');
    }
  }

  String _parseSupabaseError(String message) {
    if (message.contains('User already registered')) {
      return 'Email ya registrado';
    }
    if (message.contains('rate limit')) {
      return 'Demasiados intentos';
    }
    if (message.contains('Email not confirmed')) {
      return 'Email no confirmado';
    }
    return message;
  }
}
