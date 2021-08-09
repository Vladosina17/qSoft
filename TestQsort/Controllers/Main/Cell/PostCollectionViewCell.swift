//
//  PostCollectionViewCell.swift
//  TestQsort
//
//  Created by Влад Барченков on 09.08.2021.
//

import UIKit
import SnapKit

class PostCollectionViewCell: UICollectionViewCell {
    
    static var reuseId: String = "MainCell"
    
    let photoImageView = UIImageView()
    let nameLabel = UILabel()
    let likeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PostCollectionViewCell {
    
    private func configure() {
        photoImageView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        nameLabel.text = "Vladosina17"
        
        likeLabel.font = UIFont.systemFont(ofSize: 14)
        likeLabel.textColor = .gray
        likeLabel.textAlignment = .left
        likeLabel.text = "Нравится: 225"
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        addSubview(photoImageView)
        addSubview(nameLabel)
        addSubview(likeLabel)
        
        photoImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
    }
}
