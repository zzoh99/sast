package com.hr.hrd.code.careerPathPreView;

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

import com.hr.common.language.Language;
import com.hr.common.logger.Log;

@Controller
@SuppressWarnings("unchecked")
@RequestMapping(value="/CareerPathPreView.do", method=RequestMethod.POST )
public class CareerPathPreViewController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("CareerPathPreViewService")
	private CareerPathPreViewService careerPathPreViewService;

	@RequestMapping(params="cmd=viewCareerPathPreView", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCareerTarget(
		HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/code/careerPathPreView/careerPathPreView";
	}

	@RequestMapping(params="cmd=viewCareerTargetDetailPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCareerTargetDetailPopup(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/code/careerTarget/careerTargetDetailPopup";
	}

	@RequestMapping(params="cmd=viewCareerPathDetailPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCareerPathDetailPopup(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/code/careerTarget/careerPathDetailPopup";
	}



	@RequestMapping(params="cmd=getCareerPathPreViewList", method = RequestMethod.POST )
	public ModelAndView getCareerPathPreViewList(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<Map<String,Object>> listTitle = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> listRtn   = new ArrayList<Map<String,Object>>();


		List<Map<String,Object>> listTmp   = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> listTmp2  = new ArrayList<Map<String,Object>>();

		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));


		try {
			listTitle = careerPathPreViewService.getCareerPathPreViewTitleList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}

		String[] level = {"G3","G2","G1"};

		for (String lvlCd:level) {
			for (Map<String, Object> map:listTitle) {
				Log.Debug(map.toString());
				paramMap.put("searchJikCd", map.get("jikCd"));
				paramMap.put("searchCareerPathCd", lvlCd);
				List<Map<String,Object>> list = careerPathPreViewService.getCareerPathPreViewList(paramMap);
				Map<String, Object> map2 = new HashMap<>();
				map2.put("LEVEL",lvlCd);
				map2.put("JIK"  ,map.get("jikCd"));

				if (!list.isEmpty()) {
					map2.put("JOB"  ,list);
					map2.put("ROW"  ,list.size());
				}else{
					map2.put("JOB"  ,null);
					map2.put("ROW"  ,0);
				}
				listTmp.add(map2);
			}

		}




		for (String lvlCd:level) {
			int nMaxRow = 0;
			// 해당 LEVEL의 최대 데이타 개수를 가져옴
			for (Map<String, Object> map : listTmp) {
				if (map.get("LEVEL").toString().equals(lvlCd)) {

					if (nMaxRow < (Integer) map.get("ROW")) {
						nMaxRow = (Integer) map.get("ROW");
					}
				}
			}

			Log.Debug(lvlCd + "----------"+ nMaxRow);

			listTmp2 = new ArrayList<Map<String,Object>>();

			for (int i=1; i <= nMaxRow; i++) {
				listTmp2.add(new HashMap<>());
			}


			for (Map<String, Object> mapTmp : listTmp) {
				if (mapTmp.get("LEVEL").toString().equals(lvlCd)) {

					String jik = mapTmp.get("JIK").toString();
					List<Map<String, Object>> listJob = (List<Map<String, Object>>) mapTmp.get("JOB");

					for (int j= 1,nJCnt=nMaxRow;j<=nJCnt;j++) {
						Map<String, Object> mapTmp2 = listTmp2.get(j-1);

						if (listJob != null && listJob.size() >= j ) {
							Map<String, Object> mapJob = listJob.get(j-1);

							String jobNmTerm = mapJob.get("jobNm").toString();

							if (mapJob.get("exeTerm") != null) {
								jobNmTerm += "("+mapJob.get("exeTerm").toString()+")";
							}

							mapTmp2.put("level", lvlCd);
							mapTmp2.put("col" + jik, mapJob.get("jobCd"));
							mapTmp2.put("col" + jik + "nm", jobNmTerm);
						}else{
							mapTmp2.put("level", lvlCd);
							mapTmp2.put("col" + jik, "");
							mapTmp2.put("col" + jik + "nm", "");
						}

						listTmp2.remove(j-1);
						listTmp2.add(j-1,mapTmp2);

					}


				}

			}
			listRtn.addAll(listTmp2);
		}






/*		try {
			list = careerPathPreViewService.getCareerPathPreViewList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}*/
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", listRtn);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	@RequestMapping(params="cmd=getCareerPathPreViewTitleList", method = RequestMethod.POST )
	public ModelAndView getCareerPathPreViewTitleList(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = careerPathPreViewService.getCareerPathPreViewTitleList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}




}
