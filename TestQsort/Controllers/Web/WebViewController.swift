//
//  WebViewController.swift
//  TestQsort
//
//  Created by Влад Барченков on 10.08.2021.
//

import Foundation
import WebKit
import SnapKit

class WebViewController: UIViewController {
    
    var instagramApi: InstagramApi?
    var testUserData: InstagramTestUser?
    var mainVC: AuthViewController?
    
    var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        instagramApi?.authorizeApp { (url) in
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url!))
            }
        }
    }
}

extension WebViewController {
    private func configure() {
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func dismissViewController() {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.mainVC?.testUserData = self.testUserData!
            }
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        self.instagramApi?.getTestUserIDAndToken(request: request) { [weak self] (instagramTestUser) in
            self?.testUserData = instagramTestUser
            self?.dismissViewController()
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
