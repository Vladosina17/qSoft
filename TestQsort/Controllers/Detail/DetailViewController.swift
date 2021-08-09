//
//  DetailViewController.swift
//  TestQsort
//
//  Created by Влад Барченков on 09.08.2021.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    let photoImageView = UIImageView()
    let nameLabel = UILabel()
    let likeLabel = UILabel()
    let dateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
}

extension DetailViewController {
    private func configure() {
        view.backgroundColor = .white
        
        photoImageView.backgroundColor = .lightGray
        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        nameLabel.text = "Vladosina17"
        
        likeLabel.font = UIFont.systemFont(ofSize: 14)
        likeLabel.textColor = .gray
        likeLabel.textAlignment = .left
        likeLabel.text = "Нравится: 225"
        
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .left
        dateLabel.text = "10 декабря 2020г."
            
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(photoImageView)
        view.addSubview(nameLabel)
        view.addSubview(likeLabel)
        view.addSubview(dateLabel)
        
        photoImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(view.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(likeLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    }
}
