import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class World extends StatefulWidget {
  const World({super.key});

  @override
  State<World> createState() => _WorldState();
}

class _WorldState extends State<World> {
  final TransformationController _transformController =
      TransformationController();
  int? _selectedNodeId;

  final List<_WorldNode> _nodes = const [
    _WorldNode(
      id: 1,
      title: 'Rainbow River, Colombia',
      imageAsset: 'images/world1.jpg',
      location: 'https://maps.app.goo.gl/6R8t4bh1y3hBufbi8',
      position: Offset(0.22, 0.84),
    ),
    _WorldNode(
      id: 2,
      title: 'Zhangye Danxia, China',
      imageAsset: 'images/world2.jpg',
      location: 'https://maps.app.goo.gl/LitDwrqm2WAbWWgb9',
      position: Offset(0.36, 0.76),
    ),
    _WorldNode(
      id: 3,
      title: 'Lake Hillier, Australia',
      imageAsset: 'images/world3.png',
      location: 'https://maps.app.goo.gl/v4UWhSuLqqL8F1Pf8',
      position: Offset(0.26, 0.68),
    ),
    _WorldNode(
      id: 4,
      title: 'Vinicunca, Peru',
      imageAsset: 'images/world4.png',
      location: 'https://maps.app.goo.gl/5WzpBqdtXTo94NrD6',
      position: Offset(0.46, 0.60),
    ),
    _WorldNode(
      id: 5,
      title: "Thor's Well, USA",
      imageAsset: 'images/world5.png',
      location: 'https://maps.app.goo.gl/NQUYNBCJN6K2WAaD8',
      position: Offset(0.32, 0.52),
    ),
    _WorldNode(
      id: 6,
      title: 'Red Beach, China',
      imageAsset: 'images/world6.png',
      location: 'https://maps.app.goo.gl/eZxgzDMF8F8izvGQ9',
      position: Offset(0.58, 0.44),
    ),
    _WorldNode(
      id: 7,
      title: 'Pamukkale, Turkey',
      imageAsset: 'images/world7.png',
      location: 'https://maps.app.goo.gl/oVtnmivVmuW5243z5',
      position: Offset(0.40, 0.36),
    ),
    _WorldNode(
      id: 8,
      title: 'Champagne Pool, New Zealand',
      imageAsset: 'images/world8.png',
      location: 'https://maps.app.goo.gl/61uJMKUZ1F6ex45x5',
      position: Offset(0.72, 0.28),
    ),
    _WorldNode(
      id: 9,
      title: 'Tianzi Mountains, China',
      imageAsset: 'images/world9.jpg',
      location: 'https://maps.app.goo.gl/RZiUZuWftVA5RwQR6',
      position: Offset(0.52, 0.20),
    ),
    _WorldNode(
      id: 10,
      title: 'Chocolate Hills, Philippines',
      imageAsset: 'images/world10.jpg',
      location: 'https://maps.app.goo.gl/bbKu3qCfYXeNpTVg6',
      position: Offset(0.80, 0.12),
    ),
  ];

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The World'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mapWidth = constraints.maxWidth;
          final mapHeight = constraints.maxHeight;
          const nodeRadius = 28.0;
          const labelWidth = 178.0;
          const labelHeight = 28.0;
          const labelGap = 4.0;

          final sortedNodes = List<_WorldNode>.from(_nodes)
            ..sort((a, b) {
              if (a.id == _selectedNodeId) return 1;
              if (b.id == _selectedNodeId) return -1;
              return a.id.compareTo(b.id);
            });
          const labelDxOverrides = <int, double>{
            4: 34, // "Vinicunca, Peru" move right (was covered by level 3)
            3: -26, // "Lake Hillier, Australia" move left (was covered by level 2)
            2: 34, // "Zhangye Danxia, China" move right (was covered by level 1)
          };

          return InteractiveViewer(
            transformationController: _transformController,
            minScale: 1,
            maxScale: 1.7,
            boundaryMargin: const EdgeInsets.all(20),
            child: SizedBox(
              width: mapWidth,
              height: mapHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'images/world_bg.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: const Color(0xFF0F172A));
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.28),
                            Colors.black.withValues(alpha: 0.56),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomPaint(
                    size: Size(mapWidth, mapHeight),
                    painter: _WorldConnectionsPainter(
                      nodes: _nodes,
                      selectedNodeId: _selectedNodeId,
                    ),
                  ),
                  ...sortedNodes.map((node) {
                    final center = Offset(
                      node.position.dx * mapWidth,
                      node.position.dy * mapHeight,
                    );
                    final rawLabelLeft =
                        center.dx - (labelWidth / 2) + (labelDxOverrides[node.id] ?? 0);
                    final rawLabelTop = center.dy + nodeRadius + labelGap;
                    final labelLeft = rawLabelLeft.clamp(
                      8.0,
                      mapWidth - labelWidth - 8,
                    );
                    final labelTop = rawLabelTop.clamp(
                      8.0,
                      mapHeight - labelHeight - 8,
                    );
                    final isSelected = node.id == _selectedNodeId;
                    return Positioned(
                      left: labelLeft,
                      top: labelTop,
                      child: IgnorePointer(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: labelWidth,
                          height: labelHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF6EE7F9).withValues(
                                      alpha: 0.8,
                                    )
                                  : Colors.white.withValues(alpha: 0.30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.30),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                color: Colors.black.withValues(
                                  alpha: isSelected ? 0.56 : 0.50,
                                ),
                                child: Text(
                                  node.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.8,
                                    fontWeight: FontWeight.w700,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black87,
                                        blurRadius: 8,
                                        offset: Offset(0, 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  ...sortedNodes.map((node) {
                    final center = Offset(
                      node.position.dx * mapWidth,
                      node.position.dy * mapHeight,
                    );
                    final isSelected = node.id == _selectedNodeId;
                    return Positioned(
                      left: center.dx - nodeRadius,
                      top: center.dy - nodeRadius,
                      child: _WorldNodeWidget(
                        node: node,
                        selected: isSelected,
                        onTap: () {
                          setState(() => _selectedNodeId = node.id);
                          _showNodeDetails(node);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showNodeDetails(_WorldNode node) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      node.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '#${node.id}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  node.imageAsset,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 190,
                      width: double.infinity,
                      color: Colors.white.withValues(alpha: 0.08),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white70,
                        size: 36,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: const Color(0xFF0F172A),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _openLocation(node),
                  icon: const Icon(Icons.location_on),
                  label: const Text(
                    'Open Location',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openLocation(_WorldNode node) async {
    final uri = _buildMapsUri(node.location);
    if (uri == null) {
      _showLocationError();
      return;
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showLocationError();
    }
  }

  Uri? _buildMapsUri(String location) {
    final trimmed = location.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return Uri.tryParse(trimmed);
    }

    final parts = trimmed.split(',');
    if (parts.length != 2) return null;

    final lat = double.tryParse(parts[0].trim());
    final lon = double.tryParse(parts[1].trim());
    if (lat == null || lon == null) return null;

    return Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lon',
    );
  }

  void _showLocationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unable to open location. Please try again later.'),
      ),
    );
  }
}

class _WorldNode {
  const _WorldNode({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.location,
    required this.position,
  });

  final int id;
  final String title;
  final String imageAsset;
  final String location;
  final Offset position;
}

class _WorldNodeWidget extends StatelessWidget {
  const _WorldNodeWidget({
    required this.node,
    required this.selected,
    required this.onTap,
  });

  final _WorldNode node;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: selected
                    ? const [Color(0xFF34D399), Color(0xFF22D3EE)]
                    : const [Color(0xFFFFD17A), Color(0xFF38BDF8)],
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      (selected
                              ? const Color(0xFF22D3EE)
                              : const Color(0xFF38BDF8))
                          .withValues(alpha: 0.45),
                  blurRadius: selected ? 14 : 10,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.9),
                width: selected ? 3 : 2,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0F172A).withValues(alpha: 0.2),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.7),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${node.id}',
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorldConnectionsPainter extends CustomPainter {
  _WorldConnectionsPainter({
    required this.nodes,
    required this.selectedNodeId,
  });

  final List<_WorldNode> nodes;
  final int? selectedNodeId;

  @override
  void paint(Canvas canvas, Size size) {
    final ordered = [...nodes]..sort((a, b) => a.id.compareTo(b.id));
    if (ordered.length < 2) return;

    const nodeYOffset = 0.0;
    final points = ordered
        .map(
          (node) => Offset(
            node.position.dx * size.width,
            node.position.dy * size.height + nodeYOffset,
          ),
        )
        .toList(growable: false);

    final routePath = _buildSmoothPath(points);

    final glowPaint = Paint()
      ..color = const Color(0xFF67E8F9).withValues(alpha: 0.23)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final routePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF7DD3FC), Color(0xFF22D3EE), Color(0xFF67E8F9)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(routePath, glowPaint);
    canvas.drawPath(routePath, routePaint);

    if (selectedNodeId != null) {
      final selectedIndex = ordered.indexWhere((node) => node.id == selectedNodeId);
      if (selectedIndex > 0) {
        _drawHighlightedSegment(canvas, points[selectedIndex - 1], points[selectedIndex]);
      }
      if (selectedIndex >= 0 && selectedIndex < points.length - 1) {
        _drawHighlightedSegment(canvas, points[selectedIndex], points[selectedIndex + 1]);
      }
    }
  }

  Path _buildSmoothPath(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    return path;
  }

  void _drawHighlightedSegment(Canvas canvas, Offset start, Offset end) {
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);

    final highlight = Paint()
      ..color = const Color(0xFFCCFBF1).withValues(alpha: 0.9)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, highlight);
  }

  @override
  bool shouldRepaint(covariant _WorldConnectionsPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.selectedNodeId != selectedNodeId;
  }
}
