//
//  HealthGoalWidget.swift
//  HealthGoalWidget
//
//  Created by Leon Grimmeisen on 25.04.24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    // what is shown if system does not have any data
    func placeholder(in context: Context) -> HealthGoalEntry {
        HealthGoalEntry(date: Date(), emoji: "😀", healthGoal: sampleHealthGoal)
    }

    //
    func getSnapshot(in context: Context, completion: @escaping (HealthGoalEntry) -> ()) {
        let entry = HealthGoalEntry(date: Date(), emoji: "😀", healthGoal: sampleHealthGoal)
        completion(entry)
    }

    // where the actual timeline gets created
    // entry is the data
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [HealthGoalEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = HealthGoalEntry(date: entryDate, emoji: "😀", healthGoal: sampleHealthGoal)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// always needs at least a date
struct HealthGoalEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let healthGoal: HealthGoal
}

struct HealthGoalWidgetEntryView : View {
    var entry: HealthGoalEntry

    var body: some View {
        ZStack {
//            ContainerRelativeShape()
//                .fill(sampleHealthGoal.colorSet.background)
            VStack {
                WidgetPreView(healthGoal: sampleHealthGoal)
                    .frame(maxWidth: .infinity)
            }
        }

    }
}

struct HealthGoalWidget: Widget {
    let kind: String = "HealthGoalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HealthGoalWidgetEntryView(entry: entry)
                    .containerBackground(.fill, for: .widget)
            } else {
                HealthGoalWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

//#Preview(as: .systemSmall) {
//    HealthGoalWidget()
//} timeline: {
//    HealthGoalEntry(date: .now, emoji: "😀", healthGoal: sampleHealthGoal)
//    HealthGoalEntry(date: .now, emoji: "🤩", healthGoal: sampleHealthGoal)
//}
