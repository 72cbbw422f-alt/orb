import Foundation

enum FeedCategory: String, CaseIterable, Identifiable {
    case home
    case popular
    case all

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .popular: "Popular"
        case .all: "All"
        }
    }

    var sectionTitle: String {
        switch self {
        case .home: "Your feed"
        case .popular: "Popular now"
        case .all: "Explore all"
        }
    }
}

enum FeedSort: String, CaseIterable, Identifiable {
    case recommended
    case mostDiscussed
    case title

    var id: String { rawValue }
    var title: String {
        switch self {
        case .recommended: "Recommended"
        case .mostDiscussed: "Most discussed"
        case .title: "Title A–Z"
        }
    }
}

enum FeedKindFilter: String, CaseIterable, Identifiable {
    case all
    case discussion
    case image
    case link
    case video

    var id: String { rawValue }
    var title: String {
        switch self {
        case .all: "All"
        case .discussion: "Text"
        case .image: "Images"
        case .link: "Links"
        case .video: "Video"
        }
    }
}

/// Pure feed-query logic. Keeps presentation state in SwiftUI and makes
/// filtering and ordering deterministic and independently testable.
struct FeedQuery {
    var scope: FeedCategory
    var sort: FeedSort
    var kind: FeedKindFilter
    var searchText: String

    func apply(to posts: [FeedPost]) -> [FeedPost] {
        let scopedPosts: [FeedPost]
        switch scope {
        case .home:
            scopedPosts = posts
        case .popular:
            scopedPosts = posts.enumerated()
                .sorted {
                    if $0.element.commentCount == $1.element.commentCount {
                        return $0.offset < $1.offset
                    }
                    return $0.element.commentCount > $1.element.commentCount
                }
                .map(\.element)
        case .all:
            scopedPosts = Array(posts.reversed())
        }

        let normalizedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let filtered = scopedPosts.filter { post in
            let matchesSearch = normalizedSearch.isEmpty ||
                post.title.localizedCaseInsensitiveContains(normalizedSearch) ||
                post.community.localizedCaseInsensitiveContains(normalizedSearch) ||
                post.author.localizedCaseInsensitiveContains(normalizedSearch) ||
                post.excerpt.localizedCaseInsensitiveContains(normalizedSearch)
            let matchesKind = kind == .all || post.kind.rawValue == kind.rawValue
            return matchesSearch && matchesKind
        }

        switch sort {
        case .recommended:
            return filtered
        case .mostDiscussed:
            return filtered.enumerated()
                .sorted {
                    if $0.element.commentCount == $1.element.commentCount {
                        return $0.offset < $1.offset
                    }
                    return $0.element.commentCount > $1.element.commentCount
                }
                .map(\.element)
        case .title:
            return filtered.enumerated()
                .sorted {
                    let comparison = $0.element.title.localizedCaseInsensitiveCompare($1.element.title)
                    return comparison == .orderedSame ? $0.offset < $1.offset : comparison == .orderedAscending
                }
                .map(\.element)
        }
    }
}
