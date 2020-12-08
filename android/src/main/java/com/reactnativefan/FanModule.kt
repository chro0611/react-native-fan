package com.reactnativefan

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.LifecycleEventListener

import com.facebook.ads.Ad
import com.facebook.ads.AdError
import com.facebook.ads.InterstitialAdListener
import com.facebook.ads.InterstitialAd

class FanModule : ReactContextBaseJavaModule, LifecycleEventListener{

    constructor(context: ReactApplicationContext){
      reactContext = context
      context.addLifecycleEventListener(this)

      adListener = object:InterstitialAdListener{
        override fun onError(ad: Ad?, adError: AdError){
          (loadPromise as Promise).reject("E_FAILED_TO_LOAD", adError.getErrorMessage())
          cleanUp()
        }

        override fun onAdLoaded(ad: Ad){
          (loadPromise as Promise).resolve(true)
          adLoaded = true
        }

        override fun onAdClicked(ad: Ad?){
          didClick = true
        }

        override fun onInterstitialDismissed(ad: Ad?){
          showPromise?.resolve(didClick)
          cleanUp()
        }

        override fun onInterstitialDisplayed(ad: Ad?){
        }

        override fun onLoggingImpression(ad: Ad?){
        }
      }
    }

    var adListener : InterstitialAdListener
    var reactContext : ReactApplicationContext

    var loadPromise : Promise? = null
    var showPromise : Promise? = null

    var interstitial : InterstitialAd? = null

    var didClick : Boolean = false
    var adLoaded : Boolean = false

    override fun getName(): String{
      return "Fan"
    }

    @ReactMethod
    fun initialized(placementId : String){
      this.interstitial = InterstitialAd(reactContext, placementId)
    }

    @ReactMethod
    fun isLoad(p: Promise){
      p.resolve(this.adLoaded)
    }

    @ReactMethod
    fun showAd(p: Promise){
      showPromise = p

      if(adLoaded) interstitial?.show()
    }

    @ReactMethod
    fun loadAd(p: Promise){
      loadPromise = p

      (interstitial as InterstitialAd).loadAd(
        (interstitial as InterstitialAd).buildLoadAdConfig()
          .withAdListener(adListener)
          .build())
    }

    private fun cleanUp(){
      showPromise = null
      loadPromise = null
      didClick = false
      adLoaded = false
    }

    override fun onHostResume(){
    }

    override fun onHostPause(){
    }

    override fun onHostDestroy(){
      cleanUp()
    }
}
