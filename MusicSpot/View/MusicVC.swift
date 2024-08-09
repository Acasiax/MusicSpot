//
//  MusicViewController.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MusicVC: UIViewController {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let disposeBag = DisposeBag()
    let results = BehaviorRelay<[Movie]>(value: [])
    
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func bindSearchBar() {
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { term -> Observable<MovieResponse> in
                return NetworkManager.shared.searchMedia(term: term, mediaType: .music, responseType: MovieResponse.self)
                    .catchAndReturn(MovieResponse(results: []))
            }
            .map { $0.results }
            .bind(to: results)
            .disposed(by: disposeBag)
    }
    
    func bindTableView() {
        results
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = element.trackName
                cell.detailTextLabel?.text = element.artistName
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                print("Selected movie: \(movie.trackName)")
                
            })
            .disposed(by: disposeBag)
    }
}
