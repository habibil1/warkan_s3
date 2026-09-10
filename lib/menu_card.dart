import 'package:flutter/material.dart';
import 'jumlah_porsi.dart';

class BarangCard extends StatelessWidget {
  final String nama;
  final int hargaAnggota;
  final int stok;
  final String kategori;
  final bool sorot;

  const BarangCard({
    super.key,
    required this.nama,
    required this.hargaAnggota,
    required this.stok,
    required this.kategori,
    this.sorot = false,
  });

  IconData _pilihIkon(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'atk':
        return Icons.edit;
      case 'makanan':
        return Icons.fastfood;
      case 'minuman':
        return Icons.local_drink;
      case 'mainan':
        return Icons.toys;
      default:
        return Icons.inventory_2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: sorot ? Colors.amber.shade100 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _pilihIkon(kategori),
              color: const Color.fromARGB(255, 135, 0, 0),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('Anggota Rp $hargaAnggota'),
                  Text(
                    kategori,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            KeranjangItem(
              stok: stok,
              harga: hargaAnggota,
            ),
          ],
        ),
      ),
    );
  }
}