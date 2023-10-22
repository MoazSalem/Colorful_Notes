package com.moazsalem.notes

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.content.SharedPreferences
import android.graphics.Color
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class BigNoteWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId, HomeWidgetPlugin.getData(context))
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int,
    widgetData: SharedPreferences
) {
    val views = RemoteViews(context.packageName, R.layout.big_note_widget).apply {
        val titleText = widgetData.getString("title", "No Title");
        val contentText = widgetData.getString("content", "No Content");
        setTextViewText(R.id.title, titleText);
        setTextViewText(R.id.content, contentText);
        setInt(R.id.background, "setBackgroundColor", Color.parseColor(widgetData.getString("color", "#ffffff")));
        if (titleText == null || contentText == null) {
            setTextViewText(R.id.title, "No Notes");
            setTextViewText(R.id.content, "Add a note from the app");
            return;
        }
    }

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}