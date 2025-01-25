//
//  UserDefault.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import Foundation
import Combine

/// A property wrapper that provides a convenient way to store and retrieve values from `UserDefaults`.
/// It supports atomic operations and publishes changes using Combine.
@propertyWrapper
final class UserDefault<Value: Codable> {
    /// A dispatch queue to ensure atomic access to the value.
    private let queue = DispatchQueue(label: "atomicUserDefault")
    
    /// The key used to store the value in `UserDefaults`.
    private let key: String
    
    /// The default value to return if no value is found in `UserDefaults`.
    private let defaultValue: Value
    
    /// The `UserDefaults` container to use for storage.
    private var container: UserDefaults
    
    /// A subject that publishes changes to the value.
    private lazy var valueSubject = CurrentValueSubject<Value, Never>(value)
    
    /// The underlying value stored in `UserDefaults`.
    private var value: Value {
        get { decodeValue() }
        set { encodeValue(newValue) }
    }
    
    /// The wrapped value that provides access to the stored value.
    var wrappedValue: Value {
        get { queue.sync { value } }
        set { queue.sync { value = newValue } }
    }
    
    /// Mutates the value using a closure, ensuring atomic access.
    func mutate(
        _ mutation: (inout Value) -> Void
    ) {
        queue.sync { mutation(&value) }
    }
    
    /// A publisher that emits the current value and any future changes.
    var publisher: AnyPublisher<Value, Never> {
        valueSubject.eraseToAnyPublisher()
    }
    
    /// A projected value that returns the `UserDefault` instance itself.
    var projectedValue: UserDefault<Value> {
        self
    }
    
    /// Initializes the `UserDefault` property wrapper with a default value, key, and container.
    /// - Parameters:
    ///   - wrappedValue: The default value to use if no value is found in `UserDefaults`.
    ///   - key: The key to use for storing the value in `UserDefaults`.
    ///   - container: The `UserDefaults` container to use for storage.
    init(
        wrappedValue: Value,
        _ key: String,
        container: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = wrappedValue
        self.container = container
    }
    
    /// Decodes the value from `UserDefaults`.
    private func decodeValue() -> Value {
        guard let data = container.data(forKey: key) else { return defaultValue }
        let value = try? JSONDecoder().decode(Value.self, from: data)
        return value ?? defaultValue
    }
    
    /// Encodes and stores the value in `UserDefaults`.
    private func encodeValue(
        _ newValue: Value
    ) {
        if let optional = newValue as? AnyOptional, optional.isNil {
            // Remove the value from `UserDefaults` if it's nil.
            container.removeObject(forKey: key)
        } else {
            // Encode and store the value in `UserDefaults`.
            let data = try? JSONEncoder().encode(newValue)
            container.setValue(data, forKey: key)
        }
        // Publish the new value.
        valueSubject.send(newValue)
    }
}

/// An extension for `UserDefault` that supports optional values.
extension UserDefault where Value: ExpressibleByNilLiteral {
    convenience init(
        _ key: String,
        container: UserDefaults = .standard
    ) {
        self.init(wrappedValue: nil, key, container: container)
    }
}
