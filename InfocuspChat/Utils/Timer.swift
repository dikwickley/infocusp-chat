//
//  Timer.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 06/04/23.
//

import Foundation

class RepeatTimer {
    var timer: Timer?
    
    var timeInterval: TimeInterval
    var completion: () async throws -> Void
    
    init(every timeInterval: TimeInterval, run completion: @escaping () async throws ->Void) {
        self.timeInterval = timeInterval
        self.completion = completion
    }

    func startTimer() {
        // Start a timer that triggers the updateTimer function every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() async {
        try? await completion()
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
