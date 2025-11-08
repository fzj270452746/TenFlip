//
//  LuminousDialogPortal.swift
//  TenFlip
//
//  Dialog Peringatan Tersuai dengan Tema Mahjong
//

import UIKit

class PortalDialogBercahaya: UIView {
    
    private let bekasBekas: UIView = {
        let view = UIView()
        view.backgroundColor = KonfigurasiRahsia.PaletWarna.warnaLatarKaca
        view.layer.cornerRadius = KonfigurasiRahsia.MetrikSusunAtur.jejariSudutKaca
        view.layer.borderWidth = 2
        view.layer.borderColor = KonfigurasiRahsia.PaletWarna.warnaSempadanKaca.cgColor
        view.layer.shadowColor = KonfigurasiRahsia.PaletWarna.warnaNeoPurple.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = KonfigurasiRahsia.MetrikSusunAtur.kelegumanCahayaNeon
        view.layer.shadowRadius = KonfigurasiRahsia.MetrikSusunAtur.jejariCahayaNeon
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paparanKesanKabur: UIVisualEffectView = {
        let kesanKabur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let paparanKabur = UIVisualEffectView(effect: kesanKabur)
        paparanKabur.layer.cornerRadius = KonfigurasiRahsia.MetrikSusunAtur.jejariSudutKaca
        paparanKabur.clipsToBounds = true
        paparanKabur.translatesAutoresizingMaskIntoConstraints = false
        return paparanKabur
    }()
    
    private let paparanSkrol: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let labelTajuk: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .black)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        
        // Kesan cahaya neon
        label.layer.shadowColor = KonfigurasiRahsia.PaletWarna.warnaNeoCyan.cgColor
        label.layer.shadowRadius = 10
        label.layer.shadowOpacity = 0.8
        label.layer.shadowOffset = .zero
        label.layer.masksToBounds = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelMesej: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timbunanButang: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var tindakanTersimpan: [TindakanDialog] = []
    
    init() {
        super.init(frame: .zero)
        konfigurasiAntaraMuka()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) belum dilaksanakan")
    }
    
    private func konfigurasiAntaraMuka() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        addSubview(bekasBekas)
        bekasBekas.addSubview(paparanKesanKabur)
        bekasBekas.addSubview(labelTajuk)
        bekasBekas.addSubview(paparanSkrol)
        paparanSkrol.addSubview(labelMesej)
        bekasBekas.addSubview(timbunanButang)
        
        // Cipta kekangan dengan keutamaan yang sesuai
        let kekanganTinggiBekas = bekasBekas.heightAnchor.constraint(lessThanOrEqualToConstant: 550)
        kekanganTinggiBekas.priority = .defaultHigh
        
        let kekanganTinggiSkrol = paparanSkrol.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        kekanganTinggiSkrol.priority = .required
        
        NSLayoutConstraint.activate([
            bekasBekas.centerXAnchor.constraint(equalTo: centerXAnchor),
            bekasBekas.centerYAnchor.constraint(equalTo: centerYAnchor),
            bekasBekas.widthAnchor.constraint(equalToConstant: 320),
            bekasBekas.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            bekasBekas.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            bekasBekas.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            bekasBekas.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            kekanganTinggiBekas,
            
            paparanKesanKabur.topAnchor.constraint(equalTo: bekasBekas.topAnchor),
            paparanKesanKabur.leadingAnchor.constraint(equalTo: bekasBekas.leadingAnchor),
            paparanKesanKabur.trailingAnchor.constraint(equalTo: bekasBekas.trailingAnchor),
            paparanKesanKabur.bottomAnchor.constraint(equalTo: bekasBekas.bottomAnchor),
            
            labelTajuk.topAnchor.constraint(equalTo: bekasBekas.topAnchor, constant: 28),
            labelTajuk.leadingAnchor.constraint(equalTo: bekasBekas.leadingAnchor, constant: 24),
            labelTajuk.trailingAnchor.constraint(equalTo: bekasBekas.trailingAnchor, constant: -24),
            
            paparanSkrol.topAnchor.constraint(equalTo: labelTajuk.bottomAnchor, constant: 16),
            paparanSkrol.leadingAnchor.constraint(equalTo: bekasBekas.leadingAnchor, constant: 20),
            paparanSkrol.trailingAnchor.constraint(equalTo: bekasBekas.trailingAnchor, constant: -20),
            paparanSkrol.bottomAnchor.constraint(equalTo: timbunanButang.topAnchor, constant: -16),
            kekanganTinggiSkrol,
            
            labelMesej.topAnchor.constraint(equalTo: paparanSkrol.topAnchor),
            labelMesej.leadingAnchor.constraint(equalTo: paparanSkrol.leadingAnchor),
            labelMesej.trailingAnchor.constraint(equalTo: paparanSkrol.trailingAnchor),
            labelMesej.bottomAnchor.constraint(equalTo: paparanSkrol.bottomAnchor),
            labelMesej.widthAnchor.constraint(equalTo: paparanSkrol.widthAnchor),
            
            timbunanButang.leadingAnchor.constraint(equalTo: bekasBekas.leadingAnchor, constant: 20),
            timbunanButang.trailingAnchor.constraint(equalTo: bekasBekas.trailingAnchor, constant: -20),
            timbunanButang.bottomAnchor.constraint(equalTo: bekasBekas.bottomAnchor, constant: -20),
            timbunanButang.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func tampilkanDenganKonfigurasi(
        tajuk: String,
        mesej: String,
        tindakan: [TindakanDialog]
    ) {
        tindakanTersimpan = tindakan
        labelTajuk.text = tajuk
        labelMesej.text = mesej
        
        timbunanButang.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (indeks, tindakan) in tindakan.enumerated() {
            let butang = ciptaButangBergaya(untuk: tindakan)
            butang.tag = indeks
            timbunanButang.addArrangedSubview(butang)
        }
        
        guard let tetingkap = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        self.frame = tetingkap.bounds
        self.alpha = 0
        tetingkap.addSubview(self)
        
        bekasBekas.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        bekasBekas.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.alpha = 1
            self.bekasBekas.transform = .identity
            self.bekasBekas.alpha = 1
        }
        
        // Kemaskini kerangka kesan kabur dan lapisan gradien butang
        DispatchQueue.main.async {
            self.paparanKesanKabur.frame = self.bekasBekas.bounds
            self.kemaskiniLapisanGradienButang()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        paparanKesanKabur.frame = bekasBekas.bounds
        kemaskiniLapisanGradienButang()
    }
    
    private func kemaskiniLapisanGradienButang() {
        for butang in timbunanButang.arrangedSubviews {
            if let btn = butang as? UIButton {
                if let lapisanGradien = btn.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
                    lapisanGradien.frame = btn.bounds
                }
            }
        }
    }
    
    private func ciptaButangBergaya(untuk tindakan: TindakanDialog) -> UIButton {
        let butang = UIButton(type: .system)
        butang.setTitle(tindakan.tajuk, for: .normal)
        butang.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        butang.layer.cornerRadius = 14
        butang.translatesAutoresizingMaskIntoConstraints = false
        
        // Cipta lapisan gradien
        let lapisanGradien = CAGradientLayer()
        
        switch tindakan.gaya {
        case .primer:
            lapisanGradien.colors = [
                KonfigurasiRahsia.PaletWarna.warnaButangMulaGradienAwal.cgColor,
                KonfigurasiRahsia.PaletWarna.warnaButangMulaGradienAkhir.cgColor
            ]
            butang.setTitleColor(.white, for: .normal)
            butang.layer.shadowColor = KonfigurasiRahsia.PaletWarna.warnaNeoPink.cgColor
        case .sekunder:
            lapisanGradien.colors = [
                UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.8).cgColor,
                UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8).cgColor
            ]
            butang.setTitleColor(.white, for: .normal)
            butang.layer.shadowColor = UIColor.gray.cgColor
        case .musnah:
            lapisanGradien.colors = [
                UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0).cgColor,
                UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0).cgColor
            ]
            butang.setTitleColor(.white, for: .normal)
            butang.layer.shadowColor = UIColor.red.cgColor
        }
        
        lapisanGradien.startPoint = CGPoint(x: 0, y: 0)
        lapisanGradien.endPoint = CGPoint(x: 1, y: 1)
        lapisanGradien.cornerRadius = 14
        butang.layer.insertSublayer(lapisanGradien, at: 0)
        
        // Kesan cahaya neon
        butang.layer.shadowRadius = 10
        butang.layer.shadowOpacity = 0.6
        butang.layer.shadowOffset = CGSize(width: 0, height: 0)
        butang.layer.masksToBounds = false
        
        // Kemaskini kerangka gradien
        DispatchQueue.main.async {
            lapisanGradien.frame = butang.bounds
        }
        
        butang.addTarget(self, action: #selector(butangTindakanDiketuk(_:)), for: .touchUpInside)
        
        // Animasi tekan butang
        butang.addTarget(self, action: #selector(butangDialogDitekan(_:)), for: .touchDown)
        butang.addTarget(self, action: #selector(butangDialogDilepas(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return butang
    }
    
    @objc private func butangDialogDitekan(_ penghantar: UIButton) {
        UIView.animate(withDuration: 0.1) {
            penghantar.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func butangDialogDilepas(_ penghantar: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            penghantar.transform = .identity
        }
    }
    
    @objc private func butangTindakanDiketuk(_ penghantar: UIButton) {
        let indeks = penghantar.tag
        guard indeks < tindakanTersimpan.count else { return }
        
        let tindakan = tindakanTersimpan[indeks]
        tutupDenganAnimasi {
            tindakan.pengendali?()
        }
    }
    
    func tutupDenganAnimasi(selesai: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.bekasBekas.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            self.removeFromSuperview()
            selesai?()
        }
    }
}

// MARK: - Tindakan Dialog

struct TindakanDialog {
    enum GayaTindakan {
        case primer
        case sekunder
        case musnah
    }
    
    let tajuk: String
    let gaya: GayaTindakan
    let pengendali: (() -> Void)?
    
    init(tajuk: String, gaya: GayaTindakan = .primer, pengendali: (() -> Void)? = nil) {
        self.tajuk = tajuk
        self.gaya = gaya
        self.pengendali = pengendali
    }
}
