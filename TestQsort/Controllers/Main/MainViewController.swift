//
//  MainViewController.swift
//  TestQsort
//
//  Created by Влад Барченков on 09.08.2021.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout {
     
    var collectionView: UICollectionView!
    let refreshControl = UIRefreshControl()
    
    var instagramUserToken: InstagramTestUser?
    let instagramApi = InstagramApi.shared
    var instagramUser: InstagramUser?
    var mediaData: Feed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupCollectionView()
        getDataUser()
        getMedia()
    }
}

extension MainViewController {
    
    private func configure() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(tapLogOut))
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.width)
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.reuseId)
        collectionView.refreshControl = refreshControl
        
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
    
    private func getMedia() {
        instagramApi.getMediaData { [weak self] (data) in
            self?.mediaData = data
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
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
    
    @objc func refresh() {
        getMedia()
        refreshControl.endRefreshing()
    }
}


//MARK: - Delegates

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaData?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuseId, for: indexPath) as? PostCollectionViewCell,
              let mediaId = mediaData?.data[indexPath.row].id else { return PostCollectionViewCell()}
        cell.setCell(mediaId: mediaId)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.mediaId = mediaData?.data[indexPath.row].id
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let position = scrollView.contentOffset.y
//        if position > (collectionView.contentSize.height - 100 - scrollView.frame.height) {
//            print("fetch more dara...")
//        }
//    }
}
