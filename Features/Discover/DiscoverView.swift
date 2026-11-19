import SwiftUI

struct DiscoverView: View {
    @State private var searchText = ""
    @EnvironmentObject private var follows: CommunityFollowStore

    private let communities = [
        CommunityPreview(name: "iOS", category: "Apple & software", members: "4.2M", description: "News, questions and discussion about Apple's mobile platform."),
        CommunityPreview(name: "technology", category: "Technology", members: "18.7M", description: "Technology news, analysis and conversation."),
        CommunityPreview(name: "design", category: "Design", members: "2.1M", description: "Digital products, visual design and creative process."),
        CommunityPreview(name: "apple", category: "Apple", members: "5.8M", description: "Everything across the Apple ecosystem."),
        CommunityPreview(name: "science", category: "Science", members: "33.4M", description: "Discoveries, research and scientific discussion."),
        CommunityPreview(name: "movies", category: "Film & TV", members: "34.1M", description: "Films, cinema and recommendations.")
    ]

    private var matchingCommunities: [CommunityPreview] {
        communities.filter {
            searchText.isEmpty ||
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var followedCommunities: [CommunityPreview] {
        matchingCommunities.filter { follows.contains($0.name) }
    }

    private var exploreCommunities: [CommunityPreview] {
        matchingCommunities.filter { !follows.contains($0.name) }
    }

    var body: some View {
        ZStack {
            OrbitTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Find your orbit")
                        .font(.title2.bold())
                        .foregroundStyle(OrbitTheme.primaryText)

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(OrbitTheme.secondaryText)
                        TextField("Search communities", text: $searchText)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .foregroundStyle(OrbitTheme.primaryText)
                    }
                    .padding(14)
                    .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: 14))

                    if !followedCommunities.isEmpty && searchText.isEmpty {
                        Text("YOUR COMMUNITIES")
                            .font(.caption.weight(.bold))
                            .tracking(1)
                            .foregroundStyle(OrbitTheme.secondaryText)

                        LazyVStack(spacing: 10) {
                            ForEach(followedCommunities) { community in
                                CommunityRow(community: community)
                            }
                        }
                    }

                    Text(searchText.isEmpty ? "COMMUNITIES TO EXPLORE" : "SEARCH RESULTS")
                        .font(.caption.weight(.bold))
                        .tracking(1)
                        .foregroundStyle(OrbitTheme.secondaryText)

                    if matchingCommunities.isEmpty {
                        ContentUnavailableView.search(text: searchText)
                            .padding(.top, 28)
                    } else if exploreCommunities.isEmpty && searchText.isEmpty {
                        Text("You're following every community in this preview. Search for more when live discovery is connected.")
                            .font(.subheadline)
                            .foregroundStyle(OrbitTheme.secondaryText)
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(searchText.isEmpty ? exploreCommunities : matchingCommunities) { community in
                                CommunityRow(community: community)
                            }
                        }
                    }

                    Text("Discovery is currently powered by sample data. Live community search will be connected through the approved API.")
                        .font(.caption2)
                        .foregroundStyle(OrbitTheme.secondaryText)
                        .padding(.top, 4)
                }
                .padding(.horizontal, OrbitTheme.horizontalPadding)
                .padding(.vertical, 16)
            }
        }
        .navigationTitle("Discover")
        .navigationBarTitleDisplayMode(.large)
    }
}

private struct CommunityPreview: Identifiable {
    let name: String
    let category: String
    let members: String
    let description: String
    var id: String { name }
}

private struct CommunityRow: View {
    let community: CommunityPreview

    var body: some View {
        NavigationLink {
            CommunityDetailView(name: community.name, description: community.description)
        } label: {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 13)
                    .fill(OrbitTheme.accent.opacity(0.13))
                    .frame(width: 46, height: 46)
                    .overlay {
                        Text(String(community.name.prefix(1)).uppercased())
                            .font(.headline.bold())
                            .foregroundStyle(OrbitTheme.accent)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text("r/\(community.name)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(OrbitTheme.primaryText)
                    Text(community.description)
                        .font(.caption)
                        .foregroundStyle(OrbitTheme.secondaryText)
                        .lineLimit(2)
                    Text("\(community.category) · \(community.members) members")
                        .font(.caption2)
                        .foregroundStyle(OrbitTheme.secondaryText)
                }

                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(OrbitTheme.secondaryText)
            }
            .padding(13)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: 17))
            .contentShape(RoundedRectangle(cornerRadius: 17))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        DiscoverView()
    }
    .environmentObject(CommunityFollowStore())
    .environmentObject(BookmarkStore())
}
