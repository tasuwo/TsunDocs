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
    /// 保存
    internal static let save = L10n.tr("Localizable", "save")
    /// タグを削除
    internal static let tagGridAlertDeleteTagAction = L10n.tr("Localizable", "tag_grid_alert_delete_tag_action")
    /// タグ「%@」を削除しますか？
    internal static func tagGridAlertDeleteTagMessage(_ p1: Any) -> String {
        return L10n.tr("Localizable", "tag_grid_alert_delete_tag_message %@", String(describing: p1))
    }

    /// このタグの新しい名前を入力してください
    internal static let tagGridAlertRenameTagMessage = L10n.tr("Localizable", "tag_grid_alert_rename_tag_message")
    /// タグ名
    internal static let tagGridAlertRenameTagPlaceholder = L10n.tr("Localizable", "tag_grid_alert_rename_tag_placeholder")
    /// タグ名の変更
    internal static let tagGridAlertRenameTagTitle = L10n.tr("Localizable", "tag_grid_alert_rename_tag_title")
    /// コピー
    internal static let tagGridMenuCopy = L10n.tr("Localizable", "tag_grid_menu_copy")
    /// 削除
    internal static let tagGridMenuDelete = L10n.tr("Localizable", "tag_grid_menu_delete")
    /// 名前の変更
    internal static let tagGridMenuRename = L10n.tr("Localizable", "tag_grid_menu_rename")
    /// タイトルなし
    internal static let tsundocEditViewNoTitle = L10n.tr("Localizable", "tsundoc_edit_view_no_title")
    /// 保存
    internal static let tsundocEditViewSaveButton = L10n.tr("Localizable", "tsundoc_edit_view_save_button")
    /// タグ
    internal static let tsundocEditViewTagsTitle = L10n.tr("Localizable", "tsundoc_edit_view_tags_title")
    /// このWebページのタイトルを入力してください
    internal static let tsundocEditViewTitleEditMessage = L10n.tr("Localizable", "tsundoc_edit_view_title_edit_message")
    /// タイトル
    internal static let tsundocEditViewTitleEditPlaceholder = L10n.tr("Localizable", "tsundoc_edit_view_title_edit_placeholder")
    /// タイトルの編集
    internal static let tsundocEditViewTitleEditTitle = L10n.tr("Localizable", "tsundoc_edit_view_title_edit_title")
    /// 未読
    internal static let tsundocEditViewUnreadToggle = L10n.tr("Localizable", "tsundoc_edit_view_unread_toggle")

    internal enum EmojiList {
        /// %@を選択中
        internal static func selectedTitle(_ p1: Any) -> String {
            return L10n.tr("Localizable", "emoji_list.selected_title", String(describing: p1))
        }

        /// 絵文字を選択
        internal static let title = L10n.tr("Localizable", "emoji_list.title")
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
