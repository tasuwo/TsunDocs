//
//  Copyright ©︎ 2022 Tasuku Tozawa. All rights reserved.
//

import Combine
import CompositeKit
import Domain
import Environment
import SwiftUI

public protocol HasCloudKitAvailabilityObserver {
    var cloudKitAvailabilityObserver: CloudKitAvailabilityObservable { get }
}

public typealias SettingViewDependency = HasCloudKitAvailabilityObserver
    & HasSharedUserSettingStorage
    & HasUserSettingStorage

public struct SettingViewReducer: Reducer {
    public typealias Dependency = SettingViewDependency
    public typealias State = SettingViewState
    public typealias Action = SettingViewAction

    // MARK: - Initializers

    public init() {}

    // MARK: - Reducer

    public func execute(action: Action, state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        var nextState = state

        switch action {
        // MARK: View Life-Cycle

        case .onAppear:
            return Self.prepare(state: state, dependency: dependency)

        // MARK: State Observation

        case let .iCloudSyncSettingUpdated(isEnabled: isEnabled):
            nextState.isiCloudSyncInternalSettingEnabled = isEnabled
            return (nextState, .none)

        case let .cloudKitAvailabilityUpdated(isAvailable: isAvaialable):
            nextState.isCloudKitAvailable = isAvaialable
            return (nextState, .none)

        case let .markAsReadAutomatically(isEnabled: isEnabled):
            nextState.markAsReadAutomatically = isEnabled
            return (nextState, .none)

        case let .markAsReadAtCreate(isEnabled: isEnabled):
            nextState.markAsReadAtCreate = isEnabled
            return (nextState, .none)

        // MARK: Control

        case let .iCloudSyncAvailabilityChanged(isEnabled: isEnabled):
            guard let isCloudKitAvailable = state.isCloudKitAvailable else {
                return (nextState, .none)
            }

            // iCloudが利用不可な場合は、内部状態を書き換えるか確認する
            if isEnabled, !isCloudKitAvailable {
                if state.isiCloudSyncInternalSettingEnabled {
                    nextState.alert = .iCloudSettingForceTurnOffConfirmation
                } else {
                    nextState.alert = .iCloudSettingForceTurnOnConfirmation
                }
                return (nextState, .none)
            }

            if isEnabled {
                dependency.userSettingStorage.set(isiCloudSyncEnabled: true)
                nextState.isiCloudSyncInternalSettingEnabled = true
            } else {
                nextState.alert = .iCloudTurnOffConfirmation
            }

            return (nextState, .none)

        case let .markAsReadAutomaticallyChanged(isEnabled: isEnabled):
            dependency.userSettingStorage.set(markAsReadAutomatically: isEnabled)
            return (nextState, .none)

        case let .markAsReadAtCreateChanged(isEnabled: isEnabled):
            dependency.sharedUserSettingStorage.set(markAsReadAtCreate: isEnabled)
            return (nextState, .none)

        // MARK: Alert Completion

        case .iCloudForceTurnOffConfirmed:
            nextState.alert = nil
            dependency.userSettingStorage.set(isiCloudSyncEnabled: false)
            nextState.isiCloudSyncInternalSettingEnabled = false
            return (nextState, .none)

        case .iCloudForceTurnOnConfirmed:
            nextState.alert = nil
            dependency.userSettingStorage.set(isiCloudSyncEnabled: true)
            nextState.isiCloudSyncInternalSettingEnabled = true
            return (nextState, .none)

        case .iCloudTurnOffConfirmed:
            nextState.alert = nil
            dependency.userSettingStorage.set(isiCloudSyncEnabled: false)
            nextState.isiCloudSyncInternalSettingEnabled = false
            return (nextState, .none)

        case .alertDismissed:
            nextState.alert = nil
            return (nextState, .none)
        }
    }
}

// MARK: - Preparation

extension SettingViewReducer {
    private static func prepare(state: State, dependency: Dependency) -> (State, [Effect<Action>]?) {
        let iCloudSyncSettingStream = dependency.userSettingStorage.isiCloudSyncEnabled
            .map { Action.iCloudSyncSettingUpdated(isEnabled: $0) as Action? }
        let iCloudSyncSettingEffect = Effect(iCloudSyncSettingStream)

        let cloudKitAvailabilityStream = dependency.cloudKitAvailabilityObserver
            .cloudKitAccountAvailability
            .map { Action.cloudKitAvailabilityUpdated(isAvailable: $0) as Action? }
        let cloudKitAvailabilityEffect = Effect(cloudKitAvailabilityStream)

        let markAsReadAutomaticallyStream = dependency.userSettingStorage.markAsReadAutomatically
            .map { Action.markAsReadAutomatically(isEnabled: $0) as Action? }
        let markAsReadAutomaticallyEffect = Effect(markAsReadAutomaticallyStream)

        let markAsReadAtCreateStream = dependency.sharedUserSettingStorage.markAsReadAtCreate
            .map { Action.markAsReadAtCreate(isEnabled: $0) as Action? }
        let markAsReadAtCreateEffect = Effect(markAsReadAtCreateStream)

        var nextState = state
        nextState.isiCloudSyncInternalSettingEnabled = dependency.userSettingStorage.isiCloudSyncEnabledValue
        nextState.markAsReadAutomatically = dependency.userSettingStorage.markAsReadAutomaticallyValue
        nextState.markAsReadAtCreate = dependency.sharedUserSettingStorage.markAsReadAtCreateValue

        return (nextState, [iCloudSyncSettingEffect, cloudKitAvailabilityEffect, markAsReadAutomaticallyEffect, markAsReadAtCreateEffect])
    }
}
