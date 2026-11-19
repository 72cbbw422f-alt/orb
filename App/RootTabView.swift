import SwiftUI

struct RootTabView: View {
    @StateObject private var bookmarks = BookmarkStore()

    var body: some View {
        TabView {
            NavigationStack {
                FeedView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack {
                DiscoverView()
            }
            .tabItem {
                Label("Discover", systemImage: "safari")
            }

            NavigationStack {
                SavedPostsView()
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
        .environmentObject(bookmarks)
    }
}

private struct PlaceholderView: View {
    let title: String
    let subtitle: String
    let symbol: String

    var body: some View {
        ZStack {
            OrbitTheme.background.ignoresSafeArea()
            ContentUnavailableView(
                title,
                systemImage: symbol,
                description: Text(subtitle)
            )
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }
}
