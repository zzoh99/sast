<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<% 
	//request.setCharacterEncoding("UTF-8");  //한글깨지면 주석제거
	
    String inputYn             = request.getParameter("inputYn");
    String roadFullAddr        = request.getParameter("roadFullAddr");
    String roadAddrPart1       = request.getParameter("roadAddrPart1");
    String roadAddrPart2       = request.getParameter("roadAddrPart2");
    String engAddr             = request.getParameter("engAddr");
    String jibunAddr           = request.getParameter("jibunAddr");
    String zipNo               = request.getParameter("zipNo");
    String addrDetail          = request.getParameter("addrDetail");
    String admCd               = request.getParameter("admCd");
    String rnMgtSn             = request.getParameter("rnMgtSn");
    String bdMgtSn             = request.getParameter("bdMgtSn");
    String detBdNmList         = request.getParameter("detBdNmList");
    /** 2017년 2월 추가제공 **/
    String bdNm                = request.getParameter("bdNm");
    String bdKdcd              = request.getParameter("bdKdcd");
    String siNm                = request.getParameter("siNm");
    String sggNm               = request.getParameter("sggNm");
    String emdNm               = request.getParameter("emdNm");
    String liNm                = request.getParameter("liNm");
    String rn                  = request.getParameter("rn");
    String udrtYn              = request.getParameter("udrtYn");
    String buldMnnm            = request.getParameter("buldMnnm");
    String buldSlno            = request.getParameter("buldSlno");
    String mtYn                = request.getParameter("mtYn");
    String lnbrMnnm            = request.getParameter("lnbrMnnm");
    String lnbrSlno            = request.getParameter("lnbrSlno");
    /** 2017년 3월 추가제공 **/
    String emdNo               = request.getParameter("emdNo");

%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- <link rel="stylesheet" type="text/css" href="/HTML/images/css/addrlinkSample.css"> -->
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>

<script type="text/javascript">
// document.domain = "localhost:9090";
$(document).ready(function(){
	init();
});
function init(){	
	var url = location.href;
	
	var resultType = "4"; // 도로명주소 검색결과 화면 출력내용, 1 : 도로명, 2 : 도로명+지번, 3 : 도로명+상세건물명, 4 : 도로명+지번+상세건물명
	var inputYn= "<%=removeXSS(inputYn, '1')%>";
	

	if(inputYn != "Y"){
		
		var license = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "queryId=getZipcodeLicense",false).codeList;
		
		var confmKey = license[0].code;
		
		document.form.confmKey.value = confmKey;
		document.form.returnUrl.value = url;
		document.form.resultType.value = resultType;
		document.form.action="http://www.juso.go.kr/addrlink/addrLinkUrl.do"; //인터넷망
		//document.form.action="http://10.182.60.20:80/addrlink/addrLinkUrl.do"; //행정망
		document.form.submit();
	}else{
		var arrayList = new Array();

        arrayList["zip"] = "<%=removeXSS(zipNo, '1')%>";

        arrayList["doroAddr"] = "<%=removeXSS(roadAddrPart1, '1')%>"+" "+"<%=removeXSS(roadAddrPart2, '1')%>";
        arrayList["detailAddr"] = "<%=removeXSS(addrDetail, '1')%>";
        arrayList["doroFullAddr"] = "<%=removeXSS(roadAddrPart1, '1')%>"+" "+"<%=removeXSS(roadAddrPart2, '1')%>"+" "+"<%=removeXSS(addrDetail, '1')%>";
        arrayList["resDoroFullAddr"] = "<%=removeXSS(roadAddrPart1, '1')%>"+" "+"<%=removeXSS(roadAddrPart2, '1')%>"+" "+"<%=removeXSS(addrDetail, '1')%>";

        arrayList["doroFullAddrEng"] ="<%=removeXSS(engAddr, '1')%>";
        arrayList["resDoroFullAddrEng"] = "<%=removeXSS(engAddr, '1')%>";

        var returnValue = "";
        var i = 0;
        for(key in arrayList) {
            if(key != "contains"){
                returnValue = returnValue + ((i==0) ? "\"" : ",\"") +[key]+"\":\""+arrayList[key]+"\"";
            }
            i++;
        }
        
        opener.getReturnValue(returnValue);
        window.close();
	}
}
</script>
<%-- <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%> --%>
</head>
<body>
	<form id="form" name="form" method="post" target="_top">
		<input type="hidden" id="confmKey" name="confmKey" value=""/>
		<input type="hidden" id="returnUrl" name="returnUrl" value=""/>
		<input type="hidden" id="resultType" name="resultType" value=""/>
		<!-- 해당시스템의 인코딩타입이 EUC-KR일경우에만 추가 START-->
		 
<!-- 		<input type="hidden" id="encodingType" name="encodingType" value="EUC-KR"/> -->
	</form>
</body>
</html>