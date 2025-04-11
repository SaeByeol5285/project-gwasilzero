package scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.project.gwasil_zero.dao.ScheduleService;

@Component
@EnableScheduling
public class ScheduledTask {

    @Autowired
    ScheduleService scheduleService;

    // 매 시간 정각 (초, 분, 시, 일, 월, 요일)
    @Scheduled(cron = "0 0 * * * *")
    public void runHourlyTask() {
        System.out.println(" 매 시간 정각 알림 전송 중..");
        scheduleService.notifyAboutSoonExpiringBoards();
    }
    

}
