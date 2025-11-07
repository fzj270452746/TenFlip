

import UIKit

class ChronicleDataSource {
    private var records: [PinnacleRecord] = []
    
    func loadRecords(for difficulty: ZenithDifficulty) {
        records = AncientVaultKeeper.shared.fetchRecordsForDifficulty(difficulty)
    }
    
    func numberOfRecords() -> Int {
        return records.isEmpty ? 1 : min(records.count, ArcaneConfiguration.GameParameters.leaderboardLimit)
    }
    
    func record(at index: Int) -> PinnacleRecord? {
        guard !records.isEmpty, index < records.count else { return nil }
        return records[index]
    }
    
    func isEmpty() -> Bool {
        return records.isEmpty
    }
}

class CusyeddChronicleController: UIViewController {
    
    private let dataSource = ChronicleDataSource()
    private let resourceProvider = StandardResourceProvider()
    
    private lazy var backgroundTexture: UIImageView = {
        let iv = UIImageView()
        iv.image = resourceProvider.obtainBackgroundTexture()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var dimmerOverlay: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var retreatButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("← Back", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 20
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
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
    
    private lazy var difficultySelector: UISegmentedControl = {
        let items = ["Simple", "Difficult"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = ArcaneConfiguration.ColorPalette.neutralIvory.withAlphaComponent(0.9)
        sc.selectedSegmentTintColor = ArcaneConfiguration.ColorPalette.primaryBronze
        sc.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(difficultyDidChange), for: .valueChanged)
        return sc
    }()
    
    private lazy var recordsTable: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(PinnacleRecordCell.self, forCellReuseIdentifier: "PinnacleRecordCell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assembleInterface()
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        refreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func assembleInterface() {
        view.addSubview(backgroundTexture)
        view.addSubview(dimmerOverlay)
        view.addSubview(retreatButton)
        view.addSubview(titleLabel)
        view.addSubview(difficultySelector)
        view.addSubview(recordsTable)
        
        NSLayoutConstraint.activate([
            backgroundTexture.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundTexture.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundTexture.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundTexture.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dimmerOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            dimmerOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmerOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmerOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            retreatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            retreatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            difficultySelector.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            difficultySelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            difficultySelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            difficultySelector.heightAnchor.constraint(equalToConstant: 40),
            
            recordsTable.topAnchor.constraint(equalTo: difficultySelector.bottomAnchor, constant: 20),
            recordsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recordsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func difficultyDidChange() {
        refreshData()
    }
    
    private func refreshData() {
        let difficulty: ZenithDifficulty = difficultySelector.selectedSegmentIndex == 0 ? .novice : .arduous
        dataSource.loadRecords(for: difficulty)
        recordsTable.reloadData()
    }
}

extension CusyeddChronicleController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRecords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinnacleRecordCell", for: indexPath) as! PinnacleRecordCell
        
        if dataSource.isEmpty() {
            cell.configureEmptyState()
        } else if let record = dataSource.record(at: indexPath.row) {
            cell.configureWithRecord(record, rank: indexPath.row + 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

