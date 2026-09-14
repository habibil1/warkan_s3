import 'package:flutter/material.dart';
import 'menu.dart';
import 'aturan.dart';

class JumlahPorsi extends StatefulWidget {
  final bool tersedia;
  final int porsiTersisa;
  final int jumlah;
  final ValueChanged<int> onJumlahBerubah;
  final String? namaMenu;

  const JumlahPorsi({
    super.key,
    required this.tersedia,
    required this.porsiTersisa,
    required this.jumlah,
    required this.onJumlahBerubah,
    this.namaMenu,
  });

  factory JumlahPorsi.fromMenu({
    Key? key,
    required Menu menu,
    required int jumlah,
    required ValueChanged<int> onJumlahBerubah,
  }) {
    return JumlahPorsi(
      key: key,
      tersedia: menu.tersedia,
      porsiTersisa: menu.porsiTersisa,
      jumlah: jumlah,
      onJumlahBerubah: onJumlahBerubah,
      namaMenu: menu.namaMenu,
    );
  }

  @override
  State<JumlahPorsi> createState() => _JumlahPorsiState();
}

class _JumlahPorsiState extends State<JumlahPorsi> {
  late int _jumlah;

  @override
  void initState() {
    super.initState();
    _jumlah = widget.jumlah;
  }

  @override
  void didUpdateWidget(covariant JumlahPorsi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.jumlah != oldWidget.jumlah) {
      setState(() {
        _jumlah = widget.jumlah;
      });
    }
  }

  void _tambahPorsi() {
    final porsiBaru = _jumlah + 1;
    if (jumlahValid(porsiBaru, widget.porsiTersisa)) {
      setState(() {
        _jumlah = porsiBaru;
      });
      widget.onJumlahBerubah(_jumlah);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Maksimal pesanan ${widget.namaMenu ?? 'menu ini'} adalah ${widget.porsiTersisa} porsi!',
            style: const TextStyle(fontSize: 13),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: const Color(0xFF1E56A0), // Tetap warna asli biru
        ),
      );
    }
  }

  void _kurangPorsi() {
    if (_jumlah > 0) {
      setState(() {
        _jumlah--;
      });
      widget.onJumlahBerubah(_jumlah);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bisaPesan = bisaDipesan(widget.tersedia, widget.porsiTersisa);
    const warnaUtama = Color(0xFF1E56A0); // Tetap warna asli biru

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Tombol Minus (Lingkaran Outlined)
        InkWell(
          onTap: _jumlah > 0 ? _kurangPorsi : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _jumlah > 0 ? Colors.grey.shade400 : Colors.grey.shade200,
                width: 1.2,
              ),
              color: Colors.transparent,
            ),
            child: Icon(
              Icons.remove,
              size: 16,
              color: _jumlah > 0 ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
          ),
        ),
        
        // Angka Jumlah
        SizedBox(
          width: 32,
          child: Text(
            '$_jumlah',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF163172),
            ),
          ),
        ),

        // Tombol Plus (Lingkaran Filled Biru)
        InkWell(
          onTap: bisaPesan ? _tambahPorsi : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bisaPesan ? warnaUtama : warnaUtama.withValues(alpha: 0.3),
            ),
            child: const Icon(
              Icons.add,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}