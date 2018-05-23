package com.basicshell;

import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import com.basicshell.browser.ActivityBaseWebImpl;

import java.net.URISyntaxException;
import java.util.List;

public class ActivityNativeWeb extends ActivityBaseWebImpl {

    private static final long DURATION = 3000;
    private long latestTimeMillis;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        toolbar.setVisibility(View.GONE);
    }

    @Override
    protected String getUrl() {
        String url = BuildConfig.SHELL_WEB_URL;
        if (TextUtils.isEmpty(url)) {
            url = super.getUrl();
        }
        return url;
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        boolean result = false;
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            result = agentWeb.back();
            if (!result) {
                long now = System.currentTimeMillis();
                if (now - latestTimeMillis > DURATION) {
                    latestTimeMillis = now;
                    Toast.makeText(this, "再按一下就退出了哦！", Toast.LENGTH_SHORT).show();
                    result = true;
                }
            }
        }
        if (!result) {
            result = super.onKeyDown(keyCode, event);
        }
        return result;
    }

    @Override
    protected WebViewClient getWebViewClient() {
        WebViewClient webViewClient = new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                try {
                    if (url.startsWith("intent://")) {
                        Intent intent;
                        try {
                            intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
                            intent.addCategory("android.intent.category.BROWSABLE");
                            intent.setComponent(null);
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH_MR1) {
                                intent.setSelector(null);
                            }
                            List<ResolveInfo> resolves = getApplicationContext().getPackageManager().queryIntentActivities(intent, 0);
                            if (resolves.size() > 0) {
                                startActivityIfNeeded(intent, -1);
                            }
                            return true;
                        } catch (URISyntaxException e) {
                            e.printStackTrace();
                        }
                    }
                    if (!url.startsWith("http")) {
                        try {
                            final Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);
                            startActivity(intent);
                        } catch (Exception e) {
                            e.printStackTrace();
                            Toast.makeText(ActivityNativeWeb.this, "打开应用失败！", Toast.LENGTH_SHORT).show();
                        }
                        return true;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                return super.shouldOverrideUrlLoading(view, url);
            }
        };
        return webViewClient;
    }
}