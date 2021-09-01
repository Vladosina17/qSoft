//
//  MainPresenter.swift
//  TestQsort
//
//  Created by Влад Барченков on 30.08.2021.
//

import UIKit

class MainPresenter: NSObject, UICollectionViewDelegateFlowLayout {
    
    var viewController: MainViewController!
    var collectionView: UICollectionView!
    
    let refreshControl = UIRefreshControl()
    
    var mediaData: Feed?
    var isDataLoading: Bool = false
    
    init(vc: MainViewController) {
        self.viewController = vc
        super.init()
        configure()
        setupCollectionView()
    }
}

extension MainPresenter {
    
    //MARK: - Configure
    
    private func configure() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
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
    
    @objc func refresh() {
        viewController.refresh()
        refreshControl.endRefreshing()
    }
    
    func update (with model: Feed) {
        self.mediaData = model
        collectionView.reloadData()
    }
    
    func appendPagination(with model: [MediaData]) {
        mediaData?.data?.append(contentsOf: model)
        collectionView.reloadData()
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MainPresenter: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaData?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuseId, for: indexPath) as? PostCollectionViewCell,
              let media = mediaData?.data?[indexPath.row] else { return PostCollectionViewCell()}
        cell.setCell(media: media)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.mediaId = mediaData?.data?[indexPath.row].id
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
                viewController.validateToken()
            }
        }
    }
    
}
