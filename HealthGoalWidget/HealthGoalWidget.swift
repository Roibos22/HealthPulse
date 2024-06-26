//
//  HealthGoalWidget.swift
//  HealthGoalWidget
//
//  Created by Leon Grimmeisen on 25.04.24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> HealthGoalEntry {
        HealthGoalEntry(date: Date(), healthGoal: sampleHealthGoal)
    }

    func getSnapshot(in context: Context, completion: @escaping (HealthGoalEntry) -> ()) {
        let entry = HealthGoalEntry(date: Date(), healthGoal: sampleHealthGoal)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [HealthGoalEntry] = []
        
        if let loadedHealthGoal: HealthGoal = UserDefaults(suiteName: "group.lmg.runningGoal")!.codableObject(forKey: "healthGoal", as: HealthGoal.self) {
            let newHealthGoal = HealthGoalEntry(date: Date(), healthGoal: loadedHealthGoal)
            entries.append(newHealthGoal)
            print("Entry appended.")
        } else {
            print("Failed to load data.")
        }

        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct HealthGoalEntry: TimelineEntry {
    let date: Date
    let healthGoal: HealthGoal
}

struct HealthGoalWidgetEntryView : View {
    var entry: HealthGoalEntry

    var body: some View {
        if #available(iOS 17, *) {
            ZStack {
                WidgetPreView(healthGoal: entry.healthGoal)
            }
            .containerBackground(entry.healthGoal.colorSet.background, for: .widget)
        } else {
            ZStack {
                ContainerRelativeShape()
                    .fill(entry.healthGoal.colorSet.background)
                WidgetPreView(healthGoal: entry.healthGoal)
            }
        }
    }
}

struct HealthGoalWidget: Widget {
    let kind: String = "HealthGoalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ZStack {
                ContainerRelativeShape()
                    .fill(entry.healthGoal.colorSet.background)
                HealthGoalWidgetEntryView(entry: entry)
                    .padding(10)
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall])
    }
}

struct HealthGoalWidget_Previews: PreviewProvider {
    static var previews: some View {
        HealthGoalWidgetEntryView(entry: HealthGoalEntry(date: Date(), healthGoal: sampleHealthGoal))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

