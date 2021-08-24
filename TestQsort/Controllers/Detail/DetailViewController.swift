//
//  DetailViewController.swift
//  TestQsort
//
//  Created by Влад Барченков on 09.08.2021.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    var dataFetcherService = DataFetcherService.shared
    
    let photoImageView = UIImageView()
    let nameLabel = UILabel(fontSize: 18, color: .black)
    let commentLabel = UILabel(fontSize: 14, color: .gray)
    let dateLabel = UILabel(fontSize: 14, color: .gray)
    
    var mediaId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setDetail(mediaId: mediaId)
    }
}

extension DetailViewController {
    private func configure() {
        view.backgroundColor = .white
        photoImageView.contentMode = .scaleAspectFit
        setupConstraints()
    }
    
    func setDetail(mediaId: String?) {
        guard let id = mediaId else { return }
        dataFetcherService.getMedia(mediaId: id) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    guard let data = data, let url = URL(string: data.media_url)  else {return}
                    self?.photoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options : [.transition (. fade ( 0.2 ))])
                    self?.nameLabel.text = data.username.capitalized
                    self?.dateLabel.text = FormatDate.dateFormater(stringDate: data.timestamp)
                    self?.commentLabel.text = data.caption
                }
            case .failure(let error):
                self?.showAlert(with: "Ошибка!", and: error.localizedDescription)
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
