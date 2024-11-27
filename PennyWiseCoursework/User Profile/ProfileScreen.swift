import SwiftUI
import CoreData
import PhotosUI


struct ProfileScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Profile.entity(), sortDescriptors: []) private var profiles: FetchedResults<Profile>
    
    @State private var username: String = "John Doe"
    @State private var email: String = "johndoe@example.com"
    @State private var profilePicture: Image? = Image(systemName: "person.crop.circle.fill")
    
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
        VStack(spacing: 20) {
            VStack {
                profilePicture?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                
                Button(action: {
                    profilePicture = Image(systemName: "person.crop.circle.badge.plus")
                }) {
                    Text("Change Profile Picture")
                        .font(.headline)
                        .foregroundColor(.purple)
                }
                .padding(.top, 10)
            }
            .padding(.top, 50)

            VStack(alignment: .leading) {
                Text("Username")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                TextField("Enter your username", text: $username)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.bottom, 15)
            }
            .padding(.horizontal)

            VStack(alignment: .leading) {
                Text("Email")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                TextField("Enter your email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .keyboardType(.emailAddress)
                    .padding(.bottom, 15)
            }
            .padding(.horizontal)
            
            Button(action: {
                saveProfile()
            }) {
                Text("Save Profile")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)

            Spacer()
        }
        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
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
