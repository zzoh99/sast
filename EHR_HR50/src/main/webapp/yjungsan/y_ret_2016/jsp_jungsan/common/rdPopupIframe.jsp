<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%@ include file="../../../common_jungsan/jsp/pathPropRd_44.jsp" %>

<!DOCTYPE html><html class="bodywrap" style="margin:0;height:100%"><head><base target="_self"><title>e-HR</title>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->

<%
String baseRdPath       = "/html/report/" ;

//local 일때는 서버의  mrd 파일을 읽어들임
String tmpIpChk = request.getRemoteAddr();
if (tmpIpChk.equals("127.0.0.1") || tmpIpChk.equals("0:0:0:0:0:0:0:1")) {
    rdBaseUrl =rdUrl;
}

%>

<script src="<%=rdUrl%>/ReportingServer/html5/js/jquery-1.11.0.min.js"></script>
<script src="<%=rdUrl%>/ReportingServer/html5/js/crownix-viewer.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=rdUrl%>/ReportingServer/html5/css/crownix-viewer.min.css">
</head>
<body style="margin:0;height:100%">
<div id="crownix-viewer" style="position:absolute;width:100%;height:100%"></div>
<script>

window.onload = function(){

//
var rdUrl   = "<%=rdUrl%>";
var rsn     = "<%=rdAliasName%>";
var rdBasePath = "<%=rdBasePath%>";
var rdAgent = "/DataServer/rdagent.jsp" ;


var mrd     = "";
var param   = "/rfn ["+rdUrl+rdAgent+"] /rsn ["+rsn+"] /rreportopt [256] ";
        param  = param +"/" + $("#ParamGubun", parent.document).val() + " ";//rp또는 rv로 넘어온다.
        reportFileNm =  "<%=rdBaseUrl%>" + rdBasePath+"/"+$("#Mrd", parent.document).val();//루트를 제외한 RD경로 및 파일명 매칭

        param       = param + $("#Param", parent.document).val(); //파라매터 넘김
        mrd         = reportFileNm;

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

        var viewer = new m2soft.crownix.Viewer(rdUrl+ '/ReportingServer/service', 'crownix-viewer');
        
		<%--
        2021 귀속 년도 당시 미완성 소스이므로 주석처리함. 필요할 경우 정비 필요. 20240822
		/*************************************************************
		 * 2021.04.19 로그관리
		 * 버튼 설정 작업
		 *************************************************************/

		var pdfsave   = function(){ reasonYnChk('pdf');       };
		var excelsave = function(){ reasonYnChk('xls');       };
		var pptsave   = function(){ reasonYnChk('ppt');       };
		var docsave   = function(){ reasonYnChk('doc');       };
		var hwpsave   = function(){ reasonYnChk('hwp');       };
		var pdfPrint  = function(){ reasonYnChk('print_pdf'); };

		var d=m2soft.crownix.resource.Icon;
		var e=m2soft.crownix.Resource;

		var downloadPDF = {
		    index : 9, //툴바 버튼 위치
		    id : 'pdf_2' ,
		    //svg:d.PDF,
		    img:"data:image/png;base64,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",
		    title : 'PDF 저장',
		    separator : true,
		    handler :  pdfsave
		};
		var downloadXLS = {
		    index : 10, //툴바 버튼 위치
		    id : 'xls_2' ,
		    img:"data:image/png;base64,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",
		    title : 'XLS 저장',
		    separator : true,
		    handler :  excelsave
		};
		var downloadPPT = {
		    index : 11, //툴바 버튼 위치
		    id : 'ppt_2' ,
		    //툴바 아이콘은 svg 형식의 이미지를 지원함.
		    img:"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAABIAAAASABGyWs+AAAACXZwQWcAAAAgAAAAIACH+pydAAAEMElEQVRYw8XXW4hVZRQH8N/e5+pcvM1YQY2iDiYapkY9JeFD1Is9+BhdQCGC3pKgnoIuT11AyJfIwIQeepCe7UYEBZlRUlJmmo6aYJOXc+bMnOvuYe8zZ5/THJspyQV/9trfZa3/t9ba3/dtbrIEfdpGMIbCDfJTxQQmEV2PwBLsHsp57PZBq4o5OYFIiDAZHabQnt1KEKX0DoKZuvr5ijPlhoN4F1fnIjCE17eN2r3nbtl7VlMcJiokcUijmNJhpj+CGWZKHP2NN37U+OJP7+A5lHsJPHHvUm+/v0Nh/H6MJquUrCxK6elnC80EjT56E1Oc/J5HP1Y9cs1TeE/KRT5g55ObFcZ3YC0GkUcmoRklRmuYRgUlXEuhnMJUMqaSjA8Z38ST6xUCdibWZRMCg0NZYxvuS8qvlrBWIMh1cp8un6BHD5JotPUwsRHVqVXjvpANaxj61lipYRC1NoEgzMtkV6RCtvwBVj9LfpQo6p+CuZ5RilnlD756kxOf0ySbI8zIaMRLyKZXEUmcBwOsfYFbHnJDpFDg7BEqFVGruyvsemsXVJQnN3JjnMOiEbL5zqeakk4E2t9wsyekN0LatrvS00uATv7TAyd/5pt9BGGMeXvE1qcZuXMBBHp3MSifZ+Iw215l0ej8QhNFHN1LeaKbwBwk/k6gqTtXGQzlWLaSgVvnSaDF4uF47oJSMCeBkPpZPnmEIEPUJAg66Yik0hPEfVGL+hQbd3UTSEd23gRC5Bo0LhLmWHJXvLlc+aFjfGQrSzcyNE5xlKvHOX2QMPjHCHSqKs2y2UMgHzEwwJYXefBT1u3qPpiCq9TPMf0TpWNUT8dzQv9IYO4IpAkEyDW57RHW7SFTjNOS0zkjioMMjjIwRn45mTpXg8523VuE80qBNAEsWR87hxXb2bwvronSd1z5Og53mNRAGHQItgmksaAaCMTVPPU9zSkygyzeFANOvcKlM1RK1E4RFmlcJtPqPrAWHIE0gWyGy4c5/TJ3PEN+Bc0ylz7k3Fs0J2OkjWcH/kUEevM/m4aAVpUzr3HpAwpj1Cep/EKr1nHUe0T3Lm5eZ0HvwOJKVu2JHbUtRVFMqutimJaIMB/PTdteUA20ZdEaVr/kP0uaRD8Cwexn2KRe/e9O21Kv0mgSEfQhELUizUZ79dUSRw6yeIziUGoJC5FkH5gp8+VBpkug0aIVdSqtTWCqXDNx/KKt21clLcf2c+Ij8sP9b8XzaZsuMXl29v34Zcp1E+Jr6yyBWhQ5dOCohx9arTC+DJkGM6fiW206f/2e1+tL5OQVDvyqGnFIfPWdPTDh5IWSFd/9bsvygnA4R63BVI1KPUFab6Mxh97oYLrO5Rk+u8DzRzW+umQ/9qKeJKpLlmDXUN7jtw9bVczIda2htwyiPnr3ezDTTH7N6tf/NUu3/W8/pzdd/gK+VwfM/p7hewAAACV0RVh0Y3JlYXRlLWRhdGUAMjAwOC0xMC0xOFQxODo0NDozNiswODowMPx1HEEAAAAldEVYdG1vZGlmeS1kYXRlADIwMDgtMTAtMThUMTg6NDQ6MzYrMDg6MDCjxGp1AAAAAElFTkSuQmCC",
		    title : 'ppt 저장',
		    separator : true,
		    handler :  pptsave
		};
		var downloadDOC = {
		    index : 12, //툴바 버튼 위치
		    id : 'doc_2' ,
		    img:"data:image/png;base64,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",
		    title : 'doc 저장',
		    separator : true,
		    handler :  docsave
		};
		var downloadHWP = {
		    index : 13, //툴바 버튼 위치
		    id : 'hwp_2' ,
		    //svg:d.HWP,
		    img:"data:image/png;base64,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",
		    title : 'hwp 저장',
		    separator : true,
		    handler :  hwpsave
		};
		var printPdf = {
		    index : 14, //툴바 버튼 위치
		    id : 'print_pdf2' ,
		    svg:d.PRINT_PDF,
		    title:e.get("print"),
		    //img:"data:image/png;base64,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",
		    separator : true,
		    handler :  pdfPrint
		};

		var saveYn  = $("#SaveYn" , parent.document).val();
		var printYn = $("#PrintYn", parent.document).val();
		var excelYn = $("#ExcelYn", parent.document).val();
		var wordYn  = $("#WordYn" , parent.document).val();
		var pptYn   = $("#PptYn"  , parent.document).val();
		var hwpYn   = $("#HwpYn"  , parent.document).val();
		var pdfYn   = $("#PdfYn"  , parent.document).val();

		if(saveYn   == "Y") {
		    if(printYn  == "Y") { viewer.addToolbarItem(printPdf);     }
		    if(excelYn  == "Y") { viewer.addToolbarItem(downloadXLS);  }
		    if(wordYn   == "Y") { viewer.addToolbarItem(downloadDOC);  }
		    if(pptYn    == "Y") { viewer.addToolbarItem(downloadPPT);  }
		    if(hwpYn    == "Y") { viewer.addToolbarItem(downloadHWP);  }
		    if(pdfYn    == "Y") { viewer.addToolbarItem(downloadPDF);  }
		}
		viewer.hideToolbarItem(["save"]);
		viewer.hideToolbarItem(["print_pdf"]); //기존 Save 버튼 숨김.
		--%>

        <%--viewer.openFile(mrd, param);--%>
		<%-- 20231219 MRD 파라미터 암호화 페이지 INCLUDE --%>
		<%@ include file="./rdPopupIframeEnc.jsp"%>
};

<%--
 2021 귀속 년도 당시 미완성 소스이므로 주석처리함. 필요할 경우 정비 필요. 20240822
	/*************************************************************
	 * 2021.04.19 로그관리
	 * reasonYnChk 함수 추가
	 * 사유저장 여부 조회 후 팝업 호출
	 *************************************************************/
	function reasonYnChk(value){

	    //최초 출력 버튼 클릭시 출력 사유 여부 조회
	    //IE에서는 인코딩 문제로  logStdCd => encodeURI(logStdCd)으로 변경
		var bFlag = false;
	    var logStdCd = "CPN_YEA_RD_LOG_YN";
	        rdFileType = value;
	    if(value == "print_pdf"){
			var reasonMap = ajaxCall("../auth/beforeDownloadPopupRst.jsp?cmd=getDownReasonYn&logStdCd="+encodeURI(logStdCd), "queryId=getDownReasonYn",false).codeList;

	        if(reasonMap[0].log_yn_cd == "Y"){ // 다운로드 사유
	            bFlag = true;
	        }
	        if(bFlag){
	            // 사유 Popup open
	            var args = new Array();
	            args["type"] = 'RD';

	            if(value != "print_pdf"){
	                args["type2"] = 'F'; // 파일다운로드 했는지
	            }else {
	                args["type2"] = 'P'; // 프린트 했는지
	            }

	            openPopup("../auth/beforeDownloadPopup.jsp", args, "450","280");
	        }else {
	        	viewer.print();
	        }
		}else{
			viewer.downloadFile(value);
		}
	}
	/*************************************************************
	 * 2021.04.19 로그관리
	 * callDownRD 함수 추가
	 * 사유 저장 후 콜백
	 *************************************************************/
	function callDownRD(returnValue){

	    if(returnValue){
	        if(rdFileType == "print_pdf"){
	            viewer.print();
	        }else {
	            viewer.downloadFile(rdFileType);
	        }
	    }
	}
--%>
</script>
</body>
</HTML>
