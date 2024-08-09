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
            .subscribe(onNext: { software in
                print("앱을 선택했습니다.: \(software.trackName)")
                // 추가적으로 상세 화면 이동 등을 여기에 구현하기 이따가.
            })
            .disposed(by: disposeBag)
    }
}



