import SwiftUI

struct FeedPostDetailView: View {
    let post: FeedPost

    var body: some View {
        ZStack {
            OrbitTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    FeedPostCard(post: post)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("POST")
                            .font(.caption.weight(.bold))
                            .tracking(1.1)
                            .foregroundStyle(OrbitTheme.accent)

                        Text(post.title)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(OrbitTheme.primaryText)

                        Text(post.excerpt)
                            .font(.body)
                            .foregroundStyle(OrbitTheme.secondaryText)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: OrbitTheme.cardRadius))

                    CommentThreadView(post: post)
                }
                .padding(OrbitTheme.horizontalPadding)
                .padding(.vertical, 12)
            }
        }
        .navigationTitle(post.community)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        FeedPostDetailView(post: FeedPreviewData.posts[0])
    }
    .environmentObject(BookmarkStore())
}
