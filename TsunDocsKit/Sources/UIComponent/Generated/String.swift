// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum L10n {
    /// キャンセル
    static let cancel = L10n.tr("Localizable", "cancel", fallback: "キャンセル")
    /// 保存
    static let save = L10n.tr("Localizable", "save", fallback: "保存")
    /// タグを削除
    static let tagGridAlertDeleteTagAction = L10n.tr("Localizable", "tag_grid_alert_delete_tag_action", fallback: "タグを削除")
    /// タグ「%@」を削除しますか？
    static func tagGridAlertDeleteTagMessage(_ p1: Any) -> String {
        return L10n.tr("Localizable", "tag_grid_alert_delete_tag_message %@", String(describing: p1), fallback: "タグ「%@」を削除しますか？")
    }

    /// このタグの新しい名前を入力してください
    static let tagGridAlertRenameTagMessage = L10n.tr("Localizable", "tag_grid_alert_rename_tag_message", fallback: "このタグの新しい名前を入力してください")
    /// タグ名
    static let tagGridAlertRenameTagPlaceholder = L10n.tr("Localizable", "tag_grid_alert_rename_tag_placeholder", fallback: "タグ名")
    /// タグ名の変更
    static let tagGridAlertRenameTagTitle = L10n.tr("Localizable", "tag_grid_alert_rename_tag_title", fallback: "タグ名の変更")
    /// コピー
    static let tagGridMenuCopy = L10n.tr("Localizable", "tag_grid_menu_copy", fallback: "コピー")
    /// 削除
    static let tagGridMenuDelete = L10n.tr("Localizable", "tag_grid_menu_delete", fallback: "削除")
    /// 名前の変更
    static let tagGridMenuRename = L10n.tr("Localizable", "tag_grid_menu_rename", fallback: "名前の変更")
    /// タイトルなし
    static let tsundocEditViewNoTitle = L10n.tr("Localizable", "tsundoc_edit_view_no_title", fallback: "タイトルなし")
    /// 読み込み中...
    static let tsundocEditViewPreparingTitle = L10n.tr("Localizable", "tsundoc_edit_view_preparing_title", fallback: "読み込み中...")
    /// 保存
    static let tsundocEditViewSaveButton = L10n.tr("Localizable", "tsundoc_edit_view_save_button", fallback: "保存")
    /// タグ
    static let tsundocEditViewTagsTitle = L10n.tr("Localizable", "tsundoc_edit_view_tags_title", fallback: "タグ")
    /// このWebページのタイトルを入力してください
    static let tsundocEditViewTitleEditMessage = L10n.tr("Localizable", "tsundoc_edit_view_title_edit_message", fallback: "このWebページのタイトルを入力してください")
    /// タイトル
    static let tsundocEditViewTitleEditPlaceholder = L10n.tr("Localizable", "tsundoc_edit_view_title_edit_placeholder", fallback: "タイトル")
    /// タイトルの編集
    static let tsundocEditViewTitleEditTitle = L10n.tr("Localizable", "tsundoc_edit_view_title_edit_title", fallback: "タイトルの編集")
    /// 未読
    static let tsundocEditViewUnreadToggle = L10n.tr("Localizable", "tsundoc_edit_view_unread_toggle", fallback: "未読")
    enum EmojiList {
        /// %@を選択中
        static func selectedTitle(_ p1: Any) -> String {
            return L10n.tr("Localizable", "emoji_list.selected_title", String(describing: p1), fallback: "%@を選択中")
        }

        /// Localizable.strings
        ///
        ///
        ///   Created by Tasuku Tozawa on 2022/07/31.
        static let title = L10n.tr("Localizable", "emoji_list.title", fallback: "絵文字を選択")
    }
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
