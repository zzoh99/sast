package com.hr.common.scheduler;

import com.hr.common.logger.Log;
import com.hr.common.util.fileupload.impl.FileUploadConfig;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.attribute.BasicFileAttributes;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

@Service
public class TempCleanScheduleService {
    @Value("${temp.folder.cleanup.hours:0}")
    private int intervalHours;

    @Value("${common.temp.path:/temp}")
    private String tempPath;

    public void cleanTempOldFolders() {
        if (intervalHours <= 0) {
            return; // 설정값이 없거나 0 이하인 경우 작업을 수행하지 않음
        }

        File directory = new File(tempPath);
        if (!directory.exists() || !directory.isDirectory()) {
            return;
        }

        File[] files = directory.listFiles();
        if (files == null) {
            return;
        }

        for (File file : files) {
            try {
                BasicFileAttributes attrs = Files.readAttributes(file.toPath(), BasicFileAttributes.class);
                Instant creationTime = attrs.creationTime().toInstant();
                Instant now = Instant.now();

                if (ChronoUnit.HOURS.between(creationTime, now) >= intervalHours && file.isDirectory()) {
                    delete(file);
                }
            } catch (Exception e) {
                Log.Debug("clean old temp folders error");
                e.printStackTrace();
            }
        }
    }

    private void delete(File file) {
        if (file.isDirectory()) {
            for (File subFile : file.listFiles()) {
                delete(subFile);
            }
        }
        file.delete();
    }
}
