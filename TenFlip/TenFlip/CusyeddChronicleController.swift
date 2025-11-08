

import UIKit

class SumberDataSejarah {
    private var rekodSenarai: [RekodPuncak] = []
    
    func muatRekod(untuk kesukaran: ArasKesukaran) {
        rekodSenarai = PenjagaVault.dikongsi.ambilRekodUntukKesukaran(kesukaran)
    }
    
    func bilanganRekod() -> Int {
        return rekodSenarai.isEmpty ? 1 : min(rekodSenarai.count, KonfigurasiRahsia.ParameterPermainan.hadPapanKedudukan)
    }
    
    func rekod(pada indeks: Int) -> RekodPuncak? {
        guard !rekodSenarai.isEmpty, indeks < rekodSenarai.count else { return nil }
        return rekodSenarai[indeks]
    }
    
    func adalahKosong() -> Bool {
        return rekodSenarai.isEmpty
    }
}

class PengawalSejarahTerpilih: UIViewController {
    
    private let sumberData = SumberDataSejarah()
    private let penyediaSumber = PelaksanaanPenyediaSumberPiawai()
    
    private lazy var teksturLatar: UIImageView = {
        let iv = UIImageView()
        iv.image = penyediaSumber.dapatkanTeksturLatarBelakang()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var lapisanKelam: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
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
        btn.addTarget(self, action: #selector(tutupPaparan), for: .touchUpInside)
        return btn
    }()
    
    private lazy var labelTajuk: UILabel = {
        let lbl = UILabel()
        lbl.text = "Leaderboard"
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.shadowColor = UIColor.black.withAlphaComponent(0.5)
        lbl.shadowOffset = CGSize(width: 1, height: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var pemilihKesukaran: UISegmentedControl = {
        let item = ["Simple", "Difficult"]
        let sc = UISegmentedControl(items: item)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = KonfigurasiRahsia.PaletWarna.warnaGadingNeutral.withAlphaComponent(0.9)
        sc.selectedSegmentTintColor = KonfigurasiRahsia.PaletWarna.warnaBronzPrimer
        sc.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(kesukaranBerubah), for: .valueChanged)
        return sc
    }()
    
    private lazy var jadualRekod: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(SelRekodPuncak.self, forCellReuseIdentifier: "SelRekodPuncak")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rakaikanAntaraMuka()
        segarkanData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        segarkanData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func rakaikanAntaraMuka() {
        view.addSubview(teksturLatar)
        view.addSubview(lapisanKelam)
        view.addSubview(butangUndur)
        view.addSubview(labelTajuk)
        view.addSubview(pemilihKesukaran)
        view.addSubview(jadualRekod)
        
        NSLayoutConstraint.activate([
            teksturLatar.topAnchor.constraint(equalTo: view.topAnchor),
            teksturLatar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            teksturLatar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            teksturLatar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            lapisanKelam.topAnchor.constraint(equalTo: view.topAnchor),
            lapisanKelam.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lapisanKelam.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lapisanKelam.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            butangUndur.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            butangUndur.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            labelTajuk.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelTajuk.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelTajuk.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            pemilihKesukaran.topAnchor.constraint(equalTo: labelTajuk.bottomAnchor, constant: 20),
            pemilihKesukaran.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            pemilihKesukaran.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            pemilihKesukaran.heightAnchor.constraint(equalToConstant: 40),
            
            jadualRekod.topAnchor.constraint(equalTo: pemilihKesukaran.bottomAnchor, constant: 20),
            jadualRekod.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            jadualRekod.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            jadualRekod.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func tutupPaparan() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func kesukaranBerubah() {
        segarkanData()
    }
    
    private func segarkanData() {
        let kesukaran: ArasKesukaran = pemilihKesukaran.selectedSegmentIndex == 0 ? .pemula : .sukar
        sumberData.muatRekod(untuk: kesukaran)
        jadualRekod.reloadData()
    }
}

extension PengawalSejarahTerpilih: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sumberData.bilanganRekod()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sel = tableView.dequeueReusableCell(withIdentifier: "SelRekodPuncak", for: indexPath) as! SelRekodPuncak
        
        if sumberData.adalahKosong() {
            sel.konfigurasiKeadaanKosong()
        } else if let rekod = sumberData.rekod(pada: indexPath.row) {
            sel.konfigurasiDenganRekod(rekod, kedudukan: indexPath.row + 1)
        }
        
        return sel
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Sel Papan Kedudukan

class SelRekodPuncak: UITableViewCell {
    
    private let bekasBekas: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.93, blue: 0.88, alpha: 0.9)
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 0.6, green: 0.3, blue: 0.2, alpha: 0.5).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let labelKedudukan: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(red: 0.6, green: 0.3, blue: 0.2, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelAras: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelTarikh: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        konfigurasiAntaraMuka()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) belum dilaksanakan")
    }
    
    private func konfigurasiAntaraMuka() {
        contentView.addSubview(bekasBekas)
        bekasBekas.addSubview(labelKedudukan)
        bekasBekas.addSubview(labelAras)
        bekasBekas.addSubview(labelTarikh)
        
        NSLayoutConstraint.activate([
            bekasBekas.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bekasBekas.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bekasBekas.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bekasBekas.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            labelKedudukan.leadingAnchor.constraint(equalTo: bekasBekas.leadingAnchor, constant: 16),
            labelKedudukan.centerYAnchor.constraint(equalTo: bekasBekas.centerYAnchor),
            labelKedudukan.widthAnchor.constraint(equalToConstant: 50),
            
            labelAras.leadingAnchor.constraint(equalTo: labelKedudukan.trailingAnchor, constant: 16),
            labelAras.topAnchor.constraint(equalTo: bekasBekas.topAnchor, constant: 12),
            labelAras.trailingAnchor.constraint(equalTo: bekasBekas.trailingAnchor, constant: -16),
            
            labelTarikh.leadingAnchor.constraint(equalTo: labelKedudukan.trailingAnchor, constant: 16),
            labelTarikh.topAnchor.constraint(equalTo: labelAras.bottomAnchor, constant: 4),
            labelTarikh.trailingAnchor.constraint(equalTo: bekasBekas.trailingAnchor, constant: -16)
        ])
    }
    
    func konfigurasiDenganRekod(_ rekod: RekodPuncak, kedudukan: Int) {
        labelKedudukan.text = "#\(kedudukan)"
        labelAras.text = "Level \(rekod.arasDicapai)"
        labelTarikh.text = rekod.tarikhDiformat
        
        if kedudukan == 1 {
            labelKedudukan.textColor = UIColor(red: 1.0, green: 0.7, blue: 0.0, alpha: 1.0)
        } else if kedudukan == 2 {
            labelKedudukan.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        } else if kedudukan == 3 {
            labelKedudukan.textColor = UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0)
        } else {
            labelKedudukan.textColor = UIColor(red: 0.6, green: 0.3, blue: 0.2, alpha: 1.0)
        }
    }
    
    func konfigurasiKeadaanKosong() {
        labelKedudukan.text = ""
        labelAras.text = "No records yet"
        labelTarikh.text = "Start playing to see your scores here!"
        labelAras.textAlignment = .center
        labelTarikh.textAlignment = .center
    }
}
