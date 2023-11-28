// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Localizable.strings
  ///   TsunDocs
  /// 
  ///   Created by Tasuku Tozawa on 2021/06/22.
  ///   Copyright © 2021 Tasuku Tozawa. All rights reserved.
  internal static let appName = L10n.tr("Localizable", "app_name", fallback: "TsunDocs")
  /// キャンセル
  internal static let cancel = L10n.tr("Localizable", "cancel", fallback: "キャンセル")
  /// 設定
  internal static let tabItemTitleSettings = L10n.tr("Localizable", "tab_item_title_settings", fallback: "設定")
  /// タグ
  internal static let tabItemTitleTags = L10n.tr("Localizable", "tab_item_title_tags", fallback: "タグ")
  /// マイリスト
  internal static let tabItemTitleTsundocList = L10n.tr("Localizable", "tab_item_title_tsundoc_list", fallback: "マイリスト")
  /// 他のアプリの「共有」から、追加したいサイトの URL をシェアしましょう
  internal static let tsundocListEmptyMessageDefaultMessage = L10n.tr("Localizable", "tsundoc_list_empty_message_default_message", fallback: "他のアプリの「共有」から、追加したいサイトの URL をシェアしましょう")
  /// アイテムがありません
  internal static let tsundocListEmptyMessageDefaultTitle = L10n.tr("Localizable", "tsundoc_list_empty_message_default_title", fallback: "アイテムがありません")
  /// タグ「%@」が付与されたアイテムはありません
  internal static func tsundocListEmptyMessageTagMessage(_ p1: Any) -> String {
    return L10n.tr("Localizable", "tsundoc_list_empty_message_tag_message", String(describing: p1), fallback: "タグ「%@」が付与されたアイテムはありません")
  }
  /// マイリスト
  internal static let tsundocListTitle = L10n.tr("Localizable", "tsundoc_list_title", fallback: "マイリスト")
  internal enum Alert {
    internal enum Action {
      /// キャンセル
      internal static let cancel = L10n.tr("Localizable", "alert.action.cancel", fallback: "キャンセル")
      /// OK
      internal static let ok = L10n.tr("Localizable", "alert.action.ok", fallback: "OK")
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
