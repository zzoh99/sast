package com.hr;

import java.io.File;
import java.io.IOException;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import me.desair.tus.server.TusFileUploadService;

@Configuration
public class TusConfig {

    @Value("${tus.server.data.directory}")
    String tusStoragePath;

    @Value("${tus.server.data.expiration}")
    Long tusExpirationPeriod;
    
    private TusFileUploadService tusFileUploadService;

    @PostConstruct
    public void init() {
        new File(tusStoragePath).mkdirs();

        if (new File(tusStoragePath + "/locks").mkdirs())
            Log.Debug("Created tus lock directory");


        if (new File(tusStoragePath + "/uploads").mkdirs())
            Log.Debug("Created tus uploads directory");

        // 실제 파일을 관리할 공간
        if (new File(tusStoragePath + "/bucket").mkdirs())
            Log.Debug("Created tus lock directory");
        
        this.tusFileUploadService = new TusFileUploadService()
                .withStoragePath(tusStoragePath)
                .withDownloadFeature()
                .withUploadExpirationPeriod(tusExpirationPeriod)
//                .withUploadURI("/.*"); // 일단 전체 allow  구지 특정 url 만 허용할 필요성을 못느낌
                .withUploadURI("/tus/api/.*/upload");
    }


    @PreDestroy
    public void exit() throws IOException {
        tus().cleanup();
    }

    public TusFileUploadService tus() {
        return this.tusFileUploadService;
    }
}
