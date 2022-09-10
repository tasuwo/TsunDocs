// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
    /// 閉じる
    internal static let close = L10n.tr("Localizable", "close")
    /// タグの作成に失敗しました
    internal static let tagMultiSelectionSheetAlertFailedToCreateTagTitle = L10n.tr("Localizable", "tag_multi_selection_sheet_alert_failed_to_create_tag_title")
    /// このタグの名前を入力してください
    internal static let tagMultiSelectionViewAlertNewTagMessage = L10n.tr("Localizable", "tag_multi_selection_view_alert_new_tag_message")
    /// タグ名
    internal static let tagMultiSelectionViewAlertNewTagPlaceholder = L10n.tr("Localizable", "tag_multi_selection_view_alert_new_tag_placeholder")
    /// 新規タグ
    internal static let tagMultiSelectionViewAlertNewTagTitle = L10n.tr("Localizable", "tag_multi_selection_view_alert_new_tag_title")
    /// 完了
    internal static let tagMultiSelectionViewDoneButton = L10n.tr("Localizable", "tag_multi_selection_view_done_button")
    /// タグを選択
    internal static let tagMultiSelectionViewTitle = L10n.tr("Localizable", "tag_multi_selection_view_title")
    /// タグ「%@」が付与されたアイテムはありません
    internal static func tsundocListEmptyMessage(_ p1: Any) -> String {
        return L10n.tr("Localizable", "tsundoc_list_empty_message", String(describing: p1))
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
