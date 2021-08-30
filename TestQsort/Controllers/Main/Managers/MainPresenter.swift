//
//  MainPresenter.swift
//  TestQsort
//
//  Created by Влад Барченков on 30.08.2021.
//

import UIKit

class MainPresenter: NSObject {
    
    //MARK: - Constants
    let dataFetcherService = DataFetcherService.shared
    
    private var collectionView: UICollectionView!
    private let viewController: MainViewController!
    let refreshControl = UIRefreshControl()
    
    //MARK: - Properties
    var mediaData: Feed?
    var paginationURL: String?
    var isDataLoading: Bool = false
    
    
    init(vc: MainViewController, collection: UICollectionView) {
        self.viewController = vc
        self.collectionView = collection
        super.init()
        configure()
        setupCollectionView()
    }
    
    
    //MARK: - Configure
    private func configure() {
        viewController.view.backgroundColor = .white
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(tapLogOut))
        viewController.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: viewController.view.bounds.width / 2, height: viewController.view.bounds.width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: viewController.view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.reuseId)
        collectionView.refreshControl = refreshControl
        
        viewController.view.addSubview(collectionView)
    }
    
    
    //Обновление
    @objc func refresh() {
//        getMedia()
        refreshControl.endRefreshing()
    }
    
    //logout
    @objc func tapLogOut() {
        let ac = UIAlertController(title: nil, message: "Вы хотите выйти из учетной записи?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { _ in
//            self.signOut()
        }))
        viewController.present(ac, animated: true, completion: nil)
    }
    
    
}

extension MainPresenter: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaData?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuseId, for: indexPath) as? PostCollectionViewCell,
              let media = mediaData?.data[indexPath.row] else { return PostCollectionViewCell()}
        cell.setCell(media: media)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.mediaId = mediaData?.data[indexPath.row].id
        viewController.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: - Pagination
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let position = scrollView.contentOffset.y
        if (position + collectionView.frame.size.height) >= collectionView.contentSize.height {
            if !isDataLoading {
                isDataLoading = true
                dataFetcherService.validate { [weak self] error in
                    if let errorCode = error?.error.code, errorCode == 190 {
                        DispatchQueue.main.async {
//                            self?.signOut()
                        }
                    } else {
//                        self?.getPagination()
                    }
                }
            }
        }
    }
}
