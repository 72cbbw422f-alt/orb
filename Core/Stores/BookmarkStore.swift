import Foundation
import SwiftUI

@MainActor
final class BookmarkStore: ObservableObject {
    @Published private(set) var savedIDs: Set<UUID> = []

    private let storageKey = "orbit.savedPostIDs"

    init() {
        let values = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        savedIDs = Set(values.compactMap(UUID.init(uuidString:)))
    }

    func contains(_ post: FeedPost) -> Bool {
        savedIDs.contains(post.id)
    }

    func toggle(_ post: FeedPost) {
        if savedIDs.contains(post.id) {
            savedIDs.remove(post.id)
        } else {
            savedIDs.insert(post.id)
        }

        UserDefaults.standard.set(savedIDs.map(\.uuidString), forKey: storageKey)
    }
}
