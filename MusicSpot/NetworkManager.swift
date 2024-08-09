//
//  NetworkManager.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}


final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func searchMusic(term: String) -> Observable<[Music]> {
        let url = MusicURL.buildURL(term: term)
        
        let result = Observable<[Music]>.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                
                guard let data = data else {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(MusicResponse.self, from: data)
                    observer.onNext(decodedResponse.results)
                    observer.onCompleted() //🌟
                } catch {
                    observer.onError(error)
                }
                
            }.resume()
            
            return Disposables.create()
        }
        
        return result
    }
}

