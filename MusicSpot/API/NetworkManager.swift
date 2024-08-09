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
    
    func searchMedia<T: Codable>(term: String, mediaType: MediaType, responseType: T.Type) -> Observable<T> {
        let url = MediaURL.buildURL(term: term, mediaType: mediaType)
        
        return Observable<T>.create { observer in
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
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decodedResponse)
                    observer.onCompleted() //🌟🌟
                } catch {
                    print("응답이 왔으나 실패")
                    observer.onError(error)
                }
                
            }.resume()
            
            return Disposables.create()
        }.debug("미디어 조회")
    }
}
