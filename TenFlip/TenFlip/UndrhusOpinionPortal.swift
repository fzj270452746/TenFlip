

import UIKit

protocol PengesahPendapat {
    func sahkan(_ kandungan: String) -> Bool
    func mesejPengesahan() -> String
}

class PengesahPendapatPiawai: PengesahPendapat {
    func sahkan(_ kandungan: String) -> Bool {
        return !kandungan.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func mesejPengesahan() -> String {
        return "Please enter your feedback before submitting."
    }
}

class PortalPendapatTerpilih: UIViewController {
    
    private let pengesah: PengesahPendapat = PengesahPendapatPiawai()
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
    
    private lazy var bekasSkrol: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var kawasanKandungan: UIView = {
        let v = UIView()
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
        lbl.text = "Feedback"
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.shadowColor = UIColor.black.withAlphaComponent(0.5)
        lbl.shadowOffset = CGSize(width: 1, height: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var labelPenerangan: UILabel = {
        let lbl = UILabel()
        lbl.text = "We value your feedback! Please share your thoughts, suggestions, or report any issues."
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.shadowColor = UIColor.black.withAlphaComponent(0.5)
        lbl.shadowOffset = CGSize(width: 1, height: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var medanPendapat: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tv.textColor = .black
        tv.backgroundColor = KonfigurasiRahsia.PaletWarna.warnaGadingNeutral.withAlphaComponent(0.95)
        tv.layer.cornerRadius = KonfigurasiRahsia.MetrikSusunAtur.jejariSudut
        tv.layer.borderWidth = 2
        tv.layer.borderColor = KonfigurasiRahsia.PaletWarna.warnaBatuhitamBayang.cgColor
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var teksPlaceholder: UILabel = {
        let lbl = UILabel()
        lbl.text = "Enter your feedback here..."
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = UIColor.lightGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var butangHantar: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Submit", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        btn.backgroundColor = KonfigurasiRahsia.PaletWarna.warnaBronzPrimer
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = KonfigurasiRahsia.MetrikSusunAtur.jejariSudut
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = KonfigurasiRahsia.MetrikSusunAtur.ofsetBayang
        btn.layer.shadowOpacity = KonfigurasiRahsia.MetrikSusunAtur.kelegumanBayang
        btn.layer.shadowRadius = KonfigurasiRahsia.MetrikSusunAtur.jejarieBayang
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(hantarPendapat), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rakaikanAntaraMuka()
        tubuhkanPengendalPapanKekunci()
        tubuhkanPengecamKetukan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func rakaikanAntaraMuka() {
        view.addSubview(teksturLatar)
        view.addSubview(lapisanKelam)
        view.addSubview(bekasSkrol)
        bekasSkrol.addSubview(kawasanKandungan)
        
        kawasanKandungan.addSubview(labelTajuk)
        kawasanKandungan.addSubview(labelPenerangan)
        kawasanKandungan.addSubview(medanPendapat)
        medanPendapat.addSubview(teksPlaceholder)
        kawasanKandungan.addSubview(butangHantar)
        
        view.addSubview(butangUndur)
        
        NSLayoutConstraint.activate([
            teksturLatar.topAnchor.constraint(equalTo: view.topAnchor),
            teksturLatar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            teksturLatar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            teksturLatar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            lapisanKelam.topAnchor.constraint(equalTo: view.topAnchor),
            lapisanKelam.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lapisanKelam.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lapisanKelam.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bekasSkrol.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bekasSkrol.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bekasSkrol.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bekasSkrol.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            kawasanKandungan.topAnchor.constraint(equalTo: bekasSkrol.topAnchor),
            kawasanKandungan.leadingAnchor.constraint(equalTo: bekasSkrol.leadingAnchor),
            kawasanKandungan.trailingAnchor.constraint(equalTo: bekasSkrol.trailingAnchor),
            kawasanKandungan.bottomAnchor.constraint(equalTo: bekasSkrol.bottomAnchor),
            kawasanKandungan.widthAnchor.constraint(equalTo: bekasSkrol.widthAnchor),
            
            labelTajuk.topAnchor.constraint(equalTo: kawasanKandungan.topAnchor, constant: 20),
            labelTajuk.leadingAnchor.constraint(equalTo: kawasanKandungan.leadingAnchor, constant: 20),
            labelTajuk.trailingAnchor.constraint(equalTo: kawasanKandungan.trailingAnchor, constant: -20),
            
            labelPenerangan.topAnchor.constraint(equalTo: labelTajuk.bottomAnchor, constant: 16),
            labelPenerangan.leadingAnchor.constraint(equalTo: kawasanKandungan.leadingAnchor, constant: 30),
            labelPenerangan.trailingAnchor.constraint(equalTo: kawasanKandungan.trailingAnchor, constant: -30),
            
            medanPendapat.topAnchor.constraint(equalTo: labelPenerangan.bottomAnchor, constant: 30),
            medanPendapat.leadingAnchor.constraint(equalTo: kawasanKandungan.leadingAnchor, constant: 20),
            medanPendapat.trailingAnchor.constraint(equalTo: kawasanKandungan.trailingAnchor, constant: -20),
            medanPendapat.heightAnchor.constraint(equalToConstant: 200),
            
            teksPlaceholder.topAnchor.constraint(equalTo: medanPendapat.topAnchor, constant: 12),
            teksPlaceholder.leadingAnchor.constraint(equalTo: medanPendapat.leadingAnchor, constant: 16),
            teksPlaceholder.trailingAnchor.constraint(equalTo: medanPendapat.trailingAnchor, constant: -16),
            
            butangHantar.topAnchor.constraint(equalTo: medanPendapat.bottomAnchor, constant: 30),
            butangHantar.centerXAnchor.constraint(equalTo: kawasanKandungan.centerXAnchor),
            butangHantar.widthAnchor.constraint(equalToConstant: 200),
            butangHantar.heightAnchor.constraint(equalToConstant: KonfigurasiRahsia.MetrikSusunAtur.tinggiButang),
            butangHantar.bottomAnchor.constraint(equalTo: kawasanKandungan.bottomAnchor, constant: -40),
            
            butangUndur.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            butangUndur.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func tubuhkanPengendalPapanKekunci() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(papanKekunciAkanMuncul),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(papanKekunciAkanHilang),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func tubuhkanPengecamKetukan() {
        let gerakKetukan = UITapGestureRecognizer(target: self, action: #selector(tutupPapanKekunci))
        gerakKetukan.cancelsTouchesInView = false
        view.addGestureRecognizer(gerakKetukan)
    }
    
    @objc private func tutupPaparan() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func tutupPapanKekunci() {
        view.endEditing(true)
    }
    
    @objc private func papanKekunciAkanMuncul(pemberitahuan: NSNotification) {
        guard let kerangkaPapanKekunci = pemberitahuan.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: kerangkaPapanKekunci.height, right: 0)
        bekasSkrol.contentInset = inset
        bekasSkrol.scrollIndicatorInsets = inset
    }
    
    @objc private func papanKekunciAkanHilang(pemberitahuan: NSNotification) {
        bekasSkrol.contentInset = .zero
        bekasSkrol.scrollIndicatorInsets = .zero
    }
    
    @objc private func hantarPendapat() {
        let kandungan = medanPendapat.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !pengesah.sahkan(kandungan) {
            paparkanRalaatPengesahan()
            return
        }
        
        PenjagaVault.dikongsi.simpanentriMaklumBalas(kandungan)
        paparkanPengesahanKejayaan()
    }
    
    private func paparkanRalaatPengesahan() {
        let portal = PortalDialogBercahaya()
        let tindakanSenarai = [
            TindakanDialog(tajuk: "OK", gaya: .primer, pengendali: nil)
        ]
        portal.tampilkanDenganKonfigurasi(
            tajuk: "Empty Feedback",
            mesej: pengesah.mesejPengesahan(),
            tindakan: tindakanSenarai
        )
    }
    
    private func paparkanPengesahanKejayaan() {
        let portal = PortalDialogBercahaya()
        let tindakanSenarai = [
            TindakanDialog(tajuk: "OK", gaya: .primer) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        ]
        portal.tampilkanDenganKonfigurasi(
            tajuk: "Thank You!",
            mesej: "Your feedback has been submitted successfully.",
            tindakan: tindakanSenarai
        )
        
        medanPendapat.text = ""
        teksPlaceholder.isHidden = false
    }
}

extension PortalPendapatTerpilih: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        teksPlaceholder.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        teksPlaceholder.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        teksPlaceholder.isHidden = !textView.text.isEmpty
    }
}
