<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
//String mrdparams= "/rf [http://61.111.129.108:8081/DataServer/rdagent.jsp] /rsn [pth] ";	// DB 접속정보

String URL = "http://61.111.129.108:8081/DataServer/multiViewer";
String jars = URL+"/javard.jar,./lib/barbecue-1.5-beta1.jar,./lib/batik-all-flex.jar,./lib/ChartDirector_s.jar,./lib/enc.jar,./lib/iText-4.2.0-m2,./lib/jai_codec.jar,./lib/poi-3.2-FINAL-20081019.jar,./lib/plugin.jar,./lib/poi-scratchpad-3.2-FINAL-20081019.jar,./lib/swfutils.jar";
%>

<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>


</head>

<body onLoad="rd_onload();">
<!-- <script src="http://61.111.129.108:8081/common/plugin/DataServer/rdViewer_all.js"></script> -->
<script src="/common/js/rdViewer_all.js"></script>
<script type="text/javascript">
function rd_onload(){
	var mrd   = "";
    var param  = "/rf [http://61.111.129.108:8081/DataServer/rdagent.jsp] /rsn [pth] "; //접소ip 및 db접속 서비스명
	    param  = param +"/rp ";

    if("${param.searchTableKind}"=="list") {
	    reportFileNm = "${baseURL}/html/report/sys/TableList.mrd";
	    param          = param + "[${param.searchDbUser}]";
	}else if("${param.searchTableKind}"=="viewCol") {
	    reportFileNm = "${baseURL}/html/report/sys/TableViewCol.mrd";
	    param          = param + "[${param.searchDbUser}] [${param.searchTableName}]";
	}else if("${param.searchTableKind}"=="viewRow") {
	    reportFileNm = "${baseURL}/html/report/sys/TableViewRow.mrd";
	    param          = param + "[${param.searchDbUser}] [${param.searchTableName}]";
	};

	mrd   = reportFileNm;

	//alert(param);


		//var _os  = navigator.userAgent;
		//if(_os.indexOf("Linux") == -1 && _os.indexOf("Macintosh") == -1 ) {
			rdViewer.AutoAdjust = false;
			rdViewer.ZoomRatio = 100;
			//rdViewer.IsShowDlg = 0;
			rdViewer.SetBackgroundColor(255,255,255);
			rdViewer.ApplyLicense("http://61.111.129.108:8081/DataServer/rdagent.jsp");
			rdViewer.FileOpen(mrd, param);
			//alert(123);
		//}
	}
</script>
<SCRIPT LANGUAGE=JavaScript FOR=rdViewer EVENT="FileOpenFinished()">
<!--
     //alert("completed !!!");
	 //rdViewer.SaveAsHCellFile("c:/test.cell");

-->
</SCRIPT>
<SCRIPT LANGUAGE=JavaScript FOR=rdViewer EVENT="FileSaveAsFinished()">
<!--
     //alert("completed save as file!!!");

-->
</SCRIPT>
</body>

</HTML>




