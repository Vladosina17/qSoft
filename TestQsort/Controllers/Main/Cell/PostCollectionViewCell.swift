//
//  PostCollectionViewCell.swift
//  TestQsort
//
//  Created by Влад Барченков on 09.08.2021.
//

import UIKit
import SnapKit
import Kingfisher

class PostCollectionViewCell: UICollectionViewCell {
    
    static var reuseId: String = "MainCell"
    let instagramApi = InstagramApi.shared
    let photoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(media: MediaData) {
        let url = URL(string: media.media_url)
        photoImageView.kf.setImage(with: url, options : [.transition (. fade ( 0.2 ))])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}


extension PostCollectionViewCell {
    
    private func configure() {
        photoImageView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
    }
}
