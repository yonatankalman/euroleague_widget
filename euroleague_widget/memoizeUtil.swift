//
//  memoizeUtil.swift
//  euroleague_widgetExtension
//
//  Created by Yonatan Kalman on 13/11/2023.
//

import Foundation

class MemoizationCache<Key: Hashable, Value> {
    private var cache = [Key: (value: Value, timestamp: Date)]()
    private let maxAgeInSeconds: TimeInterval

    init(maxAgeInSeconds: TimeInterval) {
        self.maxAgeInSeconds = maxAgeInSeconds
    }

    func get(_ key: Key) -> Value? {
        if let (value, timestamp) = cache[key], abs(timestamp.timeIntervalSinceNow) <= maxAgeInSeconds {
            return value
        } else {
            return nil
        }
    }

    func set(_ key: Key, _ value: Value) {
        let timestamp = Date()
        cache[key] = (value, timestamp)
    }
    
    func remove(_ key: Key) {
        cache.removeValue(forKey: key)
    }
}

func memoizeWithMaxAge<Input: Hashable, Output>(
    _ function: @escaping (Input) async throws -> Output,
    maxAgeInSeconds: TimeInterval
) -> (Input) async throws -> Output {
    let cache = MemoizationCache<Input, Output>(maxAgeInSeconds: maxAgeInSeconds)

    return { input in
        if let cachedResult = cache.get(input) {
            return cachedResult
        } else {
            cache.remove(input)
            let result = try await function(input)
            cache.set(input, result)
            return result
        }
    }
}
