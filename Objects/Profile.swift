//
//  Profile.swift
//  ChatApplication
//
//  Created by Swiftaholic on 4/20/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation
import Kingfisher

final class Profile {
    private var username: String
    private var coverPhotoUrl: String
    private var avatarUrl: String
    private var displayName: String
    private var biography: String
    
    init(username: String, coverPhotoUrl: String, avatarUrl: String, displayName: String, biography: String) {
        self.username = username
        self.coverPhotoUrl = coverPhotoUrl
        self.avatarUrl = avatarUrl
        self.displayName = displayName
        self.biography = biography
    }
    
    func getUsername() -> String {
        return self.username
    }
    
    func setUsername(username: String) {
        self.username = username
    }
    
    func getCoverPhotoUrl() -> String {
        return self.coverPhotoUrl
    }
    
    func setCoverPhotoUrl(coverPhotoUrl: String) {
        self.coverPhotoUrl = coverPhotoUrl
    }
    
    func getAvatarUrl() -> String {
        return self.avatarUrl
    }
    
    func setAvatarUrl(avatarUrl: String) {
        self.avatarUrl = avatarUrl
    }
    
    func getDisplayName() -> String {
        return self.displayName
    }
    
    func setDisplayName(displayName: String) {
        self.displayName = displayName
    }
    
    func getBiography() -> String {
        return self.biography
    }
    
    func setBiography(biography: String) {
        self.biography = biography
    }
}
