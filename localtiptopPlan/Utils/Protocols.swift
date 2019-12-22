//
//  Protocols.swift
//  localtiptopPlan
//
//  Created by Dan Li on 17.11.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

protocol UserProfileHeaderDelegate {
    func handleEditFollowTapped(for header: UserProfileHeader)
    func setUserStats(for header: UserProfileHeader)
    func handleFollowersTapped(for header: UserProfileHeader)
    func handleFollowingTapped(for header: UserProfileHeader)
}

