# Configuração da API Key do Google Maps

## ⚠️ IMPORTANTE - SUBSTITUA "SUA_CHAVE_API_AQUI" pela sua chave real

### Como aplicar sua chave:

1. **Android**: Edite o arquivo `android/app/src/main/AndroidManifest.xml`
   - Localize a linha: `android:value="SUA_CHAVE_API_AQUI"`
   - Substitua `SUA_CHAVE_API_AQUI` pela sua chave da API

2. **iOS**: Edite o arquivo `ios/Runner/AppDelegate.swift`
   - Localize a linha: `GMSServices.provideAPIKey("SUA_CHAVE_API_AQUI")`
   - Substitua `SUA_CHAVE_API_AQUI` pela sua chave da API

### Exemplo:
Se sua chave for `AIzaSyBdVl-cTICSwYKrZ95SuvNw7dbMuDt1KG0`, então:

**Android (AndroidManifest.xml):**
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyBdVl-cTICSwYKrZ95SuvNw7dbMuDt1KG0" />
```

**iOS (AppDelegate.swift):**
```swift
GMSServices.provideAPIKey("AIzaSyBdVl-cTICSwYKrZ95SuvNw7dbMuDt1KG0")
```

### 🔒 Segurança:
- Nunca compartilhe sua chave da API publicamente
- Configure restrições de uso no Google Cloud Console
- Limite as APIs que a chave pode acessar

### 🧪 Como testar:
Após configurar as chaves, compile novamente:
```bash
flutter clean
flutter pub get
flutter build apk --debug  # Para Android
flutter build ios --debug  # Para iOS
```