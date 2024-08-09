//
//  TabBarController.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/9/24.
//

import UIKit

// MARK: - MainTab 열거형
enum MainTab: CaseIterable {
    case music
    case movies
    case podcast
    case books
    case search

    // MARK: - 제목
    var title: String {
        switch self {
        case .music: return "음악"
        case .movies: return "영화"
        case .podcast: return "팟캐스트"
        case .books: return "책"
        case .search: return "앱검색"
        }
    }

    // MARK: - 아이콘
    var image: UIImage? {
        switch self {
        case .music: return UIImage(systemName: "music.note")
        case .movies: return UIImage(systemName: "movieclapper")
        case .podcast: return UIImage(systemName: "radio")
        case .books: return UIImage(systemName: "book")
        case .search: return UIImage(systemName: "magnifyingglass")
        }
    }

    // MARK: - 뷰 컨트롤러
    var viewController: UIViewController {
        let viewController: UIViewController
        switch self {
        case .music: viewController = MusicVC()
        case .movies: viewController = MoviesVC()
        case .podcast: viewController = PodcastVC()
        case .books: viewController = EbookVC()
        case .search: viewController = AppsVC()
        }

        viewController.view.backgroundColor = .white
        viewController.tabBarItem = UITabBarItem(title: self.title, image: self.image, tag: self.hashValue)
        return viewController
    }
}

// MARK: - TabBarControllerFactory 클래스
class TabBarControllerFactory {
    static func createMainTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        // 특정 조건에 따라 TabBar의 순서를 변경할 수 있도록 유연하게 설정
        var viewControllers = [UIViewController]()
        let tabs: [MainTab] = [.music, .movies, .podcast, .books, .search]

        for tab in tabs {
            viewControllers.append(tab.viewController)
        }

        tabBarController.viewControllers = viewControllers
        return tabBarController
    }
}
