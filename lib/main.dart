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
  bool termurahDulu = true;

  final Map<String, int> jumlahPesanan = {};

  // PERUBAHAN ADA DI SINI: Menambahkan gambarAsset ke setiap menu
  final List<Menu> daftarMenu = const [
    Menu(
      namaMenu: 'Mie Ayam', 
      kategori: 'Makanan', 
      harga: 8000, 
      tersedia: true, 
      porsiTersisa: 8,
      gambarAsset: 'assets/images/mieayam.jpg', // Sesuaikan nama file dengan yang Anda punya
    ),
    Menu(
      namaMenu: 'Batagor', 
      kategori: 'Makanan', 
      harga: 5000, 
      tersedia: true, 
      porsiTersisa: 10,
      gambarAsset: 'assets/images/batagor.jpg',
    ),
    Menu(
      namaMenu: 'Martabak Manis', 
      kategori: 'Camilan', 
      harga: 20000, 
      tersedia: true, 
      porsiTersisa: 5,
      gambarAsset: 'assets/images/martabakmanis.jpg',
    ),
    Menu(
      namaMenu: 'Martabak Asin Komplit Spesial Telur Daging Sapi Lezat Gurih', 
      kategori: 'Makanan', 
      harga: 25000, 
      tersedia: true, 
      porsiTersisa: 10,
      gambarAsset: 'assets/images/martabasasin.jpg',
    ),
    Menu(
      namaMenu: 'Nasi Goreng', 
      kategori: 'Makanan', 
      harga: 13000, 
      tersedia: true, 
      porsiTersisa: 7,
      gambarAsset: 'assets/images/nasigoreng.jpg',
    ),
    Menu(
      namaMenu: 'Es Teh', 
      kategori: 'Minuman', 
      harga: 3000, 
      tersedia: true, 
      porsiTersisa: 20,
      gambarAsset: 'assets/images/esteh.jpg',
    ),
    Menu(
      namaMenu: 'Es Milo', 
      kategori: 'Minuman', 
      harga: 5000, 
      tersedia: true, 
      porsiTersisa: 12,
      gambarAsset: 'assets/images/esmilo.jpg',
    ),
    Menu(
      namaMenu: 'Es Jeruk', 
      kategori: 'Minuman', 
      harga: 3000, 
      tersedia: false, // Diubah menjadi false untuk testing Tampilan HABIS
      porsiTersisa: 0,
      gambarAsset: 'assets/images/esjeruk.jpg',
    ),
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

  int hitungTotalPorsi() {
    int total = 0;
    for (var porsi in jumlahPesanan.values) {
      total += porsi;
    }
    return total;
  }

  void _resetPesanan() {
    setState(() {
      jumlahPesanan.clear();
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Pesanan selesai. Siap melayani pesanan berikutnya!',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF163172),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasilCari = daftarMenu
        .where((m) => m.namaMenu.toLowerCase().contains(kataCari.trim()))
        .toList();

    final hasilUrut = urutkanBerdasarkanHarga(hasilCari, termurahDulu);

    final totalPesanan = hitungTotalSemua();
    final totalPorsi = hitungTotalPorsi();

    const warnaUtama = Color(0xFF1E56A0);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          // Logo aplikasi warkan biarkan tetap seperti ini
          child: Image.asset(
            'assets/images/logo_warkan.png',
            fit: BoxFit.contain,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Warkan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Daftar Menu & Penghitung Pesanan',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Cari menu...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: warnaUtama),
                suffixIcon: kataCari.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _controller.clear();
                          setState(() => kataCari = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: warnaUtama, width: 1.5),
                ),
              ),
              onChanged: (nilai) {
                setState(() => kataCari = nilai.toLowerCase());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Icon(Icons.swap_vert, size: 18, color: warnaUtama),
                  const SizedBox(width: 4),
                  const Text(
                    'Urutkan:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Harga Termurah'),
                    selected: termurahDulu,
                    onSelected: (selected) {
                      if (selected) setState(() => termurahDulu = true);
                    },
                    avatar: Icon(
                      Icons.arrow_downward,
                      size: 14,
                      color: termurahDulu ? Colors.white : warnaUtama,
                    ),
                    selectedColor: warnaUtama,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: termurahDulu ? Colors.white : const Color(0xFF334155),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: const Text('Harga Termahal'),
                    selected: !termurahDulu,
                    onSelected: (selected) {
                      if (selected) setState(() => termurahDulu = false);
                    },
                    avatar: Icon(
                      Icons.arrow_upward,
                      size: 14,
                      color: !termurahDulu ? Colors.white : warnaUtama,
                    ),
                    selectedColor: warnaUtama,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: !termurahDulu ? Colors.white : const Color(0xFF334155),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (hasilUrut.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: warnaUtama.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Menu tidak ditemukan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'Tidak ada menu yang cocok dengan "$kataCari".',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton.icon(
                            onPressed: () {
                              _controller.clear();
                              setState(() => kataCari = '');
                            },
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Tampilkan Semua Menu'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: warnaUtama,
                              side: const BorderSide(color: warnaUtama),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                int kolom;
                if (constraints.maxWidth < 600) {
                  kolom = 1;
                } else if (constraints.maxWidth < 900) {
                  kolom = 2;
                } else {
                  kolom = 3;
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: kolom,
                    mainAxisExtent: 116,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: hasilUrut.length,
                  itemBuilder: (context, index) {
                    final menu = hasilUrut[index];
                    final jumlah = jumlahPesanan[menu.namaMenu] ?? 0;

                    return MenuCard(
                      key: ValueKey(menu.namaMenu),
                      namaMenu: menu.namaMenu,
                      kategori: menu.kategori,
                      harga: menu.harga,
                      tersedia: menu.tersedia,
                      porsiTersisa: menu.porsiTersisa,
                      gambarAsset: menu.gambarAsset,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          totalPorsi > 0 ? '$totalPorsi porsi dipilih' : 'Belum ada pesanan',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Total: ${formatRupiah(totalPesanan)}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: warnaUtama,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: warnaUtama,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: totalPorsi > 0 ? _resetPesanan : null,
                    icon: const Icon(Icons.done_all, size: 18),
                    label: const Text(
                      'Selesai',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
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