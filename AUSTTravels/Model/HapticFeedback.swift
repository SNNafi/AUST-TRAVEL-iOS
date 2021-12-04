//
//  HapticFeedback.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import UIKit


enum HapticFeedback {
    case success
    case warning
    case error
    case none
    
    func provide() {
        let generator = UINotificationFeedbackGenerator()
        switch self {
        case .success:
            generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
        case .warning:
            generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.warning)
        case .error:
            generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.error)
        case .none:
            break
        }
    }
}
