import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warung_sk3/main.dart';
import 'package:warung_sk3/menu_card.dart';
import 'package:warung_sk3/aturan.dart';
import 'package:warung_sk3/menu.dart';

void main() {
  group('Pengujian Studi Kasus 3 - Warung SK3', () {
    testWidgets('1. Smoke Test & Interaksi Pesanan (Khas 1 & Khas 2)', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Warkan'), findsOneWidget);
      expect(find.text('Es Teh'), findsOneWidget);
      expect(find.text('Belum ada pesanan'), findsOneWidget);

      final tambahButtons = find.text('+ Tambah');
      expect(tambahButtons, findsWidgets);

      await tester.tap(tambahButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('1 porsi dipilih'), findsOneWidget);
      expect(find.textContaining('Total: Rp'), findsOneWidget);

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Mie');
      await tester.pumpAndSettle();

      expect(find.text('Mie Ayam'), findsOneWidget);
      expect(find.text('Es Teh'), findsNothing);
    });

    testWidgets('2. Uji Penanda HABIS & Menu Tidak Tersedia', (WidgetTester tester) async {
      const menuHabis = Menu(
        namaMenu: 'Kopi Tubruk',
        kategori: 'Minuman',
        harga: 4000,
        tersedia: false,
        porsiTersisa: 0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuCard(
              namaMenu: menuHabis.namaMenu,
              kategori: menuHabis.kategori,
              harga: menuHabis.harga,
              tersedia: menuHabis.tersedia,
              porsiTersisa: menuHabis.porsiTersisa,
              jumlah: 0,
              onJumlahBerubah: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kopi Tubruk'), findsOneWidget);
      expect(find.text('HABIS'), findsOneWidget);
      expect(find.text('Habis'), findsOneWidget);

      final habisButton = tester.widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'Habis'));
      expect(habisButton.onPressed, isNull);
    });

    testWidgets('3. Uji Fitur Pilihan F1 (Urutkan) & F4 (Tampilan Kosong)', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final chipTermahal = find.text('Harga Termahal');
      expect(chipTermahal, findsOneWidget);
      await tester.tap(chipTermahal);
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'MenuYangPastiTidakAda123');
      await tester.pumpAndSettle();

      expect(find.text('Menu tidak ditemukan'), findsOneWidget);
      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
      expect(find.text('Tampilkan Semua Menu'), findsOneWidget);

      await tester.tap(find.text('Tampilkan Semua Menu'));
      await tester.pumpAndSettle();

      expect(find.text('Es Teh'), findsOneWidget);
    });

    testWidgets('4. Uji Responsivitas 3 Ukuran Layar Bebas Galat Tata Letak', (WidgetTester tester) async {
      final widths = [360.0, 400.0, 599.0, 600.0, 750.0, 899.0, 900.0, 910.0, 920.0, 950.0, 1000.0, 1200.0];
      for (final w in widths) {
        tester.view.physicalSize = Size(w, 800);
        tester.view.devicePixelRatio = 1.0;
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();
        expect(find.text('Warkan'), findsOneWidget);
      }
      tester.view.resetPhysicalSize();
    });

    testWidgets('5. Uji Aturan Usaha di aturan.dart', (WidgetTester tester) async {
      expect(hitungPotonganDiskon(10000, 4), 0);
      expect(hitungPotonganDiskon(10000, 5), 5000);
      expect(hitungTotalHargaItem(10000, 5), 45000);

      expect(bisaDipesan(true, 5), isTrue);
      expect(bisaDipesan(false, 5), isFalse);
      expect(bisaDipesan(true, 0), isFalse);

      expect(jumlahValid(5, 5), isTrue);
      expect(jumlahValid(6, 5), isFalse);

      const daftarUji = [
        Menu(namaMenu: 'B', kategori: 'Makanan', harga: 20000, tersedia: true, porsiTersisa: 5),
        Menu(namaMenu: 'A', kategori: 'Minuman', harga: 5000, tersedia: true, porsiTersisa: 10),
      ];

      final termurah = urutkanBerdasarkanHarga(daftarUji, true);
      expect(termurah.first.harga, 5000);

      final termahal = urutkanBerdasarkanHarga(daftarUji, false);
      expect(termahal.first.harga, 20000);
    });

    testWidgets('6. Uji Tombol Selesai untuk Reset Seluruh Pesanan ke 0', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final tambahButton = find.text('+ Tambah').first;
      await tester.tap(tambahButton);
      await tester.pumpAndSettle();

      expect(find.text('1 porsi dipilih'), findsOneWidget);

      final selesaiBtn = find.text('Selesai');
      expect(selesaiBtn, findsOneWidget);
      await tester.tap(selesaiBtn);
      await tester.pumpAndSettle();

      expect(find.text('Belum ada pesanan'), findsOneWidget);
      expect(find.text('Total: Rp 0'), findsOneWidget);
      expect(find.text('Pesanan selesai. Siap melayani pesanan berikutnya!'), findsOneWidget);
    });
  });
}
