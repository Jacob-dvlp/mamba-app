import '../../domain/entities/fast_protocol_entity.dart';

const descriptions = {
  ProtocolType.twelve12: 'Ideal para iniciantes. 12h de jejum, 12h para comer.',
  ProtocolType.sixteen8: 'O mais popular. 16h de jejum, janela de 8h.',
  ProtocolType.eighteen6: 'Avançado. 18h de jejum, 6h para comer.',
  ProtocolType.custom: 'Defina seu próprio protocolo.',
};

String mapFirebaseError(String code) {
  switch (code) {
    case 'invalid-credential':
    case 'user-not-found':
    case 'wrong-password':
      return 'E-mail ou senha incorretos.';
    case 'email-already-in-use':
      return 'E-mail já cadastrado.';
    case 'weak-password':
      return 'Senha muito fraca. Use pelo menos 6 caracteres.';
    case 'invalid-email':
      return 'E-mail inválido.';
    case 'network-request-failed':
      return 'Sem conexão com a internet.';
    case 'too-many-requests':
      return 'Muitas tentativas. Tente novamente mais tarde.';
    default:
      return 'Erro de autenticação. Tente novamente.';
  }
}
