package com.basicshell.module;

import com.basicshell.MainApplication;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.Map;

import javax.annotation.Nullable;

public class AppConfigurationModule extends ReactContextBaseJavaModule {

    private ReactApplicationContext context;

    public AppConfigurationModule(ReactApplicationContext reactContext) {
        super(reactContext);
        context = reactContext;
    }

    @Override
    public String getName() {
        return "AppConfigurationModule";
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        return MainApplication.getAppConfiguration().configurationMap;
    }
}
