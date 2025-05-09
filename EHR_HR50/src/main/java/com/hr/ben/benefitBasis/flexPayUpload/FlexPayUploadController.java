package com.hr.ben.benefitBasis.flexPayUpload;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
@RequestMapping(value="/FlexPayUpload.do", method=RequestMethod.POST )
public class FlexPayUploadController extends ComController {

    /**
     * 변동급여업로드 View
     *
     * @return String
     */
    @RequestMapping(params="cmd=viewFlexPayUpload", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewFlexPayUpload() {
        return "ben/benefitBasis/flexPayUpload/flexPayUpload";
    }

    /**
     * 변동급여업로드 단건 조회
     *
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getFlexPayUploadMap", method = RequestMethod.POST )
    public ModelAndView getFlexPayUploadMap(
            HttpSession session,
            HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap
    ) throws Exception {
        Log.DebugStart();
        return getDataMap(session, request, paramMap);
    }

    /**
     * 변동급여업로드 Master 조회
     *
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getFlexPayUploadFirstList", method = RequestMethod.POST )
    public ModelAndView getFlexPayUploadFirstList(
            HttpSession session,
            HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap
    ) throws Exception {
        Log.DebugStart();
        return getDataList(session, request, paramMap);
    }

    /**
     * 변동급여업로드 Detail 조회
     *
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getFlexPayUploadSecondList", method = RequestMethod.POST )
    public ModelAndView getFlexPayUploadSecondList(
            HttpSession session,
            HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap
    ) throws Exception {
        Log.DebugStart();
        return getDataList(session, request, paramMap);
    }

    /**
     * 변동급여업로드 Detail 저장
     *
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveFlexPayUpload", method = RequestMethod.POST )
    public ModelAndView saveFlexPayUpload(
            HttpSession session,
            HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap
    ) throws Exception {
        Log.DebugStart();
        return saveData(session, request, paramMap);
    }

    /**
     * 변동급여업로드 급여마감 상태 조회
     *
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getBenefitCloseStMap", method = RequestMethod.POST )
    public ModelAndView getBenefitCloseStMap(
            HttpSession session,
            HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap
    ) throws Exception {
        Log.DebugStart();
        return getDataMap(session, request, paramMap);
    }

    /**
     * 변동급여업로드_복리후생 데이터 마감 처리
     *
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=callP_BEN_PAY_DATA_CLOSE", method = RequestMethod.POST )
    public ModelAndView callP_BEN_PAY_DATA_CLOSE(
            HttpSession session,
            HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap
    ) throws Exception {
        Log.DebugStart();
        return execPrc(session, request, paramMap);
    }

    /**
     * 변동급여업로드_복리후생 데이터 마감 취소 처리
     *
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=callP_BEN_PAY_DATA_CLOSE_CANCEL", method = RequestMethod.POST )
    public ModelAndView callP_BEN_PAY_DATA_CLOSE_CANCEL(
            HttpSession session,
            HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap
    ) throws Exception {
        Log.DebugStart();
        return execPrc(session, request, paramMap);
    }

}
