//
//  Db.swift
//  IntelliKitchen
//
//  Created by zhangjm on 6/6/20.
//  Copyright © 2020 Emily Xu. All rights reserved.
//

import UIKit
import FirebaseAuth
import UserNotifications
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

class Db{
    
    //Function from ProfilePageViewController
    func loadUserInfo(ppvc: ProfilePageViewController){
        //let ppvc:ProfilePageViewController = ProfilePageViewController()
        let db = Firestore.firestore()
        
        let tempGoogleUsername = GlobalVariable.googleUsername
        let tempGoogleEmail = GlobalVariable.googleEmail
        let tempGoogleIconUrl = GlobalVariable.googleIconUrl
        

        //handle google log in
        if tempGoogleUsername != "" && tempGoogleEmail != ""{
            ppvc.userName.text = tempGoogleUsername

            ppvc.userEmail.text = tempGoogleEmail

            guard let imageURL = tempGoogleIconUrl else { return  }

            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }

                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    ppvc.myImageView.image = image
                    ProfilePageViewController.uploadProfileImage(image!){(url) in

                    }
                }
            }
            let currentUid = Auth.auth().currentUser!.uid

            db.collection("users").document(currentUid).collection("favoriteRecipe").getDocuments{ (snapshot, error) in
                for document in snapshot!.documents{
                    let documentData = document.data()
                    ppvc.favoriteIDList = documentData["favRecipe"] as! [String]
                    if ppvc.favoriteIDList.count == 0{
                        ppvc.favRecipeAlert.text = "Add Some Favorite while Searching"
                    } else {
                        ppvc.favRecipeAlert.text = "My Favorite Recipes:"

                    }
                    ppvc.favoriteRecipes = ppvc.createArray(ppvc.favoriteIDList)
                }
            }

            db.collection("users").document(currentUid).setData(["username":tempGoogleUsername, "email":tempGoogleEmail, "uid": currentUid]) { (error) in
                if error != nil{
                    print(" error when saving google sign in information")
                }
            }
            //handle normal login
        } else {
            let currentUid = Auth.auth().currentUser!.uid
            db.collection("users").document(currentUid).getDocument { (document, error) in
                print("---=====> inside DB")
                print("before modification:")
                print(ppvc.userName.text)
                if error == nil {
                    if document != nil && document!.exists {
                        let documentData = document?.data()

                        ppvc.userName.text = documentData?["username"] as? String
                        print("=======> after modification:")
                        print(ppvc.userName.text)
                        ppvc.userEmail.text = documentData?["email"] as? String
                        ppvc.loadImageFromFirebase()

                    } else {
                        print("Can read the document but the document might not exists")
                    }

                } else {
                    print("Something wrong reading the document")
                }
            }
            db.collection("users").document(currentUid).collection("favoriteRecipe").getDocuments{ (snapshot, error) in
                for document in snapshot!.documents{
                    let documentData = document.data()
                    ppvc.favoriteIDList = documentData["favRecipe"] as! [String]
                    if ppvc.favoriteIDList.count == 0{
                        ppvc.favRecipeAlert?.text = "Add Some Favorite while Searching"
                    } else {
                        ppvc.favRecipeAlert?.text = "My Favorite Recipes:"
                    }
                    ppvc.favoriteRecipes = ppvc.createArray(ppvc.favoriteIDList)
                }
            }
        }
    }
}
