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
    /// アイテムを削除
    static let tsundocListAlertDeleteTsundocAction = L10n.tr("Localizable", "tsundoc_list_alert_delete_tsundoc_action", fallback: "アイテムを削除")
    /// このアイテムを削除しますか？
    static let tsundocListAlertDeleteTsundocMessage = L10n.tr("Localizable", "tsundoc_list_alert_delete_tsundoc_message", fallback: "このアイテムを削除しますか？")
    /// 他のアプリの「共有」から、追加したいサイトの URL をシェアしましょう
    static let tsundocListEmptyMessageDefaultMessage = L10n.tr("Localizable", "tsundoc_list_empty_message_default_message", fallback: "他のアプリの「共有」から、追加したいサイトの URL をシェアしましょう")
    /// アイテムがありません
    static let tsundocListEmptyMessageDefaultTitle = L10n.tr("Localizable", "tsundoc_list_empty_message_default_title", fallback: "アイテムがありません")
    /// 条件に合致するアイテムがありません
    static let tsundocListEmptyMessageFiltered = L10n.tr("Localizable", "tsundoc_list_empty_message_filtered", fallback: "条件に合致するアイテムがありません")
    /// 削除に失敗しました
    static let tsundocListErrorTitleDelete = L10n.tr("Localizable", "tsundoc_list_error_title_delete", fallback: "削除に失敗しました")
    /// 更新に失敗しました
    static let tsundocListErrorTitleUpdate = L10n.tr("Localizable", "tsundoc_list_error_title_update", fallback: "更新に失敗しました")
    /// 既読
    static let tsundocListFilterMenuRead = L10n.tr("Localizable", "tsundoc_list_filter_menu_read", fallback: "既読")
    /// 未読
    static let tsundocListFilterMenuUnread = L10n.tr("Localizable", "tsundoc_list_filter_menu_unread", fallback: "未読")
    /// 絵文字を追加する
    static let tsundocListMenuAddEmoji = L10n.tr("Localizable", "tsundoc_list_menu_add_emoji", fallback: "絵文字を追加する")
    /// タグを追加する
    static let tsundocListMenuAddTag = L10n.tr("Localizable", "tsundoc_list_menu_add_tag", fallback: "タグを追加する")
    /// URLをコピー
    static let tsundocListMenuCopyUrl = L10n.tr("Localizable", "tsundoc_list_menu_copy_url", fallback: "URLをコピー")
    /// 削除する
    static let tsundocListMenuDelete = L10n.tr("Localizable", "tsundoc_list_menu_delete", fallback: "削除する")
    /// 情報の編集
    static let tsundocListMenuInfo = L10n.tr("Localizable", "tsundoc_list_menu_info", fallback: "情報の編集")
    /// Safariで開く
    static let tsundocListMenuOpenSafari = L10n.tr("Localizable", "tsundoc_list_menu_open_safari", fallback: "Safariで開く")
    /// 削除
    static let tsundocListSwipeActionDelete = L10n.tr("Localizable", "tsundoc_list_swipe_action_delete", fallback: "削除")
    /// 既読
    static let tsundocListSwipeActionToggleUnreadRead = L10n.tr("Localizable", "tsundoc_list_swipe_action_toggle_unread_read", fallback: "既読")
    /// 未読
    static let tsundocListSwipeActionToggleUnreadUnread = L10n.tr("Localizable", "tsundoc_list_swipe_action_toggle_unread_unread", fallback: "未読")
    /// Localizable.strings
    ///
    ///
    ///   Created by Tasuku Tozawa on 2022/07/31.
    static let tsundocListTitle = L10n.tr("Localizable", "tsundoc_list_title", fallback: "マイリスト")
    enum BrowserMenuItem {
        enum Title {
            /// 絵文字の編集
            static let editEmoji = L10n.tr("Localizable", "browser_menu_item.title.edit_emoji", fallback: "絵文字の編集")
            /// タグの編集
            static let editTag = L10n.tr("Localizable", "browser_menu_item.title.edit_tag", fallback: "タグの編集")
        }
    }

    enum TsundocList {
        enum Alert {
            enum TsundocUrl {
                /// 作成したい記事のURLを入力してください
                static let message = L10n.tr("Localizable", "tsundoc_list.alert.tsundoc_url.message", fallback: "作成したい記事のURLを入力してください")
                /// 記事を作成
                static let title = L10n.tr("Localizable", "tsundoc_list.alert.tsundoc_url.title", fallback: "記事を作成")
            }
        }
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
