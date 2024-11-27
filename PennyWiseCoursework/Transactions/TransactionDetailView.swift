import SwiftUI

struct TransactionDetailView: View {
    let transaction: TransactionEntity
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Text(transaction.title ?? "Transaction")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)

                    Text("\(String(format: "%.2f", transaction.amount)) UAH")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(transaction.type == "income" ? .green : .red)

                    if let date = transaction.date {
                        Text(date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .multilineTextAlignment(.center)

                ZStack {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                    } else if let imageData = transaction.photo, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                    } else {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.purple.opacity(0.1))
                            .frame(height: 200)
                            .overlay(
                                Text("No Photo Available")
                                    .font(.headline)
                                    .foregroundColor(.purple)
                            )
                            .padding(.horizontal)
                    }
                }

                Button(action: {
                    showingImagePicker.toggle()
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text(selectedImage == nil ? "Add Photo" : "Change Photo")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                if let notes = transaction.notes, !notes.isEmpty {
                    VStack(spacing: 10) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(.purple)

                        Text(notes)
                            .font(.body)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top, 20)
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: savePhoto) {
            ImagePicker(image: $selectedImage)
        }
        .navigationBarTitle("Transaction Details", displayMode: .inline)
    }

    private func savePhoto() {
        if let selectedImage = selectedImage, let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            transaction.photo = imageData

            do {
                try transaction.managedObjectContext?.save()
            } catch {
                print("Failed to save photo: \(error)")
            }
        }
    }
}
