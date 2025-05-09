package com.hr.main.main;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 메뉴 서비스
 *
 * @author ParkMoohun
 *
 */
@Service("MainService")
public class MainService{

	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 대분류 메뉴 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMainMajorMenuList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> rtnList =  new ArrayList<>();

		Object grpCd = paramMap.get("ssnGrpCd");
		Log.Debug("==============================================================>"+ grpCd);
		if(null == grpCd || grpCd.toString().isEmpty())
			rtnList =  (List<?>) dao.getList("getMainMajorMenuInitList", paramMap);
		else
			rtnList =  (List<?>) dao.getList("getMainMajorMenuGrpList", paramMap);
		return rtnList;
	}
	
	/**
	 * 대분류 메뉴 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getMainMajorMenuListCount2021(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		
		Map<?, ?> map = null;
		Object grpCd = paramMap.get("ssnGrpCd");
		Log.Debug("==============================================================>"+ grpCd);
		if(null == grpCd || grpCd.toString().isEmpty())
			map = (Map<?, ?>) dao.getMap("getMainMajorMenuInitListCount2021", paramMap);
		else
			map = (Map<?, ?>) dao.getMap("getMainMajorMenuGrpListCount2021", paramMap);
		
		return map;
	}

	/**
	 * @param paramMap
	 * @return Int
	 * @throws Exception
	 */
	public int saveWidget(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)paramMap.get("insertRows")).size() > 0){
			cnt += dao.delete("deleteWidget", 	paramMap);
			cnt += dao.update("saveWidget", 	paramMap);
			
			dao.update("updateWidgetType", paramMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * main box large 3개
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMainTFList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainTFList", paramMap);
	}
	/**
	 * main box large 3개
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMainMFList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainMFList", paramMap);
	}
	/**
	 * main box large 3개
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMainBFList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainBFList", paramMap);
	}
	/**
	 * main 인사담당자
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHumanResourcesList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHumanResourcesList", paramMap);
	}
	/**
	 * main 공지사항
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getNoticeMainList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getNoticeMainList", paramMap);
	}
	/**
	 * main 자주사용하는질문
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getFaqMainList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getFaqMainList", paramMap);
	}
	/**
	 * main 신청내역
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?>getAppCountMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getAppCountMap", paramMap);
	}
	/**
	 * main 결재내역
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?>getAprCountMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getAprCountMap", paramMap);
	}
	
	/**
	 * main 급여최신일자
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?>getPayYmMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getPayYmMap", paramMap);
	}
	/**
	 * main 휴가사용실적
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?>getVacationUsedMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getVacationUsedMap", paramMap);
	}
	/**
	 * main 하계휴가사용실적
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?>getVacationSmmrUsedMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getVacationSmmrUsedMap", paramMap);
	}
	/**
	 * main 학습시간
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?>getEduLrngTmMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getEduLrngTmMap", paramMap);
	}

	/**
	 * 메인 Schedule Day  Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> tsys007SelectScheduleMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("tsys007SelectScheduleMap", paramMap);
	}


	/**
	 * 메인 Schedule Day  Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> tsys399SelectList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("tsys399SelectList", paramMap);
	}


	/**
	 *  메인 Calendar 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMainCalendarMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainCalendarListMap", paramMap);
	}

	/**
	 *  메인 Calendar 조회2 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMainCalendarMap2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainCalendarListMap2", paramMap);
	}
	
	/**
	 *  메인 Calendar 조회2 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMainCalendarMap3(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainCalendarListMap3", paramMap);
	}
	
	/**
	 * 위젯 ! 조회2 count
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getSelectMap_TSYS313(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getSelectMap_TSYS313", paramMap);
	}

	
	/**
	 * 개인별알림조회 
	 * 2020.06.09
	 */
	public List<?> getPanalAlertList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPanalAlertList", paramMap);
	}
	

	/**
	 * 위젯 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWidgetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWidgetList", paramMap);
	}

	/**
	 * 메인메뉴의 가장 최상단 프로그램 정보 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getMenuPrgMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getMenuPrgMap", paramMap);
	}

	/**
	 * 위젯 0 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox0List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox0List", paramMap);
	}
	
	/**
	 * 위젯 0 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox0List2(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox0List2", paramMap);
	}
	
	/**
	 * 위젯 0 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox0ListCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox0ListCnt", paramMap);
	}
	
	/**
	 * 위젯 ! 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox1List", paramMap);
	}


	/**
	 * 위젯 ! 조회2
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox2List(Map<?,?> paramMap, String type) throws Exception {
		Log.Debug();
		if(type.equals("R"))
			return (List<?>) dao.getList("getListBox2ListR", paramMap);
		else if (type.equals("L"))
			return (List<?>) dao.getList("getListBox2ListL", paramMap);
		return (List<?>) paramMap;
	}

	/**
	 * 위젯 ! 조회2 count
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getListBox2Cnt(Map<?, ?> paramMap, String type) throws Exception {
		Log.Debug();
		if (type.equals("R"))
			return dao.getMap("getListBox2CntR", paramMap);
		else if (type.equals("L"))
			return dao.getMap("getListBox2CntL", paramMap);
		else
			return paramMap;
	}


	
	/**
	 * 위젯 3 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox2CntL(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox2CntL", paramMap);
	}

	/**
	 * 위젯 3 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox4Cnt(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox4Cnt", paramMap);
	}
	
	/**
	 * 위젯 3 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox2CntR(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox2CntR", paramMap);
	}
	
	/**
	 * 위젯 3 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox3List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox3List", paramMap);
	}
	
	/**
	 * 위젯 4 조회 [Quick Menu]
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox4List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox4List", paramMap);
	}

	/**
	 * 위젯 801 조회 시간외 근무 사용 현황
	 *  
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListOverTime(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListOverTime", paramMap);
	}
	
	/**
	 * 위젯 802 조회 연차 보상 비용 현황
	 *  
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getVacationLeaveCost(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getVacationLeaveCost", paramMap);
	}
	
	/**
	 * 위젯 803 조회 전사 근태 현황 비율
	 *  
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAttendanceCnt(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAttendanceCnt", paramMap);
	}
	
	/**
	 * 위젯 803 전사 근태 현황 전체 수
	 *  
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAttendanceAllCnt(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAttendanceAllCnt", paramMap);
	}
	
	/**
	 * 위젯 803 조회 전사 근태 현황 전체 목록
	 *  
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAttendanceAllInfo(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAttendanceAllInfo", paramMap);
	}

	/**
	 * 위젯 807 조직 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<Map<String, Object>> getListBox807OrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getOrgCdListBySearchType", paramMap);
	}
	
	/**
	 * 위젯 810 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?>getListBox810Map(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getListBox810Map", paramMap);
	}
	
	/**
	 * 위젯 811 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox811List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox811List", paramMap);
	}
	
	/**
	 * 위젯 812 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox812List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox812List", paramMap);
	}
	
	/**
	 * 위젯 812 조직 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox812OrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox812OrgList", paramMap);
	}
    /**
     * 위젯 813 조회 조직장 근태 현황 비율
     *  
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getAttendanceLeaderRate(Map<?,?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getAttendanceLeaderRate", paramMap);
    }
    
    /**
     * 위젯 813 전사 조직장 현황 전체 수
     *  
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getAttendanceLeaderCnt(Map<?,?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getAttendanceLeaderCnt", paramMap);
    }
    
    /**
     * 위젯 813 조회 전사 조직장 현황 전체 목록
     *  
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getAttendanceLeaderInfo(Map<?,?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getAttendanceLeaderInfo", paramMap);
    }
	
	/**
	 * 위젯 701 조회 상위 순위
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSalaryTop(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSalaryTop", paramMap);
	}
	
	/**
	 * 위젯 701 조회 하위 순위  
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSalaryBottom(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSalaryBottom", paramMap);
	}
	
	/**
	 * 위젯 205 조회 승진 후보자 직위 리스트 
	 *  
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikweeList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikweeList", paramMap);
	}
	
	/**
	 * 위젯 702 조회 급여인상 top  
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSalaryIncrease(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSalaryIncrease", paramMap);
	}
	
	/**
	 * 위젯 703 조회 급여아웃라이어 top
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSalaryOutlier(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSalaryOutlier", paramMap);
	}

	/**
	 * 위젯 708 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?>getListBox708Map(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getListBox708Map", paramMap);
	}
	
    /**
     * 위젯 708 예상 퇴직금계산
     *
     * @param paramMap
     * @return int
     * @throws Exception
     */
    public Map<?,?> prcP_CPN_SEP_SIMULATION(Map<?, ?> paramMap) throws Exception {
        Log.Debug();

        return (Map) dao.excute("prcP_CPN_SEP_SIMULATION", paramMap);
    }
    
	 /**
     * 위젯 709 국민연금 조회
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getListBox709PenList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getListBox709PenList", paramMap);
    }

    /**
    * 위젯 709 건강보험 조회
    *
    * @param paramMap
    * @return List
    * @throws Exception
    */
   public List<?> getListBox709HealthInsList(Map<?, ?> paramMap) throws Exception {
       Log.Debug();
       return (List<?>) dao.getList("getListBox709HealthInsList", paramMap);
   }

   
   /**
    * 위젯 709 고용보험 조회
    *
    * @param paramMap
    * @return List
    * @throws Exception
    */
   public List<?> getListBox709EmpInsList(Map<?, ?> paramMap) throws Exception {
       Log.Debug();
       return (List<?>) dao.getList("getListBox709EmpInsList", paramMap);
   }
   
//	/**
//	 * 전사 인원 추이
//	 */
//	public List<?> getCompanyTrends(Map<String, Object> paramMap) throws Exception {
//		Log.Debug();
//		return (List<?>) dao.getList("getCompanyTrends", paramMap);
//	}
//	
//	/**
//	 * 3개년 채용인원
//	 */
//	public List<?> getCompanyYearlyTrends(Map<String, Object> paramMap) throws Exception {
//		Log.Debug();
//		return (List<?>) dao.getList("getCompanyYearlyTrends", paramMap);
//	}
//	
	/**
	 * 위젯 201 입/퇴사 추이 조회, 204 퇴사율 조회
	 *  
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getYearlyEnterExitTrend(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getYearlyEnterExitTrend", paramMap);
	}
	
	/**
	 * 위젯 201 조회 입/퇴사 추이
	 *  
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMonthlyEnterExitTrend(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMonthlyEnterExitTrend", paramMap);
	}
	
	/**
	 * 위젯 202 3개년 채용인원 , 위젯 203 3개년 채용 지수 조회
	 *  
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompanyYearlyTrendsValues(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompanyYearlyTrendsValues", paramMap);
	}

	/**
	 * 위젯 205 조회 승진후보자
	 *  
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCandidate(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCandidate", paramMap);
	}

	/**
	 * 위젯 211 항목별 퇴사 비율
	 *  
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLeaveInfo(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLeaveInfo", paramMap);
	}
	
	/**
	 * 위젯 701 직위 조회
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompanyJikweeList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompanyJikweeList", paramMap);
	}
	
	/**
	 * 위젯 5 조회 [Quick Menu]
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox5List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox5List", paramMap);
	}
	
	/**
	 * 위젯 5 전체 연차 사용률
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getListBox5TotalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox5TotalList", paramMap);
	}
	
	/**
	 * 위젯5 월별 연차 사용량
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getListBox5MonthList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox5MonthList", paramMap);
	}


	/**
	 * 위젯 6 조회[HR 공지사항]
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox6List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox6List", paramMap);
	}
	
	/**
	 * 위젯 6 조회[HR 공지사항]
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox6List2(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox6List2", paramMap);
	}
	
	/**
	 * 위젯 6 조회[HR 공지사항]
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox6ListCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox6ListCnt", paramMap);
	}

	/**
	 * 위젯 7 조회[HR 가이드]
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox7List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox7List", paramMap);
	}

	/**
	 * 위젯 8 조회 [NEW FACE]
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox8List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox8List", paramMap);
	}
	
	/**
	 * 위젯 8 조회 [NEW FACE]
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox8List2(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox8List2", paramMap);
	}
	
	/**
	 * 위젯 8 조회 [NEW FACE]
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox8ListCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox8ListCnt", paramMap);
	}

	/**
	 * 위젯 9 조회 [POLL]
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox9List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox9List", paramMap);
	}
	
	/**
	 * 위젯 9 조회 [POLL]
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox9ListCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox9ListCnt", paramMap);
	}

	/**
	 * 위젯 10 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox10List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox10List", paramMap);
	}
	
	/**
	 * 위젯 10 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox10ListCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox10ListCnt", paramMap);
	}

	/**
	 * 위젯 12 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox12List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox12List", paramMap);
	}

	/**
	 * 위젯 13 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox13List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox13List", paramMap);
	}

	/**
	 * 위젯 14 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox14List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox14List", paramMap);
	}

	/**
	 * 위젯 15 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox15List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox15List", paramMap);
	}
	
	/**
	 * 위젯 15 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox15ListCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox15ListCnt", paramMap);
	}

	/**
	 * 위젯 16 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox16Cnt(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox16Cnt", paramMap);
	}
	
	/**
	 * 위젯 16 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox16List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox16List", paramMap);
	}

	/**
	 * 위젯 ! 조회2 count
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */

	public List<?> getListBox17List(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox17List", paramMap);
	}

	public List<?> getListBox18List(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox18List", paramMap);
	}
	public List<?> getListBox23List(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox23List", paramMap);
	}

	public Map<?, ?> prcListBox23List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.excute("prcListBox23List", paramMap);
	}
	public List<?> getListBox24List(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox24List", paramMap);
	}
	/**
	 * 위젯 타입 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?>getWidgetType(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getWidgetType", paramMap);
	}
	/**
	 * 위젯 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWidgetDefaultList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWidgetDefaultList", paramMap);
	}
	
	/**
	 * 위젯 5 조회 [Quick Menu]
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getListBox25List(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox25List", paramMap);
	}
	
	/**
	 * 위젯 19 정보 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<?> getListBox19Info(Map<?, ?> param) throws Exception {
		Log.Debug();
		
		List<?> list = (List<?>) dao.getList("getListBox19Infos", param);
		
		list = list.stream().map(o  -> {
						Map<String, Object> p = new HashMap<>();
						Map<String, Object> map = (Map<String, Object>) o;
						p.putAll((Map<String, Object>) param);
						p.put("applSeq", map.get("applSeq"));
						try {
							map.put("line", dao.getList("getListBox19DetailInfos", p));
						} catch (Exception e) {
							Log.Debug(e.getLocalizedMessage());
						}
						return map;
					})
					.collect(Collectors.toList());
		
		return list;
	}

	/**
	 * ESS MAIN 결재 정보 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getMainEssAppl(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMainEssAppl", paramMap);
	}

	/**
	 * ESS MAIN 근무 정보 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getMainEssWorkTime(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMainEssWorkTime", paramMap);
	}

	/**
	 * ESS MAIN 근무 정보 출/퇴근 저장 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> prcMainEssWorkTime(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.excute("prcMainEssWorkTime", paramMap);
	}

	/**
	 * 위젯 209 복직 예정자 현황
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOverseaDeployment(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOverseaDeployment", paramMap);
	}

	/**
	 * 위젯 210 면수습 예정자 현황
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getProbationStatus(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getProbationStatus", paramMap);
	}
	/**
	 * ESS MAIN 동료 일정 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssPsnlTime(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssPsnlTime", paramMap);
	}

	/**
	 * ESS MAIN 연간 일정 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssAnnualPlan(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssAnnualPlan", paramMap);
	}

	/**
	 * ESS MAIN 즐겨찾기 저장 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public int saveMainEssBookmark(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("saveMainEssBookmark", paramMap);
	}

	/**
	 * 교육이수현황 단건 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
    public Map<?, ?> getListBox501EduInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getListBox501EduInfo", paramMap);
    }

	/**
	 * 교육이수시간 단건 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<?,?> getListBox502EduInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getListBox502EduInfo", paramMap);
	}

	/**
	 * 교육이수건수 단건 조회
	 * @param paramMap 
	 * @return
	 * @throws Exception
	 */
	public Map<?,?> getListBox503EduInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getListBox503EduInfo", paramMap);
	}

	public List<?> getListBox504EduUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox504EduUserList", paramMap);
	}

	public List<?> getListBox504EduOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getListBox504EduOrgList", paramMap);
	}

	/**
	 * ESS MAIN CEO 인원현황 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssCeoEmpCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssCeoEmpCnt", paramMap);
	}

	/**
	* ESS MAIN CEO 퇴직현황 조회
	*/
	public Map<?,?> getMainEssCeoRetireInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMainEssCeoRetireInfo", paramMap);
	}

	/**
	 * ESS MAIN CEO 신규입사자 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssCeoNewEmployee(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssCeoNewEmployee", paramMap);
	}

	/**
	 * ESS MAIN CEO 핵심인재 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssCeoCoreEmployee(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssCeoCoreEmployee", paramMap);
	}

	/**
	 * ESS MAIN CEO 인원현황 차트(연령별) 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssCeoPsnlStatus1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssCeoPsnlStatus1", paramMap);
	}

	/**
	 * ESS MAIN CEO 인원현황 차트(근무지별) 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssCeoPsnlStatus2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssCeoPsnlStatus2", paramMap);
	}

	/**
	 * ESS MAIN CEO 인원현황 차트(직군별) 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssCeoPsnlStatus3(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssCeoPsnlStatus3", paramMap);
	}

	/**
	 * ESS MAIN CEO 인원현황 차트(평가별) 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssCeoPsnlStatus4(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssCeoPsnlStatus4", paramMap);
	}

	/**
	 * ESS MAIN CEO 임원현황 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssCeoExecMemList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssCeoExecMemList", paramMap);
	}

	/**
	 * ESS MAIN CEO 전직원 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssCeoAllMemList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssCeoAllMemList", paramMap);
	}

	/**
	 * ESS MAIN CEO 지각자 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssCeoLateMemList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssCeoLateMemList", paramMap);
	}

	/**
	 * ESS MAIN CHIEF 팀원 연차 현황 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssChiefVacationList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssChiefVacationList", paramMap);
	}

	/**
	 * ESS MAIN CHIEF 연차 현황 차트 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssChiefVacationChart(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssChiefVacationChart", paramMap);
	}

	/**
	 * ESS MAIN CHIEF 초과 근무 현황 차트 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssChiefOtChart(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssChiefOtChart", paramMap);
	}

	/**
	 * ESS MAIN CHIEF 팀 교육현황 현황 차트 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssChiefEduChart(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssChiefEduChart", paramMap);
	}
	
	/**
	 * ESS MAIN CHIEF 결재현황 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getMainEssChiefApplList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssChiefApplList", paramMap);
	}

	/**
	 * ESS MAIN CHIEF 팀원 근무 정보 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getMainEssChiefWorkEmp(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMainEssChiefWorkEmp", paramMap);
	}

	public List<?> getMainEssCeoLeaderMemList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainEssCeoLeaderMemList", paramMap);
	}
}