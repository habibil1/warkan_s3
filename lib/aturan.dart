import 'menu.dart';

int hitungPotonganDiskon(int harga, int jumlahPesan) {
  if (jumlahPesan >= 5) {
    return (harga * jumlahPesan * 0.1).round();
  }
  return 0;
}

int hitungTotalHargaItem(int harga, int jumlahPesan) {
  final subtotal = harga * jumlahPesan;
  final diskon = hitungPotonganDiskon(harga, jumlahPesan);
  return subtotal - diskon;
}

bool bisaDipesan(bool tersedia, int porsiTersisa) {
  return tersedia && porsiTersisa > 0;
}

bool bisadipesan(bool tersedia) => tersedia;

bool jumlahValid(int jumlahPesan, int porsiTersisa) {
  return jumlahPesan <= porsiTersisa;
}

bool jumlahvalid(int jumlahpesan, int stokporsi) => jumlahpesan <= stokporsi;

List<Menu> urutkanBerdasarkanHarga(List<Menu> daftar, bool termurahDulu) {
  final hasil = List<Menu>.from(daftar);
  hasil.sort((a, b) {
    if (termurahDulu) {
      return a.harga.compareTo(b.harga);
    } else {
      return b.harga.compareTo(a.harga);
    }
  });
  return hasil;
}

List<Menu> urutkanberdasarkanharga(List<Menu> daftar, bool termurahdulu) =>
    urutkanBerdasarkanHarga(daftar, termurahdulu);