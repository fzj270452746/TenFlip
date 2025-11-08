//
//  EtherealGameViewModel.swift
//  TenFlip
//
//  Lapisan Model Paparan Permainan
//

import Foundation

// MARK: - Protokol Pemerhati

protocol PemerhatiKeadaanPermainanEteria: AnyObject {
    func sejarahTelahMaju(ke aras: Int)
    func fluksMasaDikemaskini(baki: Int)
    func pemilihanKadBerubah()
    func kemenangandiperoleh()
    func kegagalanKatastrofik()
    func pasanganTelahDihapuskan()
}

// MARK: - Protokol Pemasa

protocol ProtokolEnginTemporal {
    func mula(selang: TimeInterval, pengendalian: @escaping () -> Void)
    func berhenti()
}

class EnginTemporalStandard: ProtokolEnginTemporal {
    private var pemasa: Timer?
    
    func mula(selang: TimeInterval, pengendalian: @escaping () -> Void) {
        hentikanPemasaSemasa()
        pemasa = Timer.scheduledTimer(withTimeInterval: selang, repeats: true) { _ in
            pengendalian()
        }
    }
    
    func berhenti() {
        hentikanPemasaSemasa()
    }
    
    private func hentikanPemasaSemasa() {
        pemasa?.invalidate()
        pemasa = nil
    }
}

// MARK: - Corak Arahan

protocol ArahanPermainan {
    func laksanakan()
}

class ArahanPemilihanKad: ArahanPermainan {
    private weak var sesi: SesiPermainanEfemeral?
    private let indeks: Int
    private let dariAtas: Bool
    private weak var pemerhati: PemerhatiKeadaanPermainanEteria?
    
    init(sesi: SesiPermainanEfemeral, indeks: Int, dariAtas: Bool, pemerhati: PemerhatiKeadaanPermainanEteria?) {
        self.sesi = sesi
        self.indeks = indeks
        self.dariAtas = dariAtas
        self.pemerhati = pemerhati
    }
    
    func laksanakan() {
        guard let sesi = sesi else { return }
        let entitiSenarai = dariAtas ? sesi.kadGridAtas : sesi.kadGridBawah
        guard indeks < entitiSenarai.count else { return }
        
        let entitiSasaran = entitiSenarai[indeks]
        
        guard !entitiSasaran.telahDihapuskan else { return }
        guard sesi.dipilihDariAtas == nil || sesi.dipilihDariBawah == nil else { return }
        
        if dariAtas {
            guard sesi.dipilihDariAtas == nil else { return }
            bukaKadDanPilih(entiti: entitiSasaran, dalamSesi: sesi, atasGrid: true)
        } else {
            guard sesi.dipilihDariBawah == nil else { return }
            bukaKadDanPilih(entiti: entitiSasaran, dalamSesi: sesi, atasGrid: false)
        }
        
        pemerhati?.pemilihanKadBerubah()
    }
    
    private func bukaKadDanPilih(entiti: EntitiJubenMistik, dalamSesi sesi: SesiPermainanEfemeral, atasGrid: Bool) {
        entiti.sedangDibuka = true
        if atasGrid {
            sesi.dipilihDariAtas = entiti
        } else {
            sesi.dipilihDariBawah = entiti
        }
    }
}

// MARK: - Strategi Penilaian Padanan

protocol StrategiPenilaianPadanan {
    func nilai(atas: EntitiJubenMistik, bawah: EntitiJubenMistik) -> Bool
    func dapatkanJumlah(atas: EntitiJubenMistik, bawah: EntitiJubenMistik) -> Int
}

class StrategiPenilaianPadananStandard: StrategiPenilaianPadanan {
    func nilai(atas: EntitiJubenMistik, bawah: EntitiJubenMistik) -> Bool {
        let jumlah = dapatkanJumlah(atas: atas, bawah: bawah)
        return jumlah == 10
    }
    
    func dapatkanJumlah(atas: EntitiJubenMistik, bawah: EntitiJubenMistik) -> Int {
        return atas.jenisKad.nilaiPaparan + bawah.jenisKad.nilaiPaparan
    }
}

// MARK: - Pengurus Keadaan

protocol PengurusKeadaanPermainan {
    func semakSyaratKemenangan(sesi: SesiPermainanEfemeral) -> Bool
    func prosesKeputusanPadanan(padanan: Bool, atas: EntitiJubenMistik, bawah: EntitiJubenMistik, sesi: SesiPermainanEfemeral)
}

class PengurusKeadaanPermainanStandard: PengurusKeadaanPermainan {
    func semakSyaratKemenangan(sesi: SesiPermainanEfemeral) -> Bool {
        let atasLengkap = sesi.kadGridAtas.allSatisfy { $0.telahDihapuskan }
        let bawahLengkap = sesi.kadGridBawah.allSatisfy { $0.telahDihapuskan }
        return atasLengkap && bawahLengkap
    }
    
    func prosesKeputusanPadanan(padanan: Bool, atas: EntitiJubenMistik, bawah: EntitiJubenMistik, sesi: SesiPermainanEfemeral) {
        if padanan {
            lakukanPadananBerjaya(atas: atas, bawah: bawah, sesi: sesi)
        } else {
            lakukanPadananGagal(atas: atas, bawah: bawah, sesi: sesi)
        }
    }
    
    private func lakukanPadananBerjaya(atas: EntitiJubenMistik, bawah: EntitiJubenMistik, sesi: SesiPermainanEfemeral) {
        atas.telahDihapuskan = true
        bawah.telahDihapuskan = true
        sesi.dipilihDariAtas = nil
        sesi.dipilihDariBawah = nil
        sesi.masaBaki += KonfigurasiRahsia.ParameterPermainan.bonusMasa
    }
    
    private func lakukanPadananGagal(atas: EntitiJubenMistik, bawah: EntitiJubenMistik, sesi: SesiPermainanEfemeral) {
        atas.sedangDibuka = false
        bawah.sedangDibuka = false
        sesi.dipilihDariAtas = nil
        sesi.dipilihDariBawah = nil
    }
}

// MARK: - Pelaksanaan ViewModel

class ModelPaparanPermainanEteria {
    
    private(set) var sesiRahsia: SesiPermainanEfemeral
    weak var pemerhatiKeadaan: PemerhatiKeadaanPermainanEteria?
    
    private let enginTemporal: ProtokolEnginTemporal
    private let strategiPadanan: StrategiPenilaianPadanan
    private let pengurusKeadaan: PengurusKeadaanPermainan
    
    init(kesukaran: ArasKesukaran,
         enginTemporal: ProtokolEnginTemporal = EnginTemporalStandard(),
         strategiPadanan: StrategiPenilaianPadanan = StrategiPenilaianPadananStandard(),
         pengurusKeadaan: PengurusKeadaanPermainan = PengurusKeadaanPermainanStandard()) {
        self.sesiRahsia = SesiPermainanEfemeral(kesukaran: kesukaran)
        self.enginTemporal = enginTemporal
        self.strategiPadanan = strategiPadanan
        self.pengurusKeadaan = pengurusKeadaan
    }
    
    var kesukaranSemasa: ArasKesukaran {
        return sesiRahsia.kesukaran
    }
    
    var arasSemasa: Int {
        return sesiRahsia.arasSemasa
    }
    
    var masaBaki: Int {
        return sesiRahsia.masaBaki
    }
    
    var entitiGridAtas: [EntitiJubenMistik] {
        return sesiRahsia.kadGridAtas
    }
    
    var entitiGridBawah: [EntitiJubenMistik] {
        return sesiRahsia.kadGridBawah
    }
    
    func mulaCabaranBaru() {
        sesiRahsia.janaArasBarau()
        sesiRahsia.fasaPermainan = .dimulakan
        pemerhatiKeadaan?.sejarahTelahMaju(ke: sesiRahsia.arasSemasa)
        mulakanPenguranganTemporal()
    }
    
    private func mulakanPenguranganTemporal() {
        enginTemporal.mula(selang: 1.0) { [weak self] in
            self?.prosesTikTemporal()
        }
    }
    
    func hentikanEnginTemporal() {
        enginTemporal.berhenti()
    }
    
    private func prosesTikTemporal() {
        sesiRahsia.masaBaki -= 1
        pemerhatiKeadaan?.fluksMasaDikemaskini(baki: sesiRahsia.masaBaki)
        
        if sesiRahsia.masaBaki <= 0 {
            hentikanEnginTemporal()
            sesiRahsia.fasaPermainan = .kekalahan
            pemerhatiKeadaan?.kegagalanKatastrofik()
        }
    }
    
    func cubakanPemilihanKad(pada indeks: Int, dariAtas: Bool) -> Bool {
        let arahan = ArahanPemilihanKad(
            sesi: sesiRahsia,
            indeks: indeks,
            dariAtas: dariAtas,
            pemerhati: pemerhatiKeadaan
        )
        arahan.laksanakan()
        
        if let atas = sesiRahsia.dipilihDariAtas, let bawah = sesiRahsia.dipilihDariBawah {
            jadualkanPenilaianPadanan(atas: atas, bawah: bawah)
        }
        
        return true
    }
    
    private func jadualkanPenilaianPadanan(atas: EntitiJubenMistik, bawah: EntitiJubenMistik) {
        let kelewatan = KonfigurasiRahsia.TempoAnimasi.kelewatanPadanan
        DispatchQueue.main.asyncAfter(deadline: .now() + kelewatan) { [weak self] in
            guard let ini = self else { return }
            ini.nilaiCubaanPadanan(atas: atas, bawah: bawah)
        }
    }
    
    private func nilaiCubaanPadanan(atas: EntitiJubenMistik, bawah: EntitiJubenMistik) {
        let adalahPadanan = strategiPadanan.nilai(atas: atas, bawah: bawah)
        pengurusKeadaan.prosesKeputusanPadanan(
            padanan: adalahPadanan,
            atas: atas,
            bawah: bawah,
            sesi: sesiRahsia
        )
        
        if adalahPadanan {
            pemerhatiKeadaan?.pasanganTelahDihapuskan()
            sahkanSyaratKemenangan()
        } else {
            pemerhatiKeadaan?.pemilihanKadBerubah()
        }
    }
    
    private func sahkanSyaratKemenangan() {
        if pengurusKeadaan.semakSyaratKemenangan(sesi: sesiRahsia) {
            hentikanEnginTemporal()
            pemerhatiKeadaan?.kemenangandiperoleh()
        }
    }
    
    func majuKeArasBerikutnya() {
        sesiRahsia.arasSemasa += 1
        mulaCabaranBaru()
    }
    
    func setSemulaKeKeadaanAwal() {
        sesiRahsia.arasSemasa = 1
        mulaCabaranBaru()
    }
    
    func peliharaPencapaian() {
        guard sesiRahsia.arasSemasa > 1 else { return }
        let sejarah = RekodPuncak(
            kesukaran: sesiRahsia.kesukaran,
            arasDicapai: sesiRahsia.arasSemasa,
            capWaktu: Date()
        )
        PenjagaVault.dikongsi.simpanRekodPuncak(sejarah)
    }
}
