//
//  MahjongGridOrchestrator.swift
//  TenFlip
//
//  Komponen Pengurusan Paparan Koleksi
//

import UIKit

// MARK: - Protokol Delegasi

protocol DelegatGridMahjong: AnyObject {
    func gridTelahPilihKad(pada indeks: Int, adalahGridAtas: Bool)
}

// MARK: - Protokol Sumber Data

protocol SumberDataGrid {
    var entitiKad: [EntitiJubenMistik] { get set }
    var dimensialitiGrid: Int { get set }
    func bilanganItem() -> Int
    func entitiKad(pada indeks: Int) -> EntitiJubenMistik?
}

class SumberDataGridStandard: SumberDataGrid {
    var entitiKad: [EntitiJubenMistik] = []
    var dimensialitiGrid: Int = 4
    
    func bilanganItem() -> Int {
        return entitiKad.count
    }
    
    func entitiKad(pada indeks: Int) -> EntitiJubenMistik? {
        guard indeks >= 0 && indeks < entitiKad.count else { return nil }
        return entitiKad[indeks]
    }
}

// MARK: - Strategi Konfigurasi Sel

protocol StrategiKonfigurasiSel {
    func konfigurasi(sel: ArketipSelMahjong, dengan entiti: EntitiJubenMistik)
}

class StrategiKonfigurasiSelStandard: StrategiKonfigurasiSel {
    func konfigurasi(sel: ArketipSelMahjong, dengan entiti: EntitiJubenMistik) {
        sel.konfigurasiDenganKad(entiti)
    }
}

// MARK: - Pengira Susun Atur

protocol PengiraSusunAtur {
    func kiraSaizSel(untuk paparanKoleksi: UICollectionView, dimensi: Int) -> CGSize
}

class PengiraSusunAturStandard: PengiraSusunAtur {
    func kiraSaizSel(untuk paparanKoleksi: UICollectionView, dimensi: Int) -> CGSize {
        let jarak = KonfigurasiRahsia.MetrikSusunAtur.jarakGrid
        let jumlahJarak = jarak * CGFloat(dimensi - 1)
        
        let lebarTersedia = paparanKoleksi.bounds.width - jumlahJarak
        let tinggiTersedia = paparanKoleksi.bounds.height - jumlahJarak
        
        let saizSelMengikutLebar = lebarTersedia / CGFloat(dimensi)
        let saizSelMengikutTinggi = tinggiTersedia / CGFloat(dimensi)
        
        return CGSize(width: min(saizSelMengikutLebar, saizSelMengikutTinggi), 
                     height: min(saizSelMengikutLebar, saizSelMengikutTinggi))
    }
}

// MARK: - Pengurus Paparan Koleksi

protocol PengurusPaparanKoleksi {
    func daftarkanSel(dalam paparanKoleksi: UICollectionView)
    func muatSemulaData(dalam paparanKoleksi: UICollectionView?)
}

class PengurusPaparanKoleksiStandard: PengurusPaparanKoleksi {
    private let pengecamSel: String
    
    init(pengecamSel: String = "ArketipSelMahjong") {
        self.pengecamSel = pengecamSel
    }
    
    func daftarkanSel(dalam paparanKoleksi: UICollectionView) {
        paparanKoleksi.register(ArketipSelMahjong.self, forCellWithReuseIdentifier: pengecamSel)
    }
    
    func muatSemulaData(dalam paparanKoleksi: UICollectionView?) {
        paparanKoleksi?.reloadData()
    }
}

// MARK: - Pelaksanaan Orkestrator

class OrkestatorGridMahjong: NSObject {
    
    private weak var paparanKoleksi: UICollectionView?
    private let pengecamGrid: String
    private let adalahGridAtas: Bool
    private let penyediaSumber: PenyediaSumberRahsia
    weak var delegat: DelegatGridMahjong?
    
    private var sumberData: SumberDataGrid
    private let strategiKonfigurasiSel: StrategiKonfigurasiSel
    private let pengiraSusunAtur: PengiraSusunAtur
    private let pengurusPaparanKoleksi: PengurusPaparanKoleksi
    
    init(paparanKoleksi: UICollectionView, 
         pengecam: String, 
         adalahGridAtas: Bool, 
         penyediaSumber: PenyediaSumberRahsia = PelaksanaanPenyediaSumberPiawai(),
         sumberData: SumberDataGrid = SumberDataGridStandard(),
         strategiKonfigurasiSel: StrategiKonfigurasiSel = StrategiKonfigurasiSelStandard(),
         pengiraSusunAtur: PengiraSusunAtur = PengiraSusunAturStandard(),
         pengurusPaparanKoleksi: PengurusPaparanKoleksi = PengurusPaparanKoleksiStandard()) {
        self.paparanKoleksi = paparanKoleksi
        self.pengecamGrid = pengecam
        self.adalahGridAtas = adalahGridAtas
        self.penyediaSumber = penyediaSumber
        self.sumberData = sumberData
        self.strategiKonfigurasiSel = strategiKonfigurasiSel
        self.pengiraSusunAtur = pengiraSusunAtur
        self.pengurusPaparanKoleksi = pengurusPaparanKoleksi
        super.init()
        
        sediakanPaparanKoleksi()
    }
    
    private func sediakanPaparanKoleksi() {
        guard let paparanKoleksi = paparanKoleksi else { return }
        paparanKoleksi.delegate = self
        paparanKoleksi.dataSource = self
        pengurusPaparanKoleksi.daftarkanSel(dalam: paparanKoleksi)
    }
    
    func konfigurasiSemulaDenganEntiti(_ entiti: [EntitiJubenMistik], dimensi: Int) {
        sumberData.entitiKad = entiti
        sumberData.dimensialitiGrid = dimensi
        pengurusPaparanKoleksi.muatSemulaData(dalam: paparanKoleksi)
    }
    
    func segarkanPersembahan() {
        pengurusPaparanKoleksi.muatSemulaData(dalam: paparanKoleksi)
    }
}

// MARK: - Pelaksanaan UICollectionViewDataSource

extension OrkestatorGridMahjong: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sumberData.bilanganItem()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sel = collectionView.dequeueReusableCell(withReuseIdentifier: "ArketipSelMahjong", for: indexPath) as! ArketipSelMahjong
        
        if let entiti = sumberData.entitiKad(pada: indexPath.item) {
            strategiKonfigurasiSel.konfigurasi(sel: sel, dengan: entiti)
        }
        
        return sel
    }
}

// MARK: - Pelaksanaan UICollectionViewDelegate

extension OrkestatorGridMahjong: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegat?.gridTelahPilihKad(pada: indexPath.item, adalahGridAtas: adalahGridAtas)
    }
}

// MARK: - Pelaksanaan UICollectionViewDelegateFlowLayout

extension OrkestatorGridMahjong: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return pengiraSusunAtur.kiraSaizSel(untuk: collectionView, dimensi: sumberData.dimensialitiGrid)
    }
}

// MARK: - Sel Paparan Koleksi

class ArketipSelMahjong: UICollectionViewCell {
    
    private let bekasView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = false
        return view
    }()
    
    private let viewGambar: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
    
    private let lapisanSempadanGradien: CAGradientLayer = {
        let lapisan = CAGradientLayer()
        lapisan.colors = [
            KonfigurasiRahsia.PaletWarna.warnaNeoCyan.cgColor,
            KonfigurasiRahsia.PaletWarna.warnaNeoPurple.cgColor,
            KonfigurasiRahsia.PaletWarna.warnaNeoPink.cgColor
        ]
        lapisan.startPoint = CGPoint(x: 0, y: 0)
        lapisan.endPoint = CGPoint(x: 1, y: 1)
        lapisan.cornerRadius = 10
        return lapisan
    }()
    
    private let viewSempadan: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let lapisanSempadanDalam: CALayer = {
        let lapisan = CALayer()
        lapisan.borderWidth = 2
        lapisan.cornerRadius = 8
        return lapisan
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sediakanSel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) belum dilaksanakan")
    }
    
    private func sediakanSel() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(viewSempadan)
        contentView.addSubview(bekasView)
        bekasView.addSubview(viewGambar)
        
        viewSempadan.layer.insertSublayer(lapisanSempadanGradien, at: 0)
        viewGambar.layer.addSublayer(lapisanSempadanDalam)
        
        NSLayoutConstraint.activate([
            viewSempadan.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewSempadan.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewSempadan.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewSempadan.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            bekasView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            bekasView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            bekasView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            bekasView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            viewGambar.topAnchor.constraint(equalTo: bekasView.topAnchor, constant: 2),
            viewGambar.leadingAnchor.constraint(equalTo: bekasView.leadingAnchor, constant: 2),
            viewGambar.trailingAnchor.constraint(equalTo: bekasView.trailingAnchor, constant: -2),
            viewGambar.bottomAnchor.constraint(equalTo: bekasView.bottomAnchor, constant: -2)
        ])
        
        kemaskiniGayaSempadan(sedangDibuka: false, telahDihapuskan: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        kemaskiniFramLapisan()
    }
    
    private func kemaskiniFramLapisan() {
        lapisanSempadanGradien.frame = viewSempadan.bounds
        lapisanSempadanDalam.frame = viewGambar.bounds
        
        let lebarSempadan: CGFloat = 3
        let lapisanTopeng = CAShapeLayer()
        let laluan = UIBezierPath(roundedRect: viewSempadan.bounds, cornerRadius: 10)
        let laluanDalam = UIBezierPath(roundedRect: viewSempadan.bounds.insetBy(dx: lebarSempadan, dy: lebarSempadan), cornerRadius: 8)
        laluan.append(laluanDalam.reversing())
        lapisanTopeng.path = laluan.cgPath
        lapisanTopeng.fillRule = .evenOdd
        lapisanSempadanGradien.mask = lapisanTopeng
    }
    
    private func kemaskiniGayaSempadan(sedangDibuka: Bool, telahDihapuskan: Bool) {
        if telahDihapuskan {
            tetapkanGayaDihapuskan()
        } else if sedangDibuka {
            tetapkanGayaDibuka()
        } else {
            tetapkanGayaTersembunyi()
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.kemaskiniFramLapisan()
        }
    }
    
    private func tetapkanGayaDihapuskan() {
        lapisanSempadanGradien.opacity = 0.2
        viewSempadan.alpha = 0.2
        lapisanSempadanDalam.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        lapisanSempadanDalam.borderWidth = 1
        bekasView.layer.shadowOpacity = 0
        viewSempadan.layer.shadowOpacity = 0
    }
    
    private func tetapkanGayaDibuka() {
        lapisanSempadanGradien.opacity = 1.0
        viewSempadan.alpha = 1.0
        
        lapisanSempadanDalam.borderColor = KonfigurasiRahsia.PaletWarna.warnaNeoCyan.cgColor
        lapisanSempadanDalam.borderWidth = 2
        
        viewSempadan.layer.shadowColor = KonfigurasiRahsia.PaletWarna.warnaNeoCyan.cgColor
        viewSempadan.layer.shadowRadius = 8
        viewSempadan.layer.shadowOpacity = 0.8
        viewSempadan.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        bekasView.layer.shadowColor = KonfigurasiRahsia.PaletWarna.warnaNeoPurple.cgColor
        bekasView.layer.shadowRadius = 4
        bekasView.layer.shadowOpacity = 0.6
        bekasView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        tambahAnimasiDenyutan()
    }
    
    private func tetapkanGayaTersembunyi() {
        lapisanSempadanGradien.opacity = 0.6
        viewSempadan.alpha = 0.6
        lapisanSempadanDalam.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        lapisanSempadanDalam.borderWidth = 1
        viewSempadan.layer.shadowColor = UIColor.white.cgColor
        viewSempadan.layer.shadowRadius = 4
        viewSempadan.layer.shadowOpacity = 0.4
        viewSempadan.layer.shadowOffset = CGSize(width: 0, height: 0)
        bekasView.layer.shadowOpacity = 0
        
        buangAnimasiDenyutan()
    }
    
    private func tambahAnimasiDenyutan() {
        buangAnimasiDenyutan()
        
        let animasiDenyut = CABasicAnimation(keyPath: "shadowOpacity")
        animasiDenyut.fromValue = 0.6
        animasiDenyut.toValue = 1.0
        animasiDenyut.duration = 1.0
        animasiDenyut.autoreverses = true
        animasiDenyut.repeatCount = .greatestFiniteMagnitude
        animasiDenyut.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        viewSempadan.layer.add(animasiDenyut, forKey: "cahayaBerdenyut")
        
        let animasiSempadan = CABasicAnimation(keyPath: "colors")
        animasiSempadan.fromValue = [
            KonfigurasiRahsia.PaletWarna.warnaNeoCyan.cgColor,
            KonfigurasiRahsia.PaletWarna.warnaNeoPurple.cgColor,
            KonfigurasiRahsia.PaletWarna.warnaNeoPink.cgColor
        ]
        animasiSempadan.toValue = [
            KonfigurasiRahsia.PaletWarna.warnaNeoPink.cgColor,
            KonfigurasiRahsia.PaletWarna.warnaNeoCyan.cgColor,
            KonfigurasiRahsia.PaletWarna.warnaNeoPurple.cgColor
        ]
        animasiSempadan.duration = 2.0
        animasiSempadan.autoreverses = true
        animasiSempadan.repeatCount = .greatestFiniteMagnitude
        animasiSempadan.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        lapisanSempadanGradien.add(animasiSempadan, forKey: "denyutanWarnaSempadan")
    }
    
    private func buangAnimasiDenyutan() {
        bekasView.layer.removeAnimation(forKey: "cahayaBerdenyut")
        lapisanSempadanGradien.removeAnimation(forKey: "denyutanWarnaSempadan")
    }
    
    func konfigurasiDenganKad(_ kad: EntitiJubenMistik) {
        if kad.telahDihapuskan {
            viewGambar.alpha = 0.2
            viewGambar.image = nil
            kemaskiniGayaSempadan(sedangDibuka: false, telahDihapuskan: true)
        } else if kad.sedangDibuka {
            viewGambar.alpha = 1.0
            viewGambar.image = UIImage(named: kad.jenisKad.namaGambar)
            kemaskiniGayaSempadan(sedangDibuka: true, telahDihapuskan: false)
        } else {
            viewGambar.alpha = 1.0
            viewGambar.image = UIImage(named: "beimian")
            kemaskiniGayaSempadan(sedangDibuka: false, telahDihapuskan: false)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.kemaskiniFramLapisan()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buangAnimasiDenyutan()
        viewGambar.image = nil
        viewGambar.alpha = 1.0
    }
}
