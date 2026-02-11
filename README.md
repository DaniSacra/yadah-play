# Yadah Play

Hinário offline em app Flutter. Lista, busca e exibe a letra dos hinos sem necessidade de internet.

## Sobre o projeto

- **Plataforma:** Android e iOS (Flutter)
- **Interface:** Material Design 3
- **Dados:** 188 hinos em JSON embutido no app (`assets/data/hymns.json`)
- **Estado:** Provider (ChangeNotifier) para lista, carregamento e busca

## Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (ambiente configurado para `flutter` no PATH)
- Dart 3.5+

## Como rodar

```bash
# Clonar o repositório (ou já estar na pasta do projeto)
cd yadah_play

# Instalar dependências
flutter pub get

# Rodar no dispositivo/emulador
flutter run
```

Build de release (ex.: APK Android):

```bash
flutter build apk
```

## Estrutura do projeto

```
lib/
├── main.dart                 # Entrada do app, Provider e MaterialApp
├── models/
│   └── hymn.dart             # Modelo Hymn (id, number, title, lyrics)
├── repositories/
│   ├── hymn_repository.dart  # Carrega hinos do JSON (rootBundle)
│   └── hymn_state.dart      # HymnState (ChangeNotifier): lista, status, filterByQuery
└── screens/
    ├── home_screen.dart      # Lista de hinos + campo de busca
    └── hymn_detail_screen.dart # Letra do hino + controle de tamanho da fonte

assets/
└── data/
    └── hymns.json           # Dados dos 188 hinos (id, number, title, lyrics)
```

## Dados (hymns.json)

- **Formato:** array de objetos JSON.
- **Campos por hino:** `id` (string), `number` (int), `title` (string), `lyrics` (string).
- **Letras:** quebras de linha com `\n`; estrofes separadas com `\n\n` onde aplicável.
- **Aspas nas letras:** devem estar escapadas no JSON (ex.: `\"Achei-te, tu és Meu\"`).

Exemplo de entrada:

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

- **Home:** lista todos os hinos (número + título); ao tocar, abre o detalhe.
- **Busca:** filtra por número ou título (case-insensitive); botão para limpar o texto.
- **Detalhe do hino:** exibe título e letra com quebras de linha; botões para aumentar e diminuir o tamanho da fonte.

## Dependências principais

- **provider** – estado da lista de hinos e notificação à UI.

O projeto não está publicado no pub.dev (`publish_to: 'none'` no `pubspec.yaml`).

## Versão

1.0.0+1 (definida em `pubspec.yaml`).

---

Para dúvidas sobre Flutter: [documentação oficial](https://docs.flutter.dev/).
