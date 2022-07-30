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
    /// アイテムを削除
    internal static let tsundocListAlertDeleteTsundocAction = L10n.tr("Localizable", "tsundoc_list_alert_delete_tsundoc_action")
    /// このアイテムを削除しますか？
    internal static let tsundocListAlertDeleteTsundocMessage = L10n.tr("Localizable", "tsundoc_list_alert_delete_tsundoc_message")
    /// 他のアプリの「共有」から、追加したいサイトの URL をシェアしましょう
    internal static let tsundocListEmptyMessageDefaultMessage = L10n.tr("Localizable", "tsundoc_list_empty_message_default_message")
    /// アイテムがありません
    internal static let tsundocListEmptyMessageDefaultTitle = L10n.tr("Localizable", "tsundoc_list_empty_message_default_title")
    /// 条件に合致するアイテムがありません
    internal static let tsundocListEmptyMessageFiltered = L10n.tr("Localizable", "tsundoc_list_empty_message_filtered")
    /// 削除に失敗しました
    internal static let tsundocListErrorTitleDelete = L10n.tr("Localizable", "tsundoc_list_error_title_delete")
    /// 更新に失敗しました
    internal static let tsundocListErrorTitleUpdate = L10n.tr("Localizable", "tsundoc_list_error_title_update")
    /// 既読
    internal static let tsundocListFilterMenuRead = L10n.tr("Localizable", "tsundoc_list_filter_menu_read")
    /// 未読
    internal static let tsundocListFilterMenuUnread = L10n.tr("Localizable", "tsundoc_list_filter_menu_unread")
    /// 絵文字を追加する
    internal static let tsundocListMenuAddEmoji = L10n.tr("Localizable", "tsundoc_list_menu_add_emoji")
    /// タグを追加する
    internal static let tsundocListMenuAddTag = L10n.tr("Localizable", "tsundoc_list_menu_add_tag")
    /// URLをコピー
    internal static let tsundocListMenuCopyUrl = L10n.tr("Localizable", "tsundoc_list_menu_copy_url")
    /// 削除する
    internal static let tsundocListMenuDelete = L10n.tr("Localizable", "tsundoc_list_menu_delete")
    /// 情報の編集
    internal static let tsundocListMenuInfo = L10n.tr("Localizable", "tsundoc_list_menu_info")
    /// Safariで開く
    internal static let tsundocListMenuOpenSafari = L10n.tr("Localizable", "tsundoc_list_menu_open_safari")
    /// 削除
    internal static let tsundocListSwipeActionDelete = L10n.tr("Localizable", "tsundoc_list_swipe_action_delete")
    /// 既読
    internal static let tsundocListSwipeActionToggleUnreadRead = L10n.tr("Localizable", "tsundoc_list_swipe_action_toggle_unread_read")
    /// 未読
    internal static let tsundocListSwipeActionToggleUnreadUnread = L10n.tr("Localizable", "tsundoc_list_swipe_action_toggle_unread_unread")
    /// マイリスト
    internal static let tsundocListTitle = L10n.tr("Localizable", "tsundoc_list_title")

    internal enum TsundocList {
        internal enum Alert {
            internal enum TsundocUrl {
                /// 作成したい記事のURLを入力してください
                internal static let message = L10n.tr("Localizable", "tsundoc_list.alert.tsundoc_url.message")
                /// 記事を作成
                internal static let title = L10n.tr("Localizable", "tsundoc_list.alert.tsundoc_url.title")
            }
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
