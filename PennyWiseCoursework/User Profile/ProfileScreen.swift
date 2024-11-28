import SwiftUI
import CoreData
import PhotosUI

struct ProfileScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Profile.entity(), sortDescriptors: []) private var profiles: FetchedResults<Profile>
    
    @State private var username: String = "John Doe"
    @State private var email: String = "johndoe@example.com"
    @State private var profilePicture: Image? = Image("avatar") // Default avatar from assets
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    func saveProfile() {
        let profile: Profile
        if let existingProfile = profiles.first {
            profile = existingProfile
        } else {
            profile = Profile(context: viewContext)
        }

        profile.username = username
        profile.email = email
        
        if let selectedImageData = selectedImageData {
            profile.profilePictureData = selectedImageData
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving profile: \(error)")
        }
    }
    
    func loadProfile() {
        guard let profile = profiles.first else { return }
        username = profile.username ?? ""
        email = profile.email ?? ""
        if let imageData = profile.profilePictureData, let uiImage = UIImage(data: imageData) {
            profilePicture = Image(uiImage: uiImage)
        }
    }

    var body: some View {
        VStack(spacing: 15) {
            // Profile picture
            profilePicture?
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 30) // Add padding to top
            
            // Username TextField
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            
            // Email TextField
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            
            // Save Button
            Button(action: saveProfile) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple) // Purple button color
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .padding(.top, 20)
        }
        .frame(maxHeight: .infinity, alignment: .top) // Ensures the layout starts from the top
        .onAppear {
            loadProfile()
        }
    }
}


struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
