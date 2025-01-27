//
//  Prefrances.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import SwiftUI
import Combine

/// A property wrapper that provides a convenient way to access and mutate preferences.
/// It uses `@ObservedObject` to observe changes and update the view accordingly.
@propertyWrapper
struct Preference<Value>: DynamicProperty {
    
    /// An observed object that listens to changes in the preferences.
    @ObservedObject var preferencesObserver: PublisherObservableObject
    
    /// The key path to the preference value in the `Preferences` class.
    let keyPath: ReferenceWritableKeyPath<Preferences, Value>
    
    /// The shared instance of the `Preferences` class.
    let preferences: Preferences = .shared
    
    /// Initializes the `Preference` property wrapper with a key path.
    /// - Parameter keyPath: The key path to the preference value.
    init(
        _ keyPath: ReferenceWritableKeyPath<Preferences, Value>
    ) {
        self.keyPath = keyPath
        
        // Create a publisher that filters changes to the specific key path and maps them to Void.
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }
            .mapToVoid()
            .eraseToAnyPublisher()
        
        // Initialize the observer with the publisher.
        self.preferencesObserver = .init(publisher: publisher)
    }
    
    /// The wrapped value that provides access to the preference.
    var wrappedValue: Value {
        get {
            // Get the value from the preferences using the key path.
            preferences[keyPath: keyPath]
        }
        nonmutating set {
            // Set the new value in the preferences and notify observers.
            preferences[keyPath: keyPath] = newValue
            preferences.preferencesChangedSubject.send(keyPath)
        }
    }
    
    /// A binding that projects the wrapped value for use in SwiftUI views.
    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

/// A singleton class that holds the application's preferences.
final class Preferences {
    
    /// The shared instance of the `Preferences` class.
    static let shared = Preferences()
    
    /// Private initializer to enforce singleton usage.
    private init() {}
    
    /// A subject that emits the key path of the changed preference whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()
    
    @UserDefault(PrefrancesKeys.kAPPFavoriteGiveAways.rawValue)
    var favoriteGiveAways: [GiveAwayItem] = []
}
