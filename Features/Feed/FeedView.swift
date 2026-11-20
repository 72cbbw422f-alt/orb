import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel: FeedViewModel
    @State private var selectedFeed = FeedCategory.home
    @State private var selectedSort = FeedSort.recommended
    @State private var selectedKind = FeedKindFilter.all
    @State private var searchText = ""

    init(repository: any FeedRepository = PreviewFeedRepository()) {
        _viewModel = StateObject(wrappedValue: FeedViewModel(repository: repository))
    }

    private var feedQuery: FeedQuery {
        FeedQuery(
            scope: selectedFeed,
            sort: selectedSort,
            kind: selectedKind,
            searchText: searchText
        )
    }

    private var visiblePosts: [FeedPost] {
        viewModel.visiblePosts(for: feedQuery)
    }

    var body: some View {
        ZStack {
            OrbitTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    searchField

                    Picker("Feed", selection: $selectedFeed) {
                        ForEach(FeedCategory.allCases) { category in
                            Text(category.title).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(OrbitTheme.accent)

                    introCard
                    filterControls
                    feedHeading
                    feedContent

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
            .refreshable {
                await viewModel.refresh()
            }
        }
        .task {
            await viewModel.loadIfNeeded()
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var searchField: some View {
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
    }

    private var feedHeading: some View {
        HStack {
            Text(selectedFeed.sectionTitle)
                .font(.title3.weight(.bold))
                .foregroundStyle(OrbitTheme.primaryText)

            Spacer()

            Text("PREVIEW SOURCE")
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .tracking(0.8)
                .foregroundStyle(OrbitTheme.secondaryText)
        }
        .padding(.top, 2)
    }

    @ViewBuilder
    private var feedContent: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading feed…")
                .tint(OrbitTheme.accent)
                .foregroundStyle(OrbitTheme.secondaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 36)

        case .empty:
            ContentUnavailableView(
                "No posts yet",
                systemImage: "text.bubble",
                description: Text("This feed did not return any posts. Pull to refresh to try again.")
            )
            .padding(.top, 20)

        case .failed(let message) where viewModel.posts.isEmpty:
            ContentUnavailableView {
                Label("Couldn't load feed", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Try again") {
                    Task { await viewModel.load() }
                }
                .buttonStyle(.borderedProminent)
                .tint(OrbitTheme.accent)
            }
            .padding(.top, 20)

        case .loaded, .failed:
            if case .failed(let message) = viewModel.state {
                Label(message, systemImage: "exclamationmark.triangle")
                    .font(.caption)
                    .foregroundStyle(OrbitTheme.secondaryText)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(OrbitTheme.surface, in: RoundedRectangle(cornerRadius: 12))
            }

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
        }
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
