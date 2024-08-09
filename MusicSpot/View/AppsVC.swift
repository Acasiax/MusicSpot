//
//  AppsViewController.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class AppsVC: UIViewController {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let disposeBag = DisposeBag()
    let results = BehaviorRelay<[Software]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindSearchBar()
        bindTableView()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
    }
    
    func bindSearchBar() {
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { term -> Observable<SoftwareResponse> in
                return NetworkManager.shared.searchMedia(term: term, mediaType: .software, responseType: SoftwareResponse.self)
                    .catchAndReturn(SoftwareResponse(results: []))
            }
            .map { $0.results }
            .bind(to: results)
            .disposed(by: disposeBag)
    }
    
    func bindTableView() {
        results
            .bind(to: tableView.rx.items(cellIdentifier: CustomTableViewCell.identifier, cellType: CustomTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Software.self)
            .subscribe(onNext: { [weak self] software in
                print("Selected app: \(software.trackName)")
                // 추가적으로 상세 화면 이동 등을 여기에 구현할 수 있습니다.
            })
            .disposed(by: disposeBag)
    }
}

class CustomTableViewCell: UITableViewCell {
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        // 이미지뷰 설정
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        
        // 타이틀 라벨 설정
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
        
        // 서브타이틀 라벨 설정
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        contentView.addSubview(subtitleLabel)
        
        // SnapKit을 사용한 레이아웃 설정
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60) // 아이콘 이미지 크기
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with model: Software) {
        titleLabel.text = model.trackName
        subtitleLabel.text = model.artistName
        if let urlString = model.artworkUrl100, let url = URL(string: urlString) {
            // Kingfisher를 사용한 이미지 비동기 로딩 및 캐싱
            iconImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "app.fill"))
        } else {
            iconImageView.image = UIImage(systemName: "app.fill") // 기본 이미지
        }
    }

}
