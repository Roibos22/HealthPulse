//
//  SettingsView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 17.04.24.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme

    let websiteURL = URL(string: "https://leongrimmeisen.de/projects/HealthPulse/index.html")!
    let privacyPolicyURL = URL(string: "https://leongrimmeisen.de/projects/HealthPulse/privacy-policy.html")!
    let termsAndConditionsURL = URL(string: "https://leongrimmeisen.de/projects/HealthPulse/terms-and-conditions.html")!
    let twitterURL = URL(string: "https://twitter.com/LofiLeon")!

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section {
                        HStack {
                            Link("Visit our website", destination: websiteURL)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Link("Send Feedback", destination: twitterURL)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                        
                        Button {
                            rateApp()
                        } label: {
                            HStack {
                                Text("Rate HealthPulse")
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        ZStack {
                            NavigationLink {
                                LegalNoticeView()
                            } label: {
                                Text("Legal Notice")
                            }
                            HStack {
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        HStack {
                            Link("Privacy Policy", destination: privacyPolicyURL)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Link("Terms and Conditions", destination: termsAndConditionsURL)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                        
                    } header: {
                        Text("Contact")
                    }
                    .bold()
                    .foregroundColor(Color(.label))
                    .listRowBackground(Color(.systemGray5))
                    
                }
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden)
                .navigationTitle("Menu")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
        }
    }
    
    func rateApp() {
        let appReviewURL = "itms-apps://itunes.apple.com/app/idid6497484745?action=write-review&mt=8"
        print(appReviewURL)
        UIApplication.shared.open(URL(string:appReviewURL)!,options: [:])
    }
    
}

#Preview {
    MenuView()
}
