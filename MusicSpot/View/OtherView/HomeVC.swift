//
//  HomeViewController.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // fetchData()
    }
    
//    func fetchData() {
//        let searchTerm = "Beatles" // 검색어 설정
//        let selectedMediaType: MediaType = .music // 미디어 타입 설정
//        let responseType = [Music].self // 검색 결과의 데이터 타입 설정
//        
//        NetworkManager.shared.searchMedia(term: searchTerm, mediaType: selectedMediaType, responseType: responseType)
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { musicList in
//                // 검색 결과를 UI에 표시하는 코드
//                for music in musicList {
//                    print("Track: \(music.trackName) by \(music.artistName)")
//                  //  print("Track: \(music.trackName) by \(music.artistName)")
//                }
//            }, onError: { error in
//                print("Error: \(error)")
//            })
//            .disposed(by: disposeBag)
//    }
}
