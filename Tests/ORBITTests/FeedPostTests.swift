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
}
