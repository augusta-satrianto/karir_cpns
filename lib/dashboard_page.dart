import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:karir_cpns_app/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:shimmer/shimmer.dart';

import 'dart:io' show Platform;

void _launchWhatsApp() async {
  String phoneNumber = '+6283853162643';
  String message = 'Halo Dokter, saya ingin melakukan konsultasi.';
  String uri;

  // Cek apakah perangkat adalah mobile atau web
  if (kIsWeb) {
    uri = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';
  } else if (Platform.isAndroid || Platform.isIOS) {
    uri = 'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeFull(message)}';
  } else {
    print('WhatsApp tidak didukung pada perangkat ini');
    return;
  }

  // Luncurkan URI
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    print('Could not launch $uri');
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final ScrollController scrollController = ScrollController();
    // final credentials = CredentialService.getCredential();
    // final photoUrl = credentials?['photoUrl'] ?? '';
    return Scaffold(
        appBar: AppBar(
          title: Text('Beranda Page'),
          // actions: [
          //   if (photoUrl.isNotEmpty)
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: CircleAvatar(
          //         backgroundImage: NetworkImage(photoUrl),
          //       ),
          //     ),
          // ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          _launchWhatsApp();
        }),
        body: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05 < 20 ? 20 : screenWidth * 0.05),
          children: [
            SizedBox(
              height: 20,
            ),
            CarouselSlider(
              options: CarouselOptions(
                  scrollPhysics: NeverScrollableScrollPhysics(),
                  height: (screenWidth -
                          ((screenWidth * 0.05 < 20 ? 20 : screenWidth * 0.05) *
                              2)) *
                      (681 / 1600),
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  viewportFraction: 1),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) => CachedNetworkImage(
                        imageUrl:
                            "https://galaxysatwa.my.id/Banner%20(${index + 1}).jpg",
                        imageBuilder: (context, imageProvider) => Container(
                          width: screenWidth -
                              (screenWidth * 0.05 < 20
                                      ? 20
                                      : screenWidth * 0.05) *
                                  2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[500]!,
                          child: Container(
                            width: screenWidth -
                                (screenWidth * 0.05 < 20
                                        ? 20
                                        : screenWidth * 0.05) *
                                    2,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: screenWidth > 800 ? 140 : 200,
              decoration: BoxDecoration(
                  color: const Color(0xFFFAF6D7),
                  borderRadius: BorderRadius.circular(4)),
              child: Center(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: screenWidth > 800 ? 6 : 3,
                  mainAxisSpacing: 10,
                  childAspectRatio: screenWidth > 800
                      ? MediaQuery.of(context).size.width / 2 / 300
                      : MediaQuery.of(context).size.width / 2 / 150,
                  children: [
                    DashboardMenuItem(
                      title: 'Materi',
                      assetVector: 'assets/vectors/menu-materi.svg',
                      onTap: () {
                        context.go('/dashboard/user/learning-material');
                      },
                    ),
                    DashboardMenuItem(
                      title: 'Latihan',
                      assetVector: 'assets/vectors/menu-train.svg',
                      onTap: () {},
                    ),
                    DashboardMenuItem(
                      title: 'Try Out',
                      assetVector: 'assets/vectors/menu-tryout.svg',
                      onTap: () {
                        context.go('/dashboard/user/tryout/list');
                      },
                    ),
                    DashboardMenuItem(
                      title: 'Events',
                      assetVector: 'assets/vectors/menu-event.svg',
                      onTap: () {},
                    ),
                    DashboardMenuItem(
                      title: 'Webinar',
                      assetVector: 'assets/vectors/menu-webinar.svg',
                      onTap: () {
                        context.go('/dashboard/user/webinar');
                      },
                    ),
                    DashboardMenuItem(
                      title: 'Transaksi',
                      assetVector: 'assets/vectors/menu-cart.svg',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}

class DashboardMenuItem extends StatelessWidget {
  final String title;
  final String assetVector;
  final VoidCallback onTap;

  const DashboardMenuItem({
    super.key,
    required this.title,
    required this.assetVector,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
          ),
          backgroundColor:
              WidgetStateProperty.all<Color>(const Color(0xFFFAF6D7)),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all<double>(0),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetVector,
              width: screenWidth > 570 ? 60 : 40,
              // color: isHovering ? Colors.blue : Colors.black, // Warna ikon saat hover
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );

    // GestureDetector(
    //   onTap: onTap,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       SvgPicture.asset(
    //         assetVector,
    //         width: screenWidth > 570 ? 60 : 40,
    //       ),
    //       const SizedBox(height: 5),
    //       Text(
    //         title,
    //         style: const TextStyle(fontWeight: FontWeight.w600),
    //       ),
    //     ],
    //   ),
    // );
  }
}
