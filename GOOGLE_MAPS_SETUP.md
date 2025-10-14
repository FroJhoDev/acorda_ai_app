# Google Maps API Key Configuration

Para que o aplicativo funcione corretamente, você precisa configurar as chaves da API do Google Maps:

## Android

1. Obtenha uma chave da API do Google Maps no [Google Cloud Console](https://console.cloud.google.com/)
2. Adicione a chave no arquivo `android/app/src/main/AndroidManifest.xml`:

```xml
<application>
    <!-- Google Maps API Key -->
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="SUA_CHAVE_API_AQUI" />
    
    <!-- Outras configurações... -->
</application>
```

## iOS

1. Use a mesma chave da API ou crie uma nova para iOS
2. Adicione a chave no arquivo `ios/Runner/AppDelegate.swift`:

```swift
import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("SUA_CHAVE_API_AQUI")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Configuração das APIs necessárias

No Google Cloud Console, certifique-se de habilitar:
- Maps SDK for Android
- Maps SDK for iOS
- Geocoding API (se necessário)
- Places API (se necessário)

## Segurança

⚠️ **IMPORTANTE**: Nunca commite chaves de API no controle de versão. Use variáveis de ambiente ou arquivos de configuração locais.