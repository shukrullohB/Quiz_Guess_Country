import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class World extends StatefulWidget {
  const World({super.key});

  @override
  State<World> createState() => _WorldState();
}

class _WorldState extends State<World> {
  final List<_WorldNode> _nodes = const [
    _WorldNode(
      id: 1,
      title: '(Rainbow River), Colombia',
      imageAsset: 'images/world1.jpg',
      location: 'https://maps.app.goo.gl/6R8t4bh1y3hBufbi8',
      position: Offset(0.16, 0.86),
    ),
    _WorldNode(
      id: 2,
      title: 'Zhangye Danxia), China',
      imageAsset: 'images/world2.jpg',
      location: 'https://maps.app.goo.gl/LitDwrqm2WAbWWgb9',
      position: Offset(0.30, 0.78),
    ),
    _WorldNode(
      id: 3,
      title: ' (Lake Hillier), Australia',
      imageAsset: 'images/world3.png',
      location: 'https://maps.app.goo.gl/v4UWhSuLqqL8F1Pf8',
      position: Offset(0.20, 0.68),
    ),
    _WorldNode(
      id: 4,
      title: '(Vinicunca), Peru',
      imageAsset: 'images/world4.png',
      location: 'https://maps.app.goo.gl/5WzpBqdtXTo94NrD6',
      position: Offset(0.42, 0.60),
    ),
    _WorldNode(
      id: 5,
      title: ' (Thor’s Well), USA',
      imageAsset: 'images/world5.png',
      location: 'https://maps.app.goo.gl/NQUYNBCJN6K2WAaD8',
      position: Offset(0.28, 0.50),
    ),
    _WorldNode(
      id: 6,
      title: '(Red Beach), China',
      imageAsset: 'images/world6.png',
      location: 'https://maps.app.goo.gl/eZxgzDMF8F8izvGQ9',
      position: Offset(0.52, 0.45),
    ),
    _WorldNode(
      id: 7,
      title: '(Pamukkale), Turkey',
      imageAsset: 'images/world7.png',
      location: 'https://maps.app.goo.gl/oVtnmivVmuW5243z5',
      position: Offset(0.38, 0.36),
    ),
    _WorldNode(
      id: 8,
      title: '(Champagne Pool), New Zealand',
      imageAsset: 'images/world8.png',
      location: 'https://maps.app.goo.gl/61uJMKUZ1F6ex45x5',
      position: Offset(0.60, 0.32),
    ),
    _WorldNode(
      id: 9,
      title: '(Tianzi Mountains), China',
      imageAsset: 'images/world9.jpg',
      location: 'https://maps.app.goo.gl/RZiUZuWftVA5RwQR6',
      position: Offset(0.46, 0.22),
    ),
    _WorldNode(
      id: 10,
      title: '(Chocolate Hills), Philippines',
      imageAsset: 'images/world10.jpg',
      location: 'https://maps.app.goo.gl/bbKu3qCfYXeNpTVg6',
      position: Offset(0.66, 0.16),
    ),
  ];

  final List<_WorldEdge> _edges = const [
    _WorldEdge(1, 2),
    _WorldEdge(2, 3),
    _WorldEdge(3, 4),
    _WorldEdge(4, 5),
    _WorldEdge(5, 6),
    _WorldEdge(6, 7),
    _WorldEdge(7, 8),
    _WorldEdge(8, 9),
    _WorldEdge(9, 10),
  ];

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
          return Stack(
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
                        Colors.black.withValues(alpha: 0.35),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              ),
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _WorldConnectionsPainter(
                  nodes: _nodes,
                  edges: _edges,
                ),
              ),
              ..._nodes.map((node) {
                const nodeYOffset = -48.0;
                final left = node.position.dx * constraints.maxWidth;
                final top = node.position.dy * constraints.maxHeight + nodeYOffset;
                return Positioned(
                  left: left - 28,
                  top: top - 28,
                  child: _WorldNodeWidget(
                    node: node,
                    onTap: () => _showNodeDetails(node),
                  ),
                );
              }),
            ],
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
                  Text(
                    node.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '#${node.id}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
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
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.white.withValues(alpha: 0.08),
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported, color: Colors.white70, size: 36),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _openLocation(node),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.location_on, color: Color(0xFF0F172A), size: 20),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Location',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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

    return Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
  }

  void _showLocationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to open location. Please try again later.')),
    );
  }
}

class _WorldNode {
  final int id;
  final String title;
  final String imageAsset;
  final String location;
  final Offset position;

  const _WorldNode({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.location,
    required this.position,
  });
}

class _WorldEdge {
  final int fromId;
  final int toId;

  const _WorldEdge(this.fromId, this.toId);
}

class _WorldNodeWidget extends StatelessWidget {
  final _WorldNode node;
  final VoidCallback onTap;

  const _WorldNodeWidget({
    required this.node,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFD17A), Color(0xFF38BDF8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 2),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0F172A).withValues(alpha: 0.2),
                border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                '${node.id}',
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Text(
              node.title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.92),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorldConnectionsPainter extends CustomPainter {
  final List<_WorldNode> nodes;
  final List<_WorldEdge> edges;

  _WorldConnectionsPainter({
    required this.nodes,
    required this.edges,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    const nodeRadius = 28.0;
    const nodeYOffset = -48.0;

    for (final edge in edges) {
      final from = nodes.firstWhere((node) => node.id == edge.fromId).position;
      final to = nodes.firstWhere((node) => node.id == edge.toId).position;
      final start = Offset(from.dx * size.width, from.dy * size.height + nodeYOffset);
      final end = Offset(to.dx * size.width, to.dy * size.height + nodeYOffset);
      final rawPath = _buildCurvedPath(start, end, edge);
      final path = _trimPath(rawPath, nodeRadius);

      final linePaint = Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFD17A), Color(0xFF7EE8FA), Color(0xFF38BDF8)],
        ).createShader(Rect.fromPoints(start, end))
        ..strokeWidth = 4.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, linePaint);
    }
  }

  Path _trimPath(Path path, double trim) {
    final metrics = path.computeMetrics();
    if (metrics.isEmpty) return path;

    final metric = metrics.first;
    final length = metric.length;
    final start = trim.clamp(0.0, length).toDouble();
    final end = (length - trim).clamp(0.0, length).toDouble();
    if (end <= start) return path;

    return metric.extractPath(start, end);
  }

  Path _buildCurvedPath(Offset start, Offset end, _WorldEdge edge) {
    final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
    final direction = end - start;
    final length = direction.distance == 0 ? 1.0 : direction.distance;
    final normal = Offset(-direction.dy / length, direction.dx / length);
    final sign = edge.fromId.isEven ? -1.0 : 1.0;
    final curveStrength = 0.16 + (edge.fromId % 3) * 0.02;
    final control = mid + normal * (length * curveStrength * sign);

    return Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
  }

  @override
  bool shouldRepaint(covariant _WorldConnectionsPainter oldDelegate) {
    return oldDelegate.nodes != nodes || oldDelegate.edges != edges;
  }
}
