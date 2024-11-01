import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

void openLink(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      webOnlyWindowName: '_blank', // Membuka di tab baru untuk Web
    );
  } else {
    throw 'Could not launch $url';
  }
}

class EbookViewPage extends StatefulWidget {
  const EbookViewPage({super.key});

  @override
  State<EbookViewPage> createState() => _EbookViewPageState();
}

class _EbookViewPageState extends State<EbookViewPage> {
  _requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      // Handle the case where the user denied permission
      print('Storage permission is required to download and view the PDF.');
    }
  }

  File? pdfFile;
  Future<void> _downloadPDF(url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        String name =
            url.toString().replaceAll('/', '_').replaceAll('%20', '_');
        List<String> parts = name.split('_');
        String lastPart = parts.last;

        final path = '${directory.path}/$lastPart';
        if (!File(path).existsSync()) {
          File(path).writeAsBytesSync(response.bodyBytes);
        }
        setState(() {
          pdfFile = File(path);
        });
        OpenFile.open(pdfFile!.path);
      }
    }
  }

  @override
  void initState() {
    _requestStoragePermission();
    super.initState();
  }

  int _currentPage = 1;
  int _totalPages = 0;

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05 < 20 ? 20 : screenWidth * 0.05),
        children: [
          Text('Materi Pembelajaran (Document)'),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFF2F4F9),
                ),
                borderRadius: BorderRadius.circular(4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IntrinsicWidth(
                        child: ElevatedButton(
                          onPressed: () {
                            context.go(
                                '/dashboard/user/learning-material/document/list');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFBBC06),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Back',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Text/Document - TKP-SUB-TEKNOLOGI INFORMASI DAN KOMUNIKASI'),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Color(0xFF1C75BC),
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                                child: Text(
                              'Gold',
                              style: TextStyle(color: Colors.white),
                            )),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Divider(
                          color: Color(0xFFE5E5E5),
                        ),
                      ),
                      Text('Description: TKP-TIK'),
                      ElevatedButton(
                        onPressed: () {
                          if (kIsWeb) {
                            openLink(
                                // 'https://pdfobject.com/pdf/sample.pdf',
                                'https://karircpns.id/storage/files/shares/TKP%20TEKNOLOGI%20INFORMASI%20DAN%20KOMUNIKASI.pdf');
                          } else {
                            _downloadPDF(
                              // 'https://galaxysatwa.my.id/TKP%20TEKNOLOGI%20INFORMASI%20DAN%20KOMUNIKASI.pdf',
                              // 'https://pdfobject.com/pdf/sample.pdf',
                              'https://karircpns.id/storage/files/shares/TKP%20TEKNOLOGI%20INFORMASI%20DAN%20KOMUNIKASI.pdf',
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.hovered)) {
                                return Color(0xFF0067B9);
                              }
                              return Color(0xFF0067B9);
                            },
                          ),
                          elevation: WidgetStateProperty.all<double>(0),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.download,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "Download",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Divider(
                          color: Color(0xFFE5E5E5),
                        ),
                      ),
                      Container(
                        height: (screenWidth -
                                ((screenWidth * 0.05 < 20
                                        ? 20
                                        : screenWidth * 0.05) *
                                    2) -
                                40) *
                            1.414,
                        child: Stack(
                          children: [
                            SfPdfViewer.network(
                              'https://galaxysatwa.my.id/TKP%20TEKNOLOGI%20INFORMASI%20DAN%20KOMUNIKASI.pdf',
                              // 'https://pdfobject.com/pdf/sample.pdf',
                              // 'https://karircpns.id/storage/files/shares/TKP%20TEKNOLOGI%20INFORMASI%20DAN%20KOMUNIKASI.pdf',
                              key: _pdfViewerKey,
                              controller: _pdfViewerController,
                              // scrollDirection: PdfScrollDirection.horizontal,
                              pageLayoutMode: PdfPageLayoutMode.single,
                              onDocumentLoaded:
                                  (PdfDocumentLoadedDetails details) {
                                setState(() {
                                  _totalPages = details.document.pages.count;
                                });
                              },
                              onPageChanged: (PdfPageChangedDetails details) {
                                setState(() {
                                  _currentPage = details.newPageNumber;
                                });
                              },
                              canShowScrollStatus: false,
                              canShowScrollHead: false,
                            ),
                            AbsorbPointer(
                              child: GestureDetector(
                                onVerticalDragUpdate:
                                    (_) {}, // Mencegah geser vertikal
                                onHorizontalDragUpdate:
                                    (_) {}, // Mencegah geser horizontal
                                child:
                                    Container(), // Kontainer kosong untuk menyerap gesture
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _pdfViewerController.previousPage();
                            },
                            child: Text('Prev'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Page $_currentPage/$_totalPages',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _pdfViewerController.nextPage();
                            },
                            child: Text('Next'),
                          ),
                        ],
                      ),
                    ],
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
