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
    
    // ViewModel 인스턴스 생성
    let viewModel = AppsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.register(AppsTableViewCell.self, forCellReuseIdentifier: AppsTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    func bindViewModel() {
        let input = AppsViewModel.Input(searchTerm: searchBar.rx.text.orEmpty.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.results
            .drive(tableView.rx.items(cellIdentifier: AppsTableViewCell.identifier, cellType: AppsTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Software.self)
            .asDriver()
            .drive(onNext: { software in
                print("앱을 선택했습니다.: \(software.trackName)")
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




   
