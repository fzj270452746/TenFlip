
import UIKit

// MARK: - Protokol Penyedia Warna

protocol PenyediaWarna {
    var warnaNeoPink: UIColor { get }
    var warnaNeoCyan: UIColor { get }
    var warnaNeoPurple: UIColor { get }
    var warnaOren: UIColor { get }
    var warnaHijauNeon: UIColor { get }
    var warnabiruNeon: UIColor { get }
    var warnaMulaGradien: UIColor { get }
    var warnaTamatGradien: UIColor { get }
    var warnaButangMulaGradienAwal: UIColor { get }
    var warnaButangMulaGradienAkhir: UIColor { get }
    var warnaButangPapanKedudukanGradienAwal: UIColor { get }
    var warnaButangPapanKedudukanGradienAkhir: UIColor { get }
    var warnaButangPeraturanGradienAwal: UIColor { get }
    var warnaButangPeraturanGradienAkhir: UIColor { get }
    var warnaButangMaklumBalasGradienAwal: UIColor { get }
    var warnaButangMaklumBalasGradienAkhir: UIColor { get }
    var warnaLatarKaca: UIColor { get }
    var warnaSempadanKaca: UIColor { get }
}

class PelaksanaanPenyediaWarnaModen: PenyediaWarna {
    var warnaNeoPink: UIColor { 
        return buatWarna(merah: 1.0, hijau: 0.2, biru: 0.8) 
    }
    var warnaNeoCyan: UIColor { 
        return buatWarna(merah: 0.0, hijau: 1.0, biru: 1.0) 
    }
    var warnaNeoPurple: UIColor { 
        return buatWarna(merah: 0.6, hijau: 0.2, biru: 1.0) 
    }
    var warnaOren: UIColor { 
        return buatWarna(merah: 1.0, hijau: 0.5, biru: 0.0) 
    }
    var warnaHijauNeon: UIColor { 
        return buatWarna(merah: 0.2, hijau: 1.0, biru: 0.4) 
    }
    var warnabiruNeon: UIColor { 
        return buatWarna(merah: 0.2, hijau: 0.6, biru: 1.0) 
    }
    var warnaMulaGradien: UIColor { 
        return buatWarna(merah: 0.2, hijau: 0.0, biru: 0.4) 
    }
    var warnaTamatGradien: UIColor { 
        return buatWarna(merah: 0.0, hijau: 0.2, biru: 0.4) 
    }
    var warnaButangMulaGradienAwal: UIColor { 
        return buatWarna(merah: 1.0, hijau: 0.3, biru: 0.6) 
    }
    var warnaButangMulaGradienAkhir: UIColor { 
        return buatWarna(merah: 0.8, hijau: 0.2, biru: 1.0) 
    }
    var warnaButangPapanKedudukanGradienAwal: UIColor { 
        return buatWarna(merah: 0.2, hijau: 0.8, biru: 1.0) 
    }
    var warnaButangPapanKedudukanGradienAkhir: UIColor { 
        return buatWarna(merah: 0.0, hijau: 0.6, biru: 1.0) 
    }
    var warnaButangPeraturanGradienAwal: UIColor { 
        return buatWarna(merah: 0.2, hijau: 1.0, biru: 0.6) 
    }
    var warnaButangPeraturanGradienAkhir: UIColor { 
        return buatWarna(merah: 0.0, hijau: 0.8, biru: 0.4) 
    }
    var warnaButangMaklumBalasGradienAwal: UIColor { 
        return buatWarna(merah: 0.8, hijau: 0.4, biru: 1.0) 
    }
    var warnaButangMaklumBalasGradienAkhir: UIColor { 
        return buatWarna(merah: 0.6, hijau: 0.2, biru: 0.9) 
    }
    var warnaLatarKaca: UIColor { 
        return UIColor.white.withAlphaComponent(0.15) 
    }
    var warnaSempadanKaca: UIColor { 
        return UIColor.white.withAlphaComponent(0.3) 
    }
    
    private func buatWarna(merah: CGFloat, hijau: CGFloat, biru: CGFloat) -> UIColor {
        return UIColor(red: merah, green: hijau, blue: biru, alpha: 1.0)
    }
}

// MARK: - Protokol Penyedia Metrik Susun Atur

protocol PenyediaMetrikSusunAtur {
    var jarakGrid: CGFloat { get }
    var jejariSudut: CGFloat { get }
    var kelegumanBayang: Float { get }
    var jejarieBayang: CGFloat { get }
    var ofsetBayang: CGSize { get }
    var tinggiButang: CGFloat { get }
    var pelapisanPiawai: CGFloat { get }
    var jejariSudutKaca: CGFloat { get }
    var jejariCahayaNeon: CGFloat { get }
    var kelegumanCahayaNeon: Float { get }
    var lebarButang: CGFloat { get }
    var tinggiButangBesar: CGFloat { get }
    var tinggiButangBiasa: CGFloat { get }
}

class PelaksanaanPenyediaMetrikPiawai: PenyediaMetrikSusunAtur {
    var jarakGrid: CGFloat { return 4 }
    var jejariSudut: CGFloat { return 12 }
    var kelegumanBayang: Float { return 0.3 }
    var jejarieBayang: CGFloat { return 6 }
    var ofsetBayang: CGSize { return CGSize(width: 0, height: 4) }
    var tinggiButang: CGFloat { return 50 }
    var pelapisanPiawai: CGFloat { return 20 }
    var jejariSudutKaca: CGFloat { return 20 }
    var jejariCahayaNeon: CGFloat { return 15 }
    var kelegumanCahayaNeon: Float { return 0.8 }
    var lebarButang: CGFloat { return 240 }
    var tinggiButangBesar: CGFloat { return 70 }
    var tinggiButangBiasa: CGFloat { return 60 }
}

// MARK: - Protokol Penyedia Konfigurasi Animasi

protocol PenyediaKonfigurasiAnimasi {
    var kelewatanPadanan: TimeInterval { get }
    var denyutanWarna: TimeInterval { get }
    var kemunculanDialog: TimeInterval { get }
    var penutupanDialog: TimeInterval { get }
}

class PelaksanaanPenyediaAnimasiPiawai: PenyediaKonfigurasiAnimasi {
    var kelewatanPadanan: TimeInterval { return 0.5 }
    var denyutanWarna: TimeInterval { return 0.3 }
    var kemunculanDialog: TimeInterval { return 0.3 }
    var penutupanDialog: TimeInterval { return 0.2 }
}

// MARK: - Protokol Penyedia Parameter Permainan

protocol PenyediaParameterPermainan {
    var bonusMasa: Int { get }
    var hadPapanKedudukan: Int { get }
}

class PelaksanaanPenyediaParameterPiawai: PenyediaParameterPermainan {
    var bonusMasa: Int { return 5 }
    var hadPapanKedudukan: Int { return 10 }
}

// MARK: - Bekas Konfigurasi Utama

struct KonfigurasiRahsia {
    
    static let paletWarna: PenyediaWarna = PelaksanaanPenyediaWarnaModen()
    static let metrikSusunAtur: PenyediaMetrikSusunAtur = PelaksanaanPenyediaMetrikPiawai()
    static let tempoAnimasi: PenyediaKonfigurasiAnimasi = PelaksanaanPenyediaAnimasiPiawai()
    static let parameterPermainan: PenyediaParameterPermainan = PelaksanaanPenyediaParameterPiawai()
    
    // Keserasian ke belakang - PaletWarna
    struct PaletWarna {
        static var warnaNeoPink: UIColor { KonfigurasiRahsia.paletWarna.warnaNeoPink }
        static var warnaNeoCyan: UIColor { KonfigurasiRahsia.paletWarna.warnaNeoCyan }
        static var warnaNeoPurple: UIColor { KonfigurasiRahsia.paletWarna.warnaNeoPurple }
        static var warnaOren: UIColor { KonfigurasiRahsia.paletWarna.warnaOren }
        static var warnaHijauNeon: UIColor { KonfigurasiRahsia.paletWarna.warnaHijauNeon }
        static var warnabiruNeon: UIColor { KonfigurasiRahsia.paletWarna.warnabiruNeon }
        static var warnaMulaGradien: UIColor { KonfigurasiRahsia.paletWarna.warnaMulaGradien }
        static var warnaTamatGradien: UIColor { KonfigurasiRahsia.paletWarna.warnaTamatGradien }
        static var warnaButangMulaGradienAwal: UIColor { KonfigurasiRahsia.paletWarna.warnaButangMulaGradienAwal }
        static var warnaButangMulaGradienAkhir: UIColor { KonfigurasiRahsia.paletWarna.warnaButangMulaGradienAkhir }
        static var warnaButangPapanKedudukanGradienAwal: UIColor { KonfigurasiRahsia.paletWarna.warnaButangPapanKedudukanGradienAwal }
        static var warnaButangPapanKedudukanGradienAkhir: UIColor { KonfigurasiRahsia.paletWarna.warnaButangPapanKedudukanGradienAkhir }
        static var warnaButangPeraturanGradienAwal: UIColor { KonfigurasiRahsia.paletWarna.warnaButangPeraturanGradienAwal }
        static var warnaButangPeraturanGradienAkhir: UIColor { KonfigurasiRahsia.paletWarna.warnaButangPeraturanGradienAkhir }
        static var warnaButangMaklumBalasGradienAwal: UIColor { KonfigurasiRahsia.paletWarna.warnaButangMaklumBalasGradienAwal }
        static var warnaButangMaklumBalasGradienAkhir: UIColor { KonfigurasiRahsia.paletWarna.warnaButangMaklumBalasGradienAkhir }
        static var warnaLatarKaca: UIColor { KonfigurasiRahsia.paletWarna.warnaLatarKaca }
        static var warnaSempadanKaca: UIColor { KonfigurasiRahsia.paletWarna.warnaSempadanKaca }
        
        // Warna lama
        static let warnaBronzPrimer = UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 1.0)
        static let warnaAkuaSekunder = UIColor(red: 0.3, green: 0.6, blue: 0.8, alpha: 1.0)
        static let warnaEmeraldTertier = UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 1.0)
        static let warnaVioletKuaternari = UIColor(red: 0.7, green: 0.5, blue: 0.8, alpha: 1.0)
        static let warnaKrimsonAmaran = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        static let warnaHijauKejayaan = UIColor(red: 0.2, green: 1.0, blue: 0.4, alpha: 1.0)
        static let warnaGadingNeutral = UIColor(red: 0.95, green: 0.93, blue: 0.88, alpha: 1.0)
        static let warnaBatuhitamBayang = UIColor(red: 0.6, green: 0.3, blue: 0.2, alpha: 1.0)
        static let warnaLapisanCoklat = UIColor.black.withAlphaComponent(0.4)
        static let warnaKelabuSuram = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
    }
    
    // Keserasian ke belakang - MetrikSusunAtur
    struct MetrikSusunAtur {
        static var jarakGrid: CGFloat { KonfigurasiRahsia.metrikSusunAtur.jarakGrid }
        static var jejariSudut: CGFloat { KonfigurasiRahsia.metrikSusunAtur.jejariSudut }
        static var kelegumanBayang: Float { KonfigurasiRahsia.metrikSusunAtur.kelegumanBayang }
        static var jejarieBayang: CGFloat { KonfigurasiRahsia.metrikSusunAtur.jejarieBayang }
        static var ofsetBayang: CGSize { KonfigurasiRahsia.metrikSusunAtur.ofsetBayang }
        static var tinggiButang: CGFloat { KonfigurasiRahsia.metrikSusunAtur.tinggiButang }
        static var pelapisanPiawai: CGFloat { KonfigurasiRahsia.metrikSusunAtur.pelapisanPiawai }
        static var jejariSudutKaca: CGFloat { KonfigurasiRahsia.metrikSusunAtur.jejariSudutKaca }
        static var jejariCahayaNeon: CGFloat { KonfigurasiRahsia.metrikSusunAtur.jejariCahayaNeon }
        static var kelegumanCahayaNeon: Float { KonfigurasiRahsia.metrikSusunAtur.kelegumanCahayaNeon }
        static var lebarButang: CGFloat { KonfigurasiRahsia.metrikSusunAtur.lebarButang }
        static var tinggiButangBesar: CGFloat { KonfigurasiRahsia.metrikSusunAtur.tinggiButangBesar }
        static var tinggiButangBiasa: CGFloat { KonfigurasiRahsia.metrikSusunAtur.tinggiButangBiasa }
    }
    
    // Keserasian ke belakang - TempoAnimasi
    struct TempoAnimasi {
        static var kelewatanPadanan: TimeInterval { KonfigurasiRahsia.tempoAnimasi.kelewatanPadanan }
        static var denyutanWarna: TimeInterval { KonfigurasiRahsia.tempoAnimasi.denyutanWarna }
        static var kemunculanDialog: TimeInterval { KonfigurasiRahsia.tempoAnimasi.kemunculanDialog }
        static var penutupanDialog: TimeInterval { KonfigurasiRahsia.tempoAnimasi.penutupanDialog }
    }
    
    // Keserasian ke belakang - ParameterPermainan
    struct ParameterPermainan {
        static var bonusMasa: Int { KonfigurasiRahsia.parameterPermainan.bonusMasa }
        static var hadPapanKedudukan: Int { KonfigurasiRahsia.parameterPermainan.hadPapanKedudukan }
    }
}

// MARK: - Protokol Penyedia Sumber

protocol PenyediaSumberRahsia {
    func dapatkanTeksturLatarBelakang() -> UIImage?
    func dapatkanTeksturKad(untuk pengecam: String) -> UIImage?
    func dapatkanTeksturTerbalik() -> UIImage?
}

class PelaksanaanPenyediaSumberPiawai: PenyediaSumberRahsia {
    func dapatkanTeksturLatarBelakang() -> UIImage? {
        return muatImej(namaImej: "tenflip")
    }
    
    func dapatkanTeksturKad(untuk pengecam: String) -> UIImage? {
        return muatImej(namaImej: pengecam)
    }
    
    func dapatkanTeksturTerbalik() -> UIImage? {
        return muatImej(namaImej: "beimian")
    }
    
    private func muatImej(namaImej: String) -> UIImage? {
        return UIImage(named: namaImej)
    }
}
