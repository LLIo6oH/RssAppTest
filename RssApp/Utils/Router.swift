//
//  Router.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 24.12.2024.
//

import Swinject

class Router {
    private let assembler: Assembler
    private let resolver: Resolver
    
    static let shared = Router()
    
    init() {
        self.assembler = Assembler([
            ServiceAssembly(),
            ViewModelAssembly()
        ])
        self.resolver = assembler.resolver
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return resolver.resolve(type)
    }
    
    func openMainScene() -> MainSceneViewController {
        let viewModel = resolve(MainSceneViewModel.self)!
        return MainSceneViewController(viewModel: viewModel)
    }
    
    func openSettingsScene() -> SettingsViewController {
        let viewModel = resolve(SettingsViewModel.self)!
        return SettingsViewController(viewModel: viewModel)
    }
}
