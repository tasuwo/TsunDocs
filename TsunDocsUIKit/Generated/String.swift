// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
    /// キャンセル
    internal static let cancel = L10n.tr("Localizable", "cancel")
    /// 閉じる
    internal static let close = L10n.tr("Localizable", "close")
    /// 絵文字を選択
    internal static let emojiListTitle = L10n.tr("Localizable", "emoji_list_title")
    /// コピー
    internal static let tagGridMenuCopy = L10n.tr("Localizable", "tag_grid_menu_copy")
    /// 削除
    internal static let tagGridMenuDelete = L10n.tr("Localizable", "tag_grid_menu_delete")
    /// 名前の変更
    internal static let tagGridMenuRename = L10n.tr("Localizable", "tag_grid_menu_rename")
    /// このタグの名前を入力してください
    internal static let tagMultiAdditionViewAlertNewTagMessage = L10n.tr("Localizable", "tag_multi_addition_view_alert_new_tag_message")
    /// タグ名
    internal static let tagMultiAdditionViewAlertNewTagPlaceholder = L10n.tr("Localizable", "tag_multi_addition_view_alert_new_tag_placeholder")
    /// 新規タグ
    internal static let tagMultiAdditionViewAlertNewTagTitle = L10n.tr("Localizable", "tag_multi_addition_view_alert_new_tag_title")
    /// 完了
    internal static let tagMultiAdditionViewDoneButton = L10n.tr("Localizable", "tag_multi_addition_view_done_button")
    /// タグを選択
    internal static let tagSelectionViewTitle = L10n.tr("Localizable", "tag_selection_view_title")
    /// キャンセル
    internal static let textEditAlertCancelAction = L10n.tr("Localizable", "text_edit_alert_cancel_action")
    /// 保存
    internal static let textEditAlertSaveAction = L10n.tr("Localizable", "text_edit_alert_save_action")
    /// 保存
    internal static let tsundocEditViewSaveButton = L10n.tr("Localizable", "tsundoc_edit_view_save_button")
    /// タグ
    internal static let tsundocEditViewTagsTitle = L10n.tr("Localizable", "tsundoc_edit_view_tags_title")
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
