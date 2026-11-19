import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                FeedView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack {
                PlaceholderView(
                    title: "Discover",
                    subtitle: "Find communities and conversations worth your time.",
                    symbol: "safari"
                )
            }
            .tabItem {
                Label("Discover", systemImage: "safari")
            }

            NavigationStack {
                PlaceholderView(
                    title: "Saved",
                    subtitle: "Your reading list will live here.",
                    symbol: "bookmark"
                )
            }
            .tabItem {
                Label("Saved", systemImage: "bookmark")
            }

            NavigationStack {
                PlaceholderView(
                    title: "Inbox",
                    subtitle: "Replies and supported messages, gathered in one place.",
                    symbol: "tray"
                )
            }
            .tabItem {
                Label("Inbox", systemImage: "tray")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "slider.horizontal.3")
            }
        }
        .tint(OrbitTheme.accent)
    }
}

private struct PlaceholderView: View {
    let title: String
    let subtitle: String
    let symbol: String

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: symbol,
            description: Text(subtitle)
        )
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }
}
