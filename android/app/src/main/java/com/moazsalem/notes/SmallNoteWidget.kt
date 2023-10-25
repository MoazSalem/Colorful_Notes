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
class SmallNoteWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            // Create an intent to handle widget click
            val intent = Intent(context, SmallNoteWidget::class.java)
            intent.action = "widgetClicked"

            // Create a PendingIntent for the widget click
            val pendingIntent = PendingIntent.getBroadcast(context, 0, intent,
                PendingIntent.FLAG_IMMUTABLE)

            // Create RemoteViews
            val views = RemoteViews(context.packageName, R.layout.small_note_widget).apply {
                val widgetData = HomeWidgetPlugin.getData(context)
                val titlesArray = widgetData.getString("titles", "No Notes")?.split("||S||")
                val contentsArray = widgetData.getString("contents", "Add Notes from App")?.split("||S||")
                val colorsArray = widgetData.getString("colors", "#f77b85")?.split("||S||")
                val textCArray = widgetData.getString("textColors", "")?.split("||S||")
                val textColor = if(textCArray?.get(globalIndex) == "1") "#000000" else "#ffffff"
                setTextViewText(R.id.title, titlesArray?.get(globalIndex) ?: "No Title")
                setTextColor(R.id.title, Color.parseColor(textColor))
                setTextViewText(R.id.content, contentsArray?.get(globalIndex) ?: "No Content")
                setTextColor(R.id.content, Color.parseColor(textColor))
                setInt(R.id.background, "setBackgroundColor", Color.parseColor(colorsArray?.get(globalIndex) ?: "#f77b85"))
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
            val appWidgetIds = appWidgetManager.getAppWidgetIds(ComponentName(context, SmallNoteWidget::class.java))
            onUpdate(context, appWidgetManager, appWidgetIds)
        }
    }
}
