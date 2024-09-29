class FieldValidator {
  // Valida se o campo está vazio
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório.';
    }
    return null;
  }

  // Valida se o valor inserido é um e-mail válido com domínio específico
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório.';
    }

    // Verifica se o e-mail termina com '@aiesec.org.br'
    if (!value.endsWith('@aiesec.org.br')) {
      return 'Por favor, insira um e-mail com o domínio @aiesec.org.br.';
    }

    // Expressão regular básica para validar o formato do e-mail
    final emailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@aiesec\.org\.br$');

    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um e-mail válido.';
    }
    return null;
  }

  // Valida se o valor da senha atende aos requisitos mínimos
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória.';
    }

    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres.';
    }
    return null;
  }

  // Valida se o campo de confirmação de senha corresponde à senha original
  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirmação de senha é obrigatória.';
    }

    if (password != confirmPassword) {
      return 'As senhas não coincidem.';
    }
    return null;
  }
}
