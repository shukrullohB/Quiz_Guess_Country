import 'package:flutter/material.dart';

import '../settings/progress_repository.dart';
import '../settings/app_settings.dart';
import '../settings/settings_scope.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsScope.of(context);
    return ValueListenableBuilder<AppSettings>(
      valueListenable: controller,
      builder: (context, settings, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Options'),
            backgroundColor: const Color(0xFF10182D),
            foregroundColor: Colors.white,
          ),
          backgroundColor: const Color(0xFF0F172A),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SwitchTile(
                title: 'Sound effects',
                subtitle: 'Enable sounds for actions and feedback.',
                value: settings.soundEnabled,
                onChanged: controller.setSoundEnabled,
              ),
              const SizedBox(height: 10),
              _SwitchTile(
                title: 'Vibration',
                subtitle: 'Use haptic feedback on mobile devices.',
                value: settings.vibrationEnabled,
                onChanged: controller.setVibrationEnabled,
              ),
              const SizedBox(height: 10),
              _SwitchTile(
                title: 'Animations',
                subtitle: 'Enable intro and interface animations.',
                value: settings.animationsEnabled,
                onChanged: controller.setAnimationsEnabled,
              ),
              const SizedBox(height: 20),
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  backgroundColor: const Color(0xFF3B1D2A),
                  foregroundColor: const Color(0xFFFFD3DE),
                ),
                onPressed: () => _confirmReset(context),
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset progress'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset progress?'),
        content: const Text('This will clear completed levels and restore default settings.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Reset')),
        ],
      ),
    );

    if (shouldReset != true || !context.mounted) return;

    final controller = SettingsScope.of(context);
    await controller.resetSettings();
    await ProgressRepository().reset();

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings and progress have been reset.')),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF111D38),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: SwitchListTile(
        activeThumbColor: const Color(0xFF10E17A),
        inactiveThumbColor: Colors.grey.shade300,
        value: value,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.68))),
      ),
    );
  }
}
