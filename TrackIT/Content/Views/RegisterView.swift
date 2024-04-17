import SwiftUI
import Firebase

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var error: String?
    @State private var isRegistrationSuccessful: Bool = false
    let firebaseManager = FirebaseManager.shared
    
    var body: some View {
        NavigationView{
        ScrollView {
            VStack {
                ZStack {
                    Image("login")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 6)
                }
                .padding(.bottom, 20)
                
                VStack(spacing: 10) {
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.gray.opacity(0.1)))
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.gray.opacity(0.1)))
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.gray.opacity(0.1)))
                }
                
                if let error = error {
                    Text(error)
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Button(action: {
                    register()
                }) {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .padding([.leading, .trailing], 10)
                }
                
                HStack {
                    Text("Already have an account? ")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
            .padding()
        }
        
        .navigationBarHidden(true)
        .background(
            NavigationLink(destination: UserProfileView().navigationBarBackButtonHidden(true)
                           , isActive: $isRegistrationSuccessful) {
                               EmptyView()
                           }
        )
    }
        .navigationBarBackButtonHidden(true)

}
    
    func register() {
        guard password == confirmPassword else {
            self.error = "Passwords do not match"
            return
        }
        
        firebaseManager.auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch error.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    self.error = "Email already in use"
                case AuthErrorCode.invalidEmail.rawValue:
                    self.error = "Invalid email"
                case AuthErrorCode.weakPassword.rawValue:
                    self.error = "Weak password"
                default:
                    self.error = "An error occurred"
                }
            } else {
                self.isRegistrationSuccessful = true
            }
        }
    }
}
