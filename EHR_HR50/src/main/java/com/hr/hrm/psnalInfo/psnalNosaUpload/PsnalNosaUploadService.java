package com.hr.hrm.psnalInfo.psnalNosaUpload;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service
public class PsnalNosaUploadService {
    @Inject
    @Named("Dao")
    private Dao dao;

    public List<?> getPsnalNosaUploadList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPsnalNosaUploadList", paramMap);
    }

    public int savePsnalNosaUpload(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deletePsnalNosaUpload", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("savePsnalNosaUpload", convertMap);
        }

        return cnt;
    }
}
