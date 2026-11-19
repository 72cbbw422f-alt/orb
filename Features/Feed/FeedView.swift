import SwiftUI

struct FeedView: View {
    @State private var selectedFeed = FeedCategory.home
    @State private var selectedSort = FeedSort.recommended
    @State private var selectedKind = FeedKindFilter.all
    @State private var searchText = ""

    private var visiblePosts: [FeedPost] {
        let base: [FeedPost]
        switch selectedFeed {
        case .home:
            base = FeedPreviewData.posts
        case .popular:
            base = FeedPreviewData.posts.sorted { $0.commentCount > $1.commentCount }
        case .all:
            base = Array(FeedPreviewData.posts.reversed())
        }

        let searched = base.filter { post in
            let matchesSearch = searchText.isEmpty ||
                post.title.localizedCaseInsensitiveContains(searchText) ||
                post.community.localizedCaseInsensitiveContains(searchText) ||
                post.author.localizedCaseInsensitiveContains(searchText) ||
                post.excerpt.localizedCaseInsensitiveContains(searchText)
            let matchesKind = selectedKind == .all || post.kind.rawValue == selectedKind.rawValue
            return matchesSearch && matchesKind
        }

        switch selectedSort {
        case .recommended:
            return searched
        case .mostDiscussed:
            return searched.sorted { $0.commentCount > $1.commentCount }
        case .title:
            return searched.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
    }

    var body: some View {
        ZStack {
            OrbitTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(OrbitTheme.secondaryText)
                        TextField("Search posts, communities, authors", text: $searchText)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .foregroundStyle(OrbitTheme.primaryText)
                    }
                    .padding(13)
                    .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: 14))

                    Picker("Feed", selection: $selectedFeed) {
                        ForEach(FeedCategory.allCases) { category in
                            Text(category.title).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(OrbitTheme.accent)

                    introCard

                    filterControls

                    HStack {
                        Text(selectedFeed.sectionTitle)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(OrbitTheme.primaryText)

                        Spacer()

                        Text("SAMPLE CONTENT")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .tracking(0.8)
                            .foregroundStyle(OrbitTheme.secondaryText)
                    }
                    .padding(.top, 2)

                    if visiblePosts.isEmpty {
                        ContentUnavailableView.search(text: searchText.isEmpty ? "these filters" : searchText)
                            .padding(.top, 24)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(visiblePosts) { post in
                                NavigationLink {
                                    FeedPostDetailView(post: post)
                                } label: {
                                    FeedPostCard(post: post)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    Text("Preview posts are fictional and are only here to shape the interface. Live feeds will be connected after API access is verified.")
                        .font(.caption2)
                        .foregroundStyle(OrbitTheme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 2)
                }
                .padding(.horizontal, OrbitTheme.horizontalPadding)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var filterControls: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Filter", systemImage: "line.3.horizontal.decrease")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(OrbitTheme.secondaryText)
                Spacer()
                Menu {
                    Picker("Sort posts", selection: $selectedSort) {
                        ForEach(FeedSort.allCases) { sort in
                            Text(sort.title).tag(sort)
                        }
                    }
                } label: {
                    Label(selectedSort.title, systemImage: "arrow.up.arrow.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(OrbitTheme.accent)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(FeedKindFilter.allCases) { filter in
                        Button {
                            selectedKind = filter
                        } label: {
                            Text(filter.title)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(selectedKind == filter ? OrbitTheme.background : OrbitTheme.secondaryText)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    selectedKind == filter ? OrbitTheme.accent : OrbitTheme.elevatedSurface,
                                    in: Capsule()
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(14)
        .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: 14))
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("ORBIT")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .tracking(2.4)
                    .foregroundStyle(OrbitTheme.primaryText)

                Text("The internet, in your orbit.")
                    .font(.caption)
                    .foregroundStyle(OrbitTheme.secondaryText)
            }

            Spacer()

            Image(systemName: "circle.hexagongrid.fill")
                .font(.system(size: 25, weight: .medium))
                .foregroundStyle(OrbitTheme.accent)
                .frame(width: 48, height: 48)
                .background(OrbitTheme.elevatedSurface, in: Circle())
                .accessibilityHidden(true)
        }
    }

    private var introCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(OrbitTheme.accent)
                .frame(width: 44, height: 44)
                .background(OrbitTheme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {
                Text("A calmer way to keep up")
                    .font(.headline)
                    .foregroundStyle(OrbitTheme.primaryText)

                Text("Your communities. Your pace. Your rules.")
                    .font(.caption)
                    .foregroundStyle(OrbitTheme.secondaryText)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: OrbitTheme.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: OrbitTheme.cardRadius)
                .stroke(OrbitTheme.separator, lineWidth: 1)
        }
    }
}

private enum FeedCategory: String, CaseIterable, Identifiable {
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

private enum FeedSort: String, CaseIterable, Identifiable {
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

private enum FeedKindFilter: String, CaseIterable, Identifiable {
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
