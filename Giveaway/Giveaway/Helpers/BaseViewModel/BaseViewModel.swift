//
//  BaseViewModel.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import SwiftUI
import Observation
import Combine

/// A protocol defining the requirements for a base view model.
/// Conforming types must be `AnyObject` (class-bound) and implement the `CancelableStore` protocol.
/// The `@MainActor` attribute ensures that all methods and properties are accessed on the main thread,
/// which is necessary for UI updates in SwiftUI.
@MainActor
public protocol BaseViewModelProtocol: AnyObject, CancelableStore {
    /// The state type representing the view model's state.
    associatedtype State
    
    /// The action type representing the actions that can be triggered to modify the state.
    associatedtype Action
    
    /// The current state of the view model. This property is mutable and can be updated.
    var state: State { get set }
    
    /// Triggers an action to modify the state. This method is asynchronous and must be implemented by conforming types.
    /// - Parameter action: The action to be triggered.
    func trigger(_ action: Action) async
}

/// A base view model class that conforms to `BaseViewModelProtocol`.
/// This class is generic over `State` and `Action` types, allowing it to be reused for different view models.
/// The `@Observable` macro makes the class observable, enabling SwiftUI to automatically update views when the state changes.
/// The `@MainActor` attribute ensures that all state updates occur on the main thread.
@MainActor
@Observable
public class BaseViewModel<State, Action>: NSObject, BaseViewModelProtocol {
    /// The current state of the view model. This property is marked as `@Observable`,
    /// so SwiftUI will automatically observe changes to it and update the UI accordingly.
    public var state: State
    
    /// A computed property that returns an array of `AnyCancellable` objects.
    /// This is used to store Combine subscriptions. By default, it returns an empty array.
    /// Conforming types can override this property to provide their own subscriptions.
    public var bindings: [AnyCancellable] { [] }
    
    /// Initializes the view model with an initial state.
    /// - Parameter state: The initial state of the view model.
    public init(state: State) {
        self.state = state
        super.init()
        bind()
    }
    
    /// A final method that binds the Combine subscriptions.
    /// This method iterates over the `bindings` array and stores each subscription in the `cancelables` set.
    /// Subclasses should not override this method.
    public final func bind() {
        bindings.forEach { $0.store(in: &cancelables) }
    }
    
    /// Triggers an action to modify the state. This method must be overridden by subclasses.
    /// - Parameter action: The action to be triggered.
    public func trigger(_ action: Action) {
        fatalError("Override!")
    }
}

/// An extension that makes `BaseViewModel` conform to the `Identifiable` protocol.
/// This is useful when the view model needs to be identified in SwiftUI views (e.g., in lists or navigation).
extension BaseViewModel: Identifiable {
    /// A computed property that returns a unique `UUID` for the view model.
    /// This ensures that each instance of the view model has a unique identifier.
    public nonisolated var id: UUID {
        UUID()
    }
}
