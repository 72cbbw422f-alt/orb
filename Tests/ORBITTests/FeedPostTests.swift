import XCTest
@testable import ORBIT

final class FeedPostTests: XCTestCase {
    func testPostKindHasDisplayMetadata() {
        XCTAssertEqual(PostKind.discussion.symbol, "text.alignleft")
        XCTAssertEqual(PostKind.image.label, "Image")
        XCTAssertEqual(PostKind.video.label, "Video")
    }

    func testPreviewFeedContainsDistinctPosts() {
        let posts = FeedPreviewData.posts

        XCTAssertFalse(posts.isEmpty)
        XCTAssertEqual(Set(posts.map(\.id)).count, posts.count)
        XCTAssertTrue(posts.allSatisfy { !$0.title.isEmpty })
    }

    func testPreviewPostIdentifiersRemainStable() {
        XCTAssertEqual(
            FeedPreviewData.posts.map(\.id.uuidString),
            [
                "A1000000-0000-4000-8000-000000000001",
                "A1000000-0000-4000-8000-000000000002",
                "A1000000-0000-4000-8000-000000000003"
            ]
        )
    }
}
