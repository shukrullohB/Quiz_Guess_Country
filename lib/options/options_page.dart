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
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: const Color(0xFF0F172A),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F172A), Color(0xFF111D38), Color(0xFF0B1326)],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 14),
                _SwitchTile(
                  icon: Icons.graphic_eq_rounded,
                  accent: const Color(0xFF56E29A),
                  title: 'Sound effects',
                  subtitle: 'Enable sounds for actions and feedback.',
                  value: settings.soundEnabled,
                  onChanged: controller.setSoundEnabled,
                ),
                const SizedBox(height: 10),
                _SwitchTile(
                  icon: Icons.vibration_rounded,
                  accent: const Color(0xFF47C2FF),
                  title: 'Vibration',
                  subtitle: 'Use haptic feedback on mobile devices.',
                  value: settings.vibrationEnabled,
                  onChanged: controller.setVibrationEnabled,
                ),
                const SizedBox(height: 10),
                _SwitchTile(
                  icon: Icons.animation_rounded,
                  accent: const Color(0xFFFFBE4A),
                  title: 'Animations',
                  subtitle: 'Enable intro and interface animations.',
                  value: settings.animationsEnabled,
                  onChanged: controller.setAnimationsEnabled,
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      backgroundColor: const Color(0xFF7C2D12),
                      foregroundColor: const Color(0xFFFEE2E2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _confirmReset(context),
                    icon: const Icon(Icons.restart_alt),
                    label: const Text(
                      'Reset progress',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF1D4ED8),
            child: Icon(Icons.tune, color: Colors.white),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Personalize your experience',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
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
    required this.icon,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: SwitchListTile(
          activeThumbColor: Colors.white,
          activeTrackColor: accent,
          inactiveThumbColor: Colors.grey.shade300,
          inactiveTrackColor: Colors.white24,
          value: value,
          onChanged: onChanged,
          secondary: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accent),
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.70)),
          ),
        ),
      ),
    );
  }
}
