abstract class Failure implements Exception {
  const Failure();

  String get message;

  @override
  String toString() {
    return '$runtimeType Exception';
  }
}

class GeneralException extends Failure {
  const GeneralException();

  @override
  String get message => 'Ocorreu um erro. Tente novamente mais tarde';
}

//API Exceptions

class APIException extends Failure {
  const APIException({
    required this.code,
    this.textCode,
  });

  final int code;
  final String? textCode;

  @override
  String get message {
    if (textCode != null) {
      switch (textCode) {
        case 'invalid-headers':
        case 'validation-failed':
          return 'Bad request. Check you request and try again.';
        default:
          return 'Ocorreu um erro intero. Tente novamente mais tarde.';
      }
    }
    switch (code) {
      case 400:
        return 'Requisição inválida. Verifique sua solicitação e tente novamente.';
      case 401:
        return 'Usuário não autorizado a acessar este recurso no momento. Por favor, faça a autenticação novamente.';
      case 404:
        return 'Não foi possível concluir esta operação. Por favor, tente novamente mais tarde.';
      case 503:
        return 'Serviço indisponível no momento. Por favor, tente novamente mais tarde.';
      default:
        return 'Ocorreu um erro interno. Por favor, tente novamente mais tarde.';
    }
  }
}

//Services Exceptions
class AuthException extends Failure {
  const AuthException({
    required this.code,
  });

  final String code;

  @override
  String get message {
    switch (code) {
      case 'session-expired':
      case 'invalid-jwt':
      case 'invalid-headers':
      case 'user-not-authenticated':
        return 'Sessão expirada. Logue novamente.';
      case 'email-already-exists':
        return 'O e-mail fornecido já está em uso. Por favor, verifique suas informações ou crie uma nova conta.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Email ou senha incorretos. Confira suas informações ou crie uma nova conta.';
      case 'network-request-failed':
        return 'Não foi possível se conectar ao sistema. Verifique sua conexão e tente novamente.';
      case 'too-many-requests':
        return 'Devido a tentativas consecutivas falhadas, você não pode fazer login neste momento. Por favor, tente novamente em alguns instantes.';
      case 'internal':
        return 'Não foi possível criar a conta. Verifique as informações e tente novamente.';
      default:
        return 'There was an error while authenticating. Please try again later.';
    }
  }
}

class SecureStorageException extends Failure {
  const SecureStorageException();

  @override
  String get message => 'An error has occurred while fetching Secure Storage.';
}

class CacheException extends Failure {
  const CacheException();

  @override
  String get message => 'An error has occurred while fetching Local Cache.';
}

//System Exceptions
class ConnectionException extends Failure {
  const ConnectionException({
    required this.code,
  });

  final String code;

  @override
  String get message {
    switch (code) {
      case 'connection-error':
        return 'Não foi possível se conectar ao sistema. Verifique sua conexão e tente novamente.';
      default:
        return 'Ocorreu um erro interno. Por favor tente novamente.';
    }
  }
}
