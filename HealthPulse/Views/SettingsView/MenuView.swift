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

    let websiteURL = URL(string: "https://www.doomsdaymethod.com")!
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                List {
                    
                    // Contact Section
                    Section {
                        HStack {
                            Link("Visit our website", destination: websiteURL)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Link("Send Feedback", destination: websiteURL)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                        
                        Button {
                            //rateApp()
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
                            Link("Privacy Policy", destination: websiteURL)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Link("Terms and Conditions", destination: websiteURL)
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
}

#Preview {
    MenuView()
}
