// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
    /// 閉じる
    internal static let alertClose = L10n.tr("Localizable", "alert_close")
    /// URLの読み取りに失敗しました
    internal static let sharedUrlEditViewErrorTitleLoadUrl = L10n.tr("Localizable", "shared_url_edit_view_error_title_load_url")
    /// URLの保存に失敗しました
    internal static let sharedUrlEditViewErrorTitleSaveUrl = L10n.tr("Localizable", "shared_url_edit_view_error_title_save_url")
    /// タイトルなし
    internal static let sharedUrlEditViewNoTitle = L10n.tr("Localizable", "shared_url_edit_view_no_title")
    /// 保存
    internal static let sharedUrlEditViewSaveButton = L10n.tr("Localizable", "shared_url_edit_view_save_button")
    /// タグ
    internal static let sharedUrlEditViewTagsTitle = L10n.tr("Localizable", "shared_url_edit_view_tags_title")
    /// このWebページのタイトルを入力してください
    internal static let sharedUrlEditViewTitleEditMessage = L10n.tr("Localizable", "shared_url_edit_view_title_edit_message")
    /// タイトル
    internal static let sharedUrlEditViewTitleEditPlaceholder = L10n.tr("Localizable", "shared_url_edit_view_title_edit_placeholder")
    /// タイトルの編集
    internal static let sharedUrlEditViewTitleEditTitle = L10n.tr("Localizable", "shared_url_edit_view_title_edit_title")
    /// このタグの名前を入力してください
    internal static let tagSelectionViewAlertNewTagMessage = L10n.tr("Localizable", "tag_selection_view_alert_new_tag_message")
    /// タグ名
    internal static let tagSelectionViewAlertNewTagPlaceholder = L10n.tr("Localizable", "tag_selection_view_alert_new_tag_placeholder")
    /// 新規タグ
    internal static let tagSelectionViewAlertNewTagTitle = L10n.tr("Localizable", "tag_selection_view_alert_new_tag_title")
    /// 完了
    internal static let tagSelectionViewDoneButton = L10n.tr("Localizable", "tag_selection_view_done_button")
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