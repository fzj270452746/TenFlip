//
//  AppDelegate.swift
//  TenFlip
//
//  Dicipta oleh hades pada 2025.
//

import UIKit

@main
class WakilAplikasi: UIResponder, UIApplicationDelegate {

    // MARK: - UIApplicationDelegate Methods (必须使用标准方法名)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        tetapkanOrientasiPortrait()
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let konfigurasi = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        return konfigurasi
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        lakukanPembersihanSesiPaparan()
    }
    
    // MARK: - Orientation Support
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return dapatkanOrientasiYangDisokong()
    }
    
    // MARK: - Kaedah Peribadi
    
    private func tetapkanOrientasiPortrait() {
        // Paksa orientasi portrait
    }
    
    private func lakukanPembersihanSesiPaparan() {
        // Pembersihan sumber sesi
    }
    
    private func dapatkanOrientasiYangDisokong() -> UIInterfaceOrientationMask {
        return .portrait
    }
}
