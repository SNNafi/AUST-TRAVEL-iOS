//
//  StopWatch.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 14/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Foundation
import UIKit

class StopWatch: ObservableObject {
    
    @Published var hour: String = ""
    @Published var minute: String = ""
    @Published var second: String = ""
    private weak var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval?
    private var elapsed: CFTimeInterval = 0
    private var priorElapsed: CFTimeInterval = 0
    
    func resetTimer() {
        print(#function)
        stopDisplayLink()
        elapsed = 0
        priorElapsed = 0
        updateUI()
    }
    
    func startTimer() {
        print(#function)
        if displayLink == nil {
            startDisplayLink()
        }
    }
    
    func pauseTimer() {
        print(#function)
        priorElapsed += elapsed
        elapsed = 0
        displayLink?.invalidate()
    }
    
    private func startDisplayLink() {
        startTime = CACurrentMediaTime()
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink(_:)))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
    }
    
    @objc  private func handleDisplayLink(_ displayLink: CADisplayLink) {
        guard let startTime = startTime else { return }
        elapsed = CACurrentMediaTime() - startTime
        updateUI()
    }
    
    func updateUI() {
        let totalElapsed = elapsed + priorElapsed
        let hundredths = Int((totalElapsed * 100).rounded())
        let (minutes, hundredthsOfSeconds) = hundredths.quotientAndRemainder(dividingBy: 60 * 100)
        let (seconds, milliseconds) = hundredthsOfSeconds.quotientAndRemainder(dividingBy: 100)
        second = String(format: "%02d", seconds)
        minute = String(minutes)
        print(#function)
    }
}
