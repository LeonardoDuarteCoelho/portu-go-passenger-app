import 'package:flutter/material.dart';

class AppStrings {
  // General strings
  static const String empty = '';
  static const String ptCountryCode = '+351';
  static const String euroSymbol = '€';
  static const String createAccountButton = 'Criar conta';
  static const String loading = 'A processar. Aguarde...';
  static const String loading2 = 'Inicializando app...';
  static const String loading3 = 'Por favor, aguarde...';
  static const String accountCreated = 'Conta criada com sucesso!';
  static const String carInfoSaved = 'Informações do carro guardadas.';
  /// This string is integral for 'select_nearest_available_drivers_screen.dart'. Be mindful when editing it.
  static const String primeCarType = 'Prime';
  /// This string is integral for 'select_nearest_available_drivers_screen.dart'. Be mindful when editing it.
  static const String goCarType = 'GO';
  /// This string is integral for 'select_nearest_available_drivers_screen.dart'. Be mindful when editing it.
  static const String chosenDriver = 'Chosen driver';
  static const String profile = 'Perfil';

  // Error strings
  /// This string is integral for the connections between APIs and the app (Check 'assistant_methods.dart'). Be mindful when editing it.
  static const String connectToApiError = 'Erro na conexão entre a app e a API.';
  static const String signUpError = 'Erro ao criar conta. Cheque sua conexão e tente novamente.';
  static const String driverDoesNotExistError = 'Erro ao selecionar motorista. Tente novamente.';
  static const String driverAuthTokenError = 'Erro com o token de autentificação. Por favor, selecione outro motorista.';
  static const String launchPortuGoWebsiteError = 'Erro ao abrir o website. Tente novamente numa outra hora.';
  static const String getNumberOfNearbyDriversAvailableError = 'Erro ao tentar mostrar os motoristas disponíveis.';

  // 'signup_screen.dart'
  static const String welcomeMessage = 'Bem-vindo ao PortuGO!';
  static const String signingUpMessage = 'Cadastre inserindo os seus dados abaixo.';
  static const String nameTextField = 'Nome e apelido';
  static const String emailTextField = 'Email';
  static const String phoneTextField = 'Nº do telemóvel';
  static const String passwordTextField = 'Palavra-passe';
  static const String nameValidationToast = 'O nome não pode ser muito curto. Escreva seu nome completo.';
  static const String emailValidationToast = 'O email inserido não é válido.';
  static const String phoneValidationToast = 'Por favor, insira um número de telemóvel válido.';
  static const String passwordValidationToast = 'A palavra-passe deve ter pelo menos 5 dígitos.';
  static const String alreadyCreatedAccountButton = 'Já possuo uma conta';

  // 'log_in_screen.dart'
  static const String welcomeBackMessage = 'Olá de novo!  :)';
  static const String logInIntoYourAccount = 'Insira seu email e palavra-passe para dar entrada na sua conta.';
  static const String mustEnterEmailAndPassword = 'É preciso que insiras o email e a palavra-passe.';
  static const String mustEnterEmail = 'É preciso que insiras um email válido.';
  static const String mustEnterPassword = 'É preciso que insiras a palavra-passe.';
  static const String enterAccountButton = 'Fazer login';
  static const String dontHaveAccountButton = 'Sem conta? Aperte aqui!';
  static const String logInSuccessful = 'Log in realizado. Bem-vindo de volta!';
  static const String logInError = 'Erro ao entrar na conta. Cheque se as credenciais estão correctas.';
  static const String logInErrorNoRecordOfEmail = 'Erro ao entrar na conta. Email não registado como passageiro.';

  // 'navigation_drawer.dart'
  static const String history = 'Histórico';
  static const String aboutUs = 'Sobre nós';
  static const String signOut = 'Terminar sessão';
  static const String darkMode = 'Modo escuro';
  static const String lightMode = 'Modo claro';
  static const String darkModeNowOn = 'Modo escuro agora em vigor.';
  static const String lightModeNowOn = 'Modo claro agora em vigor.';
  static const String launchingWebsite = 'Abrindo o website, aguarde...';

  // 'main_screen.dart'
  static const String yourLocation = 'Sua localização';
  static const String whereIsTheUserDestination = 'Aonde desejas ir?';
  static const String currentLocation = 'A buscar sua localização...';
  static const String selectDestination = 'Selecione um local';
  static const String confirmRide = 'Confirmar viagem';
  static const String destination = 'Destino';
  static const String userNeedToSelectDestination = 'Para confirmar a viagem, selecione um destino.';
  static const String userNeedToConfirmSelectedDestination = 'Por favor, confirme o destino selecionado.';
  static const String noAvailableDriversNearby = 'Não há motoristas disponíveis no momento. Aguarde um pouco.';
  static const String driverRefusedRideRequest = 'Seu pedido foi recusado. Por favor, chame outro motorista.';
  static const String waitingDriverResponse = 'Aguardando resposta do motorista...';
  static const String cancelRequest = 'Cancelar pedido';
  static const String driverIsComing = 'Seu motorista está a chegar.';
  static const String driverHasArrived = 'Seu motorista chegou.';
  static const String driverInboundDestination = 'Em direção ao seu destino.';
  static const String messageDriver = 'Mandar mensagem';
  static const String notificationSentToDriver = 'Solicitação enviada com sucesso para o motorista!';
  // static const String waitToRequestRideAgain = 'Aguarde para confirmar a viagem novamente.'; // Discontinued string.

  // 'location_permission_warning.dart'
  static const String permissionDenied = 'Permissão negada';
  static const String permissionIsNecessaryForApp = 'Para que a aplicação PortuGO funcione, é necessário permitir que a app aceda à sua localização.';
  static const String enablingPermissionStepOne = '1. Aperte em "Conceder permissão"';
  static const String enablingPermissionStepTwo = '2. Vá para "Permissões"';
  static const String enablingPermissionStepThree = '3. Abaixo de "Não permitido", aperte em "Localização"';
  static const String enablingPermissionStepFour = '4. Selecione a opção que permita a app ter acesso a vossa geolocalização (recomendamos a opção "Permitir durante o uso do app")';
  static const String enablingPermissionStepFive = '5. Por fim, volte para a aplicação, aperte em "Reiniciar app" e já está!';
  static const String enablePermission = 'Conceder permissão';
  static const String restartApp = 'Reiniciar app';

  // 'search_places_screen.dart'
  static const String findLocation = 'Selecione um local';
  static const String findLocationHintText = 'Procure aqui...';

  // 'place_prediction_tile.dart'
  /// This string is integral for the logic behind getting the user's destination (Check 'main_screen.dart'). Be mindful when editing it.
  static const String destinationSelected = 'Destino selecionado!';

  // 'select_nearest_available_drivers_screen.dart'
  static const String nearbyDrivers = 'Motoristas próximos';
  static const String carModel = 'Modelo';

  // 'fare_amount_collection_dialog.dart'
  static const String tripPriceToPay = 'Viagem finalizada!\nPreço a pagar...';
  static const String confirmPayment = 'Efetuar pagamento';
  static const String paymentWasSuccessful = 'Pagamento efetuado com sucesso.';

  // 'rate_driver_screen.dart'
  static const String rateDriver = 'Avalie como foi sua viagem.';
  static const String driverRatingOneStar = 'Péssimo';
  static const String driverRatingTwoStar = 'Ruim';
  static const String driverRatingThreeStar = 'Bom';
  static const String driverRatingFourStar = 'Ótimo';
  static const String driverRatingFiveStar = 'Excelente';
  static const String confirmDriverRating = 'Enviar avaliação';
  static const String thankingPassengerForSendRating = 'Obrigado! Sua avaliação foi recebida com sucesso.';

  // 'trips_history_screen.dart'
  static const String tripsHistory = 'Histórico de viagens';
}

class AppColors {
  // Essential colors:
  static const Color black = Color(0xFF000000);
  static const Color blackTransparent90 = Color(0xE6000000);
  static const Color blackTransparent80 = Color(0xCC000000);
  static const Color blackTransparent50 = Color(0x80000000);

  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteTransparent90 = Color(0xE6FFFFFF);
  static const Color whiteTransparent80 = Color(0xCCFFFFFF);
  static const Color whiteTransparent50 = Color(0x80FFFFFF);
  static const Color transparent = Color(0x00000000);

  static const Color success3 = Color(0xFF81C784);
  static const Color success5 = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFBC02D);

  // Themed colors:
  static const Color gray0 = Color(0xFFF8F9FA);
  static const Color gray1 = Color(0xFFF1F3F5);
  static const Color gray2 = Color(0xFFE9ECEF);
  static const Color gray3 = Color(0xFFDEE2E6);
  static const Color gray4 = Color(0xFFCED4DA);
  static const Color gray5 = Color(0xFFADB5BD);
  static const Color gray6 = Color(0xFF868E96);
  static const Color gray7 = Color(0xFF495057);
  static const Color gray8 = Color(0xFF343A40);
  static const Color gray9 = Color(0xFF212529);
  static const Color indigo0 = Color(0xFFEDF2FF);
  static const Color indigo1 = Color(0xFFDBE4FF);
  static const Color indigo2 = Color(0xFFBAC8FF);
  static const Color indigo3 = Color(0xFF91A7FF);
  static const Color indigo4 = Color(0xFF748FFC);
  static const Color indigo5 = Color(0xFF5C7CFA);
  static const Color indigo6 = Color(0xFF4C6EF5);

  static const Color indigo7 = Color(0xFF4263EB);
  static const Color indigo7Transparent90 = Color(0xE64263EB);
  static const Color indigo7Transparent50 = Color(0x804263EB);

  static const Color indigo8 = Color(0xFF3B5BDB);
  static const Color indigo9 = Color(0xFF364FC7);
}

class AppFontFamilies {
  static const String primaryFont = 'Roboto';
}

class AppFontSizes {
  static const double xxxxl = 72;
  static const double xxxl = 56;
  static const double xxl = 40;
  static const double xl = 32;
  static const double l = 24;
  static const double ml = 20;
  static const double m = 16;
  static const double sm = 14;
  static const double s = 12;
}

class AppFontWeights {
  static const black = FontWeight.w900;
  static const semiBlack = FontWeight.w800;
  static const bold = FontWeight.w700;
  static const semiBold = FontWeight.w600;
  static const medium = FontWeight.w500;
  static const regular = FontWeight.w400;
  static const light = FontWeight.w300;
  static const semiLight = FontWeight.w200;
  static const thin = FontWeight.w100;
}

class AppLineHeights {
  static const double xxl = 1.8;
  static const double xl = 1.6;
  static const double l = 1.4;
  static const double ml = 1.2;
  static const double m = 1.0;
  static const double sm = 0.9;
  static const double s = 0.8;
}

class AppSpaceValues {
  static const double space1 = 5;
  static const double space2 = 10;
  static const double space3 = 20;
  static const double space4 = 30;
  static const double space5 = 40;
  static const double space6 = 50;
  static const double space7 = 60;
  static const double space8 = 70;
  static const double space9 = 80;
  static const double space10 = 90;
  static const double space11 = 100;
}