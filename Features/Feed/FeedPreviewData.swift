import Foundation

enum FeedPreviewData {
    /// Clearly synthetic content used only to develop and preview the interface.
    static let posts: [FeedPost] = [
        FeedPost(
            community: "r/ios",
            author: "preview_author",
            age: "12 min",
            title: "What small iOS detail makes an app feel truly polished?",
            excerpt: "The tiny interactions, transitions and thoughtful defaults that make the difference.",
            score: "2.4k",
            commentCount: 184,
            kind: .discussion
        ),
        FeedPost(
            community: "r/technology",
            author: "preview_author",
            age: "38 min",
            title: "A calmer, more intentional way to follow the topics you care about",
            excerpt: "A concept post used to test typography, spacing and long-form card behavior.",
            score: "986",
            commentCount: 72,
            kind: .link
        ),
        FeedPost(
            community: "r/design",
            author: "preview_author",
            age: "1 hr",
            title: "Show us the interface details you keep coming back to",
            excerpt: "A visual-first post placeholder for the future image and gallery experience.",
            score: "741",
            commentCount: 49,
            kind: .image
        )
    ]
}
