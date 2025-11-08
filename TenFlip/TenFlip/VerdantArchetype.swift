//
//  VerdantArchetype.swift
//  TenFlip
//
//  Model Permainan dan Struktur Data
//

import Foundation

// MARK: - Seni Bina Berasaskan Protokol

protocol KonfigurasiKesukaran {
    var dimensiGrid: Int { get }
    var elaungMasa: Int { get }
    var jumlahSelTotal: Int { get }
}

protocol PenyediaNilaiKad {
    var nilaiPaparan: Int { get }
    var namaGambar: String { get }
}

protocol PengurusKeadaanKad {
    var sedangDibuka: Bool { get set }
    var telahDihapuskan: Bool { get set }
}

protocol PenyediaPosisiGrid {
    var posisiGrid: Int { get set }
}

protocol EntitiYangBolehDikenali {
    var pengecam: String { get }
}

// MARK: - Pelaksanaan Mod Kesukaran

enum ArasKesukaran: String, Codable {
    case pemula = "Simple"
    case sukar = "Difficult"
    
    private struct StrukturKonfigurasi: KonfigurasiKesukaran {
        let dimensiGrid: Int
        let elaungMasa: Int
        var jumlahSelTotal: Int { 
            return kiraJumlahSel(dimensi: dimensiGrid) 
        }
        
        private func kiraJumlahSel(dimensi: Int) -> Int {
            return dimensi * dimensi
        }
    }
    
    private var konfig: StrukturKonfigurasi {
        switch self {
        case .pemula:
            return StrukturKonfigurasi(dimensiGrid: 4, elaungMasa: 40)
        case .sukar:
            return StrukturKonfigurasi(dimensiGrid: 5, elaungMasa: 60)
        }
    }
    
    var dimensiGrid: Int { 
        return konfig.dimensiGrid 
    }
    var elaungMasa: Int { 
        return konfig.elaungMasa 
    }
    var jumlahSelTotal: Int { 
        return konfig.jumlahSelTotal 
    }
}

// MARK: - Jenis Sut Mahjong

enum SutEteria: String, CaseIterable {
    case ndhuu
    case tersg
    case koden
    
    static func pemilihanRawak() -> SutEteria {
        let indeks = Int.random(in: 0..<allCases.count)
        return allCases[indeks]
    }
}

// MARK: - Pelaksanaan Jenis Kad

enum JenisKadCelestial {
    case glifNumerik(Int)
    case jubenMahjong(sut: SutEteria, nilai: Int)
    
    private struct PengekstrakNilai: PenyediaNilaiKad {
        let jenisKad: JenisKadCelestial
        
        var nilaiPaparan: Int {
            switch jenisKad {
            case .glifNumerik(let nilaiAngka):
                return nilaiAngka
            case .jubenMahjong(_, let nilaiAngka):
                return nilaiAngka
            }
        }
        
        var namaGambar: String {
            switch jenisKad {
            case .glifNumerik(let nilaiAngka):
                return hasilkanNamaGambarNumerik(nilai: nilaiAngka)
            case .jubenMahjong(let sut, let nilaiAngka):
                return hasilkanNamaGambarMahjong(sut: sut, nilai: nilaiAngka)
            }
        }
        
        private func hasilkanNamaGambarNumerik(nilai: Int) -> String {
            return "number\(nilai)"
        }
        
        private func hasilkanNamaGambarMahjong(sut: SutEteria, nilai: Int) -> String {
            return "\(sut.rawValue)\(nilai)"
        }
    }
    
    private var pengekstrak: PengekstrakNilai {
        return PengekstrakNilai(jenisKad: self)
    }
    
    var nilaiPaparan: Int { 
        return pengekstrak.nilaiPaparan 
    }
    var namaGambar: String { 
        return pengekstrak.namaGambar 
    }
}

// MARK: - Pelaksanaan Model Kad

class EntitiJubenMistik: EntitiYangBolehDikenali, PengurusKeadaanKad, PenyediaPosisiGrid {
    let pengecam: String
    let jenisKad: JenisKadCelestial
    var sedangDibuka: Bool = false
    var telahDihapuskan: Bool = false
    var posisiGrid: Int
    
    init(pengecam: String, jenisKad: JenisKadCelestial, posisiGrid: Int) {
        self.pengecam = pengecam
        self.jenisKad = jenisKad
        self.posisiGrid = posisiGrid
    }
}

// MARK: - Keadaan Permainan

enum FasaPermainanKelam {
    case murni
    case dimulakan
    case ditangguhkan
    case kemenangan
    case kekalahan
}

// MARK: - Entri Papan Kedudukan

struct RekodPuncak: Codable {
    let kesukaran: ArasKesukaran
    let arasDicapai: Int
    let capWaktu: Date
    
    private struct PenyediaFormatTarikh {
        static let dikongsi: DateFormatter = {
            let pemformat = DateFormatter()
            pemformat.dateStyle = .medium
            pemformat.timeStyle = .short
            return pemformat
        }()
    }
    
    var tarikhDiformat: String {
        return PenyediaFormatTarikh.dikongsi.string(from: capWaktu)
    }
}

// MARK: - Strategi Penjanaan Kad

protocol StrategiPenjanaanKad {
    func janaPasanganKad(jumlah: Int) -> [(Int, Int)]
}

struct StrategiPenjanaanPasanganRawak: StrategiPenjanaanKad {
    func janaPasanganKad(jumlah: Int) -> [(Int, Int)] {
        let jumlahPasanganDiperlukan = (jumlah + 1) / 2
        var pasangan: [(Int, Int)] = []
        var nilaiYangDijana = Set<Int>()
        var percubaan = 0
        let maksimaPercubaan = jumlah * 10
        
        while pasangan.count < jumlahPasanganDiperlukan && percubaan < maksimaPercubaan {
            let nilai = Int.random(in: 1...9)
            let pelengkap = 10 - nilai
            
            if pelengkap >= 1 && pelengkap <= 9 && !nilaiYangDijana.contains(nilai) {
                pasangan.append((nilai, pelengkap))
                nilaiYangDijana.insert(nilai)
                nilaiYangDijana.insert(pelengkap)
            }
            percubaan += 1
        }
        
        while pasangan.count < jumlahPasanganDiperlukan {
            let nilai = Int.random(in: 1...9)
            let pelengkap = 10 - nilai
            if pelengkap >= 1 && pelengkap <= 9 {
                pasangan.append((nilai, pelengkap))
            }
        }
        
        return pasangan
    }
}

// MARK: - Pembina Grid

protocol PembinaGrid {
    func binaGridAtas(pasangan: [(Int, Int)]) -> [EntitiJubenMistik]
    func binaGridBawah(pasangan: [(Int, Int)]) -> [EntitiJubenMistik]
}

class PembinaBakuGrid: PembinaGrid {
    private var jumlahSelSasaran: Int = 0
    
    func binaGridAtas(pasangan: [(Int, Int)]) -> [EntitiJubenMistik] {
        var nilaiSenarai: [Int] = []
        for (nilai, pelengkap) in pasangan {
            nilaiSenarai.append(nilai)
            nilaiSenarai.append(pelengkap)
        }
        
        nilaiSenarai.shuffle()
        
        let jumlahDiguna = jumlahSelSasaran > 0 ? min(jumlahSelSasaran, nilaiSenarai.count) : nilaiSenarai.count
        
        return nilaiSenarai.prefix(jumlahDiguna).enumerated().map { indeks, nilai in
            EntitiJubenMistik(
                pengecam: UUID().uuidString,
                jenisKad: .glifNumerik(nilai),
                posisiGrid: indeks
            )
        }
    }
    
    func binaGridBawah(pasangan: [(Int, Int)]) -> [EntitiJubenMistik] {
        var nilaiSenarai: [Int] = []
        for (nilai, pelengkap) in pasangan {
            nilaiSenarai.append(nilai)
            nilaiSenarai.append(pelengkap)
        }
        
        let pelengkapSenarai = nilaiSenarai.map { 10 - $0 }
        let pelengkapTerKocok = pelengkapSenarai.shuffled()
        
        let jumlahDiguna = jumlahSelSasaran > 0 ? min(jumlahSelSasaran, pelengkapTerKocok.count) : pelengkapTerKocok.count
        
        return pelengkapTerKocok.prefix(jumlahDiguna).enumerated().map { indeks, nilaiPelengkap in
            EntitiJubenMistik(
                pengecam: UUID().uuidString,
                jenisKad: .jubenMahjong(sut: SutEteria.pemilihanRawak(), nilai: nilaiPelengkap),
                posisiGrid: indeks
            )
        }
    }
    
    func tetapkanJumlahSelSasaran(_ jumlah: Int) {
        jumlahSelSasaran = jumlah
    }
}

// MARK: - Pelaksanaan Sesi Permainan

class SesiPermainanEfemeral {
    var kesukaran: ArasKesukaran
    var arasSemasa: Int = 1
    var kadGridAtas: [EntitiJubenMistik] = []
    var kadGridBawah: [EntitiJubenMistik] = []
    var masaBaki: Int
    var dipilihDariAtas: EntitiJubenMistik?
    var dipilihDariBawah: EntitiJubenMistik?
    var fasaPermainan: FasaPermainanKelam = .murni
    
    private let strategiPenjanaan: StrategiPenjanaanKad
    private let pembinaGrid: PembinaGrid
    
    init(kesukaran: ArasKesukaran, 
         strategi: StrategiPenjanaanKad = StrategiPenjanaanPasanganRawak(),
         pembina: PembinaGrid = PembinaBakuGrid()) {
        self.kesukaran = kesukaran
        self.masaBaki = kesukaran.elaungMasa
        self.strategiPenjanaan = strategi
        self.pembinaGrid = pembina
    }
    
    func janaArasBarau() {
        setSemulaKeadaanSesi()
        
        let jumlahSel = kesukaran.jumlahSelTotal
        let pasangan = strategiPenjanaan.janaPasanganKad(jumlah: jumlahSel)
        
        if let pembinaStandard = pembinaGrid as? PembinaBakuGrid {
            pembinaStandard.tetapkanJumlahSelSasaran(jumlahSel)
        }
        
        kadGridAtas = pembinaGrid.binaGridAtas(pasangan: pasangan)
        kadGridBawah = pembinaGrid.binaGridBawah(pasangan: pasangan)
        
        kemaskiniPosisiGridBawah()
    }
    
    private func setSemulaKeadaanSesi() {
        kadGridAtas.removeAll()
        kadGridBawah.removeAll()
        dipilihDariAtas = nil
        dipilihDariBawah = nil
        masaBaki = kesukaran.elaungMasa
    }
    
    private func kemaskiniPosisiGridBawah() {
        kadGridBawah.enumerated().forEach { indeks, kad in
            kad.posisiGrid = indeks
        }
    }
}

// MARK: - Storan Persistens

protocol StoranKekal {
    func simpanRekodPuncak(_ rekod: RekodPuncak)
    func ambilRekodPuncak() -> [RekodPuncak]
    func ambilRekodUntukKesukaran(_ kesukaran: ArasKesukaran) -> [RekodPuncak]
    func simpanentriMaklumBalas(_ maklumBalas: String)
    func ambilEntriMaklumBalas() -> [[String: Any]]
}

// MARK: - Pelaksanaan Pengurus Storan Kekal

class PenjagaVault: StoranKekal {
    static let dikongsi = PenjagaVault()
    private let kunciRekodPuncak = "rekod_puncak_nebulous"
    private let kunciRepositoriMaklumBalas = "repositori_maklum_balas_eteria"
    
    private let pengekod: JSONEncoder
    private let penyahkod: JSONDecoder
    private let piawaiPengguna: UserDefaults
    
    private init(pengekod: JSONEncoder = JSONEncoder(),
                 penyahkod: JSONDecoder = JSONDecoder(),
                 piawaiPengguna: UserDefaults = .standard) {
        self.pengekod = pengekod
        self.penyahkod = penyahkod
        self.piawaiPengguna = piawaiPengguna
    }
    
    func simpanRekodPuncak(_ rekod: RekodPuncak) {
        var rekodSedia = ambilRekodPuncak()
        rekodSedia.append(rekod)
        rekodSedia.sort { $0.arasDicapai > $1.arasDicapai }
        
        guard let dikodkan = try? pengekod.encode(rekodSedia) else { return }
        piawaiPengguna.set(dikodkan, forKey: kunciRekodPuncak)
    }
    
    func ambilRekodPuncak() -> [RekodPuncak] {
        guard let data = piawaiPengguna.data(forKey: kunciRekodPuncak),
              let rekod = try? penyahkod.decode([RekodPuncak].self, from: data) else {
            return []
        }
        return rekod
    }
    
    func ambilRekodUntukKesukaran(_ kesukaran: ArasKesukaran) -> [RekodPuncak] {
        return ambilRekodPuncak()
            .filter { $0.kesukaran == kesukaran }
            .sorted { $0.arasDicapai > $1.arasDicapai }
    }
    
    func simpanentriMaklumBalas(_ maklumBalas: String) {
        var senariMaklumBalas = ambilEntriMaklumBalas()
        let entri: [String: Any] = [
            "kandungan": maklumBalas,
            "capWaktu": Date().timeIntervalSince1970
        ]
        senariMaklumBalas.append(entri)
        piawaiPengguna.set(senariMaklumBalas, forKey: kunciRepositoriMaklumBalas)
    }
    
    func ambilEntriMaklumBalas() -> [[String: Any]] {
        return piawaiPengguna.array(forKey: kunciRepositoriMaklumBalas) as? [[String: Any]] ?? []
    }
}
