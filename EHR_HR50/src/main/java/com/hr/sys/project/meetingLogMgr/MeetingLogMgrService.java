package com.hr.sys.project.meetingLogMgr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("MeetingLogMgrService")
public class MeetingLogMgrService {

    @Inject
    @Named("Dao")
    private Dao dao;

    public List<?> getModuleList(Map<String, Object> paramMap) throws Exception {
        return (List<?>) dao.getList("getModuleList",paramMap);
    }
}
