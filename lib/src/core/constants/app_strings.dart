/// Constantes de string usadas no aplicativo
class AppStrings {
  // App Info
  static const String appName = 'AcordaAI';
  static const String appDescription = 'Alarmes Baseados em Localização';

  // Navigation
  static const String homeTitle = 'Meus Alarmes';
  static const String createAlarmTitle = 'Novo Alarme';
  static const String alarmDetailsTitle = 'Detalhes do Alarme';
  static const String settingsTitle = 'Configurações';

  // Home Screen
  static const String noAlarmsMessage = 'Nenhum alarme configurado';
  static const String createFirstAlarm =
      'Toque no + para criar seu primeiro alarme';
  static const String alarmActive = 'Ativo';
  static const String alarmInactive = 'Inativo';
  static const String alarmTriggered = 'Disparado';

  // Alarm Form
  static const String alarmTitle = 'Título';
  static const String alarmTitleHint = 'Ex: Descer no ponto X';
  static const String alarmDescription = 'Descrição';
  static const String alarmDescriptionHint =
      'Ex: Lembrar de descer perto do shopping';
  static const String selectLocation = 'Selecionar Localização';
  static const String selectLocationHint = 'Toque no mapa para marcar o local';
  static const String alarmRadius = 'Raio de Ativação (metros)';
  static const String soundSettings = 'Som e Vibração';
  static const String enableVibration = 'Habilitar Vibração';
  static const String volume = 'Volume';
  static const String saveAlarm = 'Salvar Alarme';

  // Map
  static const String mapLoadingError = 'Erro ao carregar o mapa';
  static const String locationPermissionDenied =
      'Permissão de localização negada';
  static const String locationServiceDisabled =
      'Serviço de localização desabilitado';
  static const String currentLocation = 'Localização Atual';

  // Permissions
  static const String permissionRequired = 'Permissão Necessária';
  static const String locationPermissionMessage =
      'O aplicativo precisa de acesso à localização para funcionar corretamente';
  static const String notificationPermissionMessage =
      'O aplicativo precisa de permissão para notificações para alertá-lo';
  static const String grantPermission = 'Conceder Permissão';
  static const String cancel = 'Cancelar';

  // Errors
  static const String genericError = 'Ocorreu um erro inesperado';
  static const String networkError = 'Erro de conexão';
  static const String databaseError = 'Erro no banco de dados';
  static const String locationError = 'Erro de localização';
  static const String notificationError = 'Erro de notificação';

  // Success Messages
  static const String alarmCreated = 'Alarme criado com sucesso!';
  static const String alarmUpdated = 'Alarme atualizado com sucesso!';
  static const String alarmDeleted = 'Alarme removido com sucesso!';

  // Actions
  static const String delete = 'Excluir';
  static const String edit = 'Editar';
  static const String save = 'Salvar';
  static const String ok = 'OK';
  static const String yes = 'Sim';
  static const String no = 'Não';
  static const String retry = 'Tentar Novamente';

  // Alarm Notification
  static const String alarmNotificationTitle = 'Alarme Disparado!';
  static const String alarmReachedDestination = 'Você chegou ao seu destino';
  static const String stopAlarm = 'Parar Alarme';
  static const String snoozeAlarm = 'Adiar Alarme';

  // Settings
  static const String generalSettings = 'Configurações Gerais';
  static const String defaultRadius = 'Raio Padrão (metros)';
  static const String defaultVolume = 'Volume Padrão';
  static const String vibrationByDefault = 'Vibração por Padrão';
  static const String aboutApp = 'Sobre o Aplicativo';
  static const String version = 'Versão';
}
