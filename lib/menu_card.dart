import 'package:flutter/material.dart';
import 'menu.dart';
import 'aturan.dart';
import 'jumlah_porsi.dart';

export 'jumlah_porsi.dart';

class MenuCard extends StatelessWidget {
  final String namaMenu;
  final String kategori;
  final int harga;
  final bool tersedia;
  final int porsiTersisa;
  final int jumlah;
  final ValueChanged<int> onJumlahBerubah;

  const MenuCard({
    super.key,
    required this.namaMenu,
    required this.kategori,
    required this.harga,
    required this.tersedia,
    required this.porsiTersisa,
    required this.jumlah,
    required this.onJumlahBerubah,
  });

  factory MenuCard.fromMenu({
    Key? key,
    required Menu menu,
    required int jumlah,
    required ValueChanged<int> onJumlahBerubah,
  }) {
    return MenuCard(
      key: key,
      namaMenu: menu.namaMenu,
      kategori: menu.kategori,
      harga: menu.harga,
      tersedia: menu.tersedia,
      porsiTersisa: menu.porsiTersisa,
      jumlah: jumlah,
      onJumlahBerubah: onJumlahBerubah,
    );
  }

  Menu get menu => Menu(
        namaMenu: namaMenu,
        kategori: kategori,
        harga: harga,
        tersedia: tersedia,
        porsiTersisa: porsiTersisa,
      );

  Color _kategoriWarna(String kat) {
    switch (kat.toLowerCase()) {
      case 'makanan':
        return const Color(0xFF1E56A0);
      case 'minuman':
        return const Color(0xFF0284C7);
      case 'camilan':
        return const Color(0xFF4F46E5);
      default:
        return const Color(0xFF475569);
    }
  }

  Color _kategoriBg(String kat) {
    switch (kat.toLowerCase()) {
      case 'makanan':
        return const Color(0xFFEBF3FC);
      case 'minuman':
        return const Color(0xFFE0F2FE);
      case 'camilan':
        return const Color(0xFFEEF2FF);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bisaPesan = bisaDipesan(tersedia, porsiTersisa);
    final katWarna = _kategoriWarna(kategori);
    final katBg = _kategoriBg(kategori);
    final dapatDiskon = jumlah >= 5;

    return Opacity(
      opacity: bisaPesan ? 1.0 : 0.62,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: jumlah > 0
                ? const Color(0xFF1E56A0)
                : (bisaPesan ? Colors.grey.shade200 : Colors.grey.shade300),
            width: jumlah > 0 ? 1.5 : 1,
          ),
        ),
        color: jumlah > 0
            ? const Color(0xFFF0F6FC)
            : (bisaPesan ? Colors.white : const Color(0xFFFAFAFA)),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bisaPesan ? katBg : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    menu.icon,
                    size: 24,
                    color: bisaPesan ? katWarna : Colors.grey.shade500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: bisaPesan ? katBg : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            kategori,
                            style: TextStyle(
                              color: bisaPesan ? katWarna : Colors.grey.shade600,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!bisaPesan)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.red.shade300, width: 0.8),
                            ),
                            child: const Text(
                              'HABIS',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Text(
                            'Sisa: $porsiTersisa',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10.5,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      namaMenu,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: -0.2,
                        color: bisaPesan ? const Color(0xFF0F172A) : Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          formatRupiah(harga),
                          style: const TextStyle(
                            color: Color(0xFF1E56A0),
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                        if (dapatDiskon)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFF86EFAC), width: 0.8),
                            ),
                            child: const Text(
                              'Diskon 10%',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              JumlahPorsi(
                namaMenu: namaMenu,
                tersedia: tersedia,
                porsiTersisa: porsiTersisa,
                jumlah: jumlah,
                onJumlahBerubah: onJumlahBerubah,
              ),
            ],
          ),
        ),
      ),
    );
  }
}