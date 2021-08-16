//
//  DetailViewController.swift
//  TestQsort
//
//  Created by Влад Барченков on 09.08.2021.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    let isntagramApi = InstagramApi.shared
    var mediaId: String?
    
    let photoImageView = UIImageView()
    let nameLabel = UILabel()
    let commentLabel = UILabel()
    let dateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setDetail(mediaId: mediaId)
    }
}

extension DetailViewController {
    private func configure() {
        view.backgroundColor = .white
        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        
        commentLabel.font = UIFont.systemFont(ofSize: 14)
        commentLabel.textColor = .gray
        commentLabel.textAlignment = .left
        
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .left
            
        setupConstraints()
    }
    
    func setDetail(mediaId: String?) {
        guard let id = mediaId else { return }
        isntagramApi.getMedia(mediaId: id) { [weak self] media in
            let url = URL(string: media.media_url)
            DispatchQueue.main.async {
                self?.photoImageView.kf.setImage(with: url,placeholder: UIImage(named: "placeholder"), options : [.transition (. fade ( 0.2 ))])
                self?.nameLabel.text = media.username.capitalized
                self?.dateLabel.text = media.timestamp
                self?.commentLabel.text = media.caption
            }
        }
    }
    
    private func setupConstraints() {
        view.addSubview(photoImageView)
        view.addSubview(nameLabel)
        view.addSubview(commentLabel)
        view.addSubview(dateLabel)
        
        photoImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(88)
            make.height.equalTo(view.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    }
}
