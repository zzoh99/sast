package com.hr.common.scheduler;

import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import javax.inject.Inject;

@Service
public class TempCleanScheduleController {

    @Inject
    public TempCleanScheduleService tempCleanScheduleService;

    @Value("${temp.folder.cleanup.hours:0}")
    private int intervalHours;

    // 매 시간 정각에 실행
    @Scheduled(cron = "0 0 * * * *")
    public void cleanTempOldFolders() {
        if (intervalHours > 0) {
            tempCleanScheduleService.cleanTempOldFolders();
        }
    }
}
