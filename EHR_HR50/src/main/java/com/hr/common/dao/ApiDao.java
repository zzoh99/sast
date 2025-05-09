package com.hr.common.dao;

import com.hr.common.logger.Log;
import com.hr.common.util.SessionUtil;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import java.util.*;

@Repository("ApiDao")
public class ApiDao {
    @Autowired
    private SqlSessionTemplate sqlSession;

    private static String sabunParams; // 임직원 공통 권한에서 변조가 허용되지 않는 사번 키

    @Value("${isu.auth.sabun.keys}")
    public void setKey(String sabunParams) {
        ApiDao.sabunParams = sabunParams;
    }

    public Collection<?> getList(String queryId, Object params) throws Exception {
        Collection<?> collection = null;
        params = ApiDao.convertParams(params);
        collection = sqlSession.selectList(queryId, params);
        Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
        Log.Debug("┌────────────────── {} GetList Result ────────────────────────", queryId);
        Log.Debug("│  cnt : {}", collection.size());
        Log.Debug("└────────────────── {} GetList Result ────────────────────────", queryId);
        return collection;
    }

    public Object getOne(String queryId, Object params) throws Exception {
        params = ApiDao.convertParams(params);
        return sqlSession.selectOne(queryId, params);
    }

    public Map<?, ?> getMap(String queryId, Object params) throws Exception {
        params = ApiDao.convertParams(params);
        Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
        Map<?,?> map = null;
        map = sqlSession.selectOne(queryId, params);
        Log.Debug("┌────────────────── {} Result Map Start────────────────────────", queryId);
        Log.Debug("│  {}", map);
        Log.Debug("└────────────────── {} Result Map End──────────────────────────", queryId);
        return map;
    }

    /**
     * 데이터 생성
     *
     * @param queryId
     * @param params
     * @return int
     * @throws Exception
     */
    public int create(String queryId, Object params) throws Exception {
        params = ApiDao.convertParams(params);
        Log.Debug("\n■■■■■■■■■ [ queryId :{} ] ■■■■■■■■■\n", queryId);
        int cnt = sqlSession.insert(queryId, params);
        return cnt;
    }

    /**
     * 데이터 갱신
     *
     * @param queryId
     * @param params
     * @return int
     * @throws Exception
     */
    public int update(String queryId, Object params) throws Exception {
        params = ApiDao.convertParams(params);
        Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
        int cnt = sqlSession.update(queryId, params);
        Log.Debug("┌────────────────── {} Update Result ────────────────────────", queryId);
        Log.Debug("│  cnt : {}", cnt);
        Log.Debug("└────────────────── {} Update Result ────────────────────────", queryId);
        return cnt;
    }

    /**
     * @param queryId
     * @param params
     * @return int
     * @throws Exception
     */
    public int delete(String queryId, Object params) throws Exception {
        params = ApiDao.convertParams(params);
        Log.Debug("\n■■■■■■■■■ [ queryId : {} ] ■■■■■■■■■\n", queryId);
        int cnt = sqlSession.delete(queryId, params);
        Log.Debug("┌────────────────── {} Delete Result ────────────────────────", queryId);
        Log.Debug("│  cnt : {}", cnt);
        Log.Debug("└────────────────── {} Delete Result ────────────────────────", queryId);
        return cnt;
    }

    public Object excute(String queryId, Object params)  {
        params = ApiDao.convertParams(params);
        Log.Debug("\n■■■■■■■■■ [ execute queryId : {} ] ■■■■■■■■■\n", queryId);
        sqlSession.update(queryId, params);
        return params;
    }

    public static Object convertParams(Object params) {
        Object convert = null;
        if (params instanceof Map) {
            Map<String, Object> convertmap = (Map<String, Object>) params;
            String[] ssnKeys = new String[] { "ssnEnterCd", "ssnLocaleCd", "ssnSearchType", "ssnGrpCd", "ssnBaseDate", "ssnSabun", "ssnEncodedKey", "ssnAdminYn" };
            String[] excKeys = new String[] { "selectColumn", "selectViewQuery","query","memo","relUrl","sqlConv","sqlSyntax","executeSQL", "content", "helpTxtContent", "cols", "values", "templateContent"};
            String[] inParam = new String[] { "multiManageCd","multiWorkType" ,"multiAttatchStatus","multiStatusCd","multiManageCd","multiSalClass","multiPayType","multiJikgubCd","multiJikgubNm","multiWorkType","multiWorkOrgCd","multiStatusCd","multiPayCd","multiOrdTypeCd","multiRunType","multiSalClass","multiAttatchStatus","multiSearchCode","multiNojoCd","multiNojoPositionCd","multiNojoJikchakCd","multiDevStatusCd","multiProSecCd","searchJob","searchMultiManageCd","searchManageCdHidden","searchStatusCdHidden","searchJikgubCdHidden","searchJikweeCdHidden","searchJikchakCdHidden","searchStatusCdHidden","searchOrgCdHidden","searchWorkTypeHidden","searchDAppTypeCd","searchAppTypeCd","searchAppStepCd","searchAppStepCds","searchAppStepCdNot","searchJobType","searchRunType","searchPayCdIn","searchBusinessPlaceCd","searchPayCdIn","searchStatusCd","applStatusNotCd","businessPlaceCd","locationCd","payGroupCd","runType","runTypeIn","runTypeNotIn","payActionCds","payActionCd1","payActionCd2","payCdIn","payCdNotIn","payType","manageCd","inCode","insabun","notInCode","grpCd","gubun","jikweeCd","jikweeCdL","jikgubCd","jikgubCdL","workType","workTypeL","inOrdType","jikchakCd","jikchakCdL","sexType","sexTypeL","statusCd","qrySabun1","qrySabun2","qrySabun3","qrySabun4","conditions","agreeSabun","deleteRows","ordType","authEnterCd","notInOrdType","businessPlaceCd","positionCd"
                    ,"bbsSort", "columnName"};
            //String[] changeKeys = new String[] { "grpCd", "runType", "multiStatusCd"}; //columnInfo >> 이놈은 스트립트에서 자바로 변경해야한다
            Arrays.stream(ssnKeys).filter(k -> SessionUtil.getRequestAttribute(k) != null).forEach(key ->  convertmap.put(key, SessionUtil.getRequestAttribute(key)));
            Iterator<String> it = convertmap.keySet().iterator();
            while(it.hasNext()){
                String k = it.next();
                Object v = convertmap.get(k);
                //&& !k.startsWith("log")
                if (v instanceof String && Arrays.asList(inParam).contains(k) && v != null && !v.equals("") && ((String) v).indexOf(",") != -1) {
                    convertmap.put(k,((String) v).split(","));
                }
            }

            checkEmployeeSabun(convertmap);

            convert = convertmap;
        } else {
            convert = params;
        }

        return convert;
    }

    private static void checkEmployeeSabun(Map<String, Object> map) {
        //임직원 공통일때 본인 사번으로 제한
        if ("99".equals(String.valueOf(map.get("ssnGrpCd")))) {
            String ssnSabun = String.valueOf(map.get("ssnSabun"));
            Log.Debug("임직원 공통일때 본인 사번으로 제한");
            Log.Debug("GetDataList paramMap==>" + map.toString());

            try {
                Arrays.stream(sabunParams.split(","))
                        .filter(map::containsKey)
                        .forEach(key -> map.put(key, ssnSabun));
            } catch(Exception e) {
                Log.Error("Error occured at checkEmployeeSabun => " + e.getLocalizedMessage());
            }

            Log.Debug("Changed map data ==>" + map.toString());
/*
			map.put("sabun", ssnSabun);

			// searchUserId 변조 방지
			if (map.containsKey("searchUserId")) {
				map.put("searchUserId", ssnSabun);
			}
*/
        }
    }
}
