package com.hr.cpn.personalPay.perPayPartiPopSta;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 급여명세서 Service
 *
 * @author JM
 *
 */
@Service("PerPayPartiPopStaService")
public class PerPayPartiPopStaService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 급여명세서 기본정보 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPerPayPartiPopStaBasicMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getPerPayPartiPopStaBasicMap", paramMap);
	}

	/**
	 * 급여명세서 지급/공제내역 건수조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPerPayPartiPopStaCalcCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getPerPayPartiPopStaCalcCnt", paramMap);
	}

	/**
	 * 급여명세서 지급/공제내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiPopStaCalcList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayPartiPopStaCalcList", paramMap);
	}

	/**
	 * 급여명세서  과표내역 건수조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPerPayPartiPopStaCalcTaxCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getPerPayPartiPopStaCalcTaxCnt", paramMap);
	}

	/**
	 * 급여명세서 과표내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiPopStaCalcTaxList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayPartiPopStaCalcTaxList", paramMap);
	}
}