package com.hr.common.rd;

import com.hr.common.logger.Log;
import enc.C;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

/**
 * RD 데이터 암호화
 */
@Service("EncryptRdService")
public class EncryptRdService {

    @Value("${rd.url}")
    private String rdUrl;// http://ehrdemo.isusystem.co.kr
    @Value("${rd.mrd}")
    private String rdMrd;// http://ehrdemo.isusystem.co.kr
    @Value("${rd.servicename}")
    private String rdRsn;
    @Value("${rd.base.path}")
    private String rdTypeBasic;
//    @Value("${rd.type.hr1}")
//    private String rdHrType1;// /html/report/hrm/empcard/PersonInfoCardType1_HR.mrd
//    @Value("${rd.type.hr2}")
//    private String rdHrType2;// /html/report/hrm/empcard/PersonInfoCardType2_HR.mrd
//    @Value("${rd.type.hr3}")
//    private String rdHrType3;// /html/report/hrm/other/PersonProfile.mrd
//    @Value("${rd.type.hr4}")
//    private String rdHrType4;
//    @Value("${rd.type.hr5}")
//    private String rdHrType5;
//    @Value("${rd.type.hr6}")
//    private String rdHrType6;
//    @Value("${rd.type.hr7}")
//    private String rdHrType7;
//    @Value("${rd.type.hr8}")
//    private String rdHrType8;
//    @Value("${rd.type.hr9}")
//    private String rdHrType9;
//    @Value("${rd.type.hr10}")
//    private String rdHrType10;
//    @Value("${rd.type.cp1}")
//    private String rdCpType1;
//    @Value("${rd.type.cp2}")
//    private String rdCpType2;
//    @Value("${rd.type.cp3}")
//    private String rdCpType3;
//    @Value("${rd.type.cp4}")
//    private String rdCpType4;
//    @Value("${rd.type.cp5.eng}")
//    private String rdCpType5Eng;
//    @Value("${rd.type.cp5}")
//    private String rdCpType5;

    @SuppressWarnings("unchecked")
    public Map<String, Object> encrypt(Map<String, Object> beforeParam) throws Exception{

        Map<String, Object> result = new HashMap<>();


//        String viewType          = (String)beforeParam.get("viewType");//레포트 보기 타입(1 : 전체, 2 : 요약)
        String parameterType    = (String)beforeParam.get("parameterType");//파라미터 구분(rp 또는 rv)
        String parameters       = (String)beforeParam.get("parameters");//파라미터

        String mrdTarget            = (String)beforeParam.get("rdMrd");//mrd 경로 직접 지정

//        String mrdPath = "";
//        if("hr1".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdHrType2;
//        }else if("hr2".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdHrType1;
//        }else if("hr3".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdHrType3;
//        }else if("hr4".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdHrType4;
//        }else if("hr5".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdHrType5;
//        }else if("hr6".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdHrType6;
//        }else if("hr7".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdHrType7;
//        }else if("hr8".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdHrType8;
//        }else if("hr9".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdHrType9;
//        }else if("hr10".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdHrType10;
//        }else if("cp1".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdCpType1;
//        }else if("cp2".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdCpType2;
//        }else if("cp3".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdCpType3;
//        }else if("cp4".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdCpType4;
//        }else if("cp5e".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdCpType5Eng;
//        }else if("cp5".equalsIgnoreCase(viewType)){
//            mrdPath = rdMrd + rdCpType5;
//        }

//        if(mrdTarget != null) mrdPath = rdMrd + mrdTarget;
        Log.Debug("rd param : {}", mrdTarget + ":::" + mrdTarget.startsWith("/"));

        if(!mrdTarget.startsWith("/")){
            mrdTarget = "/" + mrdTarget;
        }
        String mrdPath = rdMrd + rdTypeBasic + mrdTarget;

        String rfn = "/rfn [" + rdUrl + "/DataServer/rdagent.jsp] ";
        String rsn = "/rsn [" + rdRsn + "] ";
        String reportopt = "/rreportopt [256] /rmmlopt [1] ";
        String param = "/" + parameterType + " " + parameters;
        String securityKey = beforeParam.get("securityKey") + "";
        //todo : securityKey 변경 필요
        if("rp".equalsIgnoreCase(parameterType)){
            param += "[" + securityKey + "] /rv securityKey[" + securityKey + "]";
        }else{
            param += " securityKey[" + securityKey + "]";
        }

        Log.Debug("rd param : {}", mrdPath + "::" + rfn + rsn + reportopt + param);
        
        C.setCharset("UTF-8");
        
        result.put("path", new String(C.process(mrdPath, 11)));
        result.put("encryptParameter",  new String(C.process(rfn + rsn + reportopt + param, 11)));

        return result;
    }

    public Map<String, Object> encrypt(String mrdTarget, String param) throws Exception{

        Map<String, Object> result = new HashMap<>();

        if(!mrdTarget.startsWith("/")){
            mrdTarget = "/" + mrdTarget;
        }

        String mrdPath = rdMrd + rdTypeBasic + mrdTarget;

        String rfn = "/rfn [" + rdUrl + "/DataServer/rdagent.jsp] ";
        String rsn = "/rsn [" + rdRsn + "] ";
        String reportopt = "/rreportopt [256] ";

        Log.Debug("rd param : {}", mrdPath + "::" + rfn + rsn + reportopt + param);

        C.setCharset("UTF-8");

        result.put("path", new String(C.process(mrdPath, 11)));
        result.put("encryptParameter",  new String(C.process(rfn + rsn + reportopt + param, 11)));

        return result;
    }


}
