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
  final String? gambarAsset;

  const MenuCard({
    super.key,
    required this.namaMenu,
    required this.kategori,
    required this.harga,
    required this.tersedia,
    required this.porsiTersisa,
    required this.jumlah,
    required this.onJumlahBerubah,
    this.gambarAsset,
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
      gambarAsset: menu.gambarAsset,
    );
  }

  Menu get menu => Menu(
        namaMenu: namaMenu,
        kategori: kategori,
        harga: harga,
        tersedia: tersedia,
        porsiTersisa: porsiTersisa,
        gambarAsset: gambarAsset,
      );

  Color _kategoriWarna(String kat) {
    switch (kat.toLowerCase()) {
      case 'makanan': return const Color(0xFF1E56A0);
      case 'minuman': return const Color(0xFF0284C7);
      case 'camilan': return const Color(0xFF4F46E5);
      default: return const Color(0xFF475569);
    }
  }

  Color _kategoriBg(String kat) {
    switch (kat.toLowerCase()) {
      case 'makanan': return const Color(0xFFEBF3FC);
      case 'minuman': return const Color(0xFFE0F2FE);
      case 'camilan': return const Color(0xFFEEF2FF);
      default: return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bisaPesan = bisaDipesan(tersedia, porsiTersisa);
    final katWarna = _kategoriWarna(kategori);
    final katBg = _kategoriBg(kategori);
    const warnaAksen = Color(0xFF1E56A0); 

    return Opacity(
      opacity: bisaPesan ? 1.0 : 0.6,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: jumlah > 0 ? warnaAksen : Colors.grey.shade200,
            width: jumlah > 0 ? 1.5 : 1,
          ),
        ),
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: katBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                kategori,
                                style: TextStyle(
                                  color: katWarna,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (!bisaPesan)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444), 
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'HABIS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          namaMenu,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: -0.2,
                            color: bisaPesan ? const Color(0xFF1E293B) : Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatRupiah(harga),
                          style: TextStyle(
                            color: bisaPesan ? warnaAksen : Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sisa porsi: $porsiTersisa',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // MUNCULKAN GAMBAR DI SINI
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: gambarAsset != null
                        ? Image.asset(
                            gambarAsset!,
                            fit: BoxFit.cover,
                            color: bisaPesan ? null : Colors.grey.withValues(alpha: 0.8),
                            colorBlendMode: bisaPesan ? null : BlendMode.saturation,
                          )
                        : Icon(
                            menu.icon,
                            size: 32,
                            color: Colors.grey.shade400,
                          ),
                  ),
                ],
              ),
              if (bisaPesan) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      size: 13,
                      color: const Color(0xFF15803D).withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Diskon 10% untuk 5+ porsi',
                        style: TextStyle(
                          color: const Color(0xFF15803D).withValues(alpha: 0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              const Spacer(),
              Divider(color: Colors.grey.shade200, height: 24),
              Row(
                children: [
                  Text(
                    'Jumlah pesanan',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  JumlahPorsi(
                    namaMenu: namaMenu,
                    tersedia: tersedia,
                    porsiTersisa: porsiTersisa,
                    jumlah: jumlah,
                    onJumlahBerubah: onJumlahBerubah,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}