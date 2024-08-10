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
        
        tableView.register(AppsTableViewCell.self, forCellReuseIdentifier: AppsTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200 // 대략적인 높이 설정
    }
    
    func bindSearchBar() {
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
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
            .bind(to: tableView.rx.items(cellIdentifier: AppsTableViewCell.identifier, cellType: AppsTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Software.self)
            .asDriver()
            .drive(onNext: { software in
                print("앱을 선택했습니다.: \(software.trackName)")
                // 뷰이동은 UI작업이니깐 드라이브로 했는데 과연 맞는것인가..
                let detailVC = DetailViewController(software: software)
                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}




 class DetailViewController: UIViewController {
    
    let software: Software
    
    init(software: Software) {
        self.software = software
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = software.trackName
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }
}
