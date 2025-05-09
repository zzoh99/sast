package com.hr.common.other;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.inject.Inject;
import javax.inject.Named;

import com.hr.common.exception.HrException;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
import com.hr.hrm.appmtBasic.appmtItemMapMgr.AppmtItemMapMgrService;
import com.hr.hrm.dispatch.dispatchApr.DispatchAprService;
import com.hr.hrm.retire.retireApr.RetireAprService;
import com.hr.hrm.timeOff.timeOffApr.TimeOffAprService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("OtherService")
public class OtherService{

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private AppmtItemMapMgrService appmtItemMapMgrService;

	@Autowired
	private TimeOffAprService timeOffAprService;

	@Autowired
	private DispatchAprService dispatchAprService;

	@Autowired
	private RetireAprService retireAprService;

	/**
	 * Sequence 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getSequence(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getSequence", paramMap);
	}

	/**
	 * Base64 ENCODE 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getBase64En(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getBase64En", paramMap);
	}

	/**
	 * Base64 DECODE 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getBase64De(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getBase64De", paramMap);
	}


	/**
	 * Blob 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getImagePrint(Map<?, ?> paramMap) throws Exception {
		return dao.getMap("getImagePrint", paramMap);
	}

	/**
	 * 뷰 쿼리 Service
	 * @param mappingMap
	 * @return
	 * @throws Exception
	 */
	public String getViewQuery(Map<String, Object> mappingMap) throws Exception {
		//mappingMap.put("searchViewNm", searchViewNm);
		Map<?, ?> mp = dao.getMap("getViewQuery", mappingMap);
		String viewQuery = "";
		if(mp != null) {
			viewQuery = (String) mp.get("text");
		}
		Pattern pattern = Pattern.compile("\\'\\@(.*?)\\@\\'");
		Matcher match = pattern.matcher(viewQuery);

		while(match.find()){
			String strParam = match.group(1);
			String strValue = (String)mappingMap.get(match.group(1));
			if(strValue != null) {
				viewQuery = viewQuery.replaceAll ("\\'\\@"+strParam+"\\@\\'", "'"+strValue.replaceAll("[@]", "\\\\\\@")+"'");
			} else {
				viewQuery = viewQuery.replaceAll ("\\'\\@"+strParam+"\\@\\'", "''");
			}
		}

		return viewQuery;
	}

	public int OrdBatch(Map<?, ?> paramMap, Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		// 발령항목(select문을 만들기위해 post_item을 조회)조회
		List<Map<String,Object>> postItemList  = (List<Map<String, Object>>) appmtItemMapMgrService.getAppmtItemMapMgrList(paramMap);

		Map<String, Object> postMap = new HashMap<String,Object>();
		postMap.put("ssnSabun", paramMap.get("ssnSabun"));
		postMap.put("ssnEnterCd", paramMap.get("ssnEnterCd"));

		List<Map<String,Object>> postMergeList = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> list = (List<Map<String,Object>>)convertMap.get("mergeRows");

		for(Map<String,Object> map : list){
			String prePostYn = (String)map.get("prePostYn"); //사용자가 수정한 값
			String prePostYn2 = (String)map.get("prePostYn2"); // backup 값
			if(prePostYn!=null && prePostYn2!=null ){
				if(prePostYn.equals("Y") && !prePostYn.equals(prePostYn2)){
					// 발령연계처리
					postMergeList.add(map);

					// 발령연계시점보다 이후의 미확정발령이 존재하는 경우 에러처리
					Map<String, Object> valChk = (Map<String, Object>) dao.getMap("getPreOrdCntCheck", map);
					if(valChk != null && !valChk.isEmpty() && Integer.parseInt(valChk.get("cnt").toString()) > 0) {
						throw new HrException("사원번호 : " + map.get("sabun") + "인 직원의 발령일자 : " + map.get("ordYmd") + " 이후 미확정 발령이 존재 합니다. 발령정보를 확인해 주시기 바랍니다");
					}

					// 개인별 발령 항목 조회 (THRM151, THRM223)
					map.put("postItemList", postItemList);//발령항목
					Map<String, Object> psnlPostData = (Map<String, Object>) dao.getMap("getOrdBatchPsnlPostData", map);

					// 값 저장 후, 발령항목 예외 사항 처리
					if(psnlPostData.get("ordTypeCd").equals("C")) { // 휴직
						dao.update("saveTimeOffApr", convertMap);
						timeOffAprService.saveTimeOffAprTHRM229(convertMap);
						// 휴.복직신청 발령 연계인 경우, ORD_E_YMD 값을 REF_EDATE 값으로 대체
						psnlPostData.put("ordEYmd", map.get("refEdate"));
					} else if(psnlPostData.get("ordTypeCd").equals("D")) { // 복직
						dao.update("saveTimeOffApr", convertMap);
						psnlPostData.put("ordEYmd", map.get("refEdate"));
					} else if(psnlPostData.get("ordTypeCd").equals("K")) { // 파견 발령
						dispatchAprService.updateDispatchApr(convertMap);
					}  else if(psnlPostData.get("ordTypeCd").equals("E")) { // 퇴직
						// 퇴직신청 발령 연계인 경우, ORD_E_YMD 값을 null 처리
						retireAprService.updateRetireApr(convertMap);
						psnlPostData.put("ordEYmd", "");
					} else if(psnlPostData.get("ordTypeCd").equals("F")) {
						dao.update("savePromTargetMgr", convertMap);
						// 승진급대상자 발령 연계인 경우, 승진직위/승진직급 값으로 대체
						psnlPostData.put("jikweeCd", map.get("jikweeCd"));
						psnlPostData.put("jikweeNm", map.get("jikweeNm"));
						psnlPostData.put("jikgubCd", map.get("jikgubCd"));
						psnlPostData.put("jikgubNm", map.get("jikgubNm"));
					}

					for(Map<String,Object> postItem : postItemList){
						String ckey = StringUtil.getCamelize((String)postItem.get("columnCd"));
						postItem.put("value", psnlPostData.get(ckey));

						if("P".equals(postItem.get("cType")) || "C".equals(postItem.get("cType"))){
							String nkey = StringUtil.getCamelize((String)postItem.get("nmColumnCd"));
							postItem.put("nmValue", psnlPostData.get(nkey));
						}
					}

					psnlPostData.put("postItemList", postItemList);
					cnt += dao.create("saveOrdBatchMaster", psnlPostData); // THRM221 Insert
					dao.create("saveOrdBatchDetail", psnlPostData); // THRM223 Insert
				}
			}
		}
		return cnt;
	}
}