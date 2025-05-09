<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
    //본 파일은 rdPopupIframe.jsp에서 참조됩니다.
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
	Integer RD_SEC_LEVEL = Integer.valueOf(StringUtil.nvl(StringUtil.getPropertiesValue("RD.SEC_LEVEL"), "0")) ;

	/* 20231221 설정과 관계없이 파라미터는 일단 던져야 함. 
	if (RD_SEC_LEVEL == 2)
	{ */
		// Param암호화 :: HR암호화
		// -------------------------------------
		// 0) rdPopup.jsp 파라미터 전달 추가
		// 1) rdPopup.jsp 파라미터 전달 추가
		// 2) rdPopupIframe.jsp 추가 조치 없음
		// 3) *.mrd : 일부사이트 보안함수 파라미터 추가 이슈
        //    nvl ( F_SEC_MRD_CHECK_YEA(파라미터7개) → F_SEC_MRD_CHECK(파라미터7개), F_SEC_MRD_CHECK(파라미터3개) )
        //인사 쪽 보안 배포가 안된 경우 제증명 화면에서 원천징수영수증, 원천징수부 호출 시 오류 때문에 /rv, /rp 모두 securityKey 파라미터로 전송.
        
        out.println("function rdEncryptAndOpenFile(mrd, param) {");
        out.println("var sKey   = $('#sKey', parent.document).val();");
        out.println("var gKey   = $('#gKey', parent.document).val();");
        out.println("var sType  = $('#sType', parent.document).val();");
        out.println("var qId    = $('#qId', parent.document).val();");
        out.println("var RdThem = $('#RdThem', parent.document).val();");
		
        out.println("if ( $('#ParamGubun', parent.document).val()=='rp' ) {");
        out.println("    if ( param.indexOf('/rv') > -1 ) {");
        out.println("        param += ' sKey['+sKey+'] ';");
        out.println("        param += ' gKey['+gKey+'] ';");
        out.println("        param += ' sType['+$('#sType', parent.document).val()+'] ';");
        out.println("        param += ' qId['+$('#qId', parent.document).val()+'] ';");
        out.println("        param += ' themKey['+$('#RdThem', parent.document).val()+'] ';");
        out.println("    } else {");
        out.println("        param += ' /rv ';");
        out.println("        param += ' sKey['+$('#sKey', parent.document).val()+'] ';");
        out.println("        param += ' gKey['+$('#gKey', parent.document).val()+'] ';");
        out.println("        param += ' sType['+$('#sType', parent.document).val()+'] ';");
        out.println("        param += ' qId['+$('#qId', parent.document).val()+'] ';");
        out.println("        param += ' themKey['+$('#RdThem', parent.document).val()+'] ';");
        out.println("    }");
        out.println("} else {");
        out.println("	param = param.replace(' /rp ', ' sKey['+$('#sKey', parent.document).val()+'] '"); 
        out.println("			                     + ' gKey['+$('#gKey', parent.document).val()+'] '");
        out.println("			                     + ' sType['+$('#sType', parent.document).val()+'] '");
        out.println("			                     + ' qId['+$('#qId', parent.document).val()+'] '");
        out.println("        			             + ' themKey['+$('#RdThem', parent.document).val()+'] '");
        out.println("			                     + ' /rp ');");
        out.println("}");
	//}
	if (RD_SEC_LEVEL == 1 || RD_SEC_LEVEL == 3) 
	{	
		// Param암호화 :: M2SOFT enc라이브러리
		// -------------------------------------
		// 1) rdPopup.jsp : 추가 조치 없음
		// 2) rdPopupIframe.jsp : viewer 옵션 지정
		out.println("var EncParam = 'mrd_path='+encodeURIComponent(mrd)+'&mrd_param='+encodeURIComponent(param); ");		
		out.println("viewer.setParameterEncrypt(11); "); // viewer 옵션 지정(디폴트)
		out.println("$.ajax({ ");
		out.println("		url 		: 'rdPopupIframeEncLib.jsp', ");
		out.println("		type 		: 'post', ");
		out.println("		dataType 	: 'json', ");
		out.println("		async 		: true, ");
		out.println("		data 		: EncParam, ");		
		out.println("		success : function(data) { ");
		out.println("			if(data != null) { ");		
		out.println("				mrd = data.Enc_Mrd_path ; "); // enc.jar로 암호화된 mrd 경로
		out.println("				param = data.Enc_Mrd_param ; "); // enc.jar로 암호화된 mrd 파라미터
		out.println("               viewer.setParameterEncrypt(data.Enc_Type); "); // viewer 옵션 지정
		out.println("				viewer.openFile(mrd, param, {downloadProtocolFile:true}); ");
		out.println("				viewer.bind('report-finished', eventHandler);");
		out.println("	    	} ");
		out.println("		}, ");		
		out.println("		error : function(jqXHR, ajaxSettings, thrownError) { ");
		out.println("				alert('문서를 열 수 없습니다.'); ");//암호화된 자료가 넘어오지 않으면 아무것도 열리지 않도록
		out.println("		} ");
		out.println("	}); ");
	}
	else //if (RD_SEC_LEVEL == 2) 
	{
		out.println(" viewer.openFile(mrd, param, {downloadProtocolFile:true}); ");
        out.println(" viewer.bind('report-finished', eventHandler);");
	}
    out.println(" }");
%>