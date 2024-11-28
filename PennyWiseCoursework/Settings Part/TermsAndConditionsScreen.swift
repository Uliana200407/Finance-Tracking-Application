import SwiftUI
import UserNotifications

struct TermsAndConditionsScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Terms & Conditions")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .padding([.leading, .trailing], 16)
                
                Text("""
                Welcome to PennyWise. By accessing and using this application, you agree to be bound by the following Terms and Conditions. Please read them carefully.
                
                **Acceptance of Terms**
                By using this app, you agree to comply with and be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the app.
                
                **User Responsibilities**
                - You agree to use this app for lawful purposes only.
                - You are responsible for all activity under your account.
                - You agree not to use the app in any way that could damage, disable, or impair the app's functionality.
                
                **Privacy and Data Collection**
                We collect personal data in accordance with our [Privacy Policy]. This may include your name, email, and usage data to improve your experience and provide better services.
                
                **Account Creation and Termination**
                You may create an account to access additional features. We reserve the right to suspend or terminate your account if we believe you have violated these Terms.
                
                **Intellectual Property**
                All content within the app is protected by copyright laws and is the property of [Your Company Name] or its licensors. You may not copy, modify, or distribute any content from the app.
                
                **Disclaimers and Limitation of Liability**
                The app is provided "as is." We do not guarantee that the app will be error-free or uninterrupted. We...
                """)
                    .font(.body)
                    .lineSpacing(5)
                    .padding([.leading, .trailing], 16) 
                    .padding(.bottom, 20)
            }
            .padding(.top, 20)
        }
        .navigationBarTitle("Terms & Conditions", displayMode: .inline)
    }
}
