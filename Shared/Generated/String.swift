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
    /// 閉じる
    internal static let browseViewButtonClose = L10n.tr("Localizable", "browse_view_button_close")
    /// 読み込み中...
    internal static let browseViewTitleLoading = L10n.tr("Localizable", "browse_view_title_loading")
    /// Failed to add tag.
    internal static let errorTagAddDefault = L10n.tr("Localizable", "error_tag_add_default")
    /// Duplicated tag name.
    internal static let errorTagAddDuplicated = L10n.tr("Localizable", "error_tag_add_duplicated")
    /// Failed to delete tag
    internal static let errorTagDelete = L10n.tr("Localizable", "error_tag_delete")
    /// Failed to read tags
    internal static let errorTagRead = L10n.tr("Localizable", "error_tag_read")
    /// Duplicated tag name.
    internal static let errorTagRenameDuplicated = L10n.tr("Localizable", "error_tag_rename_duplicated")
    /// Failed to update tag
    internal static let errorTagUpdate = L10n.tr("Localizable", "error_tag_update")
    /// バージョン
    internal static let settingViewRowAppVersion = L10n.tr("Localizable", "setting_view_row_app_version")
    /// このアプリについて
    internal static let settingViewSectionTitleThisApp = L10n.tr("Localizable", "setting_view_section_title_this_app")
    /// 設定
    internal static let settingViewTitle = L10n.tr("Localizable", "setting_view_title")
    /// 設定
    internal static let tabItemTitleSettings = L10n.tr("Localizable", "tab_item_title_settings")
    /// タグ
    internal static let tabItemTitleTags = L10n.tr("Localizable", "tab_item_title_tags")
    /// マイリスト
    internal static let tabItemTitleTsundocList = L10n.tr("Localizable", "tab_item_title_tsundoc_list")
    /// タグを削除
    internal static let tagListAlertDeleteTagAction = L10n.tr("Localizable", "tag_list_alert_delete_tag_action")
    /// タグ「%@」を削除しますか？\n含まれるクリップは削除されません
    internal static func tagListAlertDeleteTagMessage(_ p1: Any) -> String {
        return L10n.tr("Localizable", "tag_list_alert_delete_tag_message", String(describing: p1))
    }

    /// このタグの名前を入力してください
    internal static let tagListAlertNewTagMessage = L10n.tr("Localizable", "tag_list_alert_new_tag_message")
    /// 新規タグ
    internal static let tagListAlertNewTagTitle = L10n.tr("Localizable", "tag_list_alert_new_tag_title")
    /// タグ名
    internal static let tagListAlertPlaceholder = L10n.tr("Localizable", "tag_list_alert_placeholder")
    /// このタグの新しい名前を入力してください
    internal static let tagListAlertUpdateTagNameMessage = L10n.tr("Localizable", "tag_list_alert_update_tag_name_message")
    /// タグ名の変更
    internal static let tagListAlertUpdateTagNameTitle = L10n.tr("Localizable", "tag_list_alert_update_tag_name_title")
    /// タグ
    internal static let tagListTitle = L10n.tr("Localizable", "tag_list_title")
    /// 削除に失敗しました
    internal static let tsundocListErrorTitleDelete = L10n.tr("Localizable", "tsundoc_list_error_title_delete")
    /// マイリスト
    internal static let tsundocListTitle = L10n.tr("Localizable", "tsundoc_list_title")
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
