import SwiftUI
struct SettingsView: View {
    @ObservedObject var settingsViewModel = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Game Settings")
                                .font(.headline)
                                .foregroundColor(.primary)) {
                        HStack {
                            Text("Game Time Limit")
                            Spacer()
                            Text("\(Int(settingsViewModel.gameTimeLimit)) seconds")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $settingsViewModel.gameTimeLimit, in: 1...120)
                            .accentColor(.orange) // Change slider color
                        
                        HStack {
                            Text("Max Balloons")
                            Spacer()
                            Text("\(Int(settingsViewModel.maxBalloons))")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $settingsViewModel.maxBalloons, in: 1...25)
                            .accentColor(.orange) // Change slider color
                    }
                }
                
                Spacer()
                
                Button(action: {
                    settingsViewModel.saveSettings()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange) // Change button color
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
