package com.hr.common.aop;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.SessionUtil;
import com.hr.common.util.StringUtil;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

@Aspect
public class SabunAuthAspect {

    @Value("${sabunAuth.paramName}")
    private String sabunParamName; // 탐색할 sabun Parameter name 목록 (,로 구분)

    @Value("${enterCdAuth.paramName}")
    private String enterCdParamName; // 탐색할 enterCd Parameter name 목록 (,로 구분)

    @Inject
    @Named("SecurityMgrService")
    private SecurityMgrService securityMgrService;

    @Autowired
    private Dao dao;

    @Autowired
    private HttpServletRequest request;

    // 컨트롤러를 제외할 포인트컷 정의
    @Pointcut("execution(* com.hr.main..*(..)) " +
            "|| (execution(* com.hr.common..*(..)) && !execution(* com.hr.common.employee..*Controller.*(..)))" + // common 은 제외하되, employee Controller는 포함하도록 설정
            "|| execution(* com.hr.hri..*(..)) " +
            "|| execution(* com.hr.sys..*(..)) " +
            "|| execution(* com.hr.kms.board..*(..)) " +
            "|| execution(* com.hr.tim.code..*(..)) ")
    public void excludedControllers() {}

    // com.hr 패키지에 속하는 모든 컨트롤러에 대한 포인트컷 정의
    @Pointcut("execution(* com.hr..*Controller.*(..))")
    public void hrController() {}

    @Around("hrController() && !excludedControllers()")
    public Object checkSabunAuth(ProceedingJoinPoint joinPoint) throws Throwable {

        // 결재 문서인 경우 권한 체크 로직 수행X (해당 부분은 Interceptor에서 별도로 체크함)
        String relativeUrl = StringUtil.getRelativeUrl(request).trim();
        Map params = new HashMap<>();
        params.put("ssnEnterCd", SessionUtil.getRequestAttribute("ssnEnterCd"));
        params.put("prgCd", relativeUrl.substring(0, relativeUrl.indexOf(".do") + 3));
        Map<String, Object> resMap = (Map<String, Object>) securityMgrService.getApplPrgCd(params);

        if(resMap != null && resMap.get("authYn") != null && resMap.get("authYn").equals("Y"))
            return joinPoint.proceed();
        
        // 사번, EnterCd 체크 로직 수행
        if((sabunParamName == null || sabunParamName.isEmpty()) && (enterCdParamName == null || enterCdParamName.isEmpty()))
            return joinPoint.proceed();

        String[] sabunParamNameArray = sabunParamName.split(",");
        String[] enterCdParamNameArray = enterCdParamName.split(",");

        for (Object arg : joinPoint.getArgs()) {
            if (arg instanceof Map) {
                Map<?, ?> mapArg = (Map<?, ?>) arg;
                for (Object key : mapArg.keySet()) {
                    if (key instanceof String) {

                        boolean containsSabunParamName = false;
                        boolean containsEnterCdParamName = false;

                        if(enterCdParamName != null && !enterCdParamName.isEmpty()) {
                            // 맵의 키 이름에 enterCdAuth.paramName 값이 포함되어 있으면 회사 권한 체크 로직 수행
                            containsEnterCdParamName = Arrays.stream(enterCdParamNameArray)
                                    .anyMatch(paramName -> key.toString().toLowerCase().equals(paramName.toLowerCase()));
                        }

                        if (sabunParamName != null && !sabunParamName.isEmpty()){
                            // 맵의 키 이름에 sabunAuth.paramName 값이 포함되어 있으면 사번 권한 체크 로직 수행
                            // 단, sheet 저장 액션의 경우 내부에 sabunAuth.paramName 값이 포함되어 있다면 넘어간다.
                            containsSabunParamName =
                                    !(mapArg.containsKey("s_SAVENAME") && mapArg.containsKey("cmd") && mapArg.get("cmd").toString().startsWith("save")) &&
                                    Arrays.stream(sabunParamNameArray)
                                    .anyMatch(paramName -> key.toString().toLowerCase().equals(paramName.toLowerCase()));
                        }

                        if (containsEnterCdParamName || containsSabunParamName) {
                            if (mapArg.get(key) != null && !mapArg.get(key).equals("")) {

                                Map<String, Object> paramMap = new HashMap<String, Object>();
                                paramMap.put("ssnEnterCd", SessionUtil.getRequestAttribute("ssnEnterCd"));
                                paramMap.put("authSqlID", "");
                                paramMap.put("ssnSearchType", SessionUtil.getRequestAttribute("ssnSearchType"));
                                paramMap.put("ssnSabun", SessionUtil.getRequestAttribute("ssnSabun"));
                                paramMap.put("searchGrpCd", SessionUtil.getRequestAttribute("ssnGrpCd"));
                                paramMap.put("ssnGrpCd", SessionUtil.getRequestAttribute("ssnGrpCd"));
                                paramMap.put("searchParam", mapArg.get(key));

                                try {
                                    Map<?, ?> authYn = null;
                                    if(containsEnterCdParamName) { // 회사 권한 체크 쿼리
                                        // 세션 EnterCd 값과 parameter의 값이 다른 경우에만 회사 권한 체크 쿼리 수행.
                                        if(paramMap.get("ssnEnterCd").equals(paramMap.get("searchParam")))
                                            continue;

                                        authYn = dao.getMap("getEnterCdAuthQueryMap", paramMap);
                                    } else if (containsSabunParamName) { // 사번 권한 체크 쿼리
                                        // 전사 조회권한인 경우, 사번 권한 체크 건너뛰기
                                        if(paramMap.get("ssnSearchType").equals("A"))
                                            continue;

                                        Map<?, ?> query = dao.getMap("getAuthQueryMap", paramMap);
                                        paramMap.put("query", query.get("query"));

                                        authYn = dao.getMap("getSabunAuthQueryMap", paramMap);
                                    }

                                    Log.Debug("authCnt : " + authYn.get("authCnt").toString());
                                    if (Integer.parseInt(authYn.get("authCnt").toString()) > 0) {
                                        Log.Debug("Auth Succeed!");
                                    } else {
                                        Log.Debug("Auth Fail! No Auth");

                                        ModelAndView mv = new ModelAndView();
                                        mv.setViewName("jsonView");
                                        mv.addObject("Code", -1);
                                        mv.addObject("DATA", "");
                                        mv.addObject("Map", "");
                                        mv.addObject("Result", "");
                                        mv.addObject("Message", "조회 권한이 없습니다.");
                                        return mv;
                                    }
                                } catch (Exception e) {
                                    Log.Debug("Auth ERROR!");
                                    Log.Debug(e.getMessage());
                                }
                            }
                        }
                    }
                }
            }
        }
        return joinPoint.proceed();
    }

}
