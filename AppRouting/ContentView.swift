//
//  ContentView.swift
//  AppRouting
//
//  Created by Martin on 15/04/2025.
//

import SwiftUI

enum NavigationType: Hashable {
    case push(Route)
    case unwind(Route)
}

struct NavigateAction {
    typealias Action = (NavigationType) -> ()
    let action: Action
    func callAsFunction(_ navigationType: NavigationType) {
        action(navigationType)
    }
}

struct NavigateEnvironmentKey: EnvironmentKey {
    static var defaultValue = NavigateAction { _ in }
}

extension EnvironmentValues {
    var navigate: (NavigateAction) {
        get { self[NavigateEnvironmentKey.self] }
        set { self[NavigateEnvironmentKey.self] = newValue }
    }
}

enum Route: Hashable {
    case detail(Movie)
    case create
    case login
    case register
    case reviews([Review])
}

struct Movie: Hashable {
    let name: String
}

struct Review: Hashable {
    let subject: String
    let description: String
}

struct MovieDetailScreen: View {
    
    @Environment(\.navigate) private var navigate
    
    let movie: Movie
    
    var body: some View {
        VStack {
            Text(movie.name)
            Button("Go to Login") {
                navigate(.push(.login))
            }.buttonStyle(.borderedProminent)
        }
    }
}

struct ReviewListScreen: View {
    
    let reviews: [Review]
    
    var body: some View {
        Text("ReviewListScreen")
    }
}

struct LoginScreen: View {
    
    var body: some View {
        VStack {
            Text("LoginScreen")
            Button("Go to Register") {
                
            }
        }
    }
}

struct RegisterScreen: View {
    
    var body: some View {
        VStack {
            Text("RegisterScreen")
            Button("Go to Movie Detail Screen") {
               
            }
            
            Button("Pop To Root") {
                
            }
        }
    }
}

struct ContentView: View {
    
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        
        VStack {
            Button("Go to Movie Detail") {
                navigate(.push(.detail(Movie(name: "Batman"))))
            }
        }
    }
}


// ContentViewContainer is only for the Xcode Previews
struct ContentViewContainer: View {
    
    @State private var routes: [Route] = []
    
    var body: some View {
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

#Preview {
    ContentViewContainer()
}
