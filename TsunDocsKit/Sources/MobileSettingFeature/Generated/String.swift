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
    enum Alert {
        enum Action {
            /// キャンセル
            static let cancel = L10n.tr("Localizable", "alert.action.cancel", fallback: "キャンセル")
            /// OK
            static let ok = L10n.tr("Localizable", "alert.action.ok", fallback: "OK")
        }
    }

    enum SettingView {
        /// Localizable.strings
        ///
        ///
        ///   Created by Tasuku Tozawa on 2022/08/01.
        static let title = L10n.tr("Localizable", "setting_view.title", fallback: "設定")
        enum Alert {
            enum IcloudUnavailable {
                /// iCloudアカウントでログインしていないか、端末のiCloud同期設定がオフになっている可能性があります。
                /// iCluoudが利用できない間に保存したデータは、後ほどiCloudが有効になった際に統合されます
                static let message = L10n.tr("Localizable", "setting_view.alert.icloud_unavailable.message", fallback: "iCloudアカウントでログインしていないか、端末のiCloud同期設定がオフになっている可能性があります。\niCluoudが利用できない間に保存したデータは、後ほどiCloudが有効になった際に統合されます")
                /// iCloudが利用できません
                static let title = L10n.tr("Localizable", "setting_view.alert.icloud_unavailable.title", fallback: "iCloudが利用できません")
                enum Action {
                    /// iCloud同期を利用しない
                    static let forceTurnOff = L10n.tr("Localizable", "setting_view.alert.icloud_unavailable.action.force_turn_off", fallback: "iCloud同期を利用しない")
                    /// iCloud同期を自動で有効にする
                    static let forceTurnOn = L10n.tr("Localizable", "setting_view.alert.icloud_unavailable.action.force_turn_on", fallback: "iCloud同期を自動で有効にする")
                }
            }

            enum TurnOffConfirmation {
                /// この端末に保存したデータを他のiOS/iPadOS端末と共有できなくなります。同期がオフの最中に保存したデータは、後ほどiCloud同期が有効になった際に、他のiOS/iPadOS端末のデータと統合されます
                static let message = L10n.tr("Localizable", "setting_view.alert.turn_off_confirmation.message", fallback: "この端末に保存したデータを他のiOS/iPadOS端末と共有できなくなります。同期がオフの最中に保存したデータは、後ほどiCloud同期が有効になった際に、他のiOS/iPadOS端末のデータと統合されます")
                /// iCloud同期をオフにしますか？
                static let title = L10n.tr("Localizable", "setting_view.alert.turn_off_confirmation.title", fallback: "iCloud同期をオフにしますか？")
            }
        }

        enum Raw {
            enum MarkAsReadAtCreate {
                /// 新規作成時は既読にする
                static let title = L10n.tr("Localizable", "setting_view.raw.mark_as_read_at_create.title", fallback: "新規作成時は既読にする")
            }

            enum MarkAsReadAutomatically {
                /// 記事を開いたら既読にする
                static let title = L10n.tr("Localizable", "setting_view.raw.mark_as_read_automatically.title", fallback: "記事を開いたら既読にする")
            }
        }

        enum Row {
            enum AppVersion {
                /// バージョン
                static let title = L10n.tr("Localizable", "setting_view.row.app_version.title", fallback: "バージョン")
            }

            enum IcloudSync {
                /// iCloudで同期する
                static let title = L10n.tr("Localizable", "setting_view.row.icloud_sync.title", fallback: "iCloudで同期する")
            }

            enum UserInterfaceStyle {
                /// テーマ
                static let title = L10n.tr("Localizable", "setting_view.row.user_interface_style.title", fallback: "テーマ")
            }
        }

        enum Section {
            enum Appearance {
                /// 表示設定
                static let title = L10n.tr("Localizable", "setting_view.section.appearance.title", fallback: "表示設定")
            }

            enum Read {
                /// 既読設定
                static let title = L10n.tr("Localizable", "setting_view.section.read.title", fallback: "既読設定")
            }

            enum Sync {
                /// 同期
                static let title = L10n.tr("Localizable", "setting_view.section.sync.title", fallback: "同期")
                enum Footer {
                    /// 他のiOS/iPadOSデバイスとデータを同期できます
                    static let title = L10n.tr("Localizable", "setting_view.section.sync.footer.title", fallback: "他のiOS/iPadOSデバイスとデータを同期できます")
                }
            }

            enum ThisApp {
                /// このアプリについて
                static let title = L10n.tr("Localizable", "setting_view.section.this_app.title", fallback: "このアプリについて")
            }
        }
    }

    enum UserInterfaceStyleSettingView {
        /// テーマ
        static let title = L10n.tr("Localizable", "user_interface_style_setting_view.title", fallback: "テーマ")
        enum Row {
            /// ダーク
            static let dark = L10n.tr("Localizable", "user_interface_style_setting_view.row.dark", fallback: "ダーク")
            /// ライト
            static let light = L10n.tr("Localizable", "user_interface_style_setting_view.row.light", fallback: "ライト")
            /// 端末に合わせる
            static let unspecified = L10n.tr("Localizable", "user_interface_style_setting_view.row.unspecified", fallback: "端末に合わせる")
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
