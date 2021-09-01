//
//  MainViewController.swift
//  TestQsort
//
//  Created by Влад Барченков on 09.08.2021.
//

import UIKit
import Locksmith

class MainViewController: UIViewController {
     
    //MARK: - Constants
    let dataFetcherService = DataFetcherService.shared
    
    //MARK: - Properties
    var mediaData: Feed?
    var paginationURL: String?
    
    private var presenter: MainPresenter!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        verificationToken()
    }
}

extension MainViewController {
    
    //MARK: - Configure
    private func configure() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(tapLogOut))
        presenter = MainPresenter(vc: self)
    }

    //MARK: - Networking
    func verificationToken() {
        dataFetcherService.validate { [weak self] error in
            if let errorCode = error?.error?.code, errorCode == 190 {
                DispatchQueue.main.async {
                    self?.signOut()
                }
            } else {
                self?.getDataUser()
                self?.getMedia()
            }
        }
    }
    
    private func getDataUser() {
        dataFetcherService.getInstagramUser { [weak self] result in
            switch result {
            case .success(let data):
                guard let user = data else { return }
                DispatchQueue.main.async {
                    self?.title = user.username
                }
            case .failure(let error):
                self?.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        }
    }
    
    private func getMedia() {
        dataFetcherService.getMediaData { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                self?.presenter.update(with: data)
                self?.paginationURL = data.paging?.next
            case .failure(let error):
                self?.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        }
    }
    
    private func getPagination() {
        dataFetcherService.getPaginationMediaData(next: paginationURL) { [weak self] result in
            switch result {
            case .success(let data):
                guard let media = data,
                      let mediaData = media.data
                else { return }
                self?.paginationURL = media.paging?.next
                DispatchQueue.main.async {
                    self?.presenter.appendPagination(with: mediaData)
                }
            case .failure(let error):
                self?.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        }
    }
    
    func refresh() {
        getMedia()
    }
    
    func validateToken() {
        dataFetcherService.validate { [weak self] error in
            if let errorCode = error?.error?.code, errorCode == 190 {
                DispatchQueue.main.async {
                    self?.signOut()
                }
            } else {
                self?.getPagination()
            }
        }
    }
    
//MARK: - Actions
    @objc func tapLogOut() {
        let ac = UIAlertController(title: nil, message: "Вы хотите выйти из учетной записи?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { _ in
            self.signOut()
        }))
        present(ac, animated: true, completion: nil)
    }
    
    func signOut() {
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
        UserDefaults.standard.setValue(false, forKey: "isAuth")
        do {
            try  Locksmith.deleteDataForUserAccount(userAccount: "Auth")
        } catch {
            print("Данные не найдены")
        }
        let authVC = AuthViewController()
        self.view.window?.rootViewController = authVC
    }
}
