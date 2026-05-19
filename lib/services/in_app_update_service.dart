import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

export 'package:in_app_update/in_app_update.dart' show AppUpdateInfo, UpdateAvailability;

typedef UpdateChecker = Future<AppUpdateInfo> Function();

/// Resultado da consulta à Play Store.
typedef UpdateResult = ({AppUpdateInfo? info, Object? error});

/// Consulta a Play Store e retorna [UpdateResult] com info ou erro.
/// Nunca lança — o erro é capturado e retornado para exibição (ex: debug banner).
Future<UpdateResult> getUpdateInfo({UpdateChecker? checker}) async {
  try {
    final info = await (checker ?? InAppUpdate.checkForUpdate)();
    return (info: info, error: null);
  } catch (e) {
    return (info: null, error: e);
  }
}

/// Verifica atualização via Play In-App Update API e exibe diálogo se houver nova versão.
///
/// [checker] é injetável para testes; em produção usa [InAppUpdate.checkForUpdate].
/// Erros são silenciados — em debug/sideload/sem Play Services nunca trava.
Future<void> checkAndPromptUpdate(
  BuildContext context, {
  UpdateChecker? checker,
}) async {
  final (:info, :error) = await getUpdateInfo(checker: checker);
  if (error != null) return; // silencioso em produção
  if (info?.updateAvailability == UpdateAvailability.updateAvailable) {
    if (context.mounted) showUpdateAvailableDialog(context);
  }
}

@visibleForTesting
void showUpdateAvailableDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Text('Nova versão disponível'),
      content: const Text(
        'Uma nova versão do Hinário está disponível.\n'
        'Atualize para ter as últimas melhorias.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Depois'),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.of(ctx).pop();
            await InAppUpdate.performImmediateUpdate();
          },
          child: const Text('Atualizar'),
        ),
      ],
    ),
  );
}
