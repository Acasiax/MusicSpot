//
//  AppsCollectionViewCell.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/9/24.
//

import UIKit
import SnapKit

class AppsTableViewCell: UITableViewCell {
   
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    let collectionView: UICollectionView
    
    var screenshots: [String] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
       // layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        contentView.addSubview(subtitleLabel)
        
        contentView.addSubview(collectionView)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.width.height.equalTo(60)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }

        collectionView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.height.greaterThanOrEqualTo(150).priority(.medium)
        }

    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AppsScreenshotCell.self, forCellWithReuseIdentifier: AppsScreenshotCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func configure(with model: Software) {
        titleLabel.text = model.trackName
        subtitleLabel.text = model.artistName
        
        if let urlString = model.artworkUrl100, let url = URL(string: urlString) {
            iconImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "bubbles.and.sparkles.fill"))
        } else {
            iconImageView.image = UIImage(systemName: "bubbles.and.sparkles.fill")
        }
        
        // 스크린샷 데이터 설정
        screenshots = model.screenshotUrls ?? []
        collectionView.reloadData()
       
    }
}

extension AppsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsScreenshotCell.identifier, for: indexPath) as! AppsScreenshotCell
        let screenshotUrl = screenshots[indexPath.item]
        cell.configure(with: screenshotUrl)
        cell.backgroundColor = .gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: collectionView.frame.height) // 셀의 높이를 컬렉션 뷰의 높이에 맞춤
    }
}

class AppsScreenshotCell: UICollectionViewCell {
 
    let screenshotImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(screenshotImageView)
        screenshotImageView.contentMode = .scaleAspectFit
        screenshotImageView.clipsToBounds = true
        
        screenshotImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 셀의 크기에 맞게 이미지뷰를 설정
        }
    }
    
    func configure(with urlString: String) {
        if let url = URL(string: urlString) {
            screenshotImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        } else {
            screenshotImageView.image = UIImage(systemName: "photo")
        }
    }
}

