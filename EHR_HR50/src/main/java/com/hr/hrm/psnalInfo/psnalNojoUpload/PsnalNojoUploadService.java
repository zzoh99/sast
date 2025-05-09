package com.hr.hrm.psnalInfo.psnalNojoUpload;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service
public class PsnalNojoUploadService {

    @Autowired
    private Dao dao;

    public List<?> getPsnalNojoUploadList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPsnalNojoUploadList", paramMap);
    }

    public int savePsnalNojoUpload(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deletePsnalNojoUpload", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("savePsnalNojoUpload", convertMap);
        }

        return cnt;
    }
}
