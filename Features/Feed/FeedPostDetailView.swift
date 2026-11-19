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

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Discussion")
                                .font(.title3.weight(.bold))
                                .foregroundStyle(OrbitTheme.primaryText)
                            Spacer()
                            Text("NEXT MILESTONE")
                                .font(.system(size: 9, weight: .bold, design: .rounded))
                                .tracking(0.8)
                                .foregroundStyle(OrbitTheme.accent)
                        }

                        Text("Threaded comments, sorting, collapsing replies and composing responses are in the next discussion milestone.")
                            .font(.subheadline)
                            .foregroundStyle(OrbitTheme.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: OrbitTheme.cardRadius))
                }
                .padding(OrbitTheme.horizontalPadding)
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
