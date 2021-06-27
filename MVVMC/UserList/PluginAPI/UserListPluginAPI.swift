//
//  UserListPluginAPI.swift
//  MVVMC
//
//  Created by Rajneesh Biswal on 27/06/21.
//  Copyright © 2021 tawkto. All rights reserved.
//

import Foundation
import UIKit

class UserListPluginAPI: UserListAPI {
    func getUserListCoordinator(navigationController: UINavigationController) -> Coordinator<Void> {
        return UserListCoordinator(navigationController: navigationController)
    }
}
