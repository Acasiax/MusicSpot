//
//  PodcastVC.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PodcastVC: UIViewController {
    let searchBar = UISearchBar()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // bindSearchBar()를 통해 앱 검색 기능 추가 가능
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}
