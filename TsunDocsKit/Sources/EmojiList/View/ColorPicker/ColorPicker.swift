//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import SwiftUI

public struct ColorPicker<C>: View where C: PickColor, C.RawValue: Hashable {
    // MARK: - Properties

    private let padding: CGFloat = 16

    private let colors: C.Type
    private let onSelect: (C.RawValue) -> Void

    @Binding private var selected: C.RawValue

    // MARK: - Initializers

    public init(color: C.Type,
                selected: Binding<C.RawValue>,
                onSelect: @escaping (C.RawValue) -> Void)
    {
        self.colors = color
        self.onSelect = onSelect
        _selected = selected
    }

    // MARK: - View

    public var body: some View {
        HStack(spacing: padding) {
            ForEach(colors.allCases.map(\.rawValue), id: \.self) { rawValue in
                let pickColor = colors.init(rawValue: rawValue)!
                ColorCircle(color: pickColor.swiftUIColor)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        GeometryReader { geometry in
                            if selected == pickColor.rawValue {
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: geometry.size.width / 8)
                                    .shadow(color: .black.opacity(0.5),
                                            radius: geometry.size.width / 32,
                                            x: geometry.size.width / 32,
                                            y: geometry.size.width / 32)
                                    .clipShape(Circle())
                                    .scaleEffect(0.9)
                            }
                        }
                    }
                    .onTapGesture {
                        onSelect(pickColor.rawValue)
                    }
            }
        }
        .padding(padding)
        .background {
            GeometryReader { geometry in
                Color.clear
                    .background(.ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: geometry.size.height / 2, style: .continuous))
            }
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    struct Container: View {
        @State var selectedColor: String = DefaultPickColor.default.rawValue

        var body: some View {
            ZStack {
                HStack(spacing: 0) {
                    ForEach(DefaultPickColor.allCases.map(\.rawValue), id: \.self) { rawValue in
                        DefaultPickColor(rawValue: rawValue)!.swiftUIColor
                    }
                }
                .opacity(0.8)

                ColorPicker(color: DefaultPickColor.self, selected: $selectedColor) {
                    self.selectedColor = $0
                }
                .padding()
            }
            .ignoresSafeArea()
        }
    }

    static var previews: some View {
        Group {
            Container()
        }
    }
}
