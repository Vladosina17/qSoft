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
    
    //MARK: - Constants
    static var reuseId: String = "MainCell"
    
    //MARK: - Properties
    let photoImageView = UIImageView()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}

//MARK: - Configure
extension PostCollectionViewCell {
    
    private func configure() {
        photoImageView.backgroundColor = .red
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
    }
    
    func setCell(media: MediaData) {
        guard let urlString = media.media_url,
              let url = URL(string: urlString) else { return }
        photoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options : [.transition (. fade ( 0.2 ))])
    }
}
