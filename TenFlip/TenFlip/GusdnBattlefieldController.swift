

import UIKit

class PengawalMedanPerangUtama: UIViewController {
    
    private var modelPaparan: ModelPaparanPermainanEteria
    private var orkestatorGridAtas: OrkestatorGridMahjong!
    private var orkestatorGridBawah: OrkestatorGridMahjong!
    private let penyediaSumber = PelaksanaanPenyediaSumberPiawai()
    
    private lazy var lapisanLatar: UIImageView = {
        let iv = UIImageView()
        iv.image = penyediaSumber.dapatkanTeksturLatarBelakang()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var lapisanKelam: UIView = {
        let v = UIView()
        v.backgroundColor = KonfigurasiRahsia.PaletWarna.warnaLapisanCoklat
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var butangUndur: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("← Back", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 20
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(mulakanUndur), for: .touchUpInside)
        return btn
    }()
    
    private lazy var panerAras: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.shadowColor = UIColor.black.withAlphaComponent(0.5)
        lbl.shadowOffset = CGSize(width: 1, height: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var kronometer: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.shadowColor = UIColor.black.withAlphaComponent(0.5)
        lbl.shadowOffset = CGSize(width: 1, height: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var koleksiAtas: UICollectionView = {
        let susunAtur = UICollectionViewFlowLayout()
        susunAtur.minimumInteritemSpacing = KonfigurasiRahsia.MetrikSusunAtur.jarakGrid
        susunAtur.minimumLineSpacing = KonfigurasiRahsia.MetrikSusunAtur.jarakGrid
        let cv = UICollectionView(frame: .zero, collectionViewLayout: susunAtur)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var koleksiBawah: UICollectionView = {
        let susunAtur = UICollectionViewFlowLayout()
        susunAtur.minimumInteritemSpacing = KonfigurasiRahsia.MetrikSusunAtur.jarakGrid
        susunAtur.minimumLineSpacing = KonfigurasiRahsia.MetrikSusunAtur.jarakGrid
        let cv = UICollectionView(frame: .zero, collectionViewLayout: susunAtur)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var garisPemisah: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    init(kesukaran: ArasKesukaran) {
        self.modelPaparan = ModelPaparanPermainanEteria(kesukaran: kesukaran)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) belum dilaksanakan")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rakaikanAntaraMuka()
        tubuhkanOrkestator()
        modelPaparan.pemerhatiKeadaan = self
        modelPaparan.mulaCabaranBaru()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        modelPaparan.hentikanEnginTemporal()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func rakaikanAntaraMuka() {
        view.addSubview(lapisanLatar)
        view.addSubview(lapisanKelam)
        view.addSubview(butangUndur)
        view.addSubview(panerAras)
        view.addSubview(kronometer)
        view.addSubview(koleksiAtas)
        view.addSubview(garisPemisah)
        view.addSubview(koleksiBawah)
        
        let lebarPaparan = view.bounds.width
        let tinggiPaparan = view.bounds.height
        let ruangAtas: CGFloat = 90
        let ruangPemisah: CGFloat = 8
        let ruangBawah: CGFloat = 30
        let tinggiTersedia = tinggiPaparan - ruangAtas - ruangPemisah - ruangBawah
        let tinggiGridTunggal = tinggiTersedia / 2 - 20
        let lebarTersedia = lebarPaparan - 32
        let saizGrid = min(lebarTersedia, tinggiGridTunggal)
        
        NSLayoutConstraint.activate([
            lapisanLatar.topAnchor.constraint(equalTo: view.topAnchor),
            lapisanLatar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lapisanLatar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lapisanLatar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            lapisanKelam.topAnchor.constraint(equalTo: view.topAnchor),
            lapisanKelam.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lapisanKelam.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lapisanKelam.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            butangUndur.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            butangUndur.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            panerAras.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            panerAras.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            panerAras.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            kronometer.topAnchor.constraint(equalTo: panerAras.bottomAnchor, constant: 4),
            kronometer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            kronometer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            koleksiAtas.topAnchor.constraint(equalTo: kronometer.bottomAnchor, constant: 8),
            koleksiAtas.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            koleksiAtas.widthAnchor.constraint(equalToConstant: saizGrid),
            koleksiAtas.heightAnchor.constraint(equalToConstant: saizGrid),
            
            garisPemisah.topAnchor.constraint(equalTo: koleksiAtas.bottomAnchor, constant: 4),
            garisPemisah.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            garisPemisah.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            garisPemisah.heightAnchor.constraint(equalToConstant: 2),
            
            koleksiBawah.topAnchor.constraint(equalTo: garisPemisah.bottomAnchor, constant: 4),
            koleksiBawah.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            koleksiBawah.widthAnchor.constraint(equalToConstant: saizGrid),
            koleksiBawah.heightAnchor.constraint(equalToConstant: saizGrid)
        ])
    }
    
    private func tubuhkanOrkestator() {
        orkestatorGridAtas = OrkestatorGridMahjong(
            paparanKoleksi: koleksiAtas,
            pengecam: "atas",
            adalahGridAtas: true,
            penyediaSumber: penyediaSumber
        )
        orkestatorGridAtas.delegat = self
        
        orkestatorGridBawah = OrkestatorGridMahjong(
            paparanKoleksi: koleksiBawah,
            pengecam: "bawah",
            adalahGridAtas: false,
            penyediaSumber: penyediaSumber
        )
        orkestatorGridBawah.delegat = self
    }
    
    private func sinkronkanAntaraMuka() {
        panerAras.text = "Level \(modelPaparan.arasSemasa)"
        kronometer.text = "Time: \(modelPaparan.masaBaki)s"
        
        orkestatorGridAtas.konfigurasiSemulaDenganEntiti(
            modelPaparan.entitiGridAtas,
            dimensi: modelPaparan.kesukaranSemasa.dimensiGrid
        )
        
        orkestatorGridBawah.konfigurasiSemulaDenganEntiti(
            modelPaparan.entitiGridBawah,
            dimensi: modelPaparan.kesukaranSemasa.dimensiGrid
        )
    }
    
    @objc private func mulakanUndur() {
        modelPaparan.hentikanEnginTemporal()
        
        let portal = PortalDialogBercahaya()
        let tindakanSenarai = [
            TindakanDialog(tajuk: "Yes", gaya: .musnah) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            TindakanDialog(tajuk: "No", gaya: .sekunder, pengendali: nil)
        ]
        portal.tampilkanDenganKonfigurasi(
            tajuk: "Quit Game",
            mesej: "Are you sure you want to quit the game?",
            tindakan: tindakanSenarai
        )
    }
    
    private func persembahkanDialogKemenangan() {
        let portal = PortalDialogBercahaya()
        let tindakanSenarai = [
            TindakanDialog(tajuk: "Next Level", gaya: .primer) { [weak self] in
                self?.modelPaparan.majuKeArasBerikutnya()
            },
            TindakanDialog(tajuk: "Quit", gaya: .sekunder) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        ]
        portal.tampilkanDenganKonfigurasi(
            tajuk: "Level Complete!",
            mesej: "Congratulations! You've cleared Level \(modelPaparan.arasSemasa)!",
            tindakan: tindakanSenarai
        )
    }
    
    private func persembahkanDialogKekalahan() {
        modelPaparan.peliharaPencapaian()
        
        let portal = PortalDialogBercahaya()
        let tindakanSenarai = [
            TindakanDialog(tajuk: "Try Again", gaya: .primer) { [weak self] in
                self?.modelPaparan.setSemulaKeKeadaanAwal()
            },
            TindakanDialog(tajuk: "Quit", gaya: .sekunder) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        ]
        
        let mesej = modelPaparan.arasSemasa > 1 ?
            "You reached Level \(modelPaparan.arasSemasa)!\nYour score has been saved." :
            "Time's up! Try again to reach higher levels."
        
        portal.tampilkanDenganKonfigurasi(
            tajuk: "Game Over",
            mesej: mesej,
            tindakan: tindakanSenarai
        )
    }
}

extension PengawalMedanPerangUtama: PemerhatiKeadaanPermainanEteria {
    
    func sejarahTelahMaju(ke aras: Int) {
        sinkronkanAntaraMuka()
    }
    
    func fluksMasaDikemaskini(baki: Int) {
        kronometer.text = "Time: \(baki)s"
        
        if baki <= 10 {
            kronometer.textColor = .red
        } else {
            kronometer.textColor = .white
        }
    }
    
    func pemilihanKadBerubah() {
        orkestatorGridAtas.segarkanPersembahan()
        orkestatorGridBawah.segarkanPersembahan()
    }
    
    func kemenangandiperoleh() {
        persembahkanDialogKemenangan()
    }
    
    func kegagalanKatastrofik() {
        persembahkanDialogKekalahan()
    }
    
    func pasanganTelahDihapuskan() {
        kronometer.textColor = KonfigurasiRahsia.PaletWarna.warnaHijauKejayaan
        
        orkestatorGridAtas.segarkanPersembahan()
        orkestatorGridBawah.segarkanPersembahan()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + KonfigurasiRahsia.TempoAnimasi.denyutanWarna) { [weak self] in
            guard let ini = self else { return }
            if ini.modelPaparan.masaBaki > 10 {
                ini.kronometer.textColor = .white
            }
        }
    }
}

extension PengawalMedanPerangUtama: DelegatGridMahjong {
    
    func gridTelahPilihKad(pada indeks: Int, adalahGridAtas: Bool) {
        _ = modelPaparan.cubakanPemilihanKad(pada: indeks, dariAtas: adalahGridAtas)
    }
}
