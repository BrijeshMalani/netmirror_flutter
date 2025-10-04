package com.example.netmirror_flutter

import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class ListTileNativeAdFactory(private val layoutInflater: LayoutInflater) :
    GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = layoutInflater.inflate(
            getLayoutId("medium_template"),
            /* root = */ null
        ) as NativeAdView

        // Bind views to actual ids defined in medium_template.xml
        setTextView(adView, nativeAd, "native_ad_headline") { view, ad ->
            view.text = ad.headline
            adView.headlineView = view
        }

        setTextView(adView, nativeAd, "native_ad_body") { view, ad ->
            view.text = ad.body ?: ""
            adView.bodyView = view
        }

        setButton(adView, nativeAd, "native_ad_button") { view, ad ->
            view.text = ad.callToAction ?: ""
            adView.callToActionView = view
        }

        setImageView(adView, nativeAd, "native_ad_icon") { view, ad ->
            ad.icon?.let { view.setImageDrawable(it.drawable) }
            adView.iconView = view
        }

        setMediaView(adView, nativeAd, "native_ad_media") { view, _ ->
            adView.mediaView = view
        }

        // Required: assign the ad to the view
        adView.setNativeAd(nativeAd)
        return adView
    }

    private fun getLayoutId(name: String): Int {
        val context = layoutInflater.context
        return context.resources.getIdentifier(name, "layout", context.packageName)
    }

    private inline fun setTextView(
        root: View,
        ad: NativeAd,
        idName: String,
        bind: (TextView, NativeAd) -> Unit
    ) {
        val id = root.resources.getIdentifier(idName, "id", root.context.packageName)
        if (id != 0) {
            val view = root.findViewById<TextView>(id)
            if (view != null) bind(view, ad)
        }
    }

    private inline fun setButton(
        root: View,
        ad: NativeAd,
        idName: String,
        bind: (Button, NativeAd) -> Unit
    ) {
        val id = root.resources.getIdentifier(idName, "id", root.context.packageName)
        if (id != 0) {
            val view = root.findViewById<Button>(id)
            if (view != null) bind(view, ad)
        }
    }

    private inline fun setImageView(
        root: View,
        ad: NativeAd,
        idName: String,
        bind: (ImageView, NativeAd) -> Unit
    ) {
        val id = root.resources.getIdentifier(idName, "id", root.context.packageName)
        if (id != 0) {
            val view = root.findViewById<ImageView>(id)
            if (view != null) bind(view, ad)
        }
    }

    private inline fun setMediaView(
        root: View,
        ad: NativeAd,
        idName: String,
        bind: (MediaView, NativeAd) -> Unit
    ) {
        val id = root.resources.getIdentifier(idName, "id", root.context.packageName)
        if (id != 0) {
            val view = root.findViewById<MediaView>(id)
            if (view != null) bind(view, ad)
        }
    }
}


