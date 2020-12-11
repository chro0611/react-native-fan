package com.reactnativefan;

import android.widget.Toast;

import com.facebook.ads.Ad;
import com.facebook.ads.AdError;
import com.facebook.ads.InterstitialAd;
import com.facebook.ads.InterstitialAdListener;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class FanModule extends ReactContextBaseJavaModule implements InterstitialAdListener, LifecycleEventListener {

  private Promise showPromise;
  private Promise loadPromise;
  private boolean didClick = false;
  private boolean loaded = false;

  private InterstitialAd interstitial;

  public FanModule(ReactApplicationContext reactContext) {
    super(reactContext);
    reactContext.addLifecycleEventListener(this);
  }

  @ReactMethod
  public void loadAd(String placementId, Promise p){
    loadPromise = p;
    ReactApplicationContext reactContext = this.getReactApplicationContext();

    interstitial = new InterstitialAd(reactContext, placementId);
    interstitial.loadAd(
      interstitial.buildLoadAdConfig().withAdListener(this).build()
    );
  }

  @ReactMethod
  public void isLoad(Promise p){
    p.resolve(loaded);
  }

  @ReactMethod
  public void showAd(Promise p){
    showPromise = p;
    if(loaded){
      interstitial.show();
    }
  }

  @Override
  public String getName() {
    return "Fan";
  }

  @Override
  public void onError(Ad ad, AdError adError) {
    loadPromise.reject("E_FAILED_TO_LOAD", adError.getErrorMessage());
    cleanUp();
  }

  @Override
  public void onAdLoaded(Ad ad) {
    loaded = true;
    loadPromise.resolve(loaded);
  }

  @Override
  public void onAdClicked(Ad ad) {
    didClick = true;
  }

  @Override
  public void onInterstitialDismissed(Ad ad) {
    showPromise.resolve(didClick);
    cleanUp();
  }

  @Override
  public void onInterstitialDisplayed(Ad ad) {

  }

  @Override
  public void onLoggingImpression(Ad ad) {
  }

  private void cleanUp() {
    showPromise = null;
    loadPromise = null;
    didClick = false;
    loaded = false;

    if (interstitial != null) {
      interstitial.destroy();
      interstitial = null;
    }
  }

  @Override
  public void onHostResume() {

  }

  @Override
  public void onHostPause() {

  }

  @Override
  public void onHostDestroy() {
    cleanUp();
  }
}
