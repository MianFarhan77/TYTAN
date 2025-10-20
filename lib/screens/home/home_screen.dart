import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tytan/screens/background/map.dart';
import 'package:tytan/screens/bottomnavbar/bottomnavbar.dart';
import 'package:tytan/screens/constant/Appconstant.dart';
import 'dart:async';

import 'package:tytan/screens/server/server_screen.dart';

enum ConnectionState { disconnected, connecting, connected }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  ConnectionState _connectionState = ConnectionState.disconnected;
  int _currentNavIndex = 0;
  String _currentServer = "Pakistan";
  String _currentIp = "198.168.192.10";
  Duration _connectedDuration = const Duration();
  Timer? _durationTimer;

  // For connecting animation
  late AnimationController _connectingAnimationController;
  final String _connectingServer = "Türkiye #1";

  // For speed metrics
  final String _downloadSpeed = "52.2 Mbps";
  final String _uploadSpeed = "52.2 Mbps";

  @override
  void initState() {
    super.initState();

    // Setup animation controller for connecting animation
    _connectingAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _connectingAnimationController.dispose();
    _stopTimer();
    super.dispose();
  }

  void _toggleConnection() {
    setState(() {
      switch (_connectionState) {
        case ConnectionState.disconnected:
          _connectionState = ConnectionState.connecting;
          _simulateConnecting();
          break;
        case ConnectionState.connecting:
          // Cancel connecting and go back to disconnected
          _connectionState = ConnectionState.disconnected;
          break;
        case ConnectionState.connected:
          _connectionState = ConnectionState.disconnected;
          _stopTimer();
          break;
      }
    });
  }

  void _simulateConnecting() {
    // Simulate 3 second connecting state before becoming connected
    Future.delayed(const Duration(seconds: 3), () {
      if (_connectionState == ConnectionState.connecting) {
        setState(() {
          _connectionState = ConnectionState.connected;
          _startTimer();
        });
      }
    });
  }

  void _startTimer() {
    _connectedDuration = Duration.zero;
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _connectedDuration = Duration(
          seconds: _connectedDuration.inSeconds + 1,
        );
      });
    });
  }

  void _stopTimer() {
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WorldMapBackground(
        child: SafeArea(
          child: Column(children: [Expanded(child: _buildContent())]),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Show different content based on connection state
    switch (_connectionState) {
      case ConnectionState.connecting:
        return _buildConnectingView();
      case ConnectionState.connected:
        return _buildConnectedView();
      case ConnectionState.disconnected:
      default:
        return _buildDisconnectedView();
    }
  }

  Widget _buildAppHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/Tytan Logo.png', width: 40, height: 40),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tytan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'VPN',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              Text(
                'Secure and Quick',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGray,
                ),
              ),
            ],
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.textGray, width: 1),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisconnectedView() {
    return Column(
      children: [
        _buildAppHeader(),
        const Spacer(flex: 1),
        // Status Text
        Text(
          'Disconnected',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        // Timer
        Text(
          '00:00:00',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFA0A0A0),
          ),
        ),
        const SizedBox(height: 50),

        // Power Button
        GestureDetector(
          onTap: _toggleConnection,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.power_settings_new_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),

        const Spacer(flex: 1),

        // Premium Box
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Premium Shield',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'PRO',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'Experience ultra-fast encrypted protection.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGray,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Upgrade Now',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Connecting Animation
        AnimatedBuilder(
          animation: _connectingAnimationController,
          builder: (context, child) {
            return SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer rotating circle
                  Transform.rotate(
                    angle: _connectingAnimationController.value * 2 * 3.14159,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            AppColors.primary.withOpacity(0),
                            AppColors.primary.withOpacity(0.8),
                            AppColors.primary.withOpacity(0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Middle dotted circle
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return CustomPaint(
                          painter: DottedCirclePainter(
                            color: Colors.white.withOpacity(0.5),
                            dottedLength: 5,
                            spaceLength: 5,
                          ),
                        );
                      },
                    ),
                  ),

                  // Inner orange circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1E1E1E),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/Tytan Logo.png',
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 30),

        // Connecting Text
        Text(
          'Connecting....',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 20),

        // Server Name
        Text(
          _connectingServer,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedView() {
    return Column(
      children: [
        _buildAppHeader(),
        const Spacer(flex: 1),
        // Status Text
        Text(
          'Connected',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        // Timer
        Text(
          _formatDuration(_connectedDuration),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFA0A0A0),
          ),
        ),
        const SizedBox(height: 50),

        // Power Button
        GestureDetector(
          onTap: _toggleConnection,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.power_settings_new_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Connection Status Message
        Text(
          'Your connection is protected',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 30),

        // Speed Metrics
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Download
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_downward_rounded,
                        size: 16,
                        color: Colors.amber[400],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'DOWNLOAD',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.amber[400],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _downloadSpeed,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              // Divider
              Container(
                width: 1,
                height: 40,
                color: AppColors.textGray.withOpacity(0.5),
              ),

              // Upload
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward_rounded,
                        size: 16,
                        color: Colors.teal[300],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'UPLOAD',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal[300],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _uploadSpeed,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Spacer(flex: 1),

        // Current Server Status
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () {
              // Open server selection screen
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Country Flag - Using a placeholder
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.withOpacity(0.1),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text('🇵🇰', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentServer,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _currentIp,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Signal Strength
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 3,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Container(
                                width: 3,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Container(
                                width: 3,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Container(
                                width: 3,
                                height: 19,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        color: AppColors.textGray,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Helper painter for dotted circle effect
class DottedCirclePainter extends CustomPainter {
  final Color color;
  final double dottedLength;
  final double spaceLength;

  DottedCirclePainter({
    required this.color,
    required this.dottedLength,
    required this.spaceLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double totalLength = dottedLength + spaceLength;
    final double radius = size.width / 2;
    final double circumference = 2 * 3.14159 * radius;
    final int segments = (circumference / totalLength).floor();

    for (int i = 0; i < segments; i++) {
      final double startAngle = (i * totalLength) / radius;
      final double endAngle = (i * totalLength + dottedLength) / radius;

      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: radius,
        ),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
