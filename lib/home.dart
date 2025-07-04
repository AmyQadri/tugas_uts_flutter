import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'profile.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({Key? key, this.username = "Andi Muhammad Yusuf Qadri"})
    : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _time;
  late String _hijriDate;

  late String?
  _namaLengkap; // Variabel untuk menyimpan nama dari SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadNamaLengkap();
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    DateTime now = DateTime.now();
    _time = DateFormat('HH : mm').format(now);

    HijriCalendar hijri = HijriCalendar.now();
    _hijriDate = "${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear}";

    Future.delayed(Duration(minutes: 1), () {
      if (mounted) {
        setState(() {
          _updateTime();
        });
      }
    });
  }

    // Fungsi untuk logout
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Akses instance SharedPreferences
    await prefs.clear(); // Hapus semua data yang tersimpan (termasuk nama_lengkap)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F4),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: const Color(0xFF184A2C),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    color: Colors.white,
                    onSelected: (value) {
                      if (value == 'login') {
                        _logout();
                        // Navigator.push(co
                      } else if (value == 'profile') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'profile',
                            child: ListTile(
                              leading: Icon(
                                Icons.person,
                                color: Color(0xFF184A2C),
                              ),
                              title: Text('Profile'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'login',
                            child: ListTile(
                              leading: Icon(
                                Icons.login,
                                color: Color(0xFF184A2C),
                              ),
                              title: Text('Log out'),
                            ),
                          ),
                        ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E8449),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, ${_namaLengkap}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _hijriDate,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.wb_sunny_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Dzuhur $_time",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),

                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: SvgPicture.asset(
                              'assets/images/icons/icon-mosque.svg',
                              height: 80,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                        children: [
                          _buildFeatureCard("Al Qur'an", "quran.svg"),
                          _buildFeatureCard("Dzikir & Doa", "dzikir.svg"),
                          _buildFeatureCard("Jadwal Sholat", "sholat.svg"),
                          _buildFeatureCard("Arah Qiblat", "navigation.svg"),
                          _buildFeatureCard(
                            "Kalender Hijriyah",
                            "calendar.svg",
                          ),
                          _buildFeatureCard("Riwayat Ibadah", "history.svg"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String svgAsset) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: const Border(
          top: BorderSide(color: Color(0xFF184A2C), width: 2),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/icons/$svgAsset',
            height: 30,
            width: 30,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF184A2C),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadNamaLengkap() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // Akses instance SharedPreferences
    setState(() {
      _namaLengkap =
          prefs.getString('nama_lengkap') ??
          'Mahasiswa'; // Ambil nilai dengan key 'nama_lengkap'
    });
  }
}
