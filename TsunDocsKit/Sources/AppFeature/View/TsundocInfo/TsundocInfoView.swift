//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TagKit
import TsundocList

struct TsundocInfoView: View {
    typealias Store = ViewStore<
        TsundocInfoViewState,
        TsundocInfoViewAction,
        TsundocInfoViewDependency
    >

    // MARK: - Properties

    @StateObject var store: Store

    @State private var isTagEditSheetPresenting = false

    @Environment(\.tagControlViewStoreBuilder) var tagControlViewStoreBuilder: TagControlViewStoreBuildable

    // MARK: - View

    var body: some View {
        VStack {
            TsundocMetaContainer(url: store.state.tsundoc.url,
                                 imageUrl: store.state.tsundoc.imageUrl,
                                 title: store.bindTitle(),
                                 selectedEmojiInfo: store.bindEmojiInfo())

            Divider()

            tagContainer()

            Spacer()
        }
        .sheet(isPresented: $isTagEditSheetPresenting) {
            TagMultiSelectionSheet(selectedIds: Set(store.state.tags.map(\.id)),
                                   viewStore: tagControlViewStoreBuilder.buildTagControlViewStore()) {
                isTagEditSheetPresenting = false
                store.execute(.editTags($0))
            }
        }
        .onAppear {
            store.execute(.onAppear)
        }
    }

    @MainActor
    @ViewBuilder
    func tagContainer() -> some View {
        VStack {
            HStack {
                Text(L10n.tsundocInfoViewTag)

                Spacer()

                Image(systemName: "plus")
                    .foregroundColor(.cyan)
                    .font(.system(size: 24))
                    .onTapGesture {
                        isTagEditSheetPresenting = true
                    }
            }

            if !store.state.tags.isEmpty {
                TagGrid(tags: store.state.tags,
                        selectedIds: .init(),
                        configuration: .init(.deletable, size: .normal, isEnabledMenu: false),
                        inset: 0) { action in
                    switch action {
                    case let .delete(tagId: tagId):
                        store.execute(.deleteTag(tagId), animation: .default)

                    default:
                        // NOP
                        break
                    }
                }
            } else {
                Spacer()
            }
        }
        .padding([.leading, .trailing], TsundocEditThumbnail.padding)
    }
}

// MARK: - Bind

extension ViewStore where Action == TsundocInfoViewAction, State == TsundocInfoViewState, Dependency == TsundocInfoViewDependency {
    func bindTitle() -> Binding<String> {
        bind { $0.tsundoc.title } action: { .editTitle($0) }
    }

    func bindEmojiInfo() -> Binding<EmojiInfo?> {
        bind {
            guard let emoji = $0.tsundoc.emoji else { return nil }
            return EmojiInfo(emoji: emoji, backgroundColor: $0.tsundoc.emojiBackgroundColor ?? .default)
        } action: {
            .editEmojiInfo($0)
        }
    }

    func bindTags() -> Binding<[Tag]> {
        bind { $0.tags } action: { .editTags($0) }
    }
}

// MARK: - Previews

#if DEBUG
import PreviewContent
#endif

struct TsundocInfoView_Previews: PreviewProvider {
    class Dependency: TsundocInfoViewDependency {
        var allTags: AnyObservedEntityArray<Tag> = {
            let tags: [Tag] = [
                .init(id: UUID(), name: "This"),
                .init(id: UUID(), name: "is"),
                .init(id: UUID(), name: "Flexible"),
                .init(id: UUID(), name: "Gird"),
                .init(id: UUID(), name: "Layout"),
                .init(id: UUID(), name: "for"),
                .init(id: UUID(), name: "Tags."),
                .init(id: UUID(), name: "This"),
                .init(id: UUID(), name: "Layout"),
                .init(id: UUID(), name: "allows"),
                .init(id: UUID(), name: "displaying"),
                .init(id: UUID(), name: "very"),
                .init(id: UUID(), name: "long"),
                .init(id: UUID(), name: "tag"),
                .init(id: UUID(), name: "names"),
                .init(id: UUID(), name: "like"),
                .init(id: UUID(), name: "Too Too Too Too Long Tag"),
                .init(id: UUID(), name: "or"),
                .init(id: UUID(), name: "Toooooooooooooo Loooooooooooooooooooooooong Tag."),
                .init(id: UUID(), name: "All"),
                .init(id: UUID(), name: "cell"),
                .init(id: UUID(), name: "sizes"),
                .init(id: UUID(), name: "are"),
                .init(id: UUID(), name: "flexible")
            ]
            return ObservedTagArrayMock(values: .init(tags))
                .eraseToAnyObservedEntityArray()
        }()

        var tags: AnyObservedEntityArray<Tag> = {
            let tags: [Tag] = [
                .init(id: UUID(), name: "This"),
                .init(id: UUID(), name: "is"),
                .init(id: UUID(), name: "Flexible"),
                .init(id: UUID(), name: "Gird"),
                .init(id: UUID(), name: "Layout"),
            ]
            return ObservedTagArrayMock(values: .init(tags))
                .eraseToAnyObservedEntityArray()
        }()

        public var tagCommandService: TagCommandService {
            let service = TagCommandServiceMock()
            service.performHandler = { $0() }
            service.beginHandler = {}
            service.commitHandler = {}
            service.createTagHandler = { [unowned self] _ in
                let id = UUID()
                let newTag = Tag(id: id,
                                 name: String(UUID().uuidString.prefix(5)),
                                 tsundocsCount: 5)

                let values = self.tags.values.value
                self.tags.values.send(values + [newTag])

                return .success(id)
            }
            return service
        }

        public var tagQueryService: TagQueryService {
            let service = TagQueryServiceMock()
            service.queryAllTagsHandler = { [unowned self] in
                .success(self.allTags)
            }
            service.queryTagsHandler = { [unowned self] _ in
                .success(self.tags)
            }
            return service
        }

        public var tsundocCommandService: TsundocCommandService {
            let service = TsundocCommandServiceMock()
            service.performHandler = { $0() }
            service.beginHandler = {}
            service.commitHandler = {}
            service.updateTsundocHandler = { _, _ in return .success(()) }
            service.updateTsundocHavingHandler = { _, _, _ in return .success(()) }
            service.updateTsundocHavingByRemovingTagHavingHandler = { _, _ in return .success(()) }
            service.updateTsundocHavingByReplacingTagsHavingHandler = { _, _ in return .success(()) }
            return service
        }

        public var tsundocQueryService: TsundocQueryService {
            let service = TsundocQueryServiceMock()
            service.queryTsundocHandler = { _ in
                .success(ObservedTsundocMock(value: .init(Tsundoc.makeDefault())).eraseToAnyObservedEntity())
            }
            return service
        }
    }

    static var previews: some View {
        let store = Store(initialState: TsundocInfoViewState(tsundoc: .makeDefault(),
                                                             tags: [.makeDefault()]),
                          dependency: Dependency(),
                          reducer: TsundocInfoViewReducer())
        TsundocInfoView(store: ViewStore(store: store))
            .environment(\.tagControlViewStoreBuilder, TagControlViewStoreBuilderMock())
    }
}
