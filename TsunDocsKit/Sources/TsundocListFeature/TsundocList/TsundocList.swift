//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import BrowseView
import CompositeKit
import Domain
import Environment
import SwiftUI
import UIComponent

public struct TsundocList: View {
    public typealias Store = ViewStore<TsundocListState, TsundocListAction, TsundocListDependency>

    // MARK: - Properties

    let title: String
    let emptyTitle: String
    let emptyMessage: String?
    let isTsundocCreationEnabled: Bool

    @StateObject var store: Store

    @Environment(\.openURL) var openURL
    @Environment(\.tagMultiSelectionSheetBuilder) var tagMultiSelectionSheetBuilder
    @Environment(\.tsundocCreateViewBuilder) var tsundocCreateViewBuilder

    // MARK: - Initializers

    public init(title: String, emptyTitle: String, emptyMessage: String?, isTsundocCreationEnabled: Bool, store: Store) {
        self.title = title
        self.emptyTitle = emptyTitle
        self.emptyMessage = emptyMessage
        self.isTsundocCreationEnabled = isTsundocCreationEnabled
        _store = .init(wrappedValue: store)
    }

    // MARK: - View

    public var body: some View {
        ZStack {
            if store.state.filteredTsundocs.isEmpty {
                if store.state.isTsundocFilterActive {
                    EmptyMessageView(L10n.tsundocListEmptyMessageFiltered, message: nil)
                } else {
                    EmptyMessageView(emptyTitle, message: emptyMessage)
                }
            } else {
                List(store.state.filteredTsundocs) {
                    cell($0)
                }
                .listStyle(GroupedListStyle())
            }
        }
        .navigationTitle(title)
        .sheet(isPresented: store.bind(\.isModalPresenting, action: { _ in .dismissModal })) {
            switch store.state.modal {
            case let .tagAdditionView(tsundocId, tagIds):
                tagMultiSelectionSheetBuilder.buildTagMultiSelectionSheet(selectedIds: tagIds) {
                    store.execute(.selectTags(Set($0.map(\.id)), tsundocId))
                }

            case let .emojiSelection(tsundocId, emoji):
                NavigationView {
                    EmojiList(currentEmoji: emoji, backgroundColors: EmojiBackgroundColor.self) { emoji, backgrounColor in
                        store.execute(.updateEmojiInfo(.init(emoji: emoji, backgroundColor: backgrounColor), tsundocId))
                    } onCancel: {
                        store.execute(.dismissModal)
                    }
                }

            case let .createTsundoc(url):
                tsundocCreateViewBuilder.buildTsundocCreateView(url: url) { _ in
                    store.execute(.dismissModal)
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

            default:
                fatalError("Invalid Alert")
            }
        }
        .alert(isPresenting: store.bind(\.isTsundocUrlEditAlertPresenting, action: { _ in .alert(.dismissed) }),
               text: "",
               config: .init(title: L10n.TsundocList.Alert.TsundocUrl.title,
                             message: L10n.TsundocList.Alert.TsundocUrl.message,
                             placeholder: "https://...",
                             validator: {
                                 guard let string = $0 else { return false }
                                 return URL(string: string) != nil
                             },
                             saveAction: { store.execute(.alert(.createTsundoc(URL(string: $0)!))) },
                             cancelAction: { store.execute(.alert(.dismissed)) }))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    store.execute(.createTsundoc)
                } label: {
                    Image(systemName: "plus")
                        .font(.body.weight(.bold))
                }
                .opacity(isTsundocCreationEnabled ? 1 : 0)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                if store.state.isTsundocFilterActive {
                    Button {
                        store.execute(.deactivateTsundocFilter, animation: .default)
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .font(.body.weight(.bold))
                    }
                } else {
                    Menu {
                        Button {
                            store.execute(.activateTsundocFilter(.unread), animation: .default)
                        } label: {
                            Label(L10n.tsundocListSwipeActionToggleUnreadUnread, systemImage: "envelope.badge")
                        }

                        Button {
                            store.execute(.activateTsundocFilter(.read), animation: .default)
                        } label: {
                            Label(L10n.tsundocListFilterMenuRead, systemImage: "envelope.open")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.body.weight(.bold))
                    }
                }
            }
        }
        .onAppear {
            store.execute(.onAppear)
        }
        .navigationDestination(for: AppRoute.Browse.self) { route in
            BrowseView(baseUrl: route.tsundoc.url) {
                Button {
                    store.execute(.tap(route.tsundoc.id, .addEmoji))
                } label: {
                    Label {
                        Text(L10n.BrowserMenuItem.Title.editEmoji)
                    } icon: {
                        Image(systemName: "face.smiling")
                    }
                }

                Button {
                    store.execute(.tap(route.tsundoc.id, .addTag))
                } label: {
                    Label {
                        Text(L10n.BrowserMenuItem.Title.editTag)
                    } icon: {
                        Image(systemName: "tag")
                    }
                }
            } onBack: {
                store.execute(.tapBackButton)
            }
            .toolbar(.hidden, for: .tabBar)
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
            .swipeActions(edge: .leading) {
                Button(role: .none) {
                    store.execute(.toggleUnread(tsundoc), animation: .default)
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
                    store.execute(.delete(tsundoc), animation: .default)
                } label: {
                    Label(L10n.tsundocListSwipeActionDelete, systemImage: "trash")
                }
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
            store.execute(.tap(tsundoc.id, .addEmoji))
        } label: {
            Label {
                Text(L10n.tsundocListMenuAddEmoji)
            } icon: {
                Image(systemName: "face.smiling")
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
}

// MARK: - Preview

#if DEBUG
import PreviewContent

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

        var router: Router

        init(router: Router) {
            self.router = router
        }
    }

    struct ContentView: View {
        @StateObject var store: ViewStore<TsundocListState, TsundocListAction, TsundocListDependency>
        @StateObject var router: StackRouter

        init() {
            let router = StackRouter()
            let store = Store(initialState: TsundocListState(query: .all),
                              dependency: DummyDependency(router: router),
                              reducer: TsundocListReducer())
            let viewStore = ViewStore(store: store)
            self._store = .init(wrappedValue: viewStore)
            self._router = .init(wrappedValue: router)
        }

        var body: some View {
            NavigationStack(path: $router.stack) {
                TsundocList(title: L10n.tsundocListTitle,
                            emptyTitle: L10n.tsundocListEmptyMessageDefaultTitle,
                            emptyMessage: L10n.tsundocListEmptyMessageDefaultMessage,
                            isTsundocCreationEnabled: true,
                            store: store)
            }
        }
    }

    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

#endif
