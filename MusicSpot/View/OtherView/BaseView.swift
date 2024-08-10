//
//  BaseView.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/9/24.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupLayout()
        setupConfigureView()
    }
    
    func addSubviews() {
        // 서브뷰 추가
    }
    
    func setupLayout() {
        // 제약조건
    }
    
    func setupConfigureView() {
        view.backgroundColor = .white
        // 나머지 설정
    }
}

// MARK: - ReusableIdentifier 프로토콜
protocol ReusableIdentifier {
    static var identifier: String { get }
}

// MARK: - UIView 확장
extension UIView: ReusableIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

