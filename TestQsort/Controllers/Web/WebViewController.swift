//
//  WebViewController.swift
//  TestQsort
//
//  Created by Влад Барченков on 10.08.2021.
//

import Foundation
import WebKit
import SnapKit
import Locksmith

class WebViewController: UIViewController {
    
    // MARK: - Constants
    var authFetcherService = AuthFetcherService.shared
    
    //MARK: - Properties
    var testUserData: InstagramTestUser?
    var mainVC: AuthViewController?
    var webView: WKWebView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        authFetcherService.authorizeApp { [weak self] url in
            guard let url = url else { return }
            self?.webView.load(URLRequest(url: url))
        }
    }
}

extension WebViewController {
    //MARK: - Configure
    
    private func configure() {
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    func dismissViewController() {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                guard self.testUserData != nil else { return }
                let mainTabVC = MainTabBarController()
                UIApplication.shared.windows.first?.rootViewController = mainTabVC
            }
        }
    }
}

//MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        self.authFetcherService.getTestUserIDAndToken(request: request) { [weak self] result in
            switch result {
            case .success(let data):
                UserDefaults.standard.setValue(true, forKey: "isAuth")
                guard let testUser = data else { return }
                do {
                    try Locksmith.saveData(data: ["token" : testUser.access_token!, "user_id" : testUser.user_id!], forUserAccount: "Auth")
                } catch {
                    print("Unabled to save data")
                }
                self?.testUserData = testUser
                self?.dismissViewController()
                
            case .failure(let error):
                self?.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
