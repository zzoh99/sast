package com.hr.cpn.perExpense.perExpenseStd;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 결산기준관리 Service
 *
 * @author EW
 *
 */
@Service("PerExpenseStdService")
public class PerExpenseStdService{

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 결산기준관리 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getPerExpenseStdLeftList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPerExpenseStdLeftList", paramMap);
    }

    /**
     * 결산기준관리 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int savePerExpenseStdLeft(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deletePerExpenseStdLeft", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("savePerExpenseStdLeft", convertMap);
        }

        return cnt;
    }

    /**
     * 결산기준관리 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getPerExpenseStdRightList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPerExpenseStdRightList", paramMap);
    }

    /**
     * 결산기준관리 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int savePerExpenseStdRight(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deletePerExpenseStdRight", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("savePerExpenseStdRight", convertMap);
        }

        return cnt;
    }

    /**
     * 결산기준관리 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public Map<String, Object> savePerExpenseStdPrc(Map<?, ?> convertMap) throws Exception {
        Log.Debug();

        List<?> mergeRows = (List<?>) convertMap.get("mergeRows");
        if (mergeRows.isEmpty()) {
            throw new Exception("처리해야할 데이터가 존재하지 않습니다.");
        }

        Map<String, String> map = (Map<String, String>) mergeRows.get(0);

        map.put("ssnEnterCd", (String) convertMap.get("ssnEnterCd"));
        map.put("searchMonth", (String) map.get("ym"));
        map.put("ssnSabun", (String) convertMap.get("ssnSabun"));

        Map<String, Object> excutedResult = (Map<String, Object>) dao.excute("savePerExpenseStdPrc", map);

        Map<String, Object> resultMap = new HashMap<>();
        if (excutedResult.get("sqlCode") != null) {
            resultMap.put("Code", excutedResult.get("sqlCode"));
        } else {
            resultMap.put("Code", "0");
        }

        if (excutedResult.get("sqlErrm") != null) {
            resultMap.put("Message", excutedResult.get("sqlErrm"));
        }

        return resultMap;
    }


    /**
     * 결산기준관리 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public Map<String, Object> savePerExpenseStdPrc1(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int sCnt = 0; // 성공수
        int fCnt = 0; // 실패수
        boolean failYn = false;
        String fMsg = ""; // 실패메시지
        String rMsg = "[반영결과]\n"; // 결과메시지

        Map<String, Object> returnMap = new HashMap<>();

        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){

            List<?> list = ((List<?>)convertMap.get("mergeRows"));

            try {

                for(int i=0; i < list.size(); i++){

                    failYn = false;

                    HashMap<String, String> map  =  (HashMap<String, String>)list.get(i);

                    map.put("ssnEnterCd", (String) convertMap.get("ssnEnterCd"));
                    map.put("searchMonth", (String) map.get("ym"));
                    map.put("ssnSabun", (String) convertMap.get("ssnSabun"));

                    Map<String, Object> resultMap = (Map<String, Object>) dao.excute("savePerExpenseStdPrc1", map);
                    if (resultMap.get("sqlCode") == null && resultMap.get("sqlErrm") == null) {
                        // 이상없음
//						sCnt++;
                    } else {
                        failYn = true;
//						fCnt++;
                        fMsg += "  - 인건비 결산 전표생성 ["+ resultMap.get("sqlErrm").toString() + "]\n";
                    }

                    resultMap = (Map<String, Object>) dao.excute("savePerExpenseStdPrc12", map);
                    if (resultMap.get("sqlCode") == null && resultMap.get("sqlErrm") == null) {
                        // 이상없음
//						sCnt++;
                    } else {
                        failYn = true;
//						fCnt++;
                        fMsg += "  - IFRS휴가보상비 비용 전표생성 ["+ resultMap.get("sqlErrm").toString() + "]\n";
                    }

                    resultMap = (Map<String, Object>) dao.excute("savePerExpenseStdPrc13", map);
                    if (resultMap.get("sqlCode") == null && resultMap.get("sqlErrm") == null) {
                        // 이상없음
//						sCnt++;
                    } else {
                        failYn = true;
//						fCnt++;
                        fMsg += "  - IFRS휴가보상비 부채정산 전표생성 ["+ resultMap.get("sqlErrm").toString() + "]\n";
                    }

                    if (failYn) {
                        fCnt++;
                    } else {
                        sCnt++;
                    }
                }

            }catch( Exception e) {
                fCnt++;
                e.getMessage();
                e.printStackTrace();
            }

            if (list.size() == 0) {
                rMsg += " * 반영할 데이터가 없습니다.";
                returnMap.put("Code", 0);
                returnMap.put("Message", rMsg);
            } else {

                rMsg += " * 총 " + list.size() + " 건 중 성공건수: " + sCnt + "건, 실패건수: " + fCnt + "건\n";
                if (fCnt > 0) {
                    rMsg += " * 실패메시지\n" + fMsg;
                    returnMap.put("Code", -2);
                    returnMap.put("Message", rMsg);
                } else {
                    returnMap.put("Code", sCnt);
                    returnMap.put("Message", rMsg);
                }
            }
        } else {
            rMsg += " * 반영할 데이터가 없습니다.";
            returnMap.put("Code", 0);
            returnMap.put("Message", rMsg);
        }

        return returnMap;
    }


    /**
     * 결산기준관리 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public Map<String, Object> savePerExpenseStdPrc2(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int sCnt = 0; // 성공수
        int fCnt = 0; // 실패수
        String fMsg = ""; // 실패메시지
        String rMsg = "[반영결과]\n"; // 결과메시지

        Map<String, Object> returnMap = new HashMap<>();

        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){

            List<?> list = ((List<?>)convertMap.get("mergeRows"));

            try {

                for(int i=0; i < list.size(); i++){

                    HashMap<String, String> map  =  (HashMap<String, String>)list.get(i);

                    map.put("ssnEnterCd", (String) convertMap.get("ssnEnterCd"));
                    map.put("searchMonth", (String) map.get("ym"));
                    map.put("searchSabun", (String) convertMap.get("searchSabun"));
                    map.put("ssnSabun", (String) convertMap.get("ssnSabun"));

                    Map<String, Object> resultMap = (Map<String, Object>) dao.excute("savePerExpenseStdPrc2", map);
                    if (resultMap.get("sqlCode") == null && resultMap.get("sqlErrm") == null) {
                        // 이상없음
                        sCnt++;
                    } else {
                        fCnt++;
                        fMsg += "  - [사번: " + map.get("sabun").toString() + "] " + resultMap.get("sqlErrm").toString() + "\n";
                    }
                }

            }catch( Exception e) {
                fCnt++;
                e.printStackTrace();
            }

            if (list.size() == 0) {
                rMsg += " * 반영할 데이터가 없습니다.";
                returnMap.put("Code", 0);
                returnMap.put("Message", rMsg);
            } else {

                rMsg += " * 총 " + list.size() + " 건 중 성공건수: " + sCnt + "건, 실패건수: " + fCnt + "건\n";
                if (fCnt > 0) {
                    rMsg += " * 실패메시지\n" + fMsg;
                    returnMap.put("Code", -2);
                    returnMap.put("Message", rMsg);
                } else {
                    returnMap.put("Code", sCnt);
                    returnMap.put("Message", rMsg);
                }
            }
        } else {
            rMsg += " * 반영할 데이터가 없습니다.";
            returnMap.put("Code", 0);
            returnMap.put("Message", rMsg);
        }

        return returnMap;
    }

    public Map<?, ?> getPerExpenseStdITFIDMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getPerExpenseStdITFIDMap", paramMap);
        Log.Debug();
        return resultMap;
    }
}
