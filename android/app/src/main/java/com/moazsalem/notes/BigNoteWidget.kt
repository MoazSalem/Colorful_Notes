package com.moazsalem.notes

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

private var globalIndex: Int = 0
class BigNoteWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            // Create an intent to handle widget click
            val intent = Intent(context, BigNoteWidget::class.java)
            intent.action = "widgetClicked"

            // Create a PendingIntent for the widget click
            val pendingIntent = PendingIntent.getBroadcast(context, 0, intent,
                PendingIntent.FLAG_IMMUTABLE)

            // Create RemoteViews
            val views = RemoteViews(context.packageName, R.layout.big_note_widget).apply {
                val widgetData = HomeWidgetPlugin.getData(context)
                val titlesArray = widgetData.getString("titles", "")?.split("||S||")
                val contentsArray = widgetData.getString("contents", "")?.split("||S||")
                val colorsArray = widgetData.getString("colors", "#F4B907")?.split("||S||")
                val layoutsArray = widgetData.getString("layouts", "")?.split("||S||")
                setTextViewText(R.id.title, titlesArray?.get(globalIndex) ?: "No Title")
                setTextViewText(R.id.content, contentsArray?.get(globalIndex) ?: "No Content")
                setInt(R.id.background, "setBackgroundColor", Color.parseColor(colorsArray?.get(globalIndex) ?: "#F4B907"))
                if (titlesArray?.get(globalIndex) == "" && contentsArray?.get(globalIndex) == "") {
                    setTextViewText(R.id.title, "No Notes")
                    setTextViewText(R.id.content, "Add a note from the app")
                    return
                }

                // Set the click action to increment globalIndex
                setOnClickPendingIntent(R.id.background, pendingIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        if (intent.action == "widgetClicked") {
            // Handle widget click
            val widgetData = HomeWidgetPlugin.getData(context)
            val titlesArray = widgetData.getString("titles", "")?.split("||S||")
            if (titlesArray != null && globalIndex < titlesArray.size - 1) {
                globalIndex++
            } else {
                globalIndex = 0
            }

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(ComponentName(context, BigNoteWidget::class.java))
            onUpdate(context, appWidgetManager, appWidgetIds)
        }
    }
}
