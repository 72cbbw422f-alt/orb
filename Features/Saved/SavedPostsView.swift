import SwiftUI

struct SavedPostsView: View {
    @EnvironmentObject private var bookmarks: BookmarkStore

    private var savedPosts: [FeedPost] {
        FeedPreviewData.posts.filter { bookmarks.savedIDs.contains($0.id) }
    }

    var body: some View {
        ZStack {
            OrbitTheme.background.ignoresSafeArea()

            Group {
                if savedPosts.isEmpty {
                    ContentUnavailableView(
                        "Nothing saved yet",
                        systemImage: "bookmark",
                        description: Text("Save a post from your feed and it will appear here for later.")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(savedPosts) { post in
                                NavigationLink {
                                    FeedPostDetailView(post: post)
                                } label: {
                                    FeedPostCard(post: post)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, OrbitTheme.horizontalPadding)
                        .padding(.vertical, 16)
                    }
                }
            }
        }
        .navigationTitle("Saved")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        SavedPostsView()
            .environmentObject(BookmarkStore())
    }
}
