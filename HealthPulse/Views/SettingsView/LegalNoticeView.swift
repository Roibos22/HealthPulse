//
//  LegalNoticeView.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 19.04.24.
//

import SwiftUI

import SwiftUI

struct LegalNoticeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    Text("Angaben gemäß § 5 TMG")
                        .font(.title2)
                        .bold()
                    Text("""
                    Leon Grimmeisen
                    Abt Rudolf Straße 43
                    73479 Ellwangen
                    """)
                }
                .padding(.bottom, 15)
                
                VStack(alignment: .leading) {
                    Text("Kontakt")
                        .font(.title2)
                        .bold()
                    Text("""
                    Telefon: +491743629023
                    E-Mail: lmgrimmeisen(at)gmail.com
                    """)
                }
                
                VStack(alignment: .leading) {
                    Text("Haftung für Links")
                        .font(.title2)
                        .bold()
                    Text("Diese App enthält Links zu externen Websites Dritter, auf deren Inhalte wir keinen Einfluss haben. Deshalb können wir für diese fremden Inhalte auch keine Gewähr übernehmen. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich. Die verlinkten Seiten wurden zum Zeitpunkt der Verlinkung, soweit möglich, auf mögliche Rechtsverstöße überprüft. Rechtswidrige Inhalte waren zum Zeitpunkt der Verlinkung nicht erkennbar. Eine permanente inhaltliche Kontrolle der verlinkten Seiten ist jedoch ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Links umgehend entfernen.")
                }
                .padding(.vertical, 15)
                
                VStack(alignment: .leading) {
                    Text("Quelle")
                        .font(.title2)
                        .bold()
                    Link("e-recht24", destination: URL(string: "https://www.e-recht24.de/impressum-generator.html")!)
                }
                .padding(.vertical, 15)
                
                Spacer()
            }
            .navigationTitle("Legal Notice")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(15)
        }
    }
}

#Preview {
    NavigationView {
        LegalNoticeView()
    }
    .navigationTitle("Legal Notice")
}
