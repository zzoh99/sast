package com.hr.cpn.payRetroact.retroPersonal;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 월별급여지급현황 Service
 *
 * @author JM
 *
 */
@Service("RetroPersonalService")
public class RetroPersonalService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 월별급여지급현황 계산내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroPersonalLst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroPersonalLst", paramMap);
	}

	/**
	 * 월별급여지급현황 계산내역TAB 세금내역 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getRetroPersonalMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getRetroPersonalMap", paramMap);
	}

	/**
	 * 월별급여지급현황 항목세부내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroPersonalDtlList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroPersonalDtlList", paramMap);
	}
	
	public List<?> getRetroDetailPopLst(Map<?, ?> paramMap, String paramQueryId) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList( paramQueryId, paramMap );
	}
	
	public Map<?,?> getRetroDetailPopMap(Map<?, ?> paramMap, String paramQueryId) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap( paramQueryId, paramMap );
	}
	
	public List<?> getRetroDetailPopLst2(Map<?, ?> paramMap, String paramQueryId) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList( paramQueryId, paramMap );
	}

    public List<?> getRetroDetailPopList1(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getRetroDetailPopList1", paramMap);
    }

    public List<?> getRetroDetailPopList2(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getRetroDetailPopList2", paramMap);
    }

    public List<?> getRetroDetailPopLst(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getRetroDetailPopLst", paramMap);
    }


}