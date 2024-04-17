import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()
            
            Form {
                Section(header: Text("Game Settings")) {
                    HStack {
                        Text("Game Time Limit")
                        Spacer()
                        Text("\(Int(settingsViewModel.gameTimeLimit)) seconds")
                    }
                    
                    Slider(value: $settingsViewModel.gameTimeLimit, in: 1...120)
                    
                    HStack {
                        Text("Max Balloons")
                        Spacer()
                        Text("\(Int(settingsViewModel.maxBalloons))")
                    }
                    
                    Slider(value: $settingsViewModel.maxBalloons, in: 1...25)
                }
            }
            
            Button(action: {
                settingsViewModel.saveSettings()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
