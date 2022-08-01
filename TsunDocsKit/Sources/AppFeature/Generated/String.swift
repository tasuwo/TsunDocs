// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
    /// TsunDocs
    internal static let appName = L10n.tr("Localizable", "app_name")
    /// キャンセル
    internal static let cancel = L10n.tr("Localizable", "cancel")
    /// 設定
    internal static let tabItemTitleSettings = L10n.tr("Localizable", "tab_item_title_settings")
    /// タグ
    internal static let tabItemTitleTags = L10n.tr("Localizable", "tab_item_title_tags")
    /// マイリスト
    internal static let tabItemTitleTsundocList = L10n.tr("Localizable", "tab_item_title_tsundoc_list")
    /// 他のアプリの「共有」から、追加したいサイトの URL をシェアしましょう
    internal static let tsundocListEmptyMessageDefaultMessage = L10n.tr("Localizable", "tsundoc_list_empty_message_default_message")
    /// アイテムがありません
    internal static let tsundocListEmptyMessageDefaultTitle = L10n.tr("Localizable", "tsundoc_list_empty_message_default_title")
    /// タグ「%@」が付与されたアイテムはありません
    internal static func tsundocListEmptyMessageTagMessage(_ p1: Any) -> String {
        return L10n.tr("Localizable", "tsundoc_list_empty_message_tag_message", String(describing: p1))
    }

    /// マイリスト
    internal static let tsundocListTitle = L10n.tr("Localizable", "tsundoc_list_title")

    internal enum Alert {
        internal enum Action {
            /// キャンセル
            internal static let cancel = L10n.tr("Localizable", "alert.action.cancel")
            /// OK
            internal static let ok = L10n.tr("Localizable", "alert.action.ok")
        }
    }
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BundleToken.self)
        #endif
    }()
}

// swiftlint:enable convenience_type
