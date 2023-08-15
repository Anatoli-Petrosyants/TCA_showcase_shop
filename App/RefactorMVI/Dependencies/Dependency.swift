//
//  Dependency.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Swinject

final class SwinjectDependency {
    
    private var assembler: Assembler!
    
    var resolver: Resolver {
        return assembler.resolver
    }
    
    static var shared: SwinjectDependency = {
        return SwinjectDependency()
    }()

    func resetContainerObjectScope() {
        let container = resolver as! Container
        container.resetObjectScope(.container)
    }
    
    private init() { }
    
    func initialize() {
        self.assembler = Assembler([
            OtherAssembly(),
            RepositoriesAssembly(),
            UseCasesAssembly(),
            ModelAssembly(),
            IntentAssembly(),
            ViewsAssembly(),
        ])
    }
}
