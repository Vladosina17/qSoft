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
    let loginTextField = BaseTextField(placeholder: "Введите логин")
    let passwordTextField = BaseTextField(placeholder: "Введите пароль", isSecure: true)
    let signInButton = UIButton(type: .system)
    
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
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.centerX.equalToSuperview()
        }
        
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).inset(150)
            make.centerX.lessThanOrEqualToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField).inset(60)
            make.centerX.lessThanOrEqualToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
        
        signInButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.centerX.lessThanOrEqualToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
    }
    
    @objc func tapSignInButton() {
        let mainTabBar = MainTabBarController()
        mainTabBar.modalPresentationStyle = .fullScreen
        present(mainTabBar, animated: true, completion: nil)
    }
}
