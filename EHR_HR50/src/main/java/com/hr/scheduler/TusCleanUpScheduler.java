package com.hr.scheduler;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.hr.TusConfig;
import com.hr.common.logger.Log;


@Component
public class TusCleanUpScheduler {

    @Autowired
    private TusConfig config;

    /**
     * 업로드가 중단된 데이터 중
     * TusConfig 에서 설정한 만료시간이 지난 데이터들 대상으로 삭제
     * @throws IOException
     */
    @Scheduled(fixedRate =  1000 * 60 * 30  ) // 30분
    public void cleanup() {
        try {
            Log.Info("tus uploads clean Up");
            config.tus().cleanup();
        }catch (IOException e){
            Log.Debug(e.getLocalizedMessage());
        }

    }

}
