//
//  UIApplication+Ex.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var authViewModel: AuthViewModel {
        SceneDelegate.austTravel.authViewModel
    }
    
    var homeViewModel: HomeViewModel {
        SceneDelegate.austTravel.homeViewModel
    }
    
    var locationManager: LocationManager {
        SceneDelegate.austTravel.locationManager
    }
    
    var liveTrackViewModel: LiveTrackViewModel {
        SceneDelegate.austTravel.liveTrackViewModel
    }
    
    var settingsViewModel: SettingsViewModel {
        SceneDelegate.austTravel.settingsViewModel
    }
}
