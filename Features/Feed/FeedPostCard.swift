import SwiftUI

struct FeedPostCard: View {
    let post: FeedPost
    @EnvironmentObject private var bookmarks: BookmarkStore
    @AppStorage("orbit.feedDensity") private var feedDensity = FeedDensity.comfortable.rawValue

    private var isCompact: Bool {
        feedDensity == FeedDensity.compact.rawValue
    }

    private var isSaved: Bool {
        bookmarks.contains(post)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 9 : 14) {
            header

            Text(post.title)
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(OrbitTheme.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Text(post.excerpt)
                .font(.subheadline)
                .foregroundStyle(OrbitTheme.secondaryText)
                .lineLimit(isCompact ? 2 : 3)
                .fixedSize(horizontal: false, vertical: true)

            footer
        }
        .padding(isCompact ? 12 : 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: OrbitTheme.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: OrbitTheme.cardRadius)
                .stroke(OrbitTheme.separator, lineWidth: 1)
        }
    }

    private var header: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(OrbitTheme.accent.opacity(0.14))
                    .frame(width: 32, height: 32)
                Image(systemName: post.kind.symbol)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(OrbitTheme.accent)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(post.community)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(OrbitTheme.primaryText)
                Text("u/\(post.author) · \(post.age)")
                    .font(.caption2)
                    .foregroundStyle(OrbitTheme.secondaryText)
            }

            Spacer()

            Text("PREVIEW")
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .tracking(0.8)
                .foregroundStyle(OrbitTheme.accent)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(OrbitTheme.accent.opacity(0.10), in: Capsule())
        }
    }

    private var footer: some View {
        HStack(spacing: 18) {
            Label(post.score, systemImage: "arrow.up")
            Label("\(post.commentCount)", systemImage: "bubble.right")
            Label(post.kind.label, systemImage: post.kind.symbol)
            Spacer()

            Button {
                bookmarks.toggle(post)
            } label: {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .foregroundStyle(isSaved ? OrbitTheme.accent : OrbitTheme.secondaryText)
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isSaved ? "Remove saved post" : "Save post")
        }
        .font(.caption.weight(.medium))
        .foregroundStyle(OrbitTheme.secondaryText)
    }
}

#Preview {
    ZStack {
        OrbitTheme.background.ignoresSafeArea()
        FeedPostCard(post: FeedPreviewData.posts[0])
            .padding()
    }
    .environmentObject(BookmarkStore())
}
