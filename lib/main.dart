import 'package:flutter/material.dart';
import 'menu.dart';
import 'menu_card.dart';
import 'aturan.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const warnaUtama = Color(0xFF1E56A0);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warkan',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: warnaUtama,
          primary: warnaUtama,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: warnaUtama,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const WarungMenuPage(),
    );
  }
}

class WarungMenuPage extends StatefulWidget {
  const WarungMenuPage({super.key});

  @override
  State<WarungMenuPage> createState() => _WarungMenuPageState();
}

class _WarungMenuPageState extends State<WarungMenuPage> {
  late final TextEditingController _controller;
  String kataCari = '';

  final Map<String, int> jumlahPesanan = {};

  final List<Menu> daftarMenu = const [
    Menu(namaMenu: 'Mie Ayam', kategori: 'Makanan', harga: 8000, tersedia: true, porsiTersisa: 8),
    Menu(namaMenu: 'Batagor', kategori: 'Makanan', harga: 5000, tersedia: true, porsiTersisa: 10),
    Menu(namaMenu: 'Martabak Manis', kategori: 'Camilan', harga: 20000, tersedia: true, porsiTersisa: 5),
    Menu(namaMenu: 'Martabak Asin Komplit Spesial Telur Daging Sapi Lezat Gurih', kategori: 'Makanan', harga: 25000, tersedia: true, porsiTersisa: 10),
    Menu(namaMenu: 'Nasi Goreng', kategori: 'Makanan', harga: 13000, tersedia: true, porsiTersisa: 7),
    Menu(namaMenu: 'Es Teh', kategori: 'Minuman', harga: 3000, tersedia: true, porsiTersisa: 20),
    Menu(namaMenu: 'Es Milo', kategori: 'Minuman', harga: 5000, tersedia: true, porsiTersisa: 12),
    Menu(namaMenu: 'Es Jeruk', kategori: 'Minuman', harga: 3000, tersedia: true, porsiTersisa: 15),
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

  int hitungTotalSemua() {
    int total = 0;
    for (var menu in daftarMenu) {
      int jumlah = jumlahPesanan[menu.namaMenu] ?? 0;
      total += menu.hitungTotal(jumlah);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final hasilCari = daftarMenu
        .where((m) => m.namaMenu.toLowerCase().contains(kataCari.trim()))
        .toList();

    const warnaUtama = Color(0xFF1E56A0);

    return Scaffold(
      appBar: AppBar(title: const Text('Warkan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Cari menu...',
                prefixIcon: const Icon(Icons.search, color: warnaUtama),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (nilai) {
                setState(() => kataCari = nilai.toLowerCase());
              },
            ),
          ),
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
                    mainAxisExtent: 116,
                  ),
                  itemCount: hasilCari.length,
                  itemBuilder: (context, index) {
                    final menu = hasilCari[index];
                    final jumlah = jumlahPesanan[menu.namaMenu] ?? 0;

                    return MenuCard(
                      key: ValueKey(menu.namaMenu),
                      namaMenu: menu.namaMenu,
                      kategori: menu.kategori,
                      harga: menu.harga,
                      tersedia: menu.tersedia,
                      porsiTersisa: menu.porsiTersisa,
                      jumlah: jumlah,
                      onJumlahBerubah: (jumlahBaru) {
                        setState(() {
                          if (jumlahBaru <= 0) {
                            jumlahPesanan.remove(menu.namaMenu);
                          } else {
                            jumlahPesanan[menu.namaMenu] = jumlahBaru;
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: warnaUtama,
            child: Text(
              'Total: ${formatRupiah(hitungTotalSemua())}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}