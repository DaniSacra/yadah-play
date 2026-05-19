import 'package:flutter/material.dart';

import '../services/in_app_update_service.dart';

/// Painel de diagnóstico do in_app_update. Só compilado/exibido em kDebugMode.
class UpdateDebugBanner extends StatefulWidget {
  const UpdateDebugBanner({super.key});

  @override
  State<UpdateDebugBanner> createState() => _UpdateDebugBannerState();
}

class _UpdateDebugBannerState extends State<UpdateDebugBanner> {
  AppUpdateInfo? _info;
  bool _loading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    setState(() {
      _loading = true;
      _error = null;
      _info = null;
    });
    final (:info, :error) = await getUpdateInfo();
    if (!mounted) return;
    setState(() {
      _info = info;
      _error = error;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.surfaceContainerHighest,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bug_report, size: 14, color: cs.primary),
                const SizedBox(width: 4),
                Text(
                  'Update Debug',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
                const Spacer(),
                if (_loading)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Verificar novamente',
                    onPressed: _check,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            if (_error != null)
              _row('❌ Erro', _error.toString(), color: Colors.red)
            else if (_info == null)
              _row('Status', 'Aguardando...')
            else ...[
              _row('Disponibilidade', _availabilityLabel(_info!.updateAvailability)),
              _row('Atualização imediata', _info!.immediateUpdateAllowed ? 'permitida' : 'não permitida'),
              _row('Atualização flexível', _info!.flexibleUpdateAllowed ? 'permitida' : 'não permitida'),
              if (_info!.clientVersionStalenessDays != null)
                _row('Dias desatualizado', '${_info!.clientVersionStalenessDays}d'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? color}) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 11),
            children: [
              TextSpan(
                text: '$label: ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              TextSpan(
                text: value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      );

  String _availabilityLabel(UpdateAvailability a) => switch (a) {
        UpdateAvailability.updateAvailable => '✅ Nova versão disponível!',
        UpdateAvailability.updateNotAvailable => '✔ App atualizado',
        UpdateAvailability.developerTriggeredUpdateInProgress => '⏳ Atualização em andamento',
        UpdateAvailability.unknown => '❓ Desconhecido',
      };
}
