//
//  AppRoutingApp.swift
//  AppRouting
//
//  Created by Martin on 15/04/2025.
//

import SwiftUI

@main
struct AppRoutingApp: App {
    
    @State private var routes: [Route] = []
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routes) {
                ContentView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                            case .create:
                                Text("Create")
                            case .detail(let movie):
                                MovieDetailScreen(movie: movie)
                            case .login:
                                LoginScreen()
                            case .register:
                                RegisterScreen()
                            case .reviews(let reviews):
                                ReviewListScreen(reviews: reviews)
                        }
                    }
            }.environment(\.navigate, NavigateAction(action: performNavigation))
        }
    }
    
    private func performNavigation(_ navigationType: NavigationType) {
        switch navigationType {
            case .push(let route):
                routes.append(route)
            case .unwind(let route):
                guard let index = routes.firstIndex(where: { $0 == route })  else { return }
                routes = Array(routes.prefix(upTo: index + 1))
        }
    }
}
