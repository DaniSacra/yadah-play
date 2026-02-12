# Assinatura de release para Google Play

Para enviar o app na Google Play, é preciso gerar um **Android App Bundle (AAB)** assinado em **modo release** (não em debug).

## 1. Criar o keystore (só uma vez)

No terminal, na pasta do projeto (ou em qualquer pasta onde queira guardar o keystore):

**Windows (PowerShell):**
```powershell
keytool -genkey -v -keystore android\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**macOS/Linux:**
```bash
keytool -genkey -v -keystore android/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

- O comando vai pedir uma **senha** para o keystore e dados (nome, organização, etc.). Anote a senha em local seguro.
- O arquivo `upload-keystore.jks` será criado em `android/`. **Guarde esse arquivo e as senhas com segurança**; sem eles você não consegue atualizar o app na Play Store.

**Opcional – migrar para PKCS12:** Se o keytool mostrar um aviso sugerindo migrar do JKS para PKCS12, você pode rodar (substituindo a senha pela sua):
```powershell
keytool -importkeystore -srckeystore android\upload-keystore.jks -destkeystore android\upload-keystore.jks -deststoretype pkcs12
```
Isso substitui o arquivo pelo formato PKCS12. O uso no `key.properties` e no build continua igual.

## 2. Configurar o key.properties

1. Na pasta `android/`, copie o exemplo:
   - Copie `key.properties.example` para `key.properties`.

2. Abra `key.properties` e preencha com os dados do seu keystore:

```properties
storePassword=senha_que_voce_definiu
keyPassword=mesma_senha_ou_senha_da_chave
keyAlias=upload
storeFile=upload-keystore.jks
```

- `storeFile` deve ser o nome do arquivo do keystore. Se você colocou o `.jks` dentro de `android/`, use `upload-keystore.jks` (caminho relativo à pasta `android/`).

**Importante:** O arquivo `key.properties` e o `.jks` já estão no `.gitignore`. Não faça commit deles.

## 3. Gerar o App Bundle para a Play Store

No terminal, na raiz do projeto:

```bash
flutter build appbundle
```

O arquivo assinado será gerado em:

```
build/app/outputs/bundle/release/app-release.aab
```

Envie esse arquivo **.aab** na Google Play Console (Produção ou teste interno/fechado).

## 4. Se der erro de assinatura

- Confirme que `android/key.properties` existe e está preenchido.
- Confirme que `android/upload-keystore.jks` existe (ou que o caminho em `storeFile` está correto).
- Senhas erradas geram falha na assinatura; use as que você definiu ao criar o keystore.

## Referência

- [Flutter: assinatura de apps Android](https://docs.flutter.dev/deployment/android#signing-the-app)
- [Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756) (a Play Store pode gerenciar a chave por você)
