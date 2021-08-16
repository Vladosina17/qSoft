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
    
    var instagramApi = InstagramApi.shared
    var testUserData: InstagramTestUser?
    var mainVC: AuthViewController?
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        instagramApi.authorizeApp { (url) in
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url!))
            }
        }
    }
}

extension WebViewController {
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

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        self.instagramApi.getTestUserIDAndToken(request: request) { [weak self] (instagramTestUser) in
            UserDefaults.standard.setValue(true, forKey: "isAuth")
            
            do {
                try Locksmith.saveData(data: ["token" : instagramTestUser.access_token, "user_id" : instagramTestUser.user_id], forUserAccount: "Auth")
            } catch {
                print("Unabled to save data")
            }
            
            self?.testUserData = instagramTestUser
            self?.dismissViewController()
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
