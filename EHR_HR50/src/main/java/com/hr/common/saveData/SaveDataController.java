package com.hr.common.saveData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.database.DatabaseService;
import com.hr.common.language.Language;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;

/**
 * SAVE DATA Controller
 *
 * @author RYU SIOONG
 *
 */
@Controller
@RequestMapping(value="/SaveData.do", method=RequestMethod.POST )
public class SaveDataController {

	/**
	 * SAVE DATA 서비스
	 */
	@Inject
	@Named("SaveDataService")
	private SaveDataService saveDataService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	@Inject
	@Named("DatabaseService")
	private DatabaseService databaseService;
	
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	@Inject
	@Named("Language")
	private	Language language;

	@RequestMapping
	public ModelAndView saveData(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		
		//Map<?, ?> columnInfoMap = databaseService.getColumnInfo(paramMap);
		//String tableName = columnInfoMap.get("tableName").toString();
		//String columnName = columnInfoMap.get("columnName").toString();
		//String columnType = columnInfoMap.get("columnType").toString();
		
		String message = "";
		int resultCnt = -1;
		/*
		if(!tableName.equals("")
			&&!columnName.equals("")
			&&!columnType.equals("")
			){
			
			List<Map> insertList = (List<Map>)convertMap.get("insertRows");
			List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
			
			String splitColumnName[] = columnName.split(",");

			for(Map<String,Object> mp : insertList) {
				Map<String,Object> dupMap = new HashMap<String,Object>();
				for(String tempColumnName:splitColumnName){
					if(tempColumnName == "ENTER_CD"){
						dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
					}else{
						dupMap.put(tempColumnName,mp.get(StringUtil.getCamelize(tempColumnName)));
					}
				}
				dupList.add(dupMap);
			}
			
			try{
				int dupCnt = 0;
				
				if(insertList.size() > 0) {
					// 중복체크
					dupCnt = commonCodeService.getDupCnt(tableName,columnName,columnType,dupList);
				}
				
				if(dupCnt > 0) {
					resultCnt = -1; message="중복된 값이 존재합니다.";
				} else {
					resultCnt = saveDataService.saveData(convertMap);
					if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
				}
			}catch(Exception e){
				resultCnt = -1; message="저장에 실패하였습니다.";
			}
		}else{
			resultCnt = -1; message="저장에 실패하였습니다. 저장시 필요한 정보를 확인하시기 바랍니다.";
		}
		*/
		resultCnt = saveDataService.saveData(convertMap);
		if(resultCnt > 0){ message=language.getMessage("msg.109987", null, "저장되었습니다."); } else{ message=language.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
	
}