package com.hr.api.self.certi;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;


@Service("SelfCertiService")
public class SelfCertiService {

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 제증명신청 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getSelfCertiAppList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getSelfCertiAppList", paramMap);
    }

    /**
     * 재직이력 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getCertiEmpHisList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getCertiEmpHisList", paramMap);
    }

    /**
     * 재직이력 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getSelfCertiAppDetList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getSelfCertiAppDetList", paramMap);
    }

    public int updateSelfCerti(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return dao.create("updateSelfCerti", paramMap);
    }

}