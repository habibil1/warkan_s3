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
          backgroundColor: const Color(0xFF1E3A8A),
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

    if (!bisaPesan) {
      return OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          minimumSize: const Size(0, 28),
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          'Habis',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade400,
          ),
        ),
      );
    }

    const warnaUtama = Color(0xFF1E56A0);

    if (_jumlah == 0) {
      return OutlinedButton(
        onPressed: _tambahPorsi,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: warnaUtama, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          minimumSize: const Size(0, 28),
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: const Text(
          '+ Tambah',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: warnaUtama,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: warnaUtama.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
            icon: Icon(
              _jumlah == 1 ? Icons.delete_outline : Icons.remove,
              size: 14,
              color: warnaUtama,
            ),
            tooltip: 'Kurangi porsi',
            onPressed: _kurangPorsi,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '$_jumlah',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF163172),
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
            icon: const Icon(
              Icons.add,
              size: 14,
              color: warnaUtama,
            ),
            tooltip: 'Tambah porsi',
            onPressed: _tambahPorsi,
          ),
        ],
      ),
    );
  }
}