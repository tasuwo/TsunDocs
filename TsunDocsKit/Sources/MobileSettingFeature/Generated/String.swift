// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
    internal enum SettingView {
        /// 設定
        internal static let title = L10n.tr("Localizable", "setting_view.title")
        internal enum Alert {
            internal enum IcloudUnavailable {
                /// iCloudアカウントでログインしていないか、端末のiCloud同期設定がオフになっている可能性があります。\niCluoudが利用できない間に保存したデータは、後ほどiCloudが有効になった際に統合されます
                internal static let message = L10n.tr("Localizable", "setting_view.alert.icloud_unavailable.message")
                /// iCloudが利用できません
                internal static let title = L10n.tr("Localizable", "setting_view.alert.icloud_unavailable.title")
                internal enum Action {
                    /// iCloud同期を利用しない
                    internal static let forceTurnOff = L10n.tr("Localizable", "setting_view.alert.icloud_unavailable.action.force_turn_off")
                    /// iCloud同期を自動で有効にする
                    internal static let forceTurnOn = L10n.tr("Localizable", "setting_view.alert.icloud_unavailable.action.force_turn_on")
                }
            }

            internal enum TurnOffConfirmation {
                /// この端末に保存したデータを他のiOS/iPadOS端末と共有できなくなります。同期がオフの最中に保存したデータは、後ほどiCloud同期が有効になった際に、他のiOS/iPadOS端末のデータと統合されます
                internal static let message = L10n.tr("Localizable", "setting_view.alert.turn_off_confirmation.message")
                /// iCloud同期をオフにしますか？
                internal static let title = L10n.tr("Localizable", "setting_view.alert.turn_off_confirmation.title")
            }
        }

        internal enum Row {
            internal enum AppVersion {
                /// バージョン
                internal static let title = L10n.tr("Localizable", "setting_view.row.app_version.title")
            }

            internal enum IcloudSync {
                /// iCloudで同期する
                internal static let title = L10n.tr("Localizable", "setting_view.row.icloud_sync.title")
            }

            internal enum UserInterfaceStyle {
                /// テーマ
                internal static let title = L10n.tr("Localizable", "setting_view.row.user_interface_style.title")
            }
        }

        internal enum Section {
            internal enum Appearance {
                /// 表示設定
                internal static let title = L10n.tr("Localizable", "setting_view.section.appearance.title")
            }

            internal enum Sync {
                /// 同期
                internal static let title = L10n.tr("Localizable", "setting_view.section.sync.title")
                internal enum Footer {
                    /// 他のiOS/iPadOSデバイスとデータを同期できます
                    internal static let title = L10n.tr("Localizable", "setting_view.section.sync.footer.title")
                }
            }

            internal enum ThisApp {
                /// このアプリについて
                internal static let title = L10n.tr("Localizable", "setting_view.section.this_app.title")
            }
        }
    }

    internal enum UserInterfaceStyleSettingView {
        /// テーマ
        internal static let title = L10n.tr("Localizable", "user_interface_style_setting_view.title")
        internal enum Row {
            /// ダーク
            internal static let dark = L10n.tr("Localizable", "user_interface_style_setting_view.row.dark")
            /// ライト
            internal static let light = L10n.tr("Localizable", "user_interface_style_setting_view.row.light")
            /// 端末に合わせる
            internal static let unspecified = L10n.tr("Localizable", "user_interface_style_setting_view.row.unspecified")
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
