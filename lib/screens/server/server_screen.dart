import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tytan/screens/background/background.dart';
import 'package:tytan/screens/bottomnavbar/bottomnavbar.dart';
import 'package:tytan/screens/constant/Appconstant.dart';

class ServersScreen extends StatefulWidget {
  const ServersScreen({Key? key}) : super(key: key);

  @override
  State<ServersScreen> createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentNavIndex = 1; // 1 for Servers tab
  String _selectedRegion = 'All';
  String _sortBy = 'Speed';
  String _selectedServer = 'Finland';

  // Sample server data
  final List<Map<String, dynamic>> _servers = [
    {
      'name': 'Finland',
      'flag': '🇫🇮',
      'ip': '198.168.192.10',
      'isPremium': true,
    },
    {
      'name': 'Pakistan',
      'flag': '🇵🇰',
      'ip': '198.168.192.10',
      'isPremium': false,
    },
    {
      'name': 'Brazil',
      'flag': '🇧🇷',
      'ip': '198.168.192.10',
      'isPremium': true,
    },
    {
      'name': 'Türkiye',
      'flag': '🇹🇷',
      'ip': '198.168.192.10',
      'isPremium': true,
    },
    {
      'name': 'Azerbaijan',
      'flag': '🇦🇿',
      'ip': '198.168.192.10',
      'isPremium': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildRegionFilter(),
              const SizedBox(height: 20),
              _buildServerList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Text(
        'Select Location',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _searchController,
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search countries or cities...',
            hintStyle: GoogleFonts.plusJakartaSans(
              color: Colors.grey,
              fontSize: 15,
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegionFilter() {
    final regions = ['All', 'Americas', 'Europe', 'Asia'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: regions
              .map(
                (region) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRegion = region;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedRegion == region
                            ? AppColors.primary
                            : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        region,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _selectedRegion == region
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildServerList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildServerListHeader(),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: _servers.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final server = _servers[index];
                  return _buildServerItem(
                    name: server['name'],
                    flag: server['flag'],
                    ip: server['ip'],
                    isPremium: server['isPremium'],
                    isSelected: server['name'] == _selectedServer,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'All Servers',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            Text(
              'Sort by: ',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Toggle sorting options
              },
              child: Text(
                _sortBy,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServerItem({
    required String name,
    required String flag,
    required String ip,
    required bool isPremium,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedServer = name;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Flag Circle
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Text(flag, style: const TextStyle(fontSize: 30)),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        if (isPremium) ...[
                          const SizedBox(width: 6),
                          // Using the crown image instead of an icon
                          Image.asset(
                            'assets/Vector (4).png',
                            width: 14,
                            height: 14,
                            color: Colors.amber,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ip,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey,
                  width: 1.5,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 15),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
