import 'package:flutter/material.dart';

class World extends StatefulWidget {
  const World({super.key});

  @override
  State<World> createState() => _WorldState();
}

class _WorldState extends State<World> {
  final List<_WorldNode> _nodes = const [
    _WorldNode(
      id: 1,
      title: 'Norway Fjords',
      imageAsset: 'images/norway.jpg',
      location: '61.20, 6.50',
      position: Offset(0.16, 0.86),
    ),
    _WorldNode(
      id: 2,
      title: 'Greenland Ice',
      imageAsset: 'images/greenland.jpg',
      location: '64.18, -51.74',
      position: Offset(0.30, 0.78),
    ),
    _WorldNode(
      id: 3,
      title: 'Georgia Peaks',
      imageAsset: 'images/georgia.jpg',
      location: '42.66, 44.62',
      position: Offset(0.20, 0.68),
    ),
    _WorldNode(
      id: 4,
      title: 'Ecuador Forest',
      imageAsset: 'images/ecuador.jpg',
      location: '-0.18, -78.47',
      position: Offset(0.42, 0.60),
    ),
    _WorldNode(
      id: 5,
      title: 'Malta Coast',
      imageAsset: 'images/malta.jpg',
      location: '35.90, 14.52',
      position: Offset(0.28, 0.50),
    ),
    _WorldNode(
      id: 6,
      title: 'Greece Cliffs',
      imageAsset: 'images/greece.jpg',
      location: '36.39, 25.46',
      position: Offset(0.52, 0.45),
    ),
    _WorldNode(
      id: 7,
      title: 'Italy Hills',
      imageAsset: 'images/italy.jpg',
      location: '43.77, 11.25',
      position: Offset(0.38, 0.36),
    ),
    _WorldNode(
      id: 8,
      title: 'France Valley',
      imageAsset: 'images/france.jpg',
      location: '45.76, 4.84',
      position: Offset(0.60, 0.32),
    ),
    _WorldNode(
      id: 9,
      title: 'Germany Lake',
      imageAsset: 'images/germany.jpg',
      location: '52.52, 13.40',
      position: Offset(0.46, 0.22),
    ),
    _WorldNode(
      id: 10,
      title: 'Spain Coast',
      imageAsset: 'images/spain.jpg',
      location: '40.42, -3.70',
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
                final left = node.position.dx * constraints.maxWidth;
                final top = node.position.dy * constraints.maxHeight;
                return Positioned(
                  left: left - 24,
                  top: top - 24,
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
              Text(
                'Location: ${node.location}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD17A), Color(0xFF38BDF8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Colors.white.withValues(alpha: 0.75), width: 1.5),
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
          const SizedBox(height: 6),
          Text(
            node.title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w600,
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
      ..color = Colors.white.withValues(alpha: 0.28)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    for (final edge in edges) {
      final from = nodes.firstWhere((node) => node.id == edge.fromId).position;
      final to = nodes.firstWhere((node) => node.id == edge.toId).position;
      final start = Offset(from.dx * size.width, from.dy * size.height);
      final end = Offset(to.dx * size.width, to.dy * size.height);
      final path = _buildCurvedPath(start, end, edge);

      final linePaint = Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFD17A), Color(0xFF7EE8FA)],
        ).createShader(Rect.fromPoints(start, end))
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, linePaint);
    }
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
