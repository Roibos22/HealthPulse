//
//  SettingsView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 17.04.24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

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
                            //.foregroundColor(Color(.black))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                        
                        
                        Button {
                            //rateApp()
                        } label: {
                            HStack {
                                Text("Rate the Doomsday Method")
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        
                        ZStack {
                            NavigationLink {
                                //LegalNotice()
                            } label: {
                                Text("Legal Notice")
                                    .opacity(1)
                            }
                            HStack {
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 10)
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
    SettingsView()
}
