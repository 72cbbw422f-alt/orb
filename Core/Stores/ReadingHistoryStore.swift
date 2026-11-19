import Foundation
import SwiftUI

@MainActor
final class ReadingHistoryStore: ObservableObject {
    @Published private(set) var viewedIDs: [UUID] = []

    private let storageKey = "orbit.readingHistoryIDs"
    private let limit = 100

    init() {
        let values = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        viewedIDs = values.compactMap(UUID.init(uuidString:))
    }

    func record(_ post: FeedPost) {
        viewedIDs.removeAll { $0 == post.id }
        viewedIDs.insert(post.id, at: 0)
        if viewedIDs.count > limit {
            viewedIDs = Array(viewedIDs.prefix(limit))
        }
        UserDefaults.standard.set(viewedIDs.map(\.uuidString), forKey: storageKey)
    }

    func clear() {
        viewedIDs.removeAll()
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
