//
//  NavigationController.swift
//  LindDE
//
//  Created by fridakitten on 06.05.25.
//

import UIKit

func RevertUI() {
    let theme: LindDEThemer = getCurrentSelectedTheme()
    
    let blurEffect = UIBlurEffect(style: .systemMaterial)
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.backgroundColor = theme.gutterBackgroundColor
    navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
    navigationBarAppearance.buttonAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
    navigationBarAppearance.backButtonAppearance = UIBarButtonItemAppearance()
    navigationBarAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor : theme.textColor]
    
    UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance?.backgroundEffect = blurEffect
    
    if #available(iOS 15.0, *) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = theme.gutterBackgroundColor
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance?.backgroundEffect = blurEffect
    }
    
    UITableView.appearance().backgroundColor = theme.gutterBackgroundColor
    UITableViewCell.appearance().backgroundColor = theme.backgroundColor
    
    UILabel.appearance().textColor = theme.textColor
    UIView.appearance().tintColor = theme.textColor
}
