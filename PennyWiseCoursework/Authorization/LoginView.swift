import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @State private var password: String = ""  // Зберігаємо введений пароль
    @State private var isAuthenticated = false
    @State private var errorMessage: String? = nil
    @State private var isPasswordSet = false  // Для перевірки, чи встановлений пароль
    @State private var newPassword: String = ""  // Для введення нового пароля
    @State private var confirmPassword: String = ""  // Для підтвердження нового пароля
    @State private var showingFaceIDAlert = false // Для показу попапа Face ID

    // Ключ для збереження пароля в UserDefaults
    private let passwordKey = "userPassword"

    var body: some View {
        ZStack {
            // Білий фон
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack {
                if isPasswordSet {
                    // Якщо пароль вже встановлено, то показуємо форму входу
                    Text("Welcome back!")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.top, 80)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)

                    // Ілюстрація (наприклад, значок замка)
                    Image(systemName: "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.purple)
                        .padding(.bottom, 40)

                    Text(password)
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.black)
                        .padding()
                        .frame(height: 50)
                        .background(Color.purple.opacity(0.1))
                        .clipShape(Capsule())
                        .padding(.bottom, 40)

                    // Вхід через Face ID
                    Button(action: {
                        authenticateWithFaceID()
                    }) {
                        Text("Login with Face ID")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)

                    // Повідомлення про помилку, якщо є
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                    }
                } else {
                    // Якщо пароль ще не встановлений, просимо його створити
                    Text("Create a password")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.top, 80)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)

                    // Ілюстрація (наприклад, значок замка)
                    Image(systemName: "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.purple)
                        .padding(.bottom, 40)

                    // Введення нового пароля
                    SecureField("New Password", text: $newPassword)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .clipShape(Capsule())
                        .padding(.bottom, 20)

                    // Підтвердження пароля
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .clipShape(Capsule())
                        .padding(.bottom, 40)

                    // Кнопка для підтвердження створення пароля
                    Button(action: {
                        setPassword()
                    }) {
                        Text("Set Password")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .alert(isPresented: $showingFaceIDAlert) {
            Alert(title: Text("Face ID Authentication Failed"), message: Text("Could not authenticate using Face ID. Please try again."), dismissButton: .default(Text("OK")))
        }
    }

    func setPassword() {
        if newPassword == confirmPassword {
            // Save password to UserDefaults (for demo purposes)
            UserDefaults.standard.set(newPassword, forKey: passwordKey)
            isPasswordSet = true
        } else {
            errorMessage = "Passwords do not match."
        }
    }

    func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?

        // Check if Face ID is available on the device
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Try to authenticate using Face ID
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Log in with Face ID") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Success, unlock the app
                        if let storedPassword = UserDefaults.standard.string(forKey: passwordKey), password == storedPassword {
                            isAuthenticated = true
                            errorMessage = nil
                        } else {
                            errorMessage = "Password does not match."
                        }
                    } else {
                        // Authentication failed
                        showingFaceIDAlert = true
                    }
                }
            }
        } else {
            errorMessage = "Face ID is not available or not set up."
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
