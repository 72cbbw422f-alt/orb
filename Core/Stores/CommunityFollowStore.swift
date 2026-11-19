import Foundation
import SwiftUI

@MainActor
final class CommunityFollowStore: ObservableObject {
    @Published private(set) var followedNames: Set<String> = []

    private let storageKey = "orbit.followedCommunities"

    init() {
        followedNames = Set(UserDefaults.standard.stringArray(forKey: storageKey) ?? [])
    }

    func contains(_ name: String) -> Bool {
        followedNames.contains(name.lowercased())
    }

    func toggle(_ name: String) {
        let key = name.lowercased()
        if followedNames.contains(key) {
            followedNames.remove(key)
        } else {
            followedNames.insert(key)
        }
        UserDefaults.standard.set(Array(followedNames).sorted(), forKey: storageKey)
    }
}
