import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:luarsekolah/features/home/widgets/user_header.dart';
import 'package:luarsekolah/features/home/widgets/custom_media_card.dart';
import 'package:luarsekolah/features/home/widgets/home_class_card.dart';
import 'package:luarsekolah/features/home/widgets/menu_item_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  // List image carousel banner still dummy from assets
  final List<String> bannerImages = [
    'assets/images/banner_1.png',
    'assets/images/banner_2.png',
    'assets/images/banner_3.png',
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: bannerImages.asMap().entries.map((entry) {
        return Container(
          width: _currentIndex == entry.key ? 24 : 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentIndex == entry.key
                ? Color(0xFF1DB892)
                : Colors.grey.withOpacity(0.3),
          ),
        );
      }).toList(),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // BODY
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with Firebase Stream (UserName Data)
              const UserHeader(),

              Transform.translate(
                offset: Offset(0, -30),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      // CAROUSEL SLIDER
                      CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: 180,
                          viewportFraction: 0.85,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(
                            milliseconds: 800,
                          ),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.15,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: bannerImages.map((imagePath) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: Colors.grey[400],
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Gambar tidak ditemukan',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 12),
                      _buildDotIndicator(),
                      SizedBox(height: 24),

                      // PROGRAM FROM LUARSEKOLAH
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Program dari Luarsekolah',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: 24),

                            // HORIZONTAL MENU SECTION (AFTER PROGRAM DARI LUARSEKOLAH)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MenuItemCard(
                                    iconPath: 'assets/icons/ic_prakerja.png',
                                    label: 'Prakerja',
                                    onTap: () {
                                      // TODO: Navigate to Prakerja page
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Prakerja - Coming Soon',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  MenuItemCard(
                                    iconPath: 'assets/icons/ic_magang.png',
                                    label: 'magang+',
                                    onTap: () {
                                      // TODO: Navigate to Magang page
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'magang+ - Coming Soon',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  MenuItemCard(
                                    iconPath: 'assets/icons/ic_luarskl.png',
                                    label: 'Subs',
                                    onTap: () {
                                      // TODO: Navigate to Subscription page
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Subs - Coming Soon'),
                                        ),
                                      );
                                    },
                                  ),
                                  MenuItemCard(
                                    iconPath: '',
                                    label: 'Lainnya',
                                    onTap: () {
                                      // TODO: Navigate to More/Others page
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Lainnya - Coming Soon',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Prakerja Voucher Card
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFCBCECF),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/icons/ic_redeem.png',
                                      height: 40,
                                      width: 26,
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Redeem Voucher Prakerjamu',
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF333333),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Kamu pengguna Prakerja? Segera redeem vouchermu sekarang juga',
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color(0xFFCBCECF),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12,
                                                horizontal: 16,
                                              ),
                                              child: Text(
                                                'Masukkan Voucher Prakerja',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF333333),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 24),

                            Text(
                              'Kelas terpopuler di prakerja',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: 16),

                            HomeClassCard(
                              imageUrl: 'assets/images/media_1.png',
                              title: 'Teknik Pemilahan dan Pengolahan Sampah',
                              rating: 4.5,
                              price: 'Rp 1.500.000',
                              tags: ['Prakerja', 'SPL'],
                              onTap: () {},
                            ),

                            SizedBox(height: 16),

                            Text(
                              'Lihat semua kelas',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue,
                              ),
                            ),

                            SizedBox(height: 24),

                            SizedBox(
                              width: 300,
                              child: Text(
                                'Akses semua kelas dengan berlangganan',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),

                            SizedBox(height: 16),

                            CustomMediaCard(
                              imageUrl: 'assets/images/media_2.png',
                              categoryLabel: '5 Kelas Pembelajaran',
                              title:
                                  'Belajar SwiftUI Untuk Pembuatan Interface',
                              onTap: () {},
                            ),

                            SizedBox(height: 16),

                            Text(
                              'Lihat semua kelas',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue,
                              ),
                            ),

                            SizedBox(height: 30),
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
      ),
    );
  }
}
