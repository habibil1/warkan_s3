import 'package:flutter/material.dart';
import 'aturan.dart';

String formatRupiah(int nominal) {
  final str = nominal.toString();
  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  final formatted = str.replaceAllMapped(reg, (Match m) => '${m[1]}.');
  return 'Rp $formatted';
}

class Menu {
  final String namaMenu;
  final String kategori;
  final int harga;
  final bool tersedia;
  final int porsiTersisa;
  final String? gambarAsset;

  const Menu({
    required this.namaMenu,
    required this.kategori,
    required this.harga,
    required this.tersedia,
    required this.porsiTersisa,
    this.gambarAsset,
  });

  const Menu.lengkap({
    String? namaMenu,
    String? namamenu,
    required this.kategori,
    required this.harga,
    required this.tersedia,
    int? porsiTersisa,
    int? stokporsi,
    this.gambarAsset,
  })  : namaMenu = namaMenu ?? namamenu ?? '',
        porsiTersisa = porsiTersisa ?? stokporsi ?? 0;

  String get namamenu => namaMenu;
  int get stokporsi => porsiTersisa;
  String get hargaFormat => formatRupiah(harga);

  int hitungSubtotal(int jumlahPesan) => harga * jumlahPesan;

  bool dapatDiskon(int jumlahPesan) => jumlahPesan >= 5;
  bool dapatdiskon(int jumlahPesan) => dapatDiskon(jumlahPesan);

  int hitungDiskon(int jumlahPesan) => hitungPotonganDiskon(harga, jumlahPesan);

  int hitungTotal(int jumlahPesan) => hitungTotalHargaItem(harga, jumlahPesan);
  int hitungtotal(int jumlahPesan) => hitungTotal(jumlahPesan);

  bool siapDipesan() => bisaDipesan(tersedia, porsiTersisa);

  IconData get icon {
    final lowerName = namaMenu.toLowerCase();
    if (lowerName.contains('mie ayam')) {
      return Icons.ramen_dining;
    } else if (lowerName.contains('batagor')) {
      return Icons.fastfood;
    } else if (lowerName.contains('martabak manis')) {
      return Icons.cake;
    } else if (lowerName.contains('martabak asin')) {
      return Icons.lunch_dining;
    } else if (lowerName.contains('nasi goreng')) {
      return Icons.rice_bowl;
    } else if (lowerName.contains('es teh')) {
      return Icons.emoji_food_beverage;
    } else if (lowerName.contains('es milo')) {
      return Icons.coffee;
    } else if (lowerName.contains('es jeruk')) {
      return Icons.local_drink;
    }

    switch (kategori.toLowerCase()) {
      case 'makanan':
        return Icons.restaurant;
      case 'minuman':
        return Icons.local_bar;
      case 'camilan':
        return Icons.bakery_dining;
      default:
        return Icons.fastfood;
    }
  }
}