//
//  ViewController.swift
//  FirestoreSnapshotExistsBug
//
//  Created by Sunil Chauhan on 08/11/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var stateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateState()
    }

    private func updateState() {
        if Auth.auth().currentUser == nil {
            loginButton.setTitle("Sign In", for: .normal)
            stateLabel.text = "Signed Out."
        } else {
            loginButton.setTitle("Sign Out", for: .normal)
            stateLabel.text = "Signed In."
        }
    }

    @IBAction func buttonTapped() {
        if Auth.auth().currentUser == nil {
            signIn()
        } else {
            signOut()
        }
    }

    private func signOut() {
        try? Auth.auth().signOut()
        updateState()
    }

    private func signIn() {
        print("🔥 Signing In....")
        Auth.auth().signIn(withEmail: "test@example.com", password: "test123") { result, error in
            guard let result = result else {
                print("🔥 Cannot sign in. Error: \(error)")
                return
            }

            self.fetchDocument(userId: result.user.uid)
        }
    }

    private func fetchDocument(userId: String) {
        print("🔥 Fetching User details for user: " + userId)
        Firestore.firestore().collection("Users").document(userId).getDocument { snapshot, error in
            guard let snapshot = snapshot else {
                print("🔥 Could not get snaphsot. Error: \(error)")
                return
            }

            print("🔥 Snapshot Exists: \(snapshot.exists)")
            self.updateState()
        }
    }
}

