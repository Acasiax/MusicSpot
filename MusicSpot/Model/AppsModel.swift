//
//  AppsModel.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/12/24.
//

import Foundation
import RxSwift
import RxCocoa

enum NetworkError: Error {
    case invalidResponse
    case noData
    case failedRequest(String) // 에러 메시지를 포함할 수 있는 케이스
    case unknown
}



protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
    var disposeBag: DisposeBag { get }
}

final class AppsViewModel: BaseViewModel {
    
    struct Input {
        let searchTerm: Observable<String>
    }
    
    struct Output {
        let results: Driver<[Software]>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let results = input.searchTerm
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest { term -> Observable<[Software]> in
                return NetworkManager.shared.searchMedia(term: term, mediaType: .software, responseType: SoftwareResponse.self)
                    .map { $0.results }
                    .catch { error in
                        print("에러 발생: \(error.localizedDescription)")
                        return Observable.just([]) //🌟🔥
                    }
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(results: results)
    }
}


