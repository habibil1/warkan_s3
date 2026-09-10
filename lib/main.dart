import 'package:flutter/material.dart';
import 'menu_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TextEditingController _controller;
  String kataCari = '';

  final List<Map<String, dynamic>> daftarBarang = [
    {'nama': 'deathnote buku death note nya keren dan bagaus', 'anggota': 4000, 'umum': 4300, 'stok': 10, 'kategori': 'ATK'},
    {'nama': 'kipas', 'anggota': 90000, 'umum': 90300, 'stok': 21, 'kategori': 'Elektronik'},
    {'nama': 'baret', 'anggota': 10000, 'umum': 10300, 'stok': 31, 'kategori': 'ATK'},
    {'nama': 'raja', 'anggota': 4000, 'umum': 4300, 'stok': 41, 'kategori': 'ATK'},
    {'nama': 'perahu', 'anggota': 90000, 'umum': 90300, 'stok': 5, 'kategori': 'Mainan'},
    {'nama': 'pintu', 'anggota': 10000, 'umum': 10300, 'stok': 6, 'kategori': 'ATK'},
    {'nama': 'monitor', 'anggota': 4000, 'umum': 4300, 'stok': 7, 'kategori': 'Elektronik'},
    {'nama': 'keyboard', 'anggota': 90000, 'umum': 90300, 'stok': 8, 'kategori': 'Elektronik'},
    {'nama': 'laptop', 'anggota': 4000, 'umum': 4300, 'stok': 9, 'kategori': 'Elektronik'},
    {'nama': 'lampu', 'anggota': 90000, 'umum': 90300, 'stok': 10, 'kategori': 'ATK'},
    {'nama': 'kelinci', 'anggota': 100000, 'umum': 90300, 'stok': 10, 'kategori': 'Mainan'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barangsiap =
        daftarBarang.where((barang) => barang['stok'] > 0).toList();

    final hasilCari = barangsiap
        .where((b) => b['nama'].toLowerCase().contains(kataCari))
        .toList();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Koperasi Sekolah')),
        body: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Cari barang...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (nilai) {
                setState(() {
                  kataCari = nilai.toLowerCase();
                });
              },
            ),
            Text('Lebar layar: ' + MediaQuery.of(context).size.width.toStringAsFixed(0)),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int kolom;
                  if (constraints.maxWidth < 600) {
                    kolom = 1;
                  } else if (constraints.maxWidth < 900) {
                    kolom = 2;
                  } else {
                    kolom = 3;
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: kolom,
                      mainAxisExtent: 140,
                    ),
                    itemCount: hasilCari.length,
                    itemBuilder: (context, index) {
                      final barang = hasilCari[index];
                      return BarangCard(
                        nama: barang['nama'],
                        hargaAnggota: barang['anggota'],
                        stok: barang['stok'],
                        kategori: barang['kategori'],
                        sorot: barang['stok'] <= 5,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//commit 12