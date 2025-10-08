//
//  AuthViewModel.swift
//  Habood
//
//  Created by Stephan Karatselios on 8/10/2025.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

protocol AuthServicing {
    var currentUser: AppUser? { get }
    func signInWithGoogle() async throws -> AppUser
    func signOut() throws
}

final class AuthService: AuthServicing {
    private let auth = FirebaseManager.shared.auth
    
    var currentUser: AppUser? {
        guard let user = auth.currentUser else { return nil }
        return AppUser.fromFirebaseUser(user)
    }
    
    /// Google Sign-In (v7) → Firebase credential
    func signInWithGoogle() async throws -> AppUser {
        // Get a presenting view controller for the Google sheet
        guard let presenter = Self.rootViewController else {
            throw AuthError.misconfigured("Unable to find root view controller")
        }
        
        // v7 API: no GIDConfiguration needed; uses plist clientID automatically
        // This presents the Google sign-in UI and returns on success
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenter)
        
        // Grab tokens from Google user
        let googleUser = signInResult.user
        guard let idToken = googleUser.idToken?.tokenString else {
            throw AuthError.misconfigured("Missing Google ID token")
        }
        let accessToken = googleUser.accessToken.tokenString
        
        // Exchange for Firebase credential
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        let authResult = try await auth.signIn(with: credential)
        return AppUser.fromFirebaseUser(authResult.user)
    }
    
    func signOut() throws {
        try auth.signOut()
        GIDSignIn.sharedInstance.signOut()
    }
    
    // MARK: - Helpers
    
    private static var rootViewController: UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?
            .rootViewController
    }
    
    enum AuthError: LocalizedError {
        case misconfigured(String)
        case unknown
        var errorDescription: String? {
            switch self {
            case .misconfigured(let msg): return msg
            case .unknown: return "Unknown authentication error."
            }
        }
    }
}
