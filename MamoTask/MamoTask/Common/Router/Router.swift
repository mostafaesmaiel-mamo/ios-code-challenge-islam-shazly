//
//  Router.swift
//  Mamo
//
//  Created by islam Elshazly on 02/06/2021.
//

import UIKit

protocol Router {
    
    typealias CompletionHandler = (() -> Void)
    
    func setRoot(presentable: UIViewController?, hideBar: Bool)
    func present(presentable: UIViewController?, animated: Bool)
    func dismiss(animated: Bool, completion: CompletionHandler?)
    func push(presentable: UIViewController?, animated: Bool, completion: CompletionHandler?)
    func pop(animated: Bool)
    func setAppRoot(presentable: UIViewController?, animated: Bool)
}

