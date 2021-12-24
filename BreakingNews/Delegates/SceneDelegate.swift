//
//  SceneDelegate.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        checkIfHasFavorites()
    }
}

fileprivate extension SceneDelegate {
    
    func checkIfHasFavorites() {
        if let _ = UserDefaultsManager.getUserFavorite() {
            setRootViewController(to: HomeViewController())
        } else {
            let onboardingViewModel = OnBoardingViewModel()
            let onBoardingViewController = OnBoardingViewController(viewModel: onboardingViewModel)
            setRootViewController(to: onBoardingViewController)
        }
    }
    
    func setRootViewController(to viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

