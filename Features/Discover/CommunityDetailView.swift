import SwiftUI

struct CommunityDetailView: View {
    let name: String
    let description: String

    @EnvironmentObject private var follows: CommunityFollowStore

    private var posts: [FeedPost] {
        FeedPreviewData.posts.filter {
            $0.community.caseInsensitiveCompare("r/\(name)") == .orderedSame
        }
    }

    var body: some View {
        ZStack {
            OrbitTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            RoundedRectangle(cornerRadius: 17)
                                .fill(OrbitTheme.accent.opacity(0.14))
                                .frame(width: 58, height: 58)
                                .overlay {
                                    Text(String(name.prefix(1)).uppercased())
                                        .font(.title2.bold())
                                        .foregroundStyle(OrbitTheme.accent)
                                }

                            Spacer()

                            Button {
                                follows.toggle(name)
                            } label: {
                                Label(
                                    follows.contains(name) ? "Following" : "Follow",
                                    systemImage: follows.contains(name) ? "checkmark" : "plus"
                                )
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(follows.contains(name) ? OrbitTheme.primaryText : OrbitTheme.background)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(
                                    follows.contains(name) ? OrbitTheme.elevatedSurface : OrbitTheme.accent,
                                    in: Capsule()
                                )
                            }
                            .buttonStyle(.plain)
                        }

                        Text("r/\(name)")
                            .font(.title.bold())
                            .foregroundStyle(OrbitTheme.primaryText)

                        Text(description)
                            .font(.subheadline)
                            .foregroundStyle(OrbitTheme.secondaryText)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: OrbitTheme.cardRadius))

                    Text("COMMUNITY FEED")
                        .font(.caption.weight(.bold))
                        .tracking(1)
                        .foregroundStyle(OrbitTheme.secondaryText)

                    if posts.isEmpty {
                        ContentUnavailableView(
                            "No preview posts",
                            systemImage: "text.bubble",
                            description: Text("Posts from this community will appear here when live community data is connected.")
                        )
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(posts) { post in
                                NavigationLink {
                                    FeedPostDetailView(post: post)
                                } label: {
                                    FeedPostCard(post: post)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    Text("Following is stored locally on this device in this preview. Live subscription syncing will require account authorization.")
                        .font(.caption2)
                        .foregroundStyle(OrbitTheme.secondaryText)
                }
                .padding(OrbitTheme.horizontalPadding)
                .padding(.vertical, 16)
            }
        }
        .navigationTitle("r/\(name)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CommunityDetailView(name: "ios", description: "News and discussion about iOS.")
            .environmentObject(CommunityFollowStore())
            .environmentObject(BookmarkStore())
    }
}
