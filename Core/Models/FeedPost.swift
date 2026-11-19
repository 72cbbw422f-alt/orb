import Foundation

struct FeedPost: Identifiable, Equatable {
    let id: UUID
    let community: String
    let author: String
    let age: String
    let title: String
    let excerpt: String
    let score: String
    let commentCount: Int
    let kind: PostKind

    init(
        id: UUID = UUID(),
        community: String,
        author: String,
        age: String,
        title: String,
        excerpt: String,
        score: String,
        commentCount: Int,
        kind: PostKind
    ) {
        self.id = id
        self.community = community
        self.author = author
        self.age = age
        self.title = title
        self.excerpt = excerpt
        self.score = score
        self.commentCount = commentCount
        self.kind = kind
    }
}

enum PostKind: String, CaseIterable, Equatable {
    case discussion
    case image
    case link
    case video

    var symbol: String {
        switch self {
        case .discussion: "text.alignleft"
        case .image: "photo"
        case .link: "link"
        case .video: "play.rectangle"
        }
    }

    var label: String {
        switch self {
        case .discussion: "Discussion"
        case .image: "Image"
        case .link: "Link"
        case .video: "Video"
        }
    }
}
