//
//  PublisherObservableObject.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import SwiftUI
import Combine

/// A class that acts as an observable object and listens to a publisher.
/// It triggers `objectWillChange` when the publisher emits a value.
final class PublisherObservableObject: ObservableObject {
    
    /// A cancellable subscription to the publisher.
    var subscriber: AnyCancellable?
    
    /// Initializes the observable object with a publisher.
    /// - Parameter publisher: The publisher to listen to.
    public init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher
            .sink(receiveValue: { _ in
                // Notify observers after the view update has happened.
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            })
    }
}
