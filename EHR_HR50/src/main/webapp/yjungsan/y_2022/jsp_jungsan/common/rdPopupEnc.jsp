<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	// 본 파일은 rdPopup.jsp, yeaDataPrtView.jsp에서 참조됩니다.

	/* ************************************************************************* 
	20231218 
	---------------------------------------------------------------------
	[ RD 보안 등급 ] RD.SEC_LEVEL
	------------------------------------------------------------------------
	 0=기본 F_SEC_MRD_CHECK(파라미터3개))
	 1=Param암호화(M2SOFT enc라이브러리::오토에버버전, v5.0 디폴트 - HMM, 호반, BGF)  F_SEC_MRD_CHECK(파라미터3개))
	 2=Param암호화&권한체크(HR암호화 & 권한체크 :: 한진칼) 속도저하우려  F_SEC_MRD_CHECK_YEA → F_SEC_MRD_CHECK(파라미터7개)
	 3=1번과 2번 동시 적용(ver 5.0) 속도저하우려
	************************************************************************* */
	//Integer RD_SEC_LEVEL = Integer.valueOf(StringUtil.nvl(StringUtil.getPropertiesValue("RD.SEC_LEVEL"), "0")) ;

	/* 20231221 설정과 관계없이 파라미터는 일단 던져야 함. START
	if (RD_SEC_LEVEL == 2)
	{ */
		// Param암호화 :: HR암호화
		// -------------------------------------
		// 0) rdPopup.jsp 파라미터 전달 추가
		// 1) rdPopup.jsp 파라미터 전달 추가
		// 2) rdPopupIframe.jsp 추가 조치 없음
		// 3) *.mrd : 일부사이트 보안함수 파라미터 추가 이슈
        //    nvl ( F_SEC_MRD_CHECK_YEA(파라미터7개) → F_SEC_MRD_CHECK(파라미터7개), F_SEC_MRD_CHECK(파라미터3개) )
        out.println(" $('#sKey').val('"  + request.getAttribute("sKey")  + "') ; ");
        out.println(" $('#gKey').val('"  + request.getAttribute("gKey")  + "') ; ");
        out.println(" $('#sType').val('" + request.getAttribute("sType") + "') ; ");
        out.println(" $('#qId').val('"   + request.getAttribute("qId")   + "') ; ");
        
        out.println(" var rdThem= '' ; //rdThem ");
        out.println(" try { ");
        out.println("     if( arg != undefined ) { rdThem = arg['rdThem']; } ");
        out.println("     else { rdThem = p.popDialogArgument('rdThem'); } ");
        out.println(" } catch (e) { ");
        out.println("     rdThem = ''; ");
        out.println(" } ");
        out.println(" if (rdThem == '' || rdThem == null || rdThem == undefined) { rdThem = \"''\"; } ");
        out.println(" $('#RdThem').val(rdThem) ; ");
    /* 20231221 설정과 관계없이 파라미터는 일단 던져야 함. END 
   	}
	//RD_SEC_LEVEL이 1 또는 3일 때, rdPopupIframe.jsp → rdPopupIframeEnc.jsp → rdPopupIframeEncLib.jsp에서 처리 
	if (RD_SEC_LEVEL == 1 || RD_SEC_LEVEL == 3) 
	{
		// Param암호화 :: M2SOFT enc라이브러리
		// -------------------------------------
		// 1) rdPopup.jsp : 추가 조치 없음
		// 2) rdPopupIframe.jsp : viewer 옵션 지정
	}
	*/
%>