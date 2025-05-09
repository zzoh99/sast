package com.hr.hrm.empRcmd.aiEmpRcmd;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.notification.NotificationService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.StringUtil;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import java.net.HttpURLConnection;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

/**
 * 인원명부항목정의 Service
 *
 * @author 이름
 *
 */
@Service("AiEmpRcmdService")
public class AiEmpRcmdService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Autowired
	private NotificationService notificationService;

	@Value("${isu.ai.key}")
	private String apiKey;

	@Value("${isu.ai.url}")
	private String apiUrl;

	/**
	 * 인원명부 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<Map<String, Object>> getAiEmpRcmdEmpList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		//사번으로 orgNm(부서명) 조회
		//F_COM_GET_ORG_NM2(#{ssnEnterCd}, #{searchSabun}, TO_CHAR(SYSDATE,'YYYYMMDD'))
		//직무 조회
		//F_COM_GET_JOB_NM(A.ENTER_CD, A.SABUN, TO_CHAR(sysdate, 'YYYYMMDD')) AS JOB_NM
		List<Map<String, Object>> list = (List<Map<String, Object>>) dao.getList("getAiEmpRcmdEmpList", paramMap);
		JSONParser jsonParser = new JSONParser();

		//det의 Json 변환
		int i = 0;
		for(Map<String, Object> result : list){
			Log.Debug(""+i);
			Log.Debug(result.toString());
			Log.Debug(""+result.containsKey("det"));
			Log.Debug(result.get("det").toString());
			if(result.containsKey("det")){
				if(result.get("det").toString().contains("\"strengths\"") && result.get("det").toString().contains("\"weaknesses\"")){
					JSONObject jsonObject = (JSONObject) jsonParser.parse(result.get("det").toString());
					if(jsonObject.containsKey("strengths")) list.get(i).put("strengths", jsonObject.get("strengths"));
					if(jsonObject.containsKey("weaknesses")) list.get(i).put("weaknesses", jsonObject.get("weaknesses"));
				}
			}
			Log.Debug(list.get(i).toString());
			i++;
		}

		return list;
	}

	/**
	 * 인원 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAiEmpRcmdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAiEmpRcmdList", paramMap);
	}

	/**
	 * API input Data
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAiEmpRcmdGubun(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAiEmpRcmdGubun", paramMap);
	}

	/**
	 * API input Data
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAiEmpRcmdGubunQuery(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAiEmpRcmdGubunQuery", paramMap);
	}

	/**
	 * 인재추천구분 항목
	 * @param paramMap
	 * @throws Exception
	 */
	public List<?> getAiEmpRcmdGubunList(HttpServletRequest request, Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAiEmpRcmdGubunList", paramMap);
	}

	/**
	 * 인재추천구분 항목
	 * @param paramMap
	 * @throws Exception
	 */
	public List<?> getAiEmpRcmdPart(HttpServletRequest request, Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> result = (Map<String, Object>) dao.getMap("getAiEmpRcmdPart", paramMap);

		//Sting to Json
		String part = result.get("part").toString();
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject = (JSONObject) jsonParser.parse(part);
		Set<String> keys = jsonObject.keySet();

		//해당하는 iGubun(ex.license) 값을 불러와
		//API reponse 중 part에서 일치하는 데이터만 리턴한다.
		List<Map<String, Object>> iGubunList  = (List<Map<String, Object>>) dao.getList("getAiEmpRcmdGubun", paramMap);

		List<String> iGubuns = iGubunList.stream()
				.map(map -> map.get("iGubun").toString())
				.collect(Collectors.toList());

		//Json to List
		List<Map<String, String>> list = new ArrayList<>();
		for (String key : keys) {
			for(Map<String, Object> iGubunMap : iGubunList){
				String gubun = iGubunMap.get("iGubun").toString();
				if(gubun.equals(key)){
					JSONObject iGubun = (JSONObject) jsonParser.parse(jsonObject.get(key).toString());
					JSONObject detail = (JSONObject) jsonParser.parse(iGubun.get("detail").toString());
					Map<String, String> map = new HashMap<>();
					map.put("iGubun", key);
					if("evaluation".equals(key)) map.put("type", "평가");
					if("licenseName".equals(key)) map.put("type", "자격증");
					if("career".equals(key)) map.put("type", "경력");
					if("school".equals(key)) map.put("type", "학력");
					if("punish".equals(key)) map.put("type", "징계");
					if("education".equals(key)) map.put("type", "교육");
					if("overseasTraining".equals(key)) map.put("type", "해외");
					if("language".equals(key)) map.put("type", "언어");
					map.put("score", iGubun.get("score").toString());
					map.put("weight", iGubun.get("part_total_score").toString());
					map.put("description", iGubun.get("description").toString());
					map.put("detail", iGubun.get("detail").toString());
					map.put("icon", iGubunMap.get("icon").toString());
					map.put("preview", iGubunMap.get("preview").toString());
					map.put("strengths", detail.get("strengths").toString());
					map.put("weaknesses", detail.get("weaknesses").toString());
					list.add(map);
				}
			}
		}

		return list;
	}

	/**
	 * 프롬프트 가공
	 * @param paramMap
	 * @throws Exception
	 */
	public String getAiEmpRcmdPrompt(HttpServletRequest request, Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		List<Map<String, Object>> iGubunList  = (List<Map<String, Object>>) dao.getList("getAiEmpRcmdGubun", paramMap);
		String prompt = "";
		String weight = "";
		int i = 0;
		for(Map<String, Object> iGubun : iGubunList){
			String gubun = "";
			if("".equals(prompt)){
				prompt = iGubun.get("rPrompt").toString()
						.replaceAll("@@직무명@@", paramMap.get("jobNm").toString())
						.replaceAll("@@NCS코드@@", paramMap.get("rType").toString())
						.replaceAll("@@NCS코드명@@", paramMap.get("jobNm").toString());
			}
			if("evaluation".equals(iGubun.get("iGubun"))) gubun = "평가";
			if("career".equals(iGubun.get("iGubun"))) gubun = "경력";
			if("language".equals(iGubun.get("iGubun"))) gubun = "언어";
			if("school".equals(iGubun.get("iGubun"))) gubun = "학력";
			if("punish".equals(iGubun.get("iGubun"))) gubun = "징계";
			if("overseasTraining".equals(iGubun.get("iGubun"))) gubun = "해외 연수";
			if("education".equals(iGubun.get("iGubun"))) gubun = "교육";
			if("licenseName".equals(iGubun.get("iGubun"))) gubun = "자격증";
		}

		return prompt;
	}

	/**
	 * 인재추천 대상자 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int saveAiEmpRcmd(Map<String, Object> paramMap) throws Exception {
		int reulst = 0;
		String[] sabuns = paramMap.get("sabuns").toString().split(",");
		for(String sabun : sabuns){
			paramMap.put("sabun", sabun);
			reulst += dao.update("saveAiEmpRcmd", paramMap);
		}
		return reulst;
	}

	/**
	 * 인재추천 대상자 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteAiEmpRcmd(Map<String, Object> paramMap) throws Exception {

		String[] sabunList = paramMap.get("sabuns").toString().split(",");
		int result = 0;
		for(String sabun : sabunList) {
			paramMap.put("searchSabun", sabun);
			result += dao.delete("deleteAiEmpRcmd", paramMap);
		}
		return result;
	}


	/**
	 * POC용 인재추천 API 호출 및 Response 데이터 저장
	 * @param paramMap
	 * @throws Exception
	 */
	public void getAiEmpRcmd(HttpServletRequest request, Map<String, Object> paramMap) throws Exception {
		/**
		 * API 호출을 위한 Json Data Set
		 */
		//추천 구분(THRM881)과 사번을 기준으로 데이터 조회
		//추천 구분과 사번을 기준으로 데이터 조회
		List<Map<String, Object>> data = new ArrayList<>();
		Map<String, Object> addPrompt = new HashMap<>();
		Map<String, Object> addInfo = null;
		Map<String, Object> info = null;

		String ssnEnterCd = paramMap.get("ssnEnterCd").toString();
		//선택 사원 별 loop
		String[] sabunList = paramMap.get("sabuns").toString().split(",");
		int i = 0;
		for(String sabun : sabunList){
			info = new HashMap<>();
			addInfo = new HashMap<>();
			paramMap.put("searchSabun", sabun);
			int licenseCnt = 0;
			int eduCnt = 0;
			//사번으로 테이블 조회
			Map<String, Object> empMap  = (Map<String, Object>) dao.getMap("getAiEmpRcmdEmpMap", paramMap);
			//사번으로 근속년수 조회
			Map<String, Object> careerMap  = (Map<String, Object>) dao.getMap("getAiEmpRcmdCareerMap", paramMap);
			//사번으로 orgNm(부서명) 조회
			Map<String, Object> orgMap  = (Map<String, Object>) dao.getMap("getAiEmpRcmdOrgMap", paramMap);
			//사번으로 enterNm 조회
			Map<String, Object> enterMap  = (Map<String, Object>) dao.getMap("getAiEmpRcmdEnterMap", paramMap);
			//인재추천구분 rGubun - 인재별 추천구분, 점수화정보 조회
			List<Map<String, Object>> list  = (List<Map<String, Object>>) dao.getList("getAiEmpRcmdGubun", paramMap);

			for(Map<String, Object> result: list){
				try{
					//추천구분별 쿼리 데이터 조회
					Map<?, ?> resultQuery = dao.getMap("getAiEmpRcmdGubunQueryMap", result);
					String queryStr = (String) resultQuery.get("query");
					if( !StringUtil.isBlank(queryStr) ) {
						if( queryStr.contains("dfSelSabun") && !StringUtil.isBlank(sabun) ) {
							queryStr = queryStr.replace("dfSelSabun", "'"+sabun+"'");
						}
					}
					paramMap.put("resultQuery", queryStr);

					//가져온 쿼리 조회 후
					List<?> reulstList = (List<?>) dao.getList("getAiEmpRcmdGubunQueryResultList", paramMap);
					String iGubun = "";

					//addInfo
					Map<String, Object> gubunMap = new HashMap<>();
					gubunMap.put("ratio", result.get("iRatio"));
					gubunMap.put("comment", result.get("memo"));
					addInfo.put(result.get("iGubun").toString(), gubunMap);

					//평가
					info.put(result.get("iGubun").toString(), reulstList);
					if("evaluation".equals(result.get("iGubun"))){
						iGubun = "평가";
					}
					//경력
					if("career".equals(result.get("iGubun"))){
						iGubun = "경력";
					}
					//언어
					if("language".equals(result.get("iGubun"))){
						iGubun = "언어";
					}
					//학력
					if("school".equals(result.get("iGubun"))){
						iGubun = "학력";
					}
					//징계
					if("punish".equals(result.get("iGubun"))){
						iGubun = "징계";
					}
					//해외
					if("overseasTraining".equals(result.get("iGubun"))){
						iGubun = "해외";
					}
					//교육
					if("education".equals(result.get("iGubun"))){
						eduCnt = reulstList.size();
						iGubun = "교육";
					}
					//자격증
					if("licenseName".equals(result.get("iGubun"))){
						licenseCnt = reulstList.size();
						iGubun = "자격증";
					}

				}catch(Exception e){
					Log.Error("getAiEmpRcmdGubunQuery Fail: " + e.getMessage());
				}
			}

			Map<String, Object> dVal = new HashMap<>();
			String ssnSabun = paramMap.get("ssnSabun").toString();
			String rGubun = paramMap.get("rGubun").toString();
			String jobCd = paramMap.get("jobCd").toString();
			String jobNm = paramMap.get("jobNm").toString();
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_DETAIL);

			//암호화 조합 enterCd@sabun@ssnSabun@rGubun@rType
			String key= CryptoUtil.encrypt(encryptKey, ssnEnterCd+"@"+sabun+"@"+ssnSabun+"@"+rGubun+"@"+jobCd+"@"+jobNm);

			dVal.put("licenseCnt", licenseCnt);
			dVal.put("eduCnt", eduCnt);
			dVal.put("allCareerYymmCnt", careerMap.get("allCareerYymmCnt"));
			dVal.put("orgNm", orgMap.get("orgNm"));
			dVal.put("enterNm", enterMap.get("enterNm"));
			dVal.put("jikgubNm", empMap.get("jikgubNm"));
			dVal.put("empYmd", empMap.get("empYmd"));
			dVal.put("sexTypeNm", empMap.get("sexTypeNm"));
			dVal.put("birYmd", empMap.get("birYmd"));
			dVal.put("jikweeNm", empMap.get("jikweeNm"));
			dVal.put("jikchakNm", empMap.get("jikchakNm"));
			dVal.put("key", key);
			dVal.put("info", info);
			data.add(dVal);
			i++;
		}

//		addPrompt.put("addPrompt", addInfo);

		JSONObject requestParams = new JSONObject();
		requestParams.put("enter_cd", ssnEnterCd);
		requestParams.put("data", data);
		requestParams.put("prompt", paramMap.get("prompt"));
		requestParams.put("addPrompt", addInfo);

		/**
		 * promptApiCall API 비동기 호출
		 */
		ExecutorService executorService = Executors.newFixedThreadPool(2);
		executorService.submit(() -> {
			Log.Debug("Async Start!!");
			try {
				promptApiCall(requestParams, paramMap);
			}catch(HttpServerErrorException ex) {
				Log.Error("HttpServer Error: "+ ex);
				//Status Update
//				saveStatusFail(paramMap);
			}catch (RestClientException ex) {
				Log.Error("RestClient Error: "+ ex);
				//Status Update
//				saveStatusFail(paramMap);
			}catch(Exception ex){
				Log.Error("Error: "+ ex);
				//Status Update
//				saveStatusFail(paramMap);
			}
			Log.Debug("Async End!!");
		});
	}

	/**
	 * 1. API 정보
	 * URL : http://175.45.193.132:9000
	 * PATH : /api/v1/talent/sugget/prompt
	 *
	 * 상세한 API 파라미터 및 예시는 아래 문서 참조
	 * http://175.45.193.132:9000/docs
	 */
	public void  promptApiCall(JSONObject body, Map<String, Object> paramMap) throws Exception {
		// Create a RestTemplate
		RestTemplate restTemplate = new RestTemplate();

		// Set request headers
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		//ISU-AI-KEY 추가
		headers.set("ISU-AI-KEY", apiKey);


		// HTTP 요청 엔티티 생성
		HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(body, headers);
		Log.Debug(" ReuquestData :::::" + entity.toString());
		ResponseEntity<JSONObject> responseEntity = restTemplate.exchange(
				apiUrl,
				HttpMethod.POST,
				entity,
				JSONObject.class);
		Log.Debug("ResponseData ::::: " + responseEntity.toString());
		// 응답 처리
//		if (responseEntity.getStatusCodeValue() == HttpURLConnection.HTTP_OK) {
//			// 성공적인 응답 처리
//			responsePrompt(responseEntity, paramMap);
//		} else {
//			// 에러 응답 처리
//			Log.Error("============================================================");
//			Log.Error("failed!"+ responseEntity.getStatusCode());
//			Log.Error("============================================================");
//			throw new Exception("http Response Error - 응답 코드 : " + responseEntity.getStatusCode().toString());
//		}
	}

	/**
	 * 통신 후 Response
	 */
	public void  responsePrompt(ResponseEntity<JSONObject> responseEntity, Map<String, Object> paramMap) throws Exception {
		JSONObject responseBody = new JSONObject();
//		Log.Debug("promptApiResponse ::::: " + paramMap.toString());
		// 응답 처리
		if (responseEntity.getStatusCodeValue() == HttpURLConnection.HTTP_OK) {
			// 성공적인 응답 처리
			JSONParser jsonParser = new JSONParser();
			responseBody = (JSONObject) jsonParser.parse(responseEntity.getBody().toString());

			//API Response Data 처리
			JSONArray results = (JSONArray) responseBody.get("results");
			String ssnEnterCd = paramMap.get("ssnEnterCd").toString();
			for(int i = 0; i < results.size(); i++){
				JSONObject result = (JSONObject) results.get(i);
				String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_DETAIL);
				//암호화 조합 enterCd@sabun@ssnSabun@rGubun@rType
				String[] encData = CryptoUtil.decrypt(encryptKey, result.get("key").toString()).split("@");
				Log.Debug(encData[0]);
				Log.Debug(encData[1]);
				Log.Debug(encData[2]);
				Log.Debug(encData[3]);
				Log.Debug(encData[4]);

				Map<String, Object> resultMap = new HashMap<>();
				resultMap.put("ssnEnterCd", ssnEnterCd);
				resultMap.put("sabun", encData[1]);
				resultMap.put("ssnSabun", encData[2]);
				resultMap.put("rGubun", encData[3]);
				resultMap.put("rType", encData[4]);
				resultMap.put("res", result.get("result").toString());
				resultMap.put("score", result.get("score").toString());
				resultMap.put("des", result.get("description").toString());
				resultMap.put("det", result.get("detail").toString());
				resultMap.put("part", result.get("part").toString());
				resultMap.put("status", "SUCCESS");

				//테이블 인서트
				int cnt = dao.update("saveAiEmpRcmd", resultMap);
				//merge시 part 길이가 1000자 이상시 Exception 발생, part만 별도 업데이트 처리
				//status도 동시 업데이트
				if(cnt > 0){
					dao.update("updatePartData", resultMap);
				}
			}
			if(results.size() > 0){
				Map<String, Object> pushData = new HashMap<>();
				pushData.put("notiSabun", paramMap.get("ssnSabun").toString());
				pushData.put("title", "notification");
				pushData.put("content", "요청하신 AI추천 정보가 저장되었습니다.");
				pushData.put("ssnEnterCd", ssnEnterCd);
				pushData.put("link", "AiEmpRcmd.do?cmd=viewAiEmpRcmd&empRcmdType=" + paramMap.get("rGubun").toString() + "&jobCd=" + paramMap.get("jobCd").toString() + "&jobNm=" + paramMap.get("jobNm").toString());

				// 알림 내용 저장
				notificationService.saveNotification(pushData);
//				notificationService.notify(ssnEnterCd, paramMap.get("ssnSabun").toString(), pushData.get("title").toString(), pushData.get("content"));
			}
		} else {
			// 에러 응답 처리
			Log.Error("============================================================");
			Log.Error("failed!"+ responseEntity.getStatusCode());
			Log.Error("============================================================");
			throw new Exception("http Response Error - 응답 코드 : " + responseEntity.getStatusCode().toString());
		}
	}

	/**
	 * Response API 호출 시
	 */
	public void responsePrompt(JSONObject res) throws Exception {
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject = (JSONObject) jsonParser.parse(res.toString());
		JSONArray results = (JSONArray) jsonObject.get("results");

		String ssnEnterCd = "";
		String ssnSabun = "";
		String rGubun = "";
		String jobCd = "";
		String jobNm = "";
		for(int i = 0; i < results.size(); i++){
			JSONObject result = (JSONObject) results.get(i);
			ssnEnterCd = result.get("enter_cd").toString();

			//암호화 조합 enterCd@sabun@ssnSabun@rGubun@rType
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_DETAIL);
			String[] encData = CryptoUtil.decrypt(encryptKey, result.get("key").toString()).split("@");
			ssnSabun = encData[2];
			rGubun = encData[3];
			jobCd = encData[4];
			jobNm = encData[5];

			Map<String, Object> resultMap = new HashMap<>();
			resultMap.put("ssnEnterCd", ssnEnterCd);
			resultMap.put("sabun", encData[1]);
			resultMap.put("ssnSabun", ssnSabun);
			resultMap.put("rGubun", rGubun);
			resultMap.put("rType", jobCd);
			resultMap.put("res", result.get("result").toString());
			resultMap.put("score", result.get("score").toString());
			resultMap.put("des", result.get("description").toString());
			resultMap.put("det", result.get("detail").toString());
			resultMap.put("part", result.get("part").toString());
			resultMap.put("status", "SUCCESS");

			//테이블 인서트
			int cnt = dao.update("saveAiEmpRcmd", resultMap);
			//merge시 part 길이가 1000자 이상시 Exception 발생, part만 별도 업데이트 처리
			//status도 동시 업데이트
			if(cnt > 0){
				dao.update("updatePartData", resultMap);
			}
		}
		if(results.size() > 0){
			Map<String, Object> pushData = new HashMap<>();
			pushData.put("notiSabun", ssnSabun);
			pushData.put("title", "notification");
			pushData.put("content", "요청하신 AI추천 정보가 저장되었습니다.");
			pushData.put("ssnEnterCd", ssnEnterCd);
			pushData.put("link", "AiEmpRcmd.do?cmd=viewAiEmpRcmd&empRcmdType=" + rGubun + "&jobCd=" + jobCd + "&jobNm=" + jobNm);

			// 알림 내용 저장
			notificationService.saveNotification(pushData);
//			notificationService.notify(ssnEnterCd, ssnSabun, pushData.get("title").toString(), pushData.get("content"));
		}
	}

	//통신 연결, 응답 등 에러 시 상태값 변경
	public void saveStatusFail(Map<String, Object> paramMap){
		try {
			String[] sabuns = paramMap.get("sabun").toString().split(",");
			paramMap.put("status", "FAIL");
			paramMap.put("sabuns", sabuns);
			paramMap.put("rType", paramMap.get("jobCd").toString());
			int cnt = dao.update("updateAiEmpRcmdStatus", paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}