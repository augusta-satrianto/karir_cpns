import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class MateriPage extends StatelessWidget {
  const MateriPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05 < 20 ? 20 : screenWidth * 0.05),
        children: [
          SizedBox(
            height: screenWidth > 760 ? 140 : 280,
            child: Center(
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: screenWidth > 760 ? 2 : 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 20,
                childAspectRatio: screenWidth > 760
                    ? MediaQuery.of(context).size.width /
                        (2 * 140) // Sesuaikan rasio
                    : MediaQuery.of(context).size.width / 140,
                children: [
                  DashboardMenuItem(
                    title: 'Materi',
                    subTitle: 'Menampilkan materi pembelajaran berupa E-Book',
                    assetVector: 'assets/vectors/menu-ebook.svg',
                    onTap: () {
                      context.go(
                          '/dashboard/user/learning-material/document/list');
                    },
                  ),
                  DashboardMenuItem(
                    title: 'Latihan',
                    subTitle: 'Menyajikan materi pembelajaran berupa video',
                    assetVector: 'assets/vectors/menu-video.svg',
                    onTap: () {
                      context
                          .go('/dashboard/user/learning-material/video/list');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardMenuItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final String assetVector;
  final VoidCallback onTap;

  const DashboardMenuItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.assetVector,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        elevation: WidgetStateProperty.all<double>(0),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: const Color(0xFFFAF6D7),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetVector,
              width: screenWidth > 570 ? 60 : 40,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  Text(
                    subTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
