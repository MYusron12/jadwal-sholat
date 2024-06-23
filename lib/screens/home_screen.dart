import 'package:flutter/material.dart';
import 'alquran_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:dropdown_search/dropdown_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  Map<String, dynamic>? jadwalSholat = {
    'tanggal': null,
    'imsak': null,
    'subuh': null,
    'terbit': null,
    'dhuha': null,
    'dzuhur': null,
    'ashar': null,
    'maghrib': null,
    'isya': null,
  };
  List<Map<String, dynamic>>? jadwalBulanan;
  List<dynamic> kota = [];
  String? selectedKota;
  final logger = Logger();

  @override
  void initState(){
    super.initState();
    fetchJadwalSholat();
    fetchJadwalSholatBulanan();
    fetchKota();
  }

  Future<void> fetchKota() async{
    final response = await http.get(Uri.parse('https://api.myquran.com/v2/sholat/kota/semua'));
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      setState(() {
        kota = data['data'];
        if(kota.isNotEmpty){
          selectedKota = kota[0]['id'];
          fetchJadwalSholat();
          fetchJadwalSholatBulanan();
        }
      });
    }
  }

  Future<void> fetchJadwalSholat() async {
    if (selectedKota == null) return;
    final today = DateTime.now();
    final formattedDate = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final response = await http.get(Uri.parse('https://api.myquran.com/v2/sholat/jadwal/$selectedKota/$formattedDate'));
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      if (data != null && data['data'] != null && data['data']['jadwal'] != null) {
        setState(() {
          jadwalSholat = data['data']['jadwal'];
        });
      } else {
        // Handle case when data is null
        setState(() {
          jadwalSholat = null;
        });
        logger.e("Data jadwal sholat tidak ditemukan.");
      }
    } else {
      // Handle HTTP error
      logger.e("Gagal mengambil data jadwal sholat dengan status code: ${response.statusCode}");
      setState(() {
        jadwalSholat = null;
      });
    }
  }

  Future<void> fetchJadwalSholatBulanan() async {
    if (selectedKota == null) return;
    final today = DateTime.now();
    final year = today.year.toString();
    final month = today.month.toString().padLeft(2, '0');
    final response = await http.get(Uri.parse('https://api.myquran.com/v2/sholat/jadwal/$selectedKota/$year/$month'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && data['data'] != null && data['data']['jadwal'] != null) {
        setState(() {
          jadwalBulanan = List<Map<String, dynamic>>.from(data['data']['jadwal']);
        });
      } else {
        // Handle case when data is null
        setState(() {
          jadwalBulanan = null;
        });
        logger.e("Data jadwal sholat bulanan tidak ditemukan.");
      }
    } else {
      // Handle HTTP error
      logger.e("Gagal mengambil data jadwal sholat bulanan dengan status code: ${response.statusCode}");
      setState(() {
        jadwalBulanan = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome AlQuran-App',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlQuranScreen()),
                );
              },
              child: const Text('Buka Alquran'),
            ),
            const SizedBox(height: 50),
            DropdownSearch<String>(
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Pilih kota",
                  hintText: "Cari kota",
                ),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedKota = kota.firstWhere((element) => element['lokasi'] == newValue)['id'];
                  fetchJadwalSholat();
                  fetchJadwalSholatBulanan();
                });
              },
              selectedItem: selectedKota != null ? kota.firstWhere((element) => element['id'] == selectedKota)['lokasi'] : null,
              items: kota.map((e) => e['lokasi'] as String).toList(),
              popupProps: const PopupProps.menu(
                showSearchBox: true,
              ),
            ),
            if (jadwalSholat != null)
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jadwal Sholat',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0), // Sesuaikan padding sesuai kebutuhan
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tanggal: ${jadwalSholat!['tanggal']}'),
                              const SizedBox(height: 5),
                              Text('Imsak: ${jadwalSholat!['imsak']}'),
                              const SizedBox(height: 5),
                              Text('Subuh: ${jadwalSholat!['subuh']}'),
                              const SizedBox(height: 5),
                              Text('Dzuhur: ${jadwalSholat!['dzuhur']}'),
                              const SizedBox(height: 5),
                              Text('Ashar: ${jadwalSholat!['ashar']}'),
                              const SizedBox(height: 5),
                              Text('Maghrib: ${jadwalSholat!['maghrib']}'),
                            ],
                          ),
                        ),
                      ),
                      // Tabel di bawah jadwal sholat
                      const SizedBox(height: 10), // Ruang antara Card dan tabel
                      Table(
                        border: TableBorder.all(), // Garis batas tabel
                        children: [
                          const TableRow(
                            children: [
                              TableCell(child: Text('Tanggal')),
                              TableCell(child: Text('Imsak')),
                              TableCell(child: Text('Subuh')),
                              TableCell(child: Text('Dzuhur')),
                              TableCell(child: Text('Ashar')),
                              TableCell(child: Text('Maghrib')),
                            ],
                          ),
                          if (jadwalBulanan != null)
                            ...jadwalBulanan!.map((jadwal) {
                              return TableRow(
                                children: [
                                  TableCell(child: Text(jadwal['tanggal'])),
                                  TableCell(child: Text(jadwal['imsak'])),
                                  TableCell(child: Text(jadwal['subuh'])),
                                  TableCell(child: Text(jadwal['dzuhur'])),
                                  TableCell(child: Text(jadwal['ashar'])),
                                  TableCell(child: Text(jadwal['maghrib'])),
                                ],
                              );
                            }),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    ),
    );
  }
}
