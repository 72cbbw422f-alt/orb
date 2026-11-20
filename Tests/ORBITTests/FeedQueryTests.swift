import XCTest
@testable import ORBIT

final class FeedQueryTests: XCTestCase {
    private var posts: [FeedPost] { FeedPreviewData.posts }

    func testHomeRecommendedPreservesSourceOrder() {
        let result = query(scope: .home, sort: .recommended).apply(to: posts)
        XCTAssertEqual(result.map(\.id), posts.map(\.id))
    }

    func testPopularScopeOrdersByCommentCountDescending() {
        let result = query(scope: .popular).apply(to: posts)
        XCTAssertEqual(result.map(\.commentCount), result.map(\.commentCount).sorted(by: >))
    }

    func testAllScopeReversesSourceOrder() {
        let result = query(scope: .all).apply(to: posts)
        XCTAssertEqual(result.map(\.id), posts.reversed().map(\.id))
    }

    func testKindFilterReturnsOnlyMatchingPostType() {
        let result = query(kind: .image).apply(to: posts)
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.allSatisfy { $0.kind == .image })
    }

    func testWhitespaceOnlySearchBehavesLikeAnEmptyQuery() {
        let result = query(search: "  \n\t ").apply(to: posts)
        XCTAssertEqual(result.map(\.id), posts.map(\.id))
    }

    func testSearchMatchesTitleCommunityAuthorAndExcerpt() {
        for post in posts {
            XCTAssertTrue(query(search: post.title).apply(to: posts).contains { $0.id == post.id })
            XCTAssertTrue(query(search: post.community).apply(to: posts).contains { $0.id == post.id })
            XCTAssertTrue(query(search: post.author).apply(to: posts).contains { $0.id == post.id })
            XCTAssertTrue(query(search: post.excerpt).apply(to: posts).contains { $0.id == post.id })
        }
    }

    func testMostDiscussedSortIsDescendingAndStableForTies() {
        let input = Array(posts.reversed())
        let result = query(sort: .mostDiscussed).apply(to: input)
        XCTAssertEqual(result.map(\.commentCount), result.map(\.commentCount).sorted(by: >))
        for count in Set(input.map(\.commentCount)) {
            XCTAssertEqual(
                result.filter { $0.commentCount == count }.map(\.id),
                input.filter { $0.commentCount == count }.map(\.id)
            )
        }
    }

    func testTitleSortIsCaseInsensitiveAndStableForEqualTitles() {
        let result = query(sort: .title).apply(to: posts)
        XCTAssertEqual(
            result.map(\.title),
            result.map(\.title).sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        )
    }

    private func query(
        scope: FeedCategory = .home,
        sort: FeedSort = .recommended,
        kind: FeedKindFilter = .all,
        search: String = ""
    ) -> FeedQuery {
        FeedQuery(scope: scope, sort: sort, kind: kind, searchText: search)
    }
}
