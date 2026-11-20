import Combine
import Foundation

enum FeedLoadState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case failed(String)
}

@MainActor
final class FeedViewModel: ObservableObject {
    @Published private(set) var posts: [FeedPost] = []
    @Published private(set) var state: FeedLoadState = .idle
    @Published private(set) var isRefreshing = false

    private let repository: any FeedRepository
    private var activeRequestID: UUID?

    init(repository: any FeedRepository) {
        self.repository = repository
    }

    func loadIfNeeded() async {
        guard state == .idle else { return }
        await load()
    }

    func load() async {
        await fetch(isRefresh: false)
    }

    func refresh() async {
        await fetch(isRefresh: true)
    }

    func visiblePosts(for query: FeedQuery) -> [FeedPost] {
        query.apply(to: posts)
    }

    private func fetch(isRefresh: Bool) async {
        let requestID = UUID()
        activeRequestID = requestID

        if isRefresh && !posts.isEmpty {
            isRefreshing = true
        } else {
            state = .loading
        }

        defer {
            if activeRequestID == requestID {
                isRefreshing = false
                activeRequestID = nil
            }
        }

        do {
            let fetchedPosts = try await repository.fetchPosts()
            guard activeRequestID == requestID else { return }
            guard !Task.isCancelled else {
                restoreStableStateAfterCancellation()
                return
            }

            var seenIDs = Set<FeedPost.ID>()
            posts = fetchedPosts.filter { seenIDs.insert($0.id).inserted }
            state = posts.isEmpty ? .empty : .loaded
        } catch is CancellationError {
            guard activeRequestID == requestID else { return }
            restoreStableStateAfterCancellation()
        } catch {
            guard activeRequestID == requestID, !Task.isCancelled else { return }
            state = .failed(error.localizedDescription)
        }
    }

    private func restoreStableStateAfterCancellation() {
        if posts.isEmpty {
            state = .idle
        } else {
            state = .loaded
        }
    }
}
