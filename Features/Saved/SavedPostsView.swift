import SwiftUI

struct SavedPostsView: View {
    @EnvironmentObject private var bookmarks: BookmarkStore
    @EnvironmentObject private var history: ReadingHistoryStore
    @State private var selectedSection = LibrarySection.saved

    private var visiblePosts: [FeedPost] {
        let postsByID = Dictionary(uniqueKeysWithValues: FeedPreviewData.posts.map { ($0.id, $0) })
        let ids = selectedSection == .saved
            ? FeedPreviewData.posts.filter { bookmarks.savedIDs.contains($0.id) }.map(\\.id)
            : history.viewedIDs
        return ids.compactMap { postsByID[$0] }
    }

    var body: some View {
        ZStack {
            OrbitTheme.background.ignoresSafeArea()

            VStack(spacing: 16) {
                Picker("Library", selection: $selectedSection) {
                    ForEach(LibrarySection.allCases) { section in
                        Text(section.title).tag(section)
                    }
                }
                .pickerStyle(.segmented)
                .tint(OrbitTheme.accent)
                .padding(.horizontal, OrbitTheme.horizontalPadding)
                .padding(.top, 8)

                if visiblePosts.isEmpty {
                    ContentUnavailableView(
                        selectedSection.emptyTitle,
                        systemImage: selectedSection.symbol,
                        description: Text(selectedSection.emptyDescription)
                    )
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(visiblePosts) { post in
                                NavigationLink {
                                    FeedPostDetailView(post: post)
                                } label: {
                                    FeedPostCard(post: post)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, OrbitTheme.horizontalPadding)
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle("Library")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if selectedSection == .history && !history.viewedIDs.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") {
                        history.clear()
                    }
                    .foregroundStyle(OrbitTheme.accent)
                }
            }
        }
    }
}

private enum LibrarySection: String, CaseIterable, Identifiable {
    case saved
    case history

    var id: String { rawValue }
    var title: String { self == .saved ? "Saved" : "History" }
    var symbol: String { self == .saved ? "bookmark" : "clock.arrow.circlepath" }
    var emptyTitle: String { self == .saved ? "Nothing saved yet" : "No reading history" }
    var emptyDescription: String {
        self == .saved
            ? "Save a post from your feed and it will appear here for later."
            : "Posts you open will appear here, so you can pick up where you left off."
    }
}

#Preview {
    NavigationStack {
        SavedPostsView()
            .environmentObject(BookmarkStore())
            .environmentObject(ReadingHistoryStore())
    }
}
