import SwiftUI
import UIKit

struct FeedPostCard: View {
    let post: FeedPost
    @EnvironmentObject private var bookmarks: BookmarkStore
    @AppStorage("orbit.feedDensity") private var feedDensity = FeedDensity.comfortable.rawValue
    @AppStorage("orbit.previewUpvotedPostIDs") private var upvotedPostIDs = ""
    @AppStorage("orbit.hapticsEnabled") private var hapticsEnabled = true

    private var isCompact: Bool { feedDensity == FeedDensity.compact.rawValue }
    private var isClassic: Bool { feedDensity == FeedDensity.classic.rawValue }
    private var isSaved: Bool { bookmarks.contains(post) }
    private var isUpvoted: Bool {
        Set(upvotedPostIDs.split(separator: ",").map(String.init)).contains(post.id.uuidString)
    }
    private var cardSpacing: CGFloat { isCompact ? 8 : (isClassic ? 10 : 14) }
    private var cardPadding: CGFloat { isCompact ? 11 : (isClassic ? 13 : 16) }
    private var cardRadius: CGFloat { isClassic ? 12 : OrbitTheme.cardRadius }
    private var excerptLines: Int { isCompact || isClassic ? 2 : 3 }
    private var cardSurface: Color { isClassic ? OrbitTheme.elevatedSurface : OrbitTheme.surface }

    var body: some View {
        VStack(alignment: .leading, spacing: cardSpacing) {
            header

            Text(post.title)
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(OrbitTheme.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Text(post.excerpt)
                .font(.subheadline)
                .foregroundStyle(OrbitTheme.secondaryText)
                .lineLimit(excerptLines)
                .fixedSize(horizontal: false, vertical: true)

            footer
        }
        .padding(cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardSurface, in: RoundedRectangle(cornerRadius: cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: cardRadius)
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
            Button {
                toggleUpvote()
            } label: {
                Label(post.score, systemImage: isUpvoted ? "arrow.up.circle.fill" : "arrow.up.circle")
                    .foregroundStyle(isUpvoted ? OrbitTheme.accent : OrbitTheme.secondaryText)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isUpvoted ? "Remove preview upvote" : "Upvote preview post")

            Label("\(post.commentCount)", systemImage: "bubble.right")
            Label(post.kind.label, systemImage: post.kind.symbol)
            Spacer()

            Button {
                bookmarks.toggle(post)
                playHaptic()
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

    private func toggleUpvote() {
        var ids = Set(upvotedPostIDs.split(separator: ",").map(String.init))
        if ids.contains(post.id.uuidString) {
            ids.remove(post.id.uuidString)
        } else {
            ids.insert(post.id.uuidString)
        }
        upvotedPostIDs = ids.sorted().joined(separator: ",")
        playHaptic()
    }

    private func playHaptic() {
        guard hapticsEnabled else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
