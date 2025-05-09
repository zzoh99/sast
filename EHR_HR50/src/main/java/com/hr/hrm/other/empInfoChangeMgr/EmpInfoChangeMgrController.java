package com.hr.hrm.other.empInfoChangeMgr;

import com.hr.common.logger.Log;
import com.hr.common.mail.CommonMailController;
import com.hr.common.notification.NotificationService;
import com.hr.common.other.OtherService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.upload.fileUpload.UploadService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
import com.hr.common.util.fileupload.jfileupload.web.JFileUploadService;
import com.hr.hrm.other.empInfoChangeFieldMgr.EmpInfoChangeFieldMgrService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.*;
import java.util.stream.Collectors;

@Controller@SuppressWarnings("unchecked")
@RequestMapping({"EmpInfoChangeMgr.do","/PsnalBasicInf.do"})
public class EmpInfoChangeMgrController {

	@Inject
	@Named("EmpInfoChangeFieldMgrService")
	private EmpInfoChangeFieldMgrService empInfoChangeFieldMgrService;

	@Inject
	@Named("EmpInfoChangeMgrService")
	private EmpInfoChangeMgrService empInfoChangeMgrService;

	@Inject
	@Named("UploadService")
	private UploadService uploadService;

	@Inject
	@Named("JFileUploadService")
	private JFileUploadService jFileUploadService;

	@Inject
	@Named("OtherService")
	private OtherService otherService;

	@Autowired
	private CommonMailController commonMailController;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Autowired
	private NotificationService notificationService;
	/**
	 * 1. 기존 첨부파일 데이터 query 2. new sequence 만들기 3. 파일 copy 4. 첨부파일 정보 table 에
	 * 데이터 insert 5. 첨부파일 sequence return
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	/*
	@RequestMapping(params="cmd=copyEmpInfoAttachFile", method = RequestMethod.POST )
	public ModelAndView copyEmpInfoAttachFile(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		// comment 시작
		Log.DebugStart();

		// 1. 기존 첨부파일 데이터 query
		List list = uploadService.getFileList(paramMap);
		// 2. new sequence 만들기
		paramMap.put("seqId", "FILE");
		otherService.getSequence(paramMap);
		Map<?, ?> seqNum = otherService.getSequence(paramMap);
		// 3. copy File
		String fileSeq = seqNum.get("getSeq").toString();
		String workDir = copyFile(paramMap, list, fileSeq);
		// 4.
		Map<String, Object> convertMap = new HashMap<String, Object>();
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("workDir", workDir);
		convertMap.put("mergeRows", list);
//		jFileUploadService.jFileSave(convertMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("fileSeq", fileSeq);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 
	 * @param paramMap
	 * @param list
	 * @param fileSeq
	 * @throws Exception
	 */
	/*
	private String copyFile(Map<String, Object> paramMap, List list, String fileSeq) throws Exception {

		FileUploadConfig fuConfig = new FileUploadConfig();
		String targetPath = fuConfig.getValue(FileUploadConfig.KEY_DISK_PATH);
		String workDir = StringUtil.replaceAll(
				targetPath + (String) paramMap.get("work") + DateUtil.getCurrentDay("yyyyMM") + "/", "//", "/");
		File toDir = new File(workDir);
		if (toDir.exists() == false) {
			toDir.mkdirs();// 폴더경로 없으면 만들어 놓기.
		}
		FileInputStream fis = null;
		FileOutputStream fos = null;

		for (Object o : list) {
			Map<String, Object> m = (Map<String, Object>) o;
			String newFileName = getTimeStemp();

			try {
				fis = new FileInputStream((String) m.get("filePath"));
				fos = new FileOutputStream(workDir + newFileName);
				Streams.copy(fis, fos, true);
			} catch (FileNotFoundException fe) {
				Log.Error("[FileNotFoundException] :" + fe);
			} finally {
				if (fos != null)
					fos.close();
				if (fis != null)
					fis.close();
			}
			m.put("sFileNm", newFileName);
			m.put("filePath", workDir + newFileName);
			m.put("fileSeq", fileSeq);

		}
		return workDir;
	}
	*/

	/**
	 * 
	 * @return
	 */
	@SuppressWarnings("unused")
	private String getTimeStemp() throws NoSuchAlgorithmException {
		Random ranGen =  SecureRandom.getInstance("SHA1PRNG");//new Random();
		ranGen.setSeed(new Date().getTime());

		String rtnStr = ranGen.nextDouble() + "";
		rtnStr = rtnStr.substring(2);
		return rtnStr;
	}

	/**
	 * 개인정보 변경신청 처리 저장 - 반영 or 반려 or 회답내용 저장 1. 803 (사원정보변경관리) 상태 처리 2. 신청 table
	 * (_emp) 데이터 조회 2. history insert ( 원본 table의 data를 history table 에 insert
	 * ) 3. 원table적용 4. 첨부파일 처리 5. 에러처리 에러발생시 상태:9로 하고 에러메시지를 update해줌
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEmpInfoChangeMgr", method = RequestMethod.POST )
	public ModelAndView saveEmpInfoChangeMgr(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		// comment 시작
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,
				paramMap.get("s_SAVENAME").toString(), "");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		// 1. 항목조회
		paramMap.put("searchUseYn", "Y");
		//paramMap.put("searchEmpTable", paramMap.get("empTable"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		//List<?> fieldList = empInfoChangeFieldMgrService.getEmpInfoChangeFieldMgrList(paramMap);

		String message = "";
		String applStatusCd = "";
		int resultCnt = -1;
		try {
			List<Map<String, Object>> mergeRows = (List<Map<String, Object>>) convertMap.get("mergeRows");
			List<String> execQuerys = new ArrayList<String>();
			for (Map<String, Object> map : mergeRows) {
				
				paramMap.put("searchEmpTable", map.get("empTable"));
				List<?> fieldList = empInfoChangeFieldMgrService.getEmpInfoChangeFieldMgrList(paramMap);
				
				map.put("ssnSabun", session.getAttribute("ssnSabun"));
				map.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
				
				applStatusCd = String.valueOf(map.get("applStatusCd"));
				
				if (!map.get("applStatusCd").equals(map.get("applStatusCdTmp"))
						&& "2".equals(map.get("applStatusCd"))) {
					if ("I".equals(map.get("applType"))) {
						String query = getSaveEmpInfoInsertQuery(fieldList, map, (String) map.get("applSeq"), "");
						if (query.substring(0, 2).equals("9-")) {
							map.put("applStatusCd", "9");
							map.put("errorLog", query.substring(2));
						} else
							execQuerys.add(query);// (emp 의 내용을)원본에 insert
					} else if ("U".equals(map.get("applType"))) {
						//execQuerys.add(getSaveEmpInfoInsertQuery(fieldList, map, (String) map.get("applSeq"), "HIST", "BEF"));// (원본의 내용을 ) hist 에 insert
						//execQuerys.add(getSaveEmpInfoInsertQuery(fieldList, map, (String) map.get("applSeq"), "HIST", "AFT"));// (원본의 내용을 ) hist 에 insert
						execQuerys.add(getSaveEmpInfoUpdateQuery(fieldList, map, (String) map.get("applSeq"), ""));// (emp의내용을)원본에update
					} else if ("D".equals(map.get("applType"))) {
						//execQuerys.add(getSaveEmpInfoInsertQuery(fieldList, map, (String) map.get("applSeq"), "HIST", "BEF"));// (원본의내용을)hist에insert
						execQuerys.add(getSaveEmpInfoDeleteQuery(fieldList, map, (String) map.get("applSeq"), ""));// 원본 delete 
					}
				}
				
			}
			
			// 저장
			convertMap.put("execQuerys", execQuerys);
			resultCnt = empInfoChangeMgrService.saveEmpInfoChangeMgr(convertMap);
			
			// 메일,GW알림,SMS 전송
			for (Map<String, Object> map : mergeRows) {
				if (map != null) {
					map.put("ssnSabun", session.getAttribute("ssnSabun"));
					map.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
					applStatusCd = String.valueOf(map.get("applStatusCd"));
				}
				
				if("2".equals(applStatusCd) || "3".equals(applStatusCd)) {
					Log.Debug("send mail start================>");
					// 알림 전송 시작
					Map <String, Object> chgItems = null;
					/*
					// 타이틀 변경 데이터 입력
					chgItems = new ArrayList<Map<String,Object>>();
					sendMap.put("titleChagne", chgItems);
					 */
					// 메일 내용 변경 데이터 입력
					chgItems = new HashMap<String, Object>();
					if(applStatusCd.equals("2")) {
						chgItems.put("#CHG_STATUS#", "반영");
					} else if(applStatusCd.equals("3")) {
						chgItems.put("#CHG_STATUS#", "반려");
					}
					String senderNm = String.valueOf(map.get("name"));
					Log.Debug("senderNm==>"+senderNm);
					if(senderNm.equals("")) {
						senderNm = String.valueOf(session.getAttribute("ssnName"));
					}
					
					String ctx = StringUtil.getBaseUrl(request);
					chgItems.put("#URL#"  , ctx);
					chgItems.put("#PATH#"  , "인사관리>사원정보관리>사원정보변경신청내역");
					chgItems.put("#CHG_ITEM#"  , paramMap.get("empTableNm"));
					chgItems.put("#CHG_ACTION#", "변경 신청");
					chgItems.put("#SABUN#"     , map.get("sabun"));
					chgItems.put("#NAME#"      , senderNm);
					paramMap.put("contentsChange", chgItems);
					paramMap.put("bizCd", "HRM_P_COM");
					paramMap.put("name", senderNm);
					
					String gwMsg = "사원 정보 변경신청이 "+chgItems.get("#CHG_STATUS#")+"되었습니다.\n인사 정보 시스템의 '" + chgItems.get("#PATH#") + "'에서 확인 해 주세요.";
					paramMap.put("gwMsg", gwMsg);
					
					message = commonMailController.sendAlarmOnComPersonalInfo(session, request, paramMap);


					//노티 알림
					String notiTitle = "개인정보변경 [완료]";
					String notiContent = "";
					if(applStatusCd.equals("2")) {
						notiContent = "개인정보변경 [반영]이(가) 처리완료되었습니다.";
					} else if(applStatusCd.equals("3")) {
						notiContent = "개인정보변경 [반려]이(가) 처리완료되었습니다.";
					}

					Map<String, Object> pushData = new HashMap<>();
					pushData.put("notiSabun", paramMap.get("ssnSabun").toString());
					pushData.put("title", notiTitle);
					pushData.put("content", notiContent);
					pushData.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

					// 알림 내용 저장
					notificationService.saveNotification(pushData);
//					notificationService.notify(session.getAttribute("ssnEnterCd").toString(), paramMap.get("ssnSabun").toString(), pushData.get("title").toString(), pushData.get("content"));
				}
			}
			
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
		} catch (Exception e) {
			resultCnt = -1;
			message = "저장에 실패하 였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;

	}

	/**
	 * 개인정보 변경신청 처리 - 신청
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEmpInfoReq", method = RequestMethod.POST )
	public ModelAndView saveEmpInfoReq(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		int resultCnt = -1;
		String message = "";

		Log.DebugStart();

		Map<String, Object> convertMap = new HashMap<String, Object>();
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		try {

			Map<String, Object> seqMap = (Map<String, Object>) empInfoChangeMgrService.getEmpInfoChangeSeq(paramMap);
			if(seqMap != null) {
				paramMap.put("applSeq", seqMap.get("applSeq"));
			}

			String applType = (String) paramMap.get("applType");
			
			if ( "I".equals(applType) ) {
				
				paramMap.put("abCd", "AFT");
				String query = getSaveEmpInfoQuery(paramMap);
				convertMap.put("query", query);
				
				List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
				list.add(paramMap);
				convertMap.put("mergeRows", list);

				resultCnt = empInfoChangeMgrService.saveEmpInfoReq(convertMap , true);
				
			}else if ( "U".equals(applType) ) {
				
				paramMap.put("abCd", "BEF");
				String query = getSaveEmpInfoQuery(paramMap);
				convertMap.put("query", query);
				
				List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
				list.add(paramMap);
				convertMap.put("mergeRows", list);

				resultCnt = empInfoChangeMgrService.saveEmpInfoReq(convertMap, true);
				
				paramMap.put("abCd", "AFT");
				query = getSaveEmpInfoQuery(paramMap);
				convertMap.put("query", query);
				
				list = new ArrayList<Map<String, Object>>();
				list.add(paramMap);
				convertMap.put("mergeRows", list);

				resultCnt = empInfoChangeMgrService.saveEmpInfoReq(convertMap, false);
				
			}else if ( "D".equals(applType) ) {
				
				paramMap.put("abCd", "BEF");
				String query = getSaveEmpInfoQuery(paramMap);
				convertMap.put("query", query);
				
				List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
				list.add(paramMap);
				convertMap.put("mergeRows", list);

				resultCnt = empInfoChangeMgrService.saveEmpInfoReq(convertMap, true);
				
			}
			
			if(resultCnt > 0) {
				Map <String, Object> chgItems = null;
				/*
				// 타이틀 변경 데이터 입력
				chgItems = new ArrayList<Map<String,Object>>();
				sendMap.put("titleChagne", chgItems);
				 */
				// 메일 내용 변경 데이터 입력
				
				chgItems = new HashMap<String, Object>();
				String ctx = StringUtil.getBaseUrl(request);
				
				String senderNm = String.valueOf(paramMap.get("name"));
				Log.Debug("senderNm==>"+senderNm);
				if("".equals(senderNm) || "null".equals(senderNm)) {
					senderNm = String.valueOf(session.getAttribute("ssnName"));
				}
				
				Log.Debug("senderNm==>"+senderNm);
				chgItems.put("#URL#"  , ctx);
				chgItems.put("#PATH#"  , "인사관리>사원정보변경>사원정보변경신청관리");
				chgItems.put("#CHG_ITEM#"  , paramMap.get("applTypeNm"));
				chgItems.put("#CHG_ACTION#", "수정 신청");
				chgItems.put("#SABUN#"     , paramMap.get("sabun"));
				chgItems.put("#NAME#"      , senderNm);
				
				paramMap.put("searchEnterCd", session.getAttribute("ssnEnterCd"));
				paramMap.put("contentsChange", chgItems);
				paramMap.put("bizCd", "HRM_P_CHG");
				
				String gwMsg = paramMap.get("applTypeNm") + "정보 변경신청이 있습니다.\n인사 정보 시스템의 '" + chgItems.get("#PATH#") + "'에서 확인 해 주세요.";
				paramMap.put("gwMsg", gwMsg);
				
				message = commonMailController.sendAlarmOnChgPersonalInfo(session, request, paramMap);
			}
			if("".equals(message)) {
				if (resultCnt > 0) {
					message = "저장 되었습니다.";
				} else {
					message = "저장된 내용이 없습니다.";
				}
			}
		} catch (Exception e) {
			resultCnt = -1;
			message = "저장에 실패하 였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();

		return mv;
	}

	private String getSaveEmpInfoDeleteQuery(List<?> fList, Map<String, Object> paramMap, String applSeq,
			String insertType) throws Exception {
		String delete = "DELETE FROM " + paramMap.get("empTable") + (insertType.equals("") ? "" : "_") + insertType;
		String where = " WHERE (ENTER_CD ";// '"+paramMap.get("ssnEnterCd")+"'
		String where2 = " IN ( SELECT ENTER_CD ";
		for (Object m : fList) {
			Map<String, Object> map = (Map<String, Object>) m;
			String cc = (String) map.get("columnCd");
			if ("P".equals(map.get("pkType")) || "S".equals(map.get("pkType"))) {
				where += " , " + cc;
				where2 += ", " + cc;
				// where += " AND "+cc+" =
				// '"+paramMap.get(StringUtil.getCamelize(cc))+"'";
			}
		}
		return delete + where + ")" + where2 + " FROM " + paramMap.get("empTable") + "_HIST where ENTER_CD = '"
				+ paramMap.get("ssnEnterCd") + "' AND APPL_SEQ = '" + paramMap.get("applSeq") + "') ";
	}

	private String getSaveEmpInfoUpdateQuery(List<?> fList, Map<String, Object> paramMap, String applSeq,
			String insertType) throws Exception {
		String merge = " MERGE INTO " + paramMap.get("empTable") + (insertType.equals("") ? "" : "_") + insertType
				+ " T";
		String using = " USING (SELECT * FROM " + paramMap.get("empTable") + "_HIST WHERE ENTER_CD = '"
				+ paramMap.get("ssnEnterCd") + "'";
		using += " AND APPL_SEQ = '" + applSeq + "' AND AB_CD = 'AFT' ";
		String on = " ON ( T.ENTER_CD = S.ENTER_CD ";
		String when = "";
		for (Object m : fList) {
			Map<String, Object> map = (Map<String, Object>) m;
			String cc = (String) map.get("columnCd");

			if ("P".equals(map.get("pkType")) || "S".equals(map.get("pkType"))) {
				on += " AND T." + cc + " = S." + cc;
			} else {
				if ("".equals(when)) {
					when = " WHEN MATCHED THEN UPDATE SET ";
					when += " T." + cc + " = S." + cc;
				} else
					when += ", T." + cc + " = S." + cc;
			}
		}
		return merge + using + ") S " + on + ")" + when;

	}

	private String getSaveEmpInfoInsertQuery(List<?> fList, Map<String, Object> paramMap, String applSeq,
			String insertType) throws Exception {
		String insertTable = "", selectTable = "";
		String where = "";

		String pks = "";
		String vpks = "";
		String seqs = "";
		String vseqs = "";
		String cols = "";
		String vcols = "";

		for (Object m : fList) {
			Map<String, Object> map = (Map<String, Object>) m;
			String cc = (String) map.get("columnCd");
			String cv = "'" + (String) paramMap.get(StringUtil.getCamelize(cc)) + "'";
			if ("P".equals(map.get("pkType"))) {// primary key
				pks += ", " + cc;
				vpks += ", " + cv;
			} else if ("S".equals(map.get("pkType"))) {// sequence
				seqs += ", " + cc;
				vseqs += ", " + cv;
			} else {
				cols += ", " + cc;
				vcols += ", " + cv;
			}
		}

		String seqs1 = seqs, pks1 = pks, seqs2 = seqs, pks2 = pks, cols1 = cols, cols2 = cols;
		if (insertType.equals("")) {// 원본 insert
			insertTable = paramMap.get("empTable") + "";
			selectTable = paramMap.get("empTable") + "_HIST A";
			where = " WHERE ENTER_CD = '" + paramMap.get("ssnEnterCd") + "' AND APPL_SEQ = '" + applSeq + "' ";

			// 원본 insert 시 sabun, seq 이외에 key 가 있는 경우 중복 select 체크
			if (seqs.length() < 1 && !pks.equals(", SABUN")) {
				String dupchkQuery = "SELECT COUNT(*) AS CNT FROM " + insertTable + " WHERE ENTER_CD = '"
						+ paramMap.get("ssnEnterCd") + "' AND (" + pks.substring(1) + ") IN (" + " SELECT "
						+ pks.substring(1) + " FROM " + selectTable + where + ")";

				paramMap.put("query", dupchkQuery);
				List<?> result = empInfoChangeMgrService.getEmpInfoList(paramMap);
				if (result != null && result.size() > 0) {
					Map<String, Object> m = (Map<String, Object>) result.get(0);
					int dupCnt = ((BigDecimal) m.get("cnt")).intValue();
					if (dupCnt > 0) {
						return "9-키가 중복됩니다.";
					}
				}

			}
			insertTable = paramMap.get("empTable") + "";
			selectTable = paramMap.get("empTable") + "_HIST A";
			where = " WHERE ENTER_CD = '" + paramMap.get("ssnEnterCd") + "' AND APPL_SEQ = '" + applSeq + "' ";

			if (seqs.length() > 1) {
				String tseq = seqs.substring(1);
				seqs2 = ", (SELECT NVL(MAX(" + tseq + "),0)+1 FROM " + insertTable + "   WHERE (ENTER_CD " + pks
						+ ") IN (SELECT ENTER_CD " + pks + " FROM " + paramMap.get("empTable")
						+ "_HIST WHERE ENTER_CD = '" + paramMap.get("ssnEnterCd") + "' AND APPL_SEQ = '" + applSeq
						+ "')) ";
			} else
				seqs2 = seqs;

		} else if (insertType.equals("HIST")) {// history insert

			insertTable = paramMap.get("empTable") + "_HIST";
			selectTable = (String) paramMap.get("empTable") + " A";
			where = " WHERE (ENTER_CD " + pks + seqs + ") IN (SELECT ENTER_CD " + pks + seqs + " FROM "
					+ paramMap.get("empTable") + "_HIST WHERE ENTER_CD = '" + paramMap.get("ssnEnterCd")
					+ "' AND APPL_SEQ = '" + applSeq + "')";

			cols1 = cols + ", APPL_SEQ";
			cols2 = cols + ", '" + applSeq + "'";
		} else if (insertType.equals("EMP")) {// emp insert
			insertTable = paramMap.get("empTable") + "_HIST";
			selectTable = "DUAL";
			where = "";
			pks2 = vpks;
			seqs2 = vseqs;
			cols2 = vcols;
		}

		String query = " INSERT INTO " + insertTable;
		query += " ( ENTER_CD, CHKDATE, CHKID " + pks1 + seqs1 + cols1 + " ) ";
		query += " SELECT '" + paramMap.get("ssnEnterCd") + "', SYSDATE, '" + paramMap.get("ssnSabun") + "'" +pks2
				+ seqs2 + cols2;
		query += " FROM " + selectTable;
		query += where;

		return query;

	}

	@SuppressWarnings("unused")
	private String getSaveEmpInfoInsertQuery2(List<?> fList, Map<String, Object> paramMap, String applSeq,
			String insertType) throws Exception {
		String insert = "INSERT INTO " + paramMap.get("empTable") + (insertType.equals("") ? "" : "_") + insertType;
		String cols = "( ENTER_CD, CHKDATE, CHKID ";
		String select = " SELECT '" + paramMap.get("ssnEnterCd") + "' , SYSDATE, '" + paramMap.get("ssnSabun") + "' ";
		String where = " WHERE ( ENTER_CD ";
		String where2 = " IN ( SELECT ENTER_CD ";
		String from = " FROM ";

		if (insertType.equals("HIST")) {
			cols += ", APPL_SEQ";
			select += ", '" + paramMap.get("applSeq") + "' ";
			from += paramMap.get("empTable");// HIST에 넣을 DATA는 원본TABLE에서 조회한다.
		} else if (insertType.equals("")) {
			from += paramMap.get("empTable") + "_HIST";// 원본에에 넣을 DATA는 EMP
														// TABLE에서 조회한다.
		}

		for (Object m : fList) {
			Map<String, Object> map = (Map<String, Object>) m;
			String cc = (String) map.get("columnCd");

			cols += ", " + cc;
			// 원본에 insert할시에 seq는 새로 조회해서 넣음.
			if (insertType.equals("") && "S".equals(map.get("pkType")))
				select += ", (SELECT NVL(MAX(" + cc + "), 0) + 1 AS " + cc + " FROM " + paramMap.get("empTable")
						+ " :WHERE: )";
			else
				select += ", " + cc;

			if ("P".equals(map.get("pkType")) || "S".equals(map.get("pkType"))) {
				if (insertType.equals("HIST")) {

					// HIST에 넣을 DATA는 원본TABLE에서 조회한다.
					where += ", " + cc;
					where2 += ", " + cc;
					// where += " AND "+cc+" =
					// '"+paramMap.get(StringUtil.getCamelize(cc))+"'";
				}
			}
		}
		if (insertType.equals("")) {
			where += ", APPL_SEQ )";
			where2 = " IN (('" + paramMap.get("ssnEnterCd") + "', '" + applSeq + "')) ";
			// where += " AND APPL_SEQ = '"+applSeq+"' ";
		} else {
			where += ")";
			where2 = where2 + " FROM " + paramMap.get("empTable") + "_HIST WHERE ENTER_CD = '"
					+ paramMap.get("ssnEnterCd") + "' AND APPL_SEQ = '" + applSeq + "' )";
		}
		return insert + cols + ")" + select + from + where + where2;
	}

	private String getSaveEmpInfoQuery(Map<String, Object> paramMap) throws Exception {
		paramMap.put("searchUseYn", "Y");
		paramMap.put("searchEmpTable", paramMap.get("empTable"));
		paramMap.put("table", paramMap.get("empTable") + "_HIST");

		String abCd = (String) paramMap.get("abCd");
		
		List<?> result = empInfoChangeFieldMgrService.getEmpInfoChangeFieldMgrList(paramMap);

		String insert = "INSERT INTO " + ((String) paramMap.get("table")).toUpperCase();
		String cols = "( ENTER_CD, CHKDATE, CHKID, APPL_SEQ, AB_CD ";
		String values = " SELECT '" + paramMap.get("ssnEnterCd") + "' , SYSDATE, '" + paramMap.get("ssnSabun") + "', '"
				+ paramMap.get("applSeq") + "', '" + paramMap.get("abCd") + "' ";
		String where = " WHERE ENTER_CD = '" + paramMap.get("ssnEnterCd") + "' ";
		boolean existsSeq = false;
		
		String value = "";
		for (Object m : result) {
			Map<String, Object> map = (Map<String, Object>) m;
			String cc = (String) map.get("columnCd");
			String cv = "'" + (String) paramMap.get(StringUtil.getCamelize(cc)) + "'";
			cv = getHiddenValColumnCd(paramMap, (String) map.get("hiddenValColumnCd"), cv);
			if (paramMap.get(StringUtil.getCamelize(cc)) == null)
				cv = "''";
			if ("I".equals(paramMap.get("applType")) && "S".equals(map.get("pkType"))) {
				existsSeq = true;
				cv = "NVL(MAX(" + cc + "), 0) + 1";
				//Log.Debug("cols I: " + cols);
				//Log.Debug("values I: " + values);
			}
/*			if ("U".equals(paramMap.get("applType")) ) {
				existsSeq = true;
				if ( "BEF".equals(abCd)) {
					Log.Debug("cols U BEF: " + cols);
					Log.Debug("values U BEF: " + values);
				}else if ( "AFT".equals(abCd) ) {
					Log.Debug("cols U AFT: " + cols);
					Log.Debug("values U AFT: " + values);
				}

			}*/
			if ("D".equals(map.get("cType")) || "M".equals(map.get("cType"))) {
				cv = cv.replaceAll("-", "");
				//Log.Debug("cols D: " + cols);
				//Log.Debug("values D: " + values);
			}
			if ("H".equals(map.get("cType")) && cv.equals("''")) {// checkbox
				cv = "'N'";
				//Log.Debug("cols H: " + cols);
				//Log.Debug("values H: " + values);
			}
			if ("twoWay".equals(map.get("cryptKey"))) {
				cv = " CRYPTIT.ENCRYPT(" + cv + ", '" + paramMap.get("ssnEnterCd") + "')";
				//Log.Debug("cols twoWay: " + cols);
				//Log.Debug("values twoWay: " + values);
				//Log.Debug("=-=========");
			} else if ("twoWay".equals(map.get("cryptKey"))) {
				cv = " CRYPTIT.CRYPT(" + cv + ", '" + paramMap.get("ssnEnterCd") + "')";
				//Log.Debug("========-=");
			}
			// else cv = cv.replaceAll("'", "''");


			if ("P".equals(map.get("pkType"))) {
				value = (String) paramMap.get(StringUtil.getCamelize((String) map.get("columnCd")));
				if ("D".equals(map.get("cType")) || "M".equals(map.get("cType"))) {
					value = value.replaceAll("-", "");
				}
				where += " AND " + map.get("columnCd") + " = '"+ value + "'";
			}
			if ("S".equals(map.get("pkType"))) {
				where += " AND " + map.get("columnCd") + " = '"
						+ paramMap.get(StringUtil.getCamelize((String) map.get("columnCd"))) + "'";
			}
/*			if ("U".equals(map.get("pkType"))) {
				where += " AND " + map.get("columnCd") + " = '"
						+ paramMap.get(StringUtil.getCamelize((String) map.get("columnCd"))) + "'";
			}*/
			
			cols += ", " + cc;
			if ( "BEF".equals(abCd)) {
				existsSeq = true;
				values += ", " + cc;
			}else {
				values += ", " + cv;
			}
			
			//Log.Debug("============================================");
			//Log.Debug("applType : " + paramMap.get("applType") );
			//Log.Debug("cryptKey : " + map.get("cryptKey") );
			//Log.Debug("cType : " + map.get("cType") );
			//Log.Debug("pkType : " + map.get("pkType") );
			//Log.Debug("cols : " + cols );
			//Log.Debug("============================================");
		}
		return insert + cols + ")" + values + " FROM " + (existsSeq ? paramMap.get("empTable") : "DUAL")
				+ (existsSeq ? where : "");
	}

	/**
	 * 
	 * 
	 * @param paramMap
	 *            : parameter value map
	 * @param hvcc
	 *            : hidden 컬럼 구성 식 : COL1||'-'||COL2 or COL1+COL2-COL3 or COL
	 * @return
	 * @throws Exception
	 */
	private String getHiddenValColumnCd(Map<String, Object> paramMap, String hvcc, String v) throws Exception {
		if (hvcc == null)
			return v;
		if (hvcc.equals(""))
			return v;
		if (hvcc.indexOf("||") == -1 && hvcc.indexOf("+") == -1 && hvcc.indexOf("-") == -1)
			return hvcc;

		String rv = "";
		StringTokenizer st = new StringTokenizer(hvcc, "||");
		// String[] hvccs = hvcc.split("[||]");
		while (st.hasMoreTokens()) {
			String c = st.nextToken();
			if (c.indexOf("'") > -1)
				rv += "||" + c;
			else {
				rv += "||'" + paramMap.get(StringUtil.getCamelize(c)) + "'";
			}

		}
		if (rv.length() > 2)
			rv = rv.substring(2);

		return rv;
	}

	private String getEmpInfoQuery(Map<String, Object> paramMap) throws Exception {
		paramMap.put("searchUseYn", "Y");
		paramMap.put("searchEmpTable", paramMap.get("empTable"));
		List<?> fieldList = empInfoChangeFieldMgrService.getEmpInfoChangeFieldMgrList(paramMap);
		return getEmpInfoQuery(paramMap, fieldList, null, false, "");
	}

	private String getEmpInfoQuery2(Map<String, Object> paramMap) throws Exception {
		paramMap.put("searchUseYn", "Y");
		paramMap.put("searchEmpTable", paramMap.get("empTable"));
		List<?> fieldList = empInfoChangeFieldMgrService.getEmpInfoChangeFieldMgrList(paramMap);
		return getEmpInfoQuery(paramMap, fieldList, paramMap.get("applSeq").toString(), false, "");
	}

	private String getEmpInfoQueryWithNm(Map<String, Object> paramMap, List<?> fieldList, String applSeq, String abCd)
			throws Exception {
		return getEmpInfoQuery(paramMap, fieldList, applSeq, true, abCd);
	}

	/**
	 * 
	 * @param paramMap
	 * @param fieldList
	 * @param applSeq
	 * @param isGetNm
	 * @return
	 * @throws Exception
	 */
	private String getEmpInfoQuery(Map<String, Object> paramMap, List<?> fieldList, String applSeq, boolean isGetNm, String abCd)
			throws Exception {
		if (paramMap.get("table") == null)
			paramMap.put("table", paramMap.get("empTable"));
		
		String select = " SELECT ENTER_CD ";
		String from = " FROM " + ((String) paramMap.get("table")).toUpperCase() + " ";
		String where = " WHERE ENTER_CD = '" + paramMap.get("ssnEnterCd") + "' ";

		for (Object m : fieldList) {
			Map<String, Object> map = (Map<String, Object>) m;
			String cc = (String) map.get("columnCd");

			if ("twoWay".equals(map.get("cryptKey"))) {
				cc = " CRYPTIT.DECRYPT(" + cc + ", ENTER_CD) ";
			}
			if ("D".equals(map.get("cType"))) {
				//cc = " TO_CHAR(TO_DATE(" + cc + ",'YYYYMMDD'),'YYYY-MM-DD')";
				cc = " TO_CHAR(TO_DATE(" + cc + ", DECODE(LENGTH(REPLACE(NVL(" + cc + ", ''), '-')), 6, 'YYYYMM', 'YYYYMMDD')), DECODE(LENGTH(REPLACE(NVL(" + cc + ", ''), '-')), 6, 'YYYY-MM', 'YYYY-MM-DD'))";
			}
			// combo 를 사용하는 코드값 의 nm을 구함.
			
			String ptype = (String) map.get("popupType");
			
			if (isGetNm && "C".equals(map.get("cType"))) {
				if (ptype != null && !"".equals(ptype)) {
					String applYmd = "";
					if (applSeq == null)
						applYmd = "'" + paramMap.get("applYmd") + "'";
					else
						applYmd = " APPL_YMD";
					if (ptype.equals("ORG")) {
						cc = " F_COM_GET_ORG_NM('" + paramMap.get("ssnEnterCd") + "', " + cc + ", " + applYmd + ") ";
					} else if (ptype.equals("JOB")) {
						cc = " F_COM_GET_JOB_NM_201('" + paramMap.get("ssnEnterCd") + "', " + cc + ", " + applYmd
								+ ") ";
					} else if (ptype.equals("LOCATION")) {
						cc = " F_COM_GET_LOCATION_NM('" + paramMap.get("ssnEnterCd") + "', " + cc + ") ";
					} else if (ptype.equals("POST")) {// 값을 그대로 읽음

					} else {
						if (ptype.indexOf(".") > 0) {// ACA_CD.NOTE1
							String pGrpCd = null;
							String pColCd = ptype.substring(0, ptype.indexOf(".") - 1);
							for (Object tmp : fieldList) {
								Map<String, Object> tmap = (Map<String, Object>) tmp;
								if (pColCd.equals(tmap.get("columnCd"))) {
									pGrpCd = (String) tmap.get("popupType");

									break;
								}
							}
							String pColNote = ptype.substring(ptype.indexOf(".") + 1);
							if (pGrpCd != null) {
								cc = "F_COM_GET_GRCODE_NAME('" + paramMap.get("ssnEnterCd") + "' " + ",(SELECT "
										+ pColNote + "  FROM TSYS005                  " + " WHERE ENTER_CD = '"
										+ paramMap.get("ssnEnterCd") + "'         " + "   AND GRCODE_CD = '" + pGrpCd
										+ "'      " + "   AND CODE = " + pColCd + ")" + ", " + cc + ") ";
							}

						} else {
							cc = "F_COM_GET_GRCODE_NAME('" + paramMap.get("ssnEnterCd") + "', '" + ptype + "', " + cc
									+ ")";
						}
					}

				}
			}
			select += " ," + cc + " AS " + map.get("columnCd");
			
			Log.Debug("************");
			Log.Debug(applSeq);

			if (applSeq == null && ("P".equals(map.get("pkType")) || "S".equals(map.get("pkType")))) {
//				if (map.get("cryptKey") != "" && !"".equals(map.get("cryptKey"))){
//						where += " AND " + map.get("columnCd") + " = "
//							    + " ENCRYPT('SAFEDB.POLICY', '" + map.get("cryptKey") + "', '" + paramMap.get(StringUtil.getCamelize((String) map.get("columnCd"))) + "'" + " )";
//				}else
					
				if(ptype != null && !"".equals(ptype)){
					    where += " AND (" + map.get("columnCd") + " = "
				                          + "F_COM_GET_GRCODE_CODE('" + paramMap.get("ssnEnterCd") + "', '" + ptype + "', '" + paramMap.get(StringUtil.getCamelize((String) map.get("columnCd"))) + "')"
				                          + "OR " + map.get("columnCd") + "= '" + paramMap.get(StringUtil.getCamelize((String) map.get("columnCd"))) + "')";
				}else{
						where += " AND " + map.get("columnCd") + " = '"
								+ paramMap.get(StringUtil.getCamelize((String) map.get("columnCd"))) + "'";
				}
			}			
				 
		}
		if (applSeq != null) {
			
			if ( "BEF".equals(abCd) ) {
				where += " AND APPL_SEQ = '" + applSeq + "'" + " AND AB_CD = '" + abCd + "'";
			}else if ( "AFT".equals(abCd) ) {
				where += " AND APPL_SEQ = '" + applSeq + "'" + " AND AB_CD = '" + abCd + "'";
			}else {
				where += " AND APPL_SEQ = '" + applSeq + "'";
			}
			
		}
		return select + from + where;
	}

	/**
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpInfoList", method = RequestMethod.POST )
	public ModelAndView getEmpInfoList(HttpSession session, HttpServletRequest request,
									   @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		// 쿼리문 만들기

		paramMap.put("query", getEmpInfoQuery(paramMap));
		List<?> result = empInfoChangeMgrService.getEmpInfoList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();

		return mv;
	}

	/**
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpInfoList2", method = RequestMethod.POST )
	public ModelAndView getEmpInfoList2(HttpSession session, HttpServletRequest request,
									   @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		// 쿼리문 만들기

		paramMap.put("query", getEmpInfoQuery2(paramMap));
		List<?> result = empInfoChangeMgrService.getEmpInfoList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 신청내역
	 * 
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpInfoChangeMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpInfoChangeFieldMgr(@RequestParam Map<String, Object> paramMap, HttpServletRequest request)
			throws Exception {
		return "hrm/other/empInfoChangeMgr/empInfoChangeMgr";
	}

	/**
	 * 신청내역 (로그인한 사용자의 신청내역)
	 * 
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpInfoChangeLst",method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewEmpInfoChangeLst(@RequestParam Map<String, Object> paramMap, HttpServletRequest request)
			throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("hrm/other/empInfoChangeMgr/empInfoChangeMgr");
		mv.addObject("cmd", "viewEmpInfoChangeLst");
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 신청내역 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpInfoChangeMgrList", method = RequestMethod.POST )
	public ModelAndView getEmpInfoChangeMgrList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List<?> result = empInfoChangeMgrService.getEmpInfoChangeMgrList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;

	}

	/**
	 * 신청내역 상세조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpInfoChangeMgrList2", method = RequestMethod.POST )
	public ModelAndView getEmpInfoChangeMgrList2(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		// 1. 항목조회
		paramMap.put("searchUseYn", "Y");
		paramMap.put("searchEmpTable", paramMap.get("empTable"));
		List<?> fieldList = empInfoChangeFieldMgrService.getEmpInfoChangeFieldMgrList(paramMap);
		// 2. 신청후 값 조회
		Map<String, Object> aftMap = null;
		paramMap.put("table", paramMap.get("empTable") + "_HIST");
		paramMap.put("query", getEmpInfoQueryWithNm(paramMap, fieldList, (String) paramMap.get("applSeq"), "AFT"));
		List<?> list = empInfoChangeMgrService.getEmpInfoList(paramMap);
		if (list != null && list.size() > 0)
			aftMap = (Map<String, Object>) list.get(0);
		list = null;
		
		
		Map<String, Object> befMap = null;
		//befMap.put("table", paramMap.get("empTable") + "_HIST");
		paramMap.put("query", getEmpInfoQueryWithNm(paramMap, fieldList, (String) paramMap.get("applSeq"), "BEF"));
		list = empInfoChangeMgrService.getEmpInfoList(paramMap);
		if (list != null && list.size() > 0) {
			befMap = (Map<String, Object>) list.get(0);
		}
		
		setEmpInfoMergeList(fieldList, befMap, aftMap);

		// FILE_SEQ 암호화 처리
		String encryptKey = securityMgrService.getEncryptKey((String) paramMap.get("ssnEnterCd"), SecurityMgrService.HRM);
		if (encryptKey != null) {
			fieldList = fieldList.stream()
					.filter(item -> item instanceof Map)
					.map(item -> (Map<String, Object>) item)
					.map(item -> {
						if ("FILE_SEQ".equalsIgnoreCase(String.valueOf(item.get("columnCd")))) {
							item.put("preValue", CryptoUtil.encrypt(encryptKey, String.valueOf(item.get("preValue"))));
							item.put("aftValue", CryptoUtil.encrypt(encryptKey, String.valueOf(item.get("aftValue"))));
						}
						return item;})
					.collect(Collectors.toList())
					;
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", fieldList);
		Log.DebugEnd();
		return mv;

	}

	/**
	 * 신청내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params = "cmd=getEmpCommonMgrList")
	public ModelAndView getEmpCommonMgrList(HttpSession session, HttpServletRequest request,
												@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));

		String surl = StringUtil.stringValueOf(paramMap.get("surl"));
		String skey = StringUtil.stringValueOf(session.getAttribute("ssnEncodedKey"));
		Map<String, Object> urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl(surl, skey);
		Log.Debug(urlParam.toString());
		paramMap.put("mainMenuCd", urlParam.get("mainMenuCd"));

		List<?> result = empInfoChangeMgrService.getEmpCommonMgrList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;

	}


	/**
	 * 신청내역 상세조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpInfoChangeMgrDupChk", method = RequestMethod.POST )
	public ModelAndView getEmpInfoChangeMgrDupChk(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		Map<String, Object> convertMap = new HashMap<String, Object>();
		
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("empTable", paramMap.get("empTable"));
		
		List<?> list  = new ArrayList<Object>();
		list = empInfoChangeMgrService.getEmpInfoColumnPkSeqList(convertMap);

		String columnCdQuery = "";
		convertMap = new HashMap<String, Object>();
		
		if ( !list.isEmpty()) {
			
			for ( int i=0; i < list.size(); i++ ) {
				HashMap<String, String> map  =  (HashMap<String, String>)list.get(i);
				
				String columnCd = (String) map.get("columnCd");
				String camelColumnCd = StringUtil.getCamelize((String) map.get("columnCd"));
				columnCdQuery = columnCdQuery + " AND B."  + columnCd  + " = '" + paramMap.get(camelColumnCd) + "' " ;
				
			}
		}
		
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("empTable", paramMap.get("empTable"));
		convertMap.put("empTableHist",  StringUtil.upperCase( (String)paramMap.get("empTable")) + "_HIST");
		convertMap.put("columnCdQuery", columnCdQuery);
		Map<String, Object> returnMap = (Map<String, Object>) empInfoChangeMgrService.getEmpInfoColumnUseList(convertMap);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", returnMap);
		Log.DebugEnd();
		return mv;
		
	}

	private void setEmpInfoMergeList(List<?> fieldList, Map<String, Object> preMap, Map<String, Object> aftMap)
			throws Exception {
		List<Object> removableList = new ArrayList<Object>();
		for (Object o : fieldList) {
			Map<String, Object> field = (Map<String, Object>) o;

			if (preMap == null)
				field.put("preValue", "");
			else
				field.put("preValue", preMap.get(StringUtil.getCamelize((String) field.get("columnCd"))));

			if (aftMap == null)
				field.put("aftValue", "");
			else
				field.put("aftValue", aftMap.get(StringUtil.getCamelize((String) field.get("columnCd"))));

			// hidden 은 지운다.
			if ("N".equals(field.get("cType")))
				removableList.add(o);
		}
		for (Object o : removableList) {
			fieldList.remove(o);
		}
	}
	

}
