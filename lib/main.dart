// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        primaryColor: const Color(0xFF6366F1),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        primaryColor: const Color(0xFF818CF8),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      themeMode: _themeMode,
      home: PortfolioScreen(
        onThemeToggle: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class PortfolioScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final bool isDarkMode;

  const PortfolioScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final opacity = (_scrollOffset / 100).clamp(0.0, 1.0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark
            ? Color.lerp(Colors.transparent, const Color(0xFF1A1A2E), opacity)
            : Color.lerp(Colors.transparent, Colors.white.withOpacity(0.9), opacity),
        title: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 200),
          child: const Text(
            '',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey(isDark),
                  color: isDark ? Colors.amber : Colors.indigo,
                ),
              ),
              onPressed: () => widget.onThemeToggle(!isDark),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0A0A0F),
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                  ]
                : [
                    const Color(0xFFF5F5F7),
                    const Color(0xFFE8EAF6),
                    const Color(0xFFC5CAE9),
                  ],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 100),
              ProfileSection(isDarkMode: isDark),
              const SizedBox(height: 60),
              ProjectsSection(isDarkMode: isDark),
              const SizedBox(height: 60),
              SkillsSection(isDarkMode: isDark),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final bool isDarkMode;
  const ProfileSection({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: (isDarkMode ? Colors.indigo : Colors.blue).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 100,
                backgroundColor: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
                child: CircleAvatar(
                  radius: 90,
                  backgroundImage: const AssetImage('assets/jayvee.png'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            curve: Curves.easeOut,
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Column(
              children: [
                Text(
                  'Jayvee Cañadilla',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: isDarkMode
                            ? [Colors.white, const Color(0xFF818CF8)]
                            : [const Color(0xFF6366F1), const Color(0xFF3B82F6)],
                      ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: (isDarkMode ? Colors.indigo : Colors.blue).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (isDarkMode ? Colors.indigo : Colors.blue).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'BSIT-3A',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? const Color(0xFF818CF8) : const Color(0xFF6366F1),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Aspiring software developer with a passion for creating beautiful and functional mobile applications.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  final bool isDarkMode;
  const ProjectsSection({super.key, required this.isDarkMode});

  final List<Map<String, dynamic>> projects = const [
    {
      'title': 'POS Mobile Application',
      'description':" A Flutter-based mobile app for small businesses to manage sales, inventory, and customer data seamlessly.",
      'github': 'https://github.com/yourusername/ecommerce',
      'icon': Icons.shopping_cart_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'title': 'Snake Game',
      'description': 'A classic snake game built with Flutter and Dart.',
      'github': 'https://github.com/yourusername/scraper',
      'icon': Icons.games_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': 'Portfolio Website',
      'description': 'A responsive portfolio website built with Flutter and Dart.',
      'github': null,
      'icon': Icons.article_rounded,
      'color': Color(0xFFF59E0B),
    },
  ];

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Projects',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          ...projects.asMap().entries.map((entry) {
            final index = entry.key;
            final project = entry.value;
            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 400 + (index * 100)),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.easeOut,
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ProjectCard(
                  title: project['title']!,
                  description: project['description']!,
                  icon: project['icon']!,
                  color: project['color']!,
                  githubLink: project['github'],
                  onTap: project['github'] != null ? () => _launchURL(project['github']) : null,
                  isDarkMode: isDarkMode,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? githubLink;
  final VoidCallback? onTap;
  final bool isDarkMode;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.githubLink,
    this.onTap,
    required this.isDarkMode,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? const Color(0xFF1E1E2E).withOpacity(0.5) : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_isHovered ? 0.3 : 0.1),
                blurRadius: _isHovered ? 20 : 10,
                spreadRadius: _isHovered ? 2 : 0,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: widget.isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onTap != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.arrow_forward_rounded, color: widget.color, size: 20),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SkillsSection extends StatelessWidget {
  final bool isDarkMode;
  const SkillsSection({super.key, required this.isDarkMode});

  final Map<String, Map<String, dynamic>> technicalSkills = const {
    'Flutter/Dart': {'icon': Icons.phone_android_rounded, 'level': 0.6},
    'Python': {'icon': Icons.code_rounded, 'level': 0.85},
    'SQL/Databases': {'icon': Icons.storage_rounded, 'level': 0.75},
    'UI/UX Design': {'icon': Icons.palette_rounded, 'level': 0.7},
    'C++': {'icon': Icons.computer_rounded, 'level': 0.6},
    'Java': {'icon': Icons.developer_mode_rounded, 'level': 0.5},
    'React': {'icon': Icons.web_rounded, 'level': 0.4},
  };

  final List<String> softSkills = const [
    'Problem Solving',
    'Team Collaboration',
    'Time Management',
    'Adaptability',
    'Effective Communication',
    'Critical Thinking',
    'Creativity',
    'Leadership',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills & Expertise',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E2E).withOpacity(0.5) : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Technical Skills',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ...technicalSkills.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SkillBar(
                      skill: entry.key,
                      icon: entry.value['icon'],
                      level: entry.value['level'],
                      isDarkMode: isDarkMode,
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                Text(
                  'Soft Skills',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: softSkills.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: (isDarkMode ? Colors.teal : Colors.blue).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: (isDarkMode ? Colors.teal : Colors.blue).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: isDarkMode ? Colors.teal : Colors.blue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            skill,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkillBar extends StatefulWidget {
  final String skill;
  final IconData icon;
  final double level;
  final bool isDarkMode;

  const SkillBar({
    super.key,
    required this.skill,
    required this.icon,
    required this.level,
    required this.isDarkMode,
  });

  @override
  State<SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<SkillBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.level).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(widget.icon, size: 18, color: widget.isDarkMode ? Colors.indigo[300] : Colors.indigo),
            const SizedBox(width: 8),
            Text(
              widget.skill,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: widget.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _animation.value,
                minHeight: 8,
                backgroundColor: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.isDarkMode ? const Color(0xFF818CF8) : const Color(0xFF6366F1),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}