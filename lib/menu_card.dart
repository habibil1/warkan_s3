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

  @override
  Widget build(BuildContext context) {
    final bisaPesan = bisaDipesan(tersedia, porsiTersisa);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    namaMenu,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(kategori, style: const TextStyle(fontSize: 11)),
                  Text('Rp $harga', style: const TextStyle(fontSize: 12)),
                  if (!bisaPesan) const Text('HABIS', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
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
    );
  }
}