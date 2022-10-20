package com.reactnativeturbo

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import dev.hotwire.turbo.fragments.TurboWebFragmentCallback
import dev.hotwire.turbo.session.TurboSession
import dev.hotwire.turbo.views.TurboView
import dev.hotwire.turbo.views.TurboWebChromeClient
import dev.hotwire.turbo.views.TurboWebView

class TurboViewManager : SimpleViewManager<RNTurboView>() {
  override fun getName() = "TurboView"

  override fun createViewInstance(reactContext: ThemedReactContext): RNTurboView {
    return RNTurboView(reactContext)
  }

  @ReactProp(name = "url")
  fun setUrl(view: RNTurboView, url: String?) {
    view.setUrl(url)
  }
}

class RNTurboView(context: ThemedReactContext) : FrameLayout(context), TurboWebFragmentCallback {
  private val view = TurboView(context)
  lateinit var session: TurboSession

  init {
    createNewSession(context)
    //session.visit()

    addView(view)
  }

  private fun onCreateWebView(context: Context): TurboWebView {
    return TurboWebView(context, null)
  }

  private fun createNewSession(context: ThemedReactContext) {
    val activity = context.currentActivity as AppCompatActivity
    session = TurboSession("home", activity, onCreateWebView(context))
  }

  override val turboView: TurboView? get() = view

  override fun createErrorView(statusCode: Int): View {
    return LayoutInflater.from(context).inflate(R.layout.turbo_error, null)
  }

  override fun createProgressView(location: String): View {
    return LayoutInflater.from(context).inflate(R.layout.turbo_progress, null)
  }

  override fun createWebChromeClient(): TurboWebChromeClient {
    return TurboWebChromeClient(session)
  }

  fun setUrl(url: String?) {
    //view.setUrl(url)
  }
}
