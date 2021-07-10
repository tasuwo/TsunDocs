//
//  Copyright © 2021 Tasuku Tozawa. All rights reserved.
//

import CompositeKit
import Domain
import SwiftUI

public struct TagGrid: View {
    // MARK: - Properties

    public let spacing: CGFloat = 8

    @ObservedObject var store: ViewStore<TagSelectionState, TagSelectionAction, TagSelectionDependency>

    @State private var availableWidth: CGFloat = 0
    @State private var cellSizes: [Tag: CGSize] = [:]

    // MARK: - View

    public var body: some View {
        ZStack {
            Color.clear
                .frame(height: 0)
                .onChangeFrame {
                    availableWidth = $0.width
                }

            GeometryReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: spacing) {
                        ForEach(calcRows(), id: \.self) { tags in
                            HStack(spacing: spacing) {
                                ForEach(tags) { tag in
                                    TagCell(tagId: tag.id,
                                            tagName: tag.name,
                                            isSelected: store.state.selectedIds.contains(tag.id))
                                        .frame(maxWidth: proxy.size.width - spacing * 2)
                                        .fixedSize()
                                        .onChangeFrame {
                                            cellSizes[tag] = $0
                                        }
                                        .onTapGesture {
                                            store.execute(.selected(tag.id))
                                        }
                                }
                            }
                        }
                    }
                    .padding(.all, spacing)
                }
            }
        }
    }

    func calcRows() -> [[Tag]] {
        var rows: [[Tag]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth - spacing * 2

        for tag in store.state.tags {
            let cellSize = cellSizes[tag, default: CGSize(width: availableWidth - spacing * 2, height: 1)]

            if remainingWidth - (cellSize.width + spacing) >= 0 {
                rows[currentRow].append(tag)
            } else {
                currentRow += 1
                rows.append([tag])
                remainingWidth = availableWidth - spacing * 2
            }

            remainingWidth -= (cellSize.width + spacing)
        }

        return rows
    }
}

// MARK: - Preview

struct TagGrid_Previews: PreviewProvider {
    static let tags: [Tag] = [
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

    static var previews: some View {
        VStack {
            TagGrid(store: makeViewStore(allowsSelection: true,
                                         allowsMultipleSelection: true))
                .padding()

            TagGrid(store: makeViewStore(allowsSelection: true,
                                         allowsMultipleSelection: false))
                .padding()

            TagGrid(store: makeViewStore(allowsSelection: false,
                                         allowsMultipleSelection: false))
                .padding()
        }
    }

    static func makeViewStore(allowsSelection: Bool,
                              allowsMultipleSelection: Bool) -> ViewStore<TagSelectionState, TagSelectionAction, TagSelectionDependency>
    {
        let store = Store(initialState: TagSelectionState(tags: tags,
                                                          allowsSelection: allowsSelection,
                                                          allowsMultipleSelection: allowsMultipleSelection),
                          dependency: (),
                          reducer: TagSelectionReducer())
        return ViewStore(store: store)
    }
}
