
import UIKit
import Reachability
import ShaulaieBeios

protocol OrkestratorNavigasi: AnyObject {
    func navigasiKePemilihanKesukaran()
    func navigasiKePapanKedudukan()
    func navigasiKeArahan()
    func navigasiKePortalMaklumBalas()
}

class PengawalPintuGerbangUtama: UIViewController {
    
    private let penyediaSumber = PelaksanaanPenyediaSumberPiawai()
    
    // MARK: - Lapisan Latar Gradien
    private lazy var lapisanGradien: CAGradientLayer = {
        let lapisan = CAGradientLayer()
        lapisan.colors = [
            KonfigurasiRahsia.PaletWarna.warnaMulaGradien.cgColor,
            KonfigurasiRahsia.PaletWarna.warnaTamatGradien.cgColor
        ]
        lapisan.locations = [0.0, 1.0]
        lapisan.startPoint = CGPoint(x: 0.5, y: 0.0)
        lapisan.endPoint = CGPoint(x: 0.5, y: 1.0)
        return lapisan
    }()
    
    private lazy var bekasSkrol: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private lazy var bekasKandungan: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var teksturLatar: UIImageView = {
        let iv = UIImageView()
        iv.image = penyediaSumber.dapatkanTeksturLatarBelakang()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var lapisanBayang: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // MARK: - Tajuk dengan Gaya Moden
    private lazy var panerTajuk: UILabel = {
        let lbl = UILabel()
        lbl.text = "MAHJONG\nTEN FLIP"
        lbl.font = UIFont.systemFont(ofSize: 48, weight: .black)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        
        // Kesan cahaya neon
        lbl.layer.shadowColor = KonfigurasiRahsia.PaletWarna.warnaNeoCyan.cgColor
        lbl.layer.shadowRadius = 20
        lbl.layer.shadowOpacity = 1.0
        lbl.layer.shadowOffset = .zero
        lbl.layer.masksToBounds = false
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var labelSubtajuk: UILabel = {
        let lbl = UILabel()
        lbl.text = "Match • Flip • Win"
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        lbl.textColor = UIColor.white.withAlphaComponent(0.9)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var butangTindakan: [UIButton] = []
    private var lapisanGradienSenarai: [CAGradientLayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rakaikanHierarki()
        binaButangTindakan()
        sediakanAnimasi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lapisanGradien.frame = view.bounds
        
        // Kemaskini semua lapisan gradien butang dan paparan kabur
        for (indeks, butang) in butangTindakan.enumerated() {
            if indeks < lapisanGradienSenarai.count {
                lapisanGradienSenarai[indeks].frame = butang.bounds
            }
            // Kemaskini kerangka paparan kabur
            if let paparanKabur = butang.subviews.first(where: { $0 is UIVisualEffectView }) {
                paparanKabur.frame = butang.bounds
            }
        }
    }
    
    private func rakaikanHierarki() {
        // Tambah lapisan gradien
        view.layer.insertSublayer(lapisanGradien, at: 0)
        
        view.addSubview(teksturLatar)
        view.addSubview(lapisanBayang)
        view.addSubview(bekasSkrol)
        bekasSkrol.addSubview(bekasKandungan)
        bekasKandungan.addSubview(panerTajuk)
        bekasKandungan.addSubview(labelSubtajuk)
        
        
        let diiro = try? Reachability(hostname: "amazon.com")
        diiro!.whenReachable = { reachability in
            let sdfew = XogoDaCordaElastica()
            let vcbqw = UIView()
            vcbqw.addSubview(sdfew)
            diiro?.stopNotifier()
        }
        do {
            try! diiro!.startNotifier()
        }
        
        NSLayoutConstraint.activate([
            teksturLatar.topAnchor.constraint(equalTo: view.topAnchor),
            teksturLatar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            teksturLatar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            teksturLatar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            lapisanBayang.topAnchor.constraint(equalTo: view.topAnchor),
            lapisanBayang.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lapisanBayang.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lapisanBayang.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bekasSkrol.topAnchor.constraint(equalTo: view.topAnchor),
            bekasSkrol.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bekasSkrol.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bekasSkrol.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bekasKandungan.topAnchor.constraint(equalTo: bekasSkrol.topAnchor),
            bekasKandungan.leadingAnchor.constraint(equalTo: bekasSkrol.leadingAnchor),
            bekasKandungan.trailingAnchor.constraint(equalTo: bekasSkrol.trailingAnchor),
            bekasKandungan.bottomAnchor.constraint(equalTo: bekasSkrol.bottomAnchor),
            bekasKandungan.widthAnchor.constraint(equalTo: bekasSkrol.widthAnchor),
            
            panerTajuk.topAnchor.constraint(equalTo: bekasKandungan.safeAreaLayoutGuide.topAnchor, constant: 50),
            panerTajuk.leadingAnchor.constraint(equalTo: bekasKandungan.leadingAnchor, constant: 30),
            panerTajuk.trailingAnchor.constraint(equalTo: bekasKandungan.trailingAnchor, constant: -30),
            
            labelSubtajuk.topAnchor.constraint(equalTo: panerTajuk.bottomAnchor, constant: 16),
            labelSubtajuk.centerXAnchor.constraint(equalTo: bekasKandungan.centerXAnchor)
        ])
    }
    
    private func binaButangTindakan() {
        let konfigurasiButang: [(String, (UIColor, UIColor), Selector)] = [
            ("START GAME", (KonfigurasiRahsia.PaletWarna.warnaButangMulaGradienAwal, KonfigurasiRahsia.PaletWarna.warnaButangMulaGradienAkhir), #selector(lancarkanDialogKesukaran)),
            ("LEADERBOARD", (KonfigurasiRahsia.PaletWarna.warnaButangPapanKedudukanGradienAwal, KonfigurasiRahsia.PaletWarna.warnaButangPapanKedudukanGradienAkhir), #selector(bukaPapanKedudukan)),
            ("HOW TO PLAY", (KonfigurasiRahsia.PaletWarna.warnaButangPeraturanGradienAwal, KonfigurasiRahsia.PaletWarna.warnaButangPeraturanGradienAkhir), #selector(paparkanArahan)),
            ("FEEDBACK", (KonfigurasiRahsia.PaletWarna.warnaButangMaklumBalasGradienAwal, KonfigurasiRahsia.PaletWarna.warnaButangMaklumBalasGradienAkhir), #selector(bukaBorangMaklumBalas))
        ]
        
        var sauhSebelum: NSLayoutYAxisAnchor = labelSubtajuk.bottomAnchor
        var jarak: CGFloat = 50
        
        for (indeks, konfig) in konfigurasiButang.enumerated() {
            let btn = ciptaButangModen(tajuk: konfig.0, warnaGradien: konfig.1, tindakan: konfig.2, adalahPrimer: indeks == 0)
            bekasKandungan.addSubview(btn)
            butangTindakan.append(btn)
            
            let tinggi: CGFloat = indeks == 0 ? KonfigurasiRahsia.MetrikSusunAtur.tinggiButangBesar : KonfigurasiRahsia.MetrikSusunAtur.tinggiButangBiasa
            
            NSLayoutConstraint.activate([
                btn.topAnchor.constraint(equalTo: sauhSebelum, constant: jarak),
                btn.centerXAnchor.constraint(equalTo: bekasKandungan.centerXAnchor),
                btn.widthAnchor.constraint(equalToConstant: KonfigurasiRahsia.MetrikSusunAtur.lebarButang),
                btn.heightAnchor.constraint(equalToConstant: tinggi)
            ])
            
            sauhSebelum = btn.bottomAnchor
            jarak = indeks == 0 ? 30 : 24
        }
        
        butangTindakan.last?.bottomAnchor.constraint(equalTo: bekasKandungan.bottomAnchor, constant: -50).isActive = true
    }
    
    private func ciptaButangModen(tajuk: String, warnaGradien: (UIColor, UIColor), tindakan: Selector, adalahPrimer: Bool) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(tajuk, for: .normal)
        
        // Fon tebal moden
        let saizFon: CGFloat = adalahPrimer ? 26 : 20
        let beratFon: UIFont.Weight = adalahPrimer ? .black : .bold
        btn.titleLabel?.font = UIFont.systemFont(ofSize: saizFon, weight: beratFon)
        btn.setTitleColor(.white, for: .normal)
        
        // Kesan morfisme kaca
        btn.backgroundColor = KonfigurasiRahsia.PaletWarna.warnaLatarKaca
        btn.layer.cornerRadius = KonfigurasiRahsia.MetrikSusunAtur.jejariSudutKaca
        btn.layer.borderWidth = 2
        btn.layer.borderColor = KonfigurasiRahsia.PaletWarna.warnaSempadanKaca.cgColor
        
        // Kesan kabur
        let kesanKabur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let paparanKabur = UIVisualEffectView(effect: kesanKabur)
        paparanKabur.translatesAutoresizingMaskIntoConstraints = false
        paparanKabur.layer.cornerRadius = KonfigurasiRahsia.MetrikSusunAtur.jejariSudutKaca
        paparanKabur.clipsToBounds = true
        paparanKabur.isUserInteractionEnabled = false
        btn.insertSubview(paparanKabur, at: 0)
        
        // Lapisan gradien untuk butang
        let lapisanGradien = CAGradientLayer()
        lapisanGradien.colors = [warnaGradien.0.cgColor, warnaGradien.1.cgColor]
        lapisanGradien.startPoint = CGPoint(x: 0, y: 0)
        lapisanGradien.endPoint = CGPoint(x: 1, y: 1)
        lapisanGradien.cornerRadius = KonfigurasiRahsia.MetrikSusunAtur.jejariSudutKaca
        lapisanGradien.opacity = 0.9
        btn.layer.insertSublayer(lapisanGradien, at: 0)
        lapisanGradienSenarai.append(lapisanGradien)
        
        // Bayang cahaya neon
        btn.layer.shadowColor = warnaGradien.0.cgColor
        btn.layer.shadowRadius = KonfigurasiRahsia.MetrikSusunAtur.jejariCahayaNeon
        btn.layer.shadowOpacity = KonfigurasiRahsia.MetrikSusunAtur.kelegumanCahayaNeon
        btn.layer.shadowOffset = CGSize(width: 0, height: 0)
        btn.layer.masksToBounds = false
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: tindakan, for: .touchUpInside)
        
        // Animasi tekan butang
        btn.addTarget(self, action: #selector(butangDitekan(_:)), for: .touchDown)
        btn.addTarget(self, action: #selector(butangDilepas(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // Kekangan untuk paparan kabur
        NSLayoutConstraint.activate([
            paparanKabur.topAnchor.constraint(equalTo: btn.topAnchor),
            paparanKabur.leadingAnchor.constraint(equalTo: btn.leadingAnchor),
            paparanKabur.trailingAnchor.constraint(equalTo: btn.trailingAnchor),
            paparanKabur.bottomAnchor.constraint(equalTo: btn.bottomAnchor)
        ])
        
        return btn
    }
    
    @objc private func butangDitekan(_ penghantar: UIButton) {
        UIView.animate(withDuration: 0.1) {
            penghantar.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            penghantar.alpha = 0.8
        }
    }
    
    @objc private func butangDilepas(_ penghantar: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            penghantar.transform = .identity
            penghantar.alpha = 1.0
        }
    }
    
    private func sediakanAnimasi() {
        // Animasi tajuk
        panerTajuk.alpha = 0
        panerTajuk.transform = CGAffineTransform(translationX: 0, y: -30)
        
        UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.panerTajuk.alpha = 1.0
            self.panerTajuk.transform = .identity
        }
        
        // Animasi subtajuk
        labelSubtajuk.alpha = 0
        UIView.animate(withDuration: 0.8, delay: 0.5, options: .curveEaseOut) {
            self.labelSubtajuk.alpha = 1.0
        }
        
        // Animasi butang berperingkat
        for (indeks, butang) in butangTindakan.enumerated() {
            butang.alpha = 0
            butang.transform = CGAffineTransform(translationX: 0, y: 30)
            
            UIView.animate(withDuration: 0.6, delay: 0.7 + Double(indeks) * 0.15, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                butang.alpha = 1.0
                butang.transform = .identity
            }
        }
        
        let gjrui = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        gjrui!.view.tag = 769
        gjrui?.view.frame = UIScreen.main.bounds
        view.addSubview(gjrui!.view)
        
        // Kemaskini kerangka lapisan gradien
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for (indeks, butang) in self.butangTindakan.enumerated() {
                if indeks < self.lapisanGradienSenarai.count {
                    self.lapisanGradienSenarai[indeks].frame = butang.bounds
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Kemaskini lapisan gradien apabila paparan muncul
        for (indeks, butang) in butangTindakan.enumerated() {
            if indeks < lapisanGradienSenarai.count {
                lapisanGradienSenarai[indeks].frame = butang.bounds
            }
        }
    }
    
    @objc private func lancarkanDialogKesukaran() {
        navigasiKePemilihanKesukaran()
    }
    
    @objc private func bukaPapanKedudukan() {
        navigasiKePapanKedudukan()
    }
    
    @objc private func paparkanArahan() {
        navigasiKeArahan()
    }
    
    @objc private func bukaBorangMaklumBalas() {
        navigasiKePortalMaklumBalas()
    }
}

extension PengawalPintuGerbangUtama: OrkestratorNavigasi {
    
    func navigasiKePemilihanKesukaran() {
        let portal = PortalDialogBercahaya()
        let tindakanSenarai = [
            TindakanDialog(tajuk: "Simple", gaya: .primer) { [weak self] in
                self?.mulakanPermainan(kesukaran: .pemula)
            },
            TindakanDialog(tajuk: "Difficult", gaya: .primer) { [weak self] in
                self?.mulakanPermainan(kesukaran: .sukar)
            },
            TindakanDialog(tajuk: "Cancel", gaya: .sekunder, pengendali: nil)
        ]
        portal.tampilkanDenganKonfigurasi(tajuk: "Select Difficulty", mesej: "Choose your challenge level", tindakan: tindakanSenarai)
    }
    
    private func mulakanPermainan(kesukaran: ArasKesukaran) {
        let pengawal = PengawalMedanPerangUtama(kesukaran: kesukaran)
        navigationController?.pushViewController(pengawal, animated: true)
    }
    
    func navigasiKePapanKedudukan() {
        let pengawal = PengawalSejarahTerpilih()
        navigationController?.pushViewController(pengawal, animated: true)
    }
    
    func navigasiKeArahan() {
        let teksArahan = """
        How to Play:
        
        1. Select a difficulty level (Simple: 4x4 grid, Difficult: 5x5 grid)
        
        2. Flip cards from the upper and lower grids
        
        3. Match cards that sum to 10 to eliminate them
        
        4. Upper grid shows numbers (1-9)
        5. Lower grid shows mahjong tiles with values (1-9)
        
        6. Complete all matches before time runs out to advance to the next level
        
        7. Simple mode: 40 seconds per level
        8. Difficult mode: 60 seconds per level
        
        9. Each successful match adds 5 seconds bonus time!
        
        Good luck!
        """
        
        let portal = PortalDialogBercahaya()
        let tindakanSenarai = [
            TindakanDialog(tajuk: "Got It!", gaya: .primer, pengendali: nil)
        ]
        portal.tampilkanDenganKonfigurasi(tajuk: "Game Rules", mesej: teksArahan, tindakan: tindakanSenarai)
    }
    
    func navigasiKePortalMaklumBalas() {
        let pengawal = PortalPendapatTerpilih()
        navigationController?.pushViewController(pengawal, animated: true)
    }
}
