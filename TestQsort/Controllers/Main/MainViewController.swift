//
//  MainViewController.swift
//  TestQsort
//
//  Created by Влад Барченков on 09.08.2021.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout {
     
    var collectionView: UICollectionView!
    var instagramUserToken: InstagramTestUser?
    let instagramApi = InstagramApi.shared
    var instagramUser: InstagramUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupCollectionView()
        getDataUser()
    }
}

extension MainViewController {
    
    private func configure() {
        view.backgroundColor = .white
//        title = "Лента"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(tapLogOut))
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.width + 100)
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.reuseId)
        
        view.addSubview(collectionView)
    }
    
    private func getDataUser() {
        instagramApi.getInstagramUser{ [weak self] (user) in
            self?.instagramUser = user
            DispatchQueue.main.async {
                self?.title = user.username
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
        let authVC = AuthViewController()
        self.view.window?.rootViewController = authVC
    }
}


//MARK: - Delegates

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuseId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
