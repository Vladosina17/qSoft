//
//  AuthViewController.swift
//  TestQsort
//
//  Created by Влад Барченков on 09.08.2021.
//

import UIKit
import SnapKit

class AuthViewController: UIViewController {
    
    let titleLabel = UILabel()
    let signInButton = UIButton(type: .system)
    
    var instagramApi = InstagramApi.shared
    var testUserData = InstagramTestUser(access_token: "", user_id: 0)
    var instagramUser: InstagramUser?
    var signedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension AuthViewController {
    private func configure() {
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = "Авторизация"
        
        signInButton.setTitle("Войти", for: .normal)
        signInButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        signInButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        signInButton.layer.cornerRadius = 5
        signInButton.addTarget(self, action: #selector(tapSignInButton), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(signInButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(signInButton.snp.top).offset(-30)
        }
        
        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(300)
        }
    }
    
    @objc func tapSignInButton() {
        if testUserData.user_id == 0 {
            presentWebViewController()
        } else {
            self.instagramApi.getInstagramUser(testUserData: self.testUserData) { [weak self] (user) in
                self?.instagramUser = user
                self?.signedIn = true
                DispatchQueue.main.async {
                    self?.presentAlert()
                }
            }
        }
        
    }
    
    func presentWebViewController() {
        let webVC = WebViewController()
        webVC.instagramApi = self.instagramApi
        webVC.mainVC = self
        present(webVC, animated: true)
    }
    
    func presentAlert() {
      let alert = UIAlertController(title: "Signed In:", message: "with account: @\(self.instagramUser!.username)", preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      self.present(alert, animated: true)
    }

}
