// ContentView.swift
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    static let shared = FirebaseManager()
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try auth.signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
struct ContentView: View {
    var body: some View {
        NavigationView{
            //                VStack {
            //                    Image("mainlogo")
            //                        .resizable()
            //                        .scaledToFit()
            //                        .frame(width: 250, height: 400)
            //                        .shadow(radius: 6)
            //                    NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true)) {
            //                        Text("Get Started")
            //                            .font(.headline)
            //                            .foregroundColor(.blue)
            //                            .padding()
            //                            .frame(width: 350, height: 50)
            //                            .background(Color.white)
            //                            .cornerRadius(10)
            //                            .overlay(
            //                                RoundedRectangle(cornerRadius: 10)
            //                                    .stroke(Color.blue, lineWidth: 2)
            //                            )
            //                            .padding([.leading, .trailing], 10)
            //                    }
            //
            //                    HStack {
            //                        Text("Already have an account? ")
            //                            .font(.subheadline)
            //                            .foregroundColor(.gray)
            //
            //                        NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
            //                            Text("Log In")
            //                                .font(.subheadline)
            //                                .foregroundColor(.gray)
            //                        }
            //                    }
            //
            //            }
            //
            //        }
            MainView()
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
