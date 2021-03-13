//
//  Box.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/13/21.
//

import Foundation

public final class Box<Value> {
    
    typealias Listener = (Value) -> Void
    var listener: Listener?
    
    var value: Value {
        didSet {
            listener?(value)
        }
    }
    
    init(value: Value) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
