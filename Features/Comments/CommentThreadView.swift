import SwiftUI

struct CommentThreadView: View {
    let post: FeedPost

    @State private var comments = PreviewComment.samples
    @State private var sort: CommentSort = .top
    @State private var draft = ""
    @State private var replyTarget: Int?
    @State private var replyAuthor: String?
    @State private var nextCommentID = 100

    private var orderedComments: [PreviewComment] {
        switch sort {
        case .top:
            comments.sorted { $0.score > $1.score }
        case .newest:
            comments.sorted { $0.id > $1.id }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Comments")
                        .font(.title3.bold())
                        .foregroundStyle(OrbitTheme.primaryText)
                    Text("\(comments.count) top-level contributions · preview")
                        .font(.caption)
                        .foregroundStyle(OrbitTheme.secondaryText)
                }

                Spacer()

                Picker("Sort comments", selection: $sort) {
                    ForEach(CommentSort.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .tint(OrbitTheme.accent)
            }

            VStack(spacing: 0) {
                ForEach(orderedComments) { comment in
                    CommentRow(comment: comment, depth: 0) { selected in
                        replyTarget = selected.id
                        replyAuthor = selected.author
                    }
                    .padding(.vertical, 12)

                    if comment.id != orderedComments.last?.id {
                        Rectangle()
                            .fill(OrbitTheme.separator)
                            .frame(height: 1)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                if let replyAuthor {
                    HStack {
                        Text("Replying to u/\(replyAuthor)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(OrbitTheme.accent)
                        Spacer()
                        Button("Cancel") {
                            replyTarget = nil
                            self.replyAuthor = nil
                        }
                        .font(.caption)
                        .foregroundStyle(OrbitTheme.secondaryText)
                    }
                }

                HStack(alignment: .bottom, spacing: 10) {
                    TextField(replyTarget == nil ? "Add a comment…" : "Write a reply…", text: $draft, axis: .vertical)
                        .lineLimit(1...4)
                        .padding(12)
                        .background(OrbitTheme.elevatedSurface, in: RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(OrbitTheme.primaryText)

                    Button(action: submitComment) {
                        Image(systemName: "arrow.up")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(OrbitTheme.background)
                            .frame(width: 42, height: 42)
                            .background(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? OrbitTheme.secondaryText : OrbitTheme.accent, in: Circle())
                    }
                    .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .buttonStyle(.plain)
                    .accessibilityLabel("Post preview comment")
                }

                Text("Comments are local preview data. Posting to a live account will be enabled only through approved API access.")
                    .font(.caption2)
                    .foregroundStyle(OrbitTheme.secondaryText)
            }
            .padding(14)
            .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: 16))
        }
    }

    private func submitComment() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let newComment = PreviewComment(
            id: nextCommentID,
            author: "you_preview",
            age: "just now",
            body: text,
            score: 1,
            replies: []
        )
        nextCommentID += 1

        if let replyTarget {
            _ = appendReply(to: &comments, targetID: replyTarget, comment: newComment)
        } else {
            comments.insert(newComment, at: 0)
        }

        draft = ""
        self.replyTarget = nil
        replyAuthor = nil
    }

    private func appendReply(to items: inout [PreviewComment], targetID: Int, comment: PreviewComment) -> Bool {
        for index in items.indices {
            if items[index].id == targetID {
                items[index].replies.append(comment)
                return true
            }
            if appendReply(to: &items[index].replies, targetID: targetID, comment: comment) {
                return true
            }
        }
        return false
    }
}

private enum CommentSort: String, CaseIterable, Identifiable {
    case top
    case newest

    var id: String { rawValue }

    var title: String {
        switch self {
        case .top: "Top"
        case .newest: "Newest"
        }
    }
}

private struct PreviewComment: Identifiable, Equatable {
    let id: Int
    let author: String
    let age: String
    let body: String
    let score: Int
    var replies: [PreviewComment]

    static let samples = [
        PreviewComment(
            id: 1,
            author: "pixelperfect",
            age: "18 min",
            body: "The details that matter most are usually the ones you barely notice: consistent spacing, responsive feedback and transitions that explain what just happened.",
            score: 128,
            replies: [
                PreviewComment(
                    id: 2,
                    author: "swiftcurious",
                    age: "12 min",
                    body: "Exactly. Good motion design makes the interface feel predictable instead of decorative.",
                    score: 46,
                    replies: []
                )
            ]
        ),
        PreviewComment(
            id: 3,
            author: "tapfeedback",
            age: "32 min",
            body: "Haptics used sparingly. A tiny confirmation on a meaningful action can make an app feel much more considered.",
            score: 84,
            replies: []
        ),
        PreviewComment(
            id: 4,
            author: "readabilityfirst",
            age: "51 min",
            body: "Typography and line length. If reading feels effortless, I forgive a lot of missing bells and whistles.",
            score: 61,
            replies: []
        )
    ]
}

private struct CommentRow: View {
    let comment: PreviewComment
    let depth: Int
    let onReply: (PreviewComment) -> Void

    @State private var isCollapsed = false
    @State private var vote = 0

    private var displayedScore: Int { comment.score + vote }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 7) {
                Circle()
                    .fill(OrbitTheme.accent.opacity(0.18))
                    .frame(width: 25, height: 25)
                    .overlay {
                        Text(String(comment.author.prefix(1)).uppercased())
                            .font(.caption2.bold())
                            .foregroundStyle(OrbitTheme.accent)
                    }

                Text("u/\(comment.author)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(OrbitTheme.primaryText)

                Text("· \(comment.age)")
                    .font(.caption2)
                    .foregroundStyle(OrbitTheme.secondaryText)

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        isCollapsed.toggle()
                    }
                } label: {
                    Image(systemName: isCollapsed ? "chevron.down" : "chevron.up")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(OrbitTheme.secondaryText)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isCollapsed ? "Expand thread" : "Collapse thread")
            }

            if !isCollapsed {
                Text(comment.body)
                    .font(.subheadline)
                    .foregroundStyle(OrbitTheme.primaryText.opacity(0.92))
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 18) {
                    Button {
                        vote = vote == 1 ? 0 : 1
                    } label: {
                        Label("\(displayedScore)", systemImage: vote == 1 ? "arrow.up.circle.fill" : "arrow.up.circle")
                            .foregroundStyle(vote == 1 ? OrbitTheme.accent : OrbitTheme.secondaryText)
                    }
                    .buttonStyle(.plain)

                    Button {
                        onReply(comment)
                    } label: {
                        Label("Reply", systemImage: "arrowshape.turn.up.left")
                            .foregroundStyle(OrbitTheme.secondaryText)
                    }
                    .buttonStyle(.plain)

                    if !comment.replies.isEmpty {
                        Text("\(comment.replies.count) repl\(comment.replies.count == 1 ? "y" : "ies")")
                            .foregroundStyle(OrbitTheme.secondaryText)
                    }
                }
                .font(.caption.weight(.medium))

                if !comment.replies.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(comment.replies) { reply in
                            CommentRow(comment: reply, depth: depth + 1, onReply: onReply)
                                .padding(.top, 12)
                        }
                    }
                    .padding(.leading, 13)
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(OrbitTheme.separator)
                            .frame(width: 2)
                    }
                }
            }
        }
        .padding(.leading, CGFloat(depth) * 12)
    }
}

#Preview {
    ScrollView {
        CommentThreadView(post: FeedPreviewData.posts[0])
            .padding()
    }
    .background(OrbitTheme.background)
}
