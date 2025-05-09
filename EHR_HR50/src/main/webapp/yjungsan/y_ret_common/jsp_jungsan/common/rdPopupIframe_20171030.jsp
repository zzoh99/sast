<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%@ include file="../../../common_jungsan/jsp/pathPropRd.jsp" %>
<!DOCTYPE html><html class="bodywrap"><head><base target="_self"><title>e-HR</title>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<link rel="stylesheet" href="../../../common_jungsan/css/nanum.css" />
<link rel="stylesheet" href="../../../common_jungsan/theme1/css/style.css" />
<script src="../../../common_jungsan/js/jquery/1.8.3/jquery.min.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>

</head>
<body onLoad="rd_onload();">
<script language="javascript" src="<%=rdScriptUrl%>"></script>
<script type="text/javascript">
/*
 * RD가 출력되는 IFRAME이다.
 */
var rdBaseUrl = "<%=rdBaseUrl%>";
var rdBasePath = "<%=rdBasePath%>";
var rdAgent = "<%=rdAgentPath%>";
var rdAlias = "<%=rdAliasName%>";
var rdVersion = "<%=rdVersion%>";

function rd_onload(){
    if(rdVersion == "2") {
    	if(checkOcx == 2){ window.location = rdBaseUrl +"/DataServer/plugin/ocxInstall_u.html" ; return ; }
    }

    if( !checkParam() ) return ;

	var mrd    = "";
	var param  = "/rfn ["+rdBaseUrl+rdAgent+"] /rsn ["+rdAlias+"] /rwatchprn [] ";
	param  = param +"/" + $("#ParamGubun", parent.document).val() + " ";//rp또는 rv로 넘어온다.

    reportFileNm = rdBasePath+"/"+$("#Mrd", parent.document).val();//루트를 제외한 RD경로 및 파일명 매칭
    if(rdVersion == "2") {
        setRdSessionInfo() ;
    }

    param        = param + $("#Param", parent.document).val(); //파라매터 넘김
	mrd   		 = reportFileNm;
    
    
   	/* 파라미터 변조 체크를 위한 securityKey 를 파라미터로 전송 함 */
	var securityKey = $("#SecurityKey", parent.document).val();
    
   	//인사 쪽 보안 배포가 안된 경우 제증명 화면에서 원천징수영수증, 원천징수부 호출 시 오류 때문에 /rv, /rp 모두 securityKey 파라미터로 전송.
    if ( $("#ParamGubun", parent.document).val()=="rp" ) {
    	if ( param.indexOf("/rv") > -1 ) {
	    	param = param.replace("/rv", " ["+securityKey+"] /rv securityKey["+securityKey+"] ");
    	} else {
    		param += " ["+securityKey+"] /rv securityKey["+securityKey+"] ";
    	}
    } else {
    	param += " securityKey["+securityKey+"] /rp ["+securityKey+"] ";
    }
	
   	
    if(rdVersion == "2") {
        //RD 툴바 메뉴 및 컨텍스트 메뉴 세팅
    	setRdMenu() ;
    	rdViewer.ApplyLicense( rdBaseUrl+rdAgent );
    } else {
			rdViewer.AutoAdjust = false;
			rdViewer.ZoomRatio=100;
    }

	rdViewer.FileOpen(mrd, param);
}

function checkParam() {
	if( !( $("#ParamGubun", parent.document).val() == "rp" || $("#ParamGubun", parent.document).val() == "rv" || $("#ParamGubun", parent.document).val() == "" ) ) {
		alert("개발오류입니다.\n파라매터 중 rdParamGubun값은 rp또는rv이어야 합니다.") ;
		return false ;
	} else if( $("#ParamGubun", parent.document).val() == "" ) { $("#ParamGubun", parent.document).val("rp") ; }//값이 넘어오지 않으면 기본 rp

	return true ;
}

function setRdSessionInfo() {
    /*
	사진을 보려면 Plugin Viewer에서는 세션유지를 못하는 버그가 있어
	해당사항을 우리 소스에서 해결하는 코드 : sessionParam
	*/
	var sessionParam = "" ;
	$("#ParamGubun", parent.document).val() == "rv" ? sessionParam = " NgmSsoName[JSESSIONID] NgmSsoData["+"<%=(String)session.getId()%>"+"]" : sessionParam = " /rv NgmSsoName[JSESSIONID] NgmSsoData["+"<%=(String)session.getId()%>"+"]" ;
	$("#Param", parent.document).val( $("#Param", parent.document).val() + sessionParam ) ;
}

function setRdMenu() {
    if($("#ToolbarYn", parent.document).val() != "Y") {
    	rdViewer.HideToolBar();//툴바 전체 비활성화 - 대소문자 주의!
    	rdViewer.HidePopupMenu(0);//컨텍스트 메뉴 전체 비활성화
    }

    if($("#SaveYn", parent.document).val() != "Y") {
        rdViewer.DisableToolbar(0);
        rdViewer.HidePopupMenu(4) ;
        rdViewer.HidePopupMenu(9) ;
        rdViewer.HidePopupMenu(8) ;
    }

    if($("#PrintYn", parent.document).val() != "Y") {
        rdViewer.DisableToolbar(1);
        rdViewer.HidePopupMenu(3) ;
    }

    if($("#ExcelYn", parent.document).val() != "Y") { rdViewer.DisableToolbar(13); }
    if($("#WordYn", parent.document).val() != "Y") { rdViewer.DisableToolbar(17); }
    if($("#PptYn", parent.document).val() != "Y") { rdViewer.DisableToolbar(16); }
    if($("#HwpYn", parent.document).val() != "Y") { rdViewer.DisableToolbar(14); }
    if($("#PdfYn", parent.document).val() != "Y") { rdViewer.DisableToolbar(15); }

	rdViewer.AutoAdjust = false;
	if($("#ZoomRatio", parent.document).val() != "") { rdViewer.ZoomRatio = Number( $("#ZoomRatio", parent.document).val() ) ; }
	else {	rdViewer.ZoomRatio = 100 ; }
	//rdViewer.IsShowDlg = 0;
	rdViewer.SetBackgroundColor(255,255,255);
}
//IE외 브라우져 최종 인쇄버튼 누를 시 발생
function PrintFinished() {
	//document.getElementById('rdViewer');
	$("#printResultYn", parent.document).val("Y") ;
	if( parent.returnResult != null ) {
		parent.returnResult() ;
	}
}
</script>
<!--
	* 인쇄결과
	IE 최종 인쇄버튼 누를 시 발생
	by JSG
-->
<SCRIPT LANGUAGE=JavaScript FOR=rdViewer EVENT="PrintFinished()">
	$("#printResultYn", parent.document).val("Y") ;
	if( parent.returnResult != null ) {
		parent.returnResult() ;
	}
</SCRIPT>
<SCRIPT LANGUAGE=JavaScript FOR=rdViewer EVENT="FileOpenFinished()">
      //alert("completed !!!");
</SCRIPT>
<SCRIPT LANGUAGE=JavaScript FOR=rdViewer EVENT="FileSaveAsFinished()">
     //alert("completed save as file!!!");
</SCRIPT>

</body>

</HTML>




