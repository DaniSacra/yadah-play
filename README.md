# Yadah Play

Hinário offline em app Flutter. Lista, busca e exibe a letra dos hinos sem necessidade de internet. Inclui tema claro/escuro, histórico dos últimos hinos visualizados e aviso de atualização quando há nova versão na Play Store.

## Sobre o projeto

- **Plataforma:** Android e iOS (Flutter)
- **Interface:** Material Design 3 (tema claro e escuro)
- **Dados:** Hinos em JSON embutido no app (`assets/data/hymns.json`)
- **Estado:** Provider (ChangeNotifier) para lista, busca, tema, tamanho da fonte e histórico de visualizados

## Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (ambiente configurado para `flutter` no PATH)
- Dart 3.5+

## Como rodar

```bash
# Na pasta do projeto
flutter pub get
flutter run
```

Build de release:

```bash
# APK (instalação direta)
flutter build apk

# Android App Bundle (recomendado para Play Store)
flutter build appbundle
```

Para assinatura e envio à Play Store, veja [SIGNING.md](SIGNING.md).

## Estrutura do projeto

```
lib/
├── main.dart                    # Entrada, temas, Provider, UpgradeAlert
├── theme_mode_notifier.dart     # Tema claro/escuro (SharedPreferences)
├── models/
│   └── hymn.dart               # Modelo Hymn (id, number, title, lyrics)
├── repositories/
│   ├── hymn_repository.dart     # Carrega hinos do JSON (rootBundle)
│   └── hymn_state.dart         # Lista, status, filtro, fonte, últimos 20 visualizados
├── screens/
│   ├── home_screen.dart        # Lista, busca, histórico, diálogo de atualização (debug)
│   ├── hymn_detail_screen.dart # Letra, A-/A+, anterior/próximo
│   └── recent_hymns_screen.dart# Tela "Últimos hinos visualizados"
└── widgets/
    └── hymn_list_tile.dart     # Card de hino reutilizado (home + recentes)

assets/
├── data/
│   └── hymns.json              # Dados dos hinos (id, number, title, lyrics)
└── icon.png                    # Ícone do app (gerado por flutter_launcher_icons)
```

## Dados (hymns.json)

- **Formato:** array de objetos JSON.
- **Campos por hino:** `id` (string), `number` (int), `title` (string), `lyrics` (string).
- **Letras:** quebras de linha com `\n`; estrofes separadas com `\n\n` onde aplicável.
- **Aspas nas letras:** devem estar escapadas no JSON (ex.: `\"Achei-te, tu és Meu\"`).

Exemplo:

```json
{
  "id": "1",
  "number": 1,
  "title": "Estamos aqui pra Te adorar",
  "lyrics": "Estamos aqui pra Te adorar,\nEm Tua presença..."
}
```

O asset está declarado em `pubspec.yaml` em `flutter.assets`.

## Funcionalidades

- **Home:** lista de hinos (número + título); toque abre o detalhe.
- **Busca:** por número ou título; opção "Buscar na letra"; case-insensitive.
- **Tema:** claro/escuro; preferência salva (SharedPreferences).
- **Detalhe do hino:** título e letra; botões A-/A+ (tamanho da fonte, persistido); anterior/próximo.
- **Últimos hinos:** ícone de histórico na home abre tela com os 20 últimos hinos visualizados (clicáveis).
- **Atualização:** ao abrir o app, se a versão na Play Store for maior que a instalada, o usuário vê aviso e botão para abrir a loja. Para forçar atualização (ex.: 2.0), adicione na descrição da ficha do app na Play Store: `[Minimum supported app version: 2.0.0]`.

## Dependências principais

| Pacote | Uso |
|--------|-----|
| **provider** | Estado (HymnState, ThemeModeNotifier). |
| **shared_preferences** | Tema, tamanho da fonte, IDs dos últimos hinos. |
| **upgrader** | Verifica versão na loja e exibe aviso de atualização. |
| **url_launcher** | Abre a Play Store no diálogo de atualização (debug). |

O projeto não está publicado no pub.dev (`publish_to: 'none'` no `pubspec.yaml`).

## Manutenção para devs

### Testes

```bash
flutter test
flutter analyze
```

- Testes em `test/`: `hymn_state_test.dart`, `hymn_test.dart`, `theme_mode_notifier_test.dart`, `widget_test.dart`.
- Helpers compartilhados em `test/helpers.dart` (FakeHymnRepository, sampleHymns).

### Ícone do app

- Fonte: `assets/icon.png`.
- Gerar ícones para Android/iOS: `dart run flutter_launcher_icons` (config em `pubspec.yaml`, seção `flutter_launcher_icons`).

### Aviso de atualização (upgrader)

- **Produção:** o aviso só aparece quando a versão na Play Store é **maior** que a instalada.
- **Debug:** em `flutter run`, um diálogo de teste "Nova versão disponível" aparece ~1,5 s após abrir a home (em `home_screen.dart`, `kDebugMode`). Não aparece em release.
- **Forçar atualização:** na descrição da ficha do app na Play Store, incluir `[Minimum supported app version: X.Y.Z]`; o upgrader esconde "Depois"/"Ignorar" para versões abaixo da mínima.

### Android (build)

- Em `android/build.gradle` há um bloco que define a propriedade `flutter` (compileSdkVersion, minSdkVersion) para plugins que dependem dela (ex.: package_info_plus). Não remover.
- Kotlin 2.2.0 em `android/settings.gradle` (exigido por dependências como package_info_plus).

### Versão

Definida em `pubspec.yaml` (`version: X.Y.Z+N`). Ao publicar nova versão na loja, incremente antes do build.

---

Para dúvidas sobre Flutter: [documentação oficial](https://docs.flutter.dev/).
