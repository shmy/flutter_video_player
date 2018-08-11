package tech.shmy.plugins.videoplayer;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.content.Intent;
//import android.widget.ImageView;
//
//import com.bumptech.glide.Glide;
import com.shuyu.gsyvideoplayer.GSYVideoManager;
import com.shuyu.gsyvideoplayer.utils.GSYVideoType;
import com.shuyu.gsyvideoplayer.utils.OrientationUtils;
import com.shuyu.gsyvideoplayer.video.StandardGSYVideoPlayer;


public class PlayerActivity extends AppCompatActivity {

    StandardGSYVideoPlayer videoPlayer;

    OrientationUtils orientationUtils;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // 该页面直接全屏
        // 去除title
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        // 去掉Activity上面的状态栏
        getWindow().setFlags(WindowManager.LayoutParams. FLAG_FULLSCREEN , WindowManager.LayoutParams. FLAG_FULLSCREEN);

        setContentView(R.layout.activity_player);

        init();
    }

    private void init() {

        Intent intent = getIntent();
        String name = intent.getStringExtra("name");
        String url = intent.getStringExtra("url");
        String pic = intent.getStringExtra("pic");
        int kernel = intent.getIntExtra("kernel", 0);
        boolean enableMediaCodec = intent.getBooleanExtra("enableMediaCodec", true);

        if (enableMediaCodec) {
            // 启用硬件解码
            GSYVideoType.enableMediaCodec();
        }

        /**
         * 设置了视频的播放类型
         * IJKPLAYER = 0; 默认IJK
         * IJKEXOPLAYER2 = 2;EXOPlayer2
         * SYSTEMPLAYER = 4;系统播放器
         */
        GSYVideoManager.instance().setVideoType(this, kernel);

        videoPlayer =  (StandardGSYVideoPlayer)findViewById(R.id.video_player);



        videoPlayer.setUp(url, true, name);

        // 显示标题栏
        videoPlayer.getTitleTextView().setVisibility(View.VISIBLE);
        // 显示返回键
        videoPlayer.getBackButton().setVisibility(View.VISIBLE);
        // 隐藏全屏按钮
        videoPlayer.getFullscreenButton().setVisibility(View.GONE);

//        ImageView imageView = new ImageView(this);
//        Glide.with(imageView).load(pic).into(imageView);
//        videoPlayer.setThumbImageView(imageView);
        // 设置旋转
        orientationUtils = new OrientationUtils(this, videoPlayer);

        //初始化不打开外部的旋转
        orientationUtils.setEnable(false);

        videoPlayer.setIsTouchWiget(true);
        //关闭自动旋转
        videoPlayer.setRotateViewAuto(false);
        videoPlayer.setLockLand(false);
//        videoPlayer.setShowFullAnimation(false);
//        videoPlayer.setNeedLockFull(true);


//
//        videoPlayer.setLockClickListener(new LockClickListener() {
//            @Override
//            public void onClick(View view, boolean lock) {
//                if (orientationUtils != null) {
//                    //配合下方的onConfigurationChanged
//                    orientationUtils.setEnable(!lock);
//                }
//            }
//        });


        //设置返回按键功能
        videoPlayer.getBackButton().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

        videoPlayer.startPlayLogic();
    }


    @Override
    protected void onPause() {
        super.onPause();
        videoPlayer.onVideoPause();
    }

    @Override
    protected void onResume() {
        super.onResume();
        videoPlayer.onVideoResume();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        GSYVideoManager.releaseAllVideos();
        if (orientationUtils != null)
            orientationUtils.releaseListener();
    }

    @Override
    public void onBackPressed() {
        // 先返回正常状态
//        if (orientationUtils.getScreenType() == ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE) {
//            videoPlayer.getFullscreenButton().performClick();
//            return;
//        }
        // 释放所有
        videoPlayer.getStartButton().performClick();
        videoPlayer.setVideoAllCallBack(null);
        super.onBackPressed();
    }


}