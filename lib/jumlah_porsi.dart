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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {},
        ),
        Text('$_jumlah'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {},
        ),
      ],
    );
  }
}