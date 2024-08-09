//
//  HomeViewController.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/9/24.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.searchMusic(term: "Beatles")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { musicList in
                // 검색 결과를 UI에 표시하는 코드
                for music in musicList {
                    print("Track: \(music.trackName) by \(music.artistName)")
                }
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

