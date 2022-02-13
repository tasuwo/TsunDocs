//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI
import TagKit

struct TsundocList: View {
    // MARK: - Properties

    let title: String
    let emptyTitle: String
    let emptyMessage: String?

    @StateObject var store: ViewStore<TsundocListState, TsundocListAction, TsundocListDependency>

    @Environment(\.openURL) var openURL
    @Environment(\.tagControlViewStoreBuilder) var tagControlViewStoreBuilder: TagControlViewStoreBuildable
    @Environment(\.tsundocInfoViewStoreBuilder) var tsundocInfoViewStoreBuilder

    // MARK: - View

    var body: some View {
        ZStack {
            if store.state.tsundocs.isEmpty {
                EmptyMessageView(emptyTitle, message: emptyMessage)
            } else {
                List(store.state.tsundocs) { tsundoc in
                    cell(tsundoc)
                        .swipeActions(edge: .leading) {
                            Button(role: .none) {
                                withAnimation {
                                    store.execute(.toggleUnread(tsundoc))
                                }
                            } label: {
                                if tsundoc.isUnread {
                                    Label(L10n.tsundocListSwipeActionToggleUnreadRead, systemImage: "envelope.open")
                                } else {
                                    Label(L10n.tsundocListSwipeActionToggleUnreadUnread, systemImage: "envelope.badge")
                                }
                            }
                            .tint(.accentColor)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                withAnimation {
                                    store.execute(.delete(tsundoc))
                                }
                            } label: {
                                Label(L10n.tsundocListSwipeActionDelete, systemImage: "trash")
                            }
                        }
                }
            }
        }
        .background(
            NavigationLink(destination: browseView(),
                           isActive: store.bind(\.isBrowseActive,
                                                action: { _ in .navigation(.deactivated(.browse)) })) {
                EmptyView()
            }
        )
        .background(
            NavigationLink(destination: infoView(),
                           isActive: store.bind(\.isEditActive,
                                                action: { _ in .navigation(.deactivated(.edit)) })) {
                EmptyView()
            }
        )
        .navigationTitle(title)
        .sheet(isPresented: store.bind(\.isModalPresenting, action: { _ in .dismissModal })) {
            switch store.state.modal {
            case let .tagAdditionView(tsundocId, tagIds):
                TagMultiSelectionSheet(selectedIds: Set(tagIds),
                                       viewStore: tagControlViewStoreBuilder.buildTagControlViewStore()) {
                    store.execute(.selectTags(Set($0.map(\.id)), tsundocId))
                }

            case .none:
                EmptyView()
            }
        }
        .alert(isPresented: store.bind(\.isAlertPresenting, action: { _ in .alert(.dismissed) })) {
            switch store.state.alert {
            case .plain(.failedToDelete):
                return Alert(title: Text(L10n.tsundocListErrorTitleDelete))

            case .plain(.failedToUpdate):
                return Alert(title: Text(L10n.tsundocListErrorTitleUpdate))

            case .confirmation, .none:
                fatalError("Invalid Alert")
            }
        }
        .onAppear {
            store.execute(.onAppear)
        }
    }

    @ViewBuilder
    private func cell(_ tsundoc: Tsundoc) -> some View {
        TsundocCell(tsundoc: tsundoc)
            .contentShape(Rectangle())
            .onTapGesture {
                store.execute(.select(tsundoc))
            }
            .contextMenu {
                menu(tsundoc)
            }
            .confirmationDialog(
                Text(L10n.tsundocListAlertDeleteTsundocMessage),
                isPresented: store.bind {
                    $0.deletingTsundocId == tsundoc.id
                } action: { _ in
                    .alert(.dismissed)
                },
                titleVisibility: .visible
            ) {
                deleteConfirmationDialog(tsundoc)
            }
    }

    @ViewBuilder
    private func menu(_ tsundoc: Tsundoc) -> some View {
        Button {
            store.execute(.tap(tsundoc.id, .editInfo))
        } label: {
            Label {
                Text(L10n.tsundocListMenuInfo)
            } icon: {
                Image(systemName: "pencil")
            }
        }

        Button {
            store.execute(.tap(tsundoc.id, .addTag))
        } label: {
            Label {
                Text(L10n.tsundocListMenuAddTag)
            } icon: {
                Image(systemName: "tag")
            }
        }

        Button {
            store.execute(.tap(tsundoc.id, .copyUrl))
        } label: {
            Label {
                Text(L10n.tsundocListMenuCopyUrl)
            } icon: {
                Image(systemName: "doc.on.doc")
            }
        }

        Button {
            openURL(tsundoc.url)
        } label: {
            Label {
                Text(L10n.tsundocListMenuOpenSafari)
            } icon: {
                Image(systemName: "safari")
            }
        }

        Divider()

        Button(role: .destructive) {
            store.execute(.tap(tsundoc.id, .delete))
        } label: {
            Label {
                Text(L10n.tsundocListMenuDelete)
            } icon: {
                Image(systemName: "trash")
            }
        }
    }

    @ViewBuilder
    private func deleteConfirmationDialog(_ tsundoc: Tsundoc) -> some View {
        Button(L10n.tsundocListAlertDeleteTsundocAction, role: .destructive) {
            store.execute(.alert(.confirmedToDelete(tsundoc.id)))
        }

        Button(L10n.cancel, role: .cancel) {
            store.execute(.alert(.dismissed))
        }
    }

    @ViewBuilder
    private func browseView() -> some View {
        if case let .browse(tsundoc, isEditing: _) = store.state.navigation {
            BrowseView(baseUrl: tsundoc.url) {
                store.execute(.tap(tsundoc.id, .editInfo))
            } onBack: {
                store.execute(.navigation(.deactivated(.browse)))
            }
            .background(
                NavigationLink(destination: infoView(),
                               isActive: store.bind(\.isBrowseAndEditActive,
                                                    action: { _ in .navigation(.deactivated(.browseAndEdit)) })) {
                    EmptyView()
                }
            )
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func infoView() -> some View {
        switch store.state.navigation {
        case let .edit(tsundoc),
             .browse(let tsundoc, isEditing: true):
            let store = tsundocInfoViewStoreBuilder.buildTsundocInfoViewStore(tsundoc: tsundoc)
            TsundocInfoView(store: store)
                .navigationBarTitleDisplayMode(.inline)

        default:
            EmptyView()
        }
    }
}

// MARK: - Preview

#if DEBUG
import PreviewContent
#endif

struct TsundocList_Previews: PreviewProvider {
    class DummyDependency: TsundocListDependency {
        var tagQueryService: TagQueryService {
            TagQueryServiceMock()
        }

        var pasteboard: Pasteboard {
            PasteboardMock()
        }

        var tsundocCommandService: TsundocCommandService {
            let service = TsundocCommandServiceMock()
            service.beginHandler = {}
            service.commitHandler = {}
            service.deleteTsundocHandler = { _ in .success(()) }
            return service
        }

        var tsundocQueryService: TsundocQueryService {
            let tsundocs: [Tsundoc] = [
                // swiftlint:disable:next force_unwrapping
                .makeDefault(title: "hoge", url: URL(string: "https://www.apple.com")!, emojiAlias: "+1"),
                // swiftlint:disable:next force_unwrapping
                .makeDefault(title: "fuga", url: URL(string: "https://www.apple.com")!, emojiAlias: "smile"),
                // swiftlint:disable:next force_unwrapping
                .makeDefault(title: "piyo", url: URL(string: "https://www.apple.com")!, emojiAlias: "ghost")
            ]
            let entities = ObservedTsundocArrayMock(values: .init(tsundocs))
                .eraseToAnyObservedEntityArray()
            let service = TsundocQueryServiceMock()
            service.queryAllTsundocsHandler = {
                return .success(entities)
            }
            return service
        }
    }

    static var previews: some View {
        let store = Store(initialState: TsundocListState(query: .all),
                          dependency: DummyDependency(),
                          reducer: TsundocListReducer())
        let viewStore = ViewStore(store: store)
        NavigationView {
            TsundocList(title: L10n.tsundocListTitle,
                        emptyTitle: L10n.tsundocListEmptyMessageDefaultTitle,
                        emptyMessage: L10n.tsundocListEmptyMessageDefaultMessage,
                        store: viewStore)
        }
    }
}
