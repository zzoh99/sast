package com.hr.common.interfaceIf.hrm;

import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.dao.ApiDao;
import com.hr.common.util.CryptoUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SearchEmpService {

    @Autowired
    private ApiDao dao;

    @Autowired
    private SecurityMgrService securityMgrService;

    public List<?> searchEmp(Map<String, Object> paramMap) throws Exception {
        List<?> empInfos = (List<?>) dao.getList("getEmpInfos", paramMap);

        for (Object empInfo : empInfos) {
            Map<String, Object> empInfoMap = (Map<String, Object>) empInfo;

            empInfoMap.put("key", makeKey(empInfoMap));

            List<Object> empSchoolList = (List<Object>) dao.getList("getEmpSchoolList", empInfoMap);
            empInfoMap.put("school", empSchoolList);

            List<Object> empEduList = (List<Object>) dao.getList("getEmpEduList", empInfoMap);
            empInfoMap.put("edu", empEduList);
            empInfoMap.put("eduCnt", empEduList.size());

            List<Object> empLicenseList = (List<Object>) dao.getList("getEmpLicenseList", empInfoMap);
            empInfoMap.put("license", empLicenseList);
            empInfoMap.put("licenseCnt", empLicenseList.size());

            List<Object> empLanguageList = (List<Object>) dao.getList("getEmpLanguageList", empInfoMap);
            empInfoMap.put("language", empLanguageList);

            List<Object> empOverStudyList = (List<Object>) dao.getList("getEmpOverStudyList", empInfoMap);
            empInfoMap.put("overStudy", empOverStudyList);

            List<Object> empCareerList = (List<Object>) dao.getList("getEmpCareerList", empInfoMap);
            empInfoMap.put("career", empCareerList);

            List<Object> empPunishList = (List<Object>) dao.getList("getEmpPunishList", empInfoMap);
            empInfoMap.put("Punish", empPunishList);

            List<Object> empAppResultList = (List<Object>) dao.getList("getEmpAppResultList", empInfoMap);
            empInfoMap.put("appResult", empAppResultList);

            empInfoMap.remove("sabun");
            empInfoMap.remove("enterCd");
        }

        return empInfos;
    }

    private String makeKey(Map<String, Object> empInfoMap) {
        String enterCd = empInfoMap.get("enterCd").toString();
        String sabun = empInfoMap.get("sabun").toString();

        String encryptKey = getEncryptKey(enterCd, SecurityMgrService.HRM);
        return CryptoUtil.encrypt(encryptKey, enterCd + "#" + sabun);
    }


    public String getEncryptKey(String enterCd, String prgPackage) {
        String key = null;
        try {
            Map<String, Object> param = new HashMap<>();
            param.put("enterCd", enterCd);
            key = (String) dao.getOne("getEncryptKeyForWrapper", param);
            int t, r;
            //서비스 별로 암호화 키를 변조한다. 특정 서비스에서 암호화한 값을 다른 서비스에서 재활용 하지 못하게 하기 위함
            switch (prgPackage){
                case SecurityMgrService.HRM:
                    //총 길이의 반을 나눈 위치의 값을
                    t = Math.floorDiv(key.length(),2);
                    //총 길이의 3을 나눈 위치의 값과 바꾼다
                    r = Math.floorDiv(key.length(),3);
                    key = key.replaceAll(key.substring(t, t+1), key.substring(r, r+1));
                    break;
                default:
            }
        } catch (Exception e) {
            Log.Debug(e.getLocalizedMessage());
        }
        return key;
    }
}
