import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'intro/animated_intro_page.dart';
import 'level_page/levels.dart';
import 'options/options_page.dart';
import 'settings/app_settings.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_repository.dart';
import 'settings/settings_scope.dart';
import 'the_world/world.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = SettingsRepository();
  final initialSettings = await repository.load();
  final controller = SettingsController(
    repository: repository,
    initial: initialSettings,
  );

  runApp(MyApp(settingsController: controller));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return SettingsScope(
      controller: settingsController,
      child: ValueListenableBuilder<AppSettings>(
        valueListenable: settingsController,
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'World Explorer',
            theme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF22D3EE),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              fontFamily: 'Roboto',
              scaffoldBackgroundColor: const Color(0xFF0F172A),
              canvasColor: const Color(0xFF0F172A),
            ),
            debugShowCheckedModeBanner: false,
            home: _AppEntry(settings: settings),
          );
        },
      ),
    );
  }
}

class _AppEntry extends StatefulWidget {
  const _AppEntry({required this.settings});

  final AppSettings settings;

  @override
  State<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<_AppEntry> {
  bool _introDone = false;

  @override
  Widget build(BuildContext context) {
    if (!_introDone) {
      return AnimatedIntroPage(
        animationsEnabled: widget.settings.animationsEnabled,
        onCompleted: () {
          if (!mounted) return;
          setState(() => _introDone = true);
        },
      );
    }

    return const MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  bool _didInitEntrance = false;
  bool _didPrecache = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPrecache) {
      _didPrecache = true;
      precacheImage(const AssetImage('images/main_sakura.jpeg'), context);
      precacheImage(const AssetImage('images/world_bg.jpg'), context);
    }
    if (_didInitEntrance) return;
    _didInitEntrance = true;
    final animationsEnabled = SettingsScope.of(context).value.animationsEnabled;
    if (animationsEnabled) {
      _entranceController.forward();
    } else {
      _entranceController.value = 1;
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.52),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF131B33), Color(0xFF0D1428)],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF6A55).withValues(alpha: 0.18),
                    border: Border.all(
                      color: const Color(0xFFFF6A55).withValues(alpha: 0.45),
                    ),
                  ),
                  child: const Icon(Icons.logout_rounded, color: Color(0xFFFF9A8A), size: 28),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Exit World Explorer?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your progress is saved. You can continue anytime.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.76),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Stay',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6A55),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        onPressed: () => SystemNavigator.pop(),
                        child: const Text(
                          'Exit',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route<void> _buildMenuRoute(Widget page) {
    return MaterialPageRoute<void>(
      builder: (_) => page,
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = SettingsScope.of(context);
    final animationsEnabled = settingsController.value.animationsEnabled;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/main_sakura.jpeg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.black.withValues(alpha: 0.14)),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF22D3EE).withValues(alpha: 0.35),
                                blurRadius: 18,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.asset('images/logo.png', fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'World Explorer',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildAnimatedButton(
                          index: 0,
                          animationsEnabled: animationsEnabled,
                          child: HomeButton(
                            label: 'Start',
                            icon: Icons.play_arrow_rounded,
                            gradient: const LinearGradient(colors: [Color(0xFF56E29A), Color(0xFF27B96A)]),
                            animationsEnabled: animationsEnabled,
                            onTap: () => Navigator.of(context).push(
                              _buildMenuRoute(const LevelSelectPage()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAnimatedButton(
                          index: 1,
                          animationsEnabled: animationsEnabled,
                          child: HomeButton(
                            label: 'The World',
                            icon: Icons.public,
                            gradient: const LinearGradient(colors: [Color(0xFF47C2FF), Color(0xFF287EF2)]),
                            animationsEnabled: animationsEnabled,
                            onTap: () => Navigator.of(context).push(
                              _buildMenuRoute(const World()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAnimatedButton(
                          index: 2,
                          animationsEnabled: animationsEnabled,
                          child: HomeButton(
                            label: 'Options',
                            icon: Icons.tune,
                            gradient: const LinearGradient(colors: [Color(0xFFFFBE4A), Color(0xFFF0852D)]),
                            animationsEnabled: animationsEnabled,
                            onTap: () => Navigator.of(context).push(
                              _buildMenuRoute(const OptionsPage()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAnimatedButton(
                          index: 3,
                          animationsEnabled: animationsEnabled,
                          child: HomeButton(
                            label: 'Exit',
                            icon: Icons.logout,
                            gradient: const LinearGradient(colors: [Color(0xFFFF6A55), Color(0xFFE53935)]),
                            animationsEnabled: animationsEnabled,
                            onTap: () => _showExitDialog(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton({
    required int index,
    required bool animationsEnabled,
    required Widget child,
  }) {
    if (!animationsEnabled) return child;

    final start = index * 0.12;
    final end = (start + 0.45).clamp(0.0, 1.0);

    final curved = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(curved),
        child: child,
      ),
    );
  }
}

class HomeButton extends StatefulWidget {
  const HomeButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.gradient,
    required this.animationsEnabled,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Gradient gradient;
  final bool animationsEnabled;

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _pressed = false;

  late final AnimationController _iconPulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animationsEnabled) {
      _iconPulse.repeat(reverse: true);
    } else {
      _iconPulse.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant HomeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationsEnabled != oldWidget.animationsEnabled) {
      if (widget.animationsEnabled) {
        _iconPulse.repeat(reverse: true);
      } else {
        _iconPulse
          ..stop()
          ..value = 1;
      }
    }
  }

  @override
  void dispose() {
    _iconPulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.985 : (_hovered ? 1.02 : 1.0);
    final baseShadow = _pressed ? 5.0 : 11.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            height: 56,
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  blurRadius: baseShadow,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _iconPulse,
                  builder: (_, __) {
                    final pulse = widget.animationsEnabled ? (0.95 + (_iconPulse.value * 0.1)) : 1.0;
                    return Transform.scale(
                      scale: pulse,
                      child: Icon(widget.icon, color: Colors.white, size: 24),
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
