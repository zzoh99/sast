<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수영수증 업로드</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%
String befSysYear = "";
if(curSysYear != null && !"".equals(curSysYear)) {
	int y = Integer.valueOf(curSysYear);
	befSysYear = String.valueOf(y-1);
}

%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var arrDown = "";
	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchWorkYy").mask('0000');

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"선택",		Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			{Header:"성명",		Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조직명",		Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"org_nm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사업장",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"biz_place_cd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"귀속년도",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"정산구분",	Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일구분",	Type:"Combo",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"file_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일순번",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_seq",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일경로",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_path",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_name",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"업로드일자",	Type:"Text",		Hidden:0,	Width:142,	Align:"Center",	ColMerge:0,	SaveName:"upload_date",	KeyField:0,	Format:"YmdHms",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"삭제",		Type:"Html",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"del_btn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"다운",		Type:"Html",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"down_btn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );
		var fileTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "YEA001"), "전체" );

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
		sheet1.SetColProperty("file_type",    {ComboText:"|"+fileTypeList[0], ComboCode:"|"+fileTypeList[1]} );
		sheet1.SetColProperty("biz_place_cd",    {ComboText:"|"+bizPlaceCdList[0], ComboCode:"|"+bizPlaceCdList[1]} );

// 		$("#searchFileType").html(fileTypeList[2]).val("");
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]).val("");

		$(window).smartresize(sheetResize); sheetInit();

		//doAction1("Search");

		/*
		$("#searchWorkYy,#searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchFileType, searchBizPlaceCd").bind("change",function(event){
			doAction1("Search");
		});
		*/

	});

	$(function(){
		$("#searchWorkYy").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						if (!chkInVal(sAction)) {break;}
						sheet1.DoSearch( "<%=jspPath%>/withHoldRcptPdfUpload/withHoldRcptPdfUploadRst.jsp?cmd=selectWithHoldRcptPdfUploadList", $("#sendForm").serialize(), 1 );
						break;
		case "PDF":
						downloadFile('A', '0');
						break;
		case "DEL":
						deleteFile('A', '0');
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
						sheet1.Down2Excel(param);

						break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			for(var i = 1; i < sheet1.RowCount()+1; i++) {
				var fileType = sheet1.GetCellValue(i,"file_type");
				var fileName = sheet1.GetCellValue(i,"file_name");
                /*************************************************************
                 * 2021.04.16 로그관리
                 * 버튼 생성 수정
                 * sort후 달라지는 seq로 인해 기존 사용하던 개별 다운(downloadFile/deleteFile)
                 * 에서 OnClick 이벤트로 변경
                 *************************************************************/
                //sheet1.SetCellValue(i,"del_btn","<a href=\"javascript:deleteFile('B', '"+i+"')\" class='basic'>삭제</a>");
                //sheet1.SetCellValue(i,"down_btn","<a href=\"javascript:downloadFile('B', '"+i+"')\" class='basic'>다운</a>");
                sheet1.SetCellValue(i,"del_btn","<a class='basic btn-white'>삭제</a>");
                sheet1.SetCellValue(i,"down_btn","<a class='basic btn-download'>다운</a>");
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	/*************************************************************
     * 2021.04.16 로그관리
     * sheet1_OnClick 함수 추가
     * sort후 달라지는 seq로 인해 기존 사용하던 개별 다운(downloadFile/deleteFile)
     * 에서 OnClick 이벤트로 변경
     *************************************************************/
    function sheet1_OnClick(Row, Col, Value) {
        arrDown = new Array();
        var obj = new Object();
        var params = "";
        var pValue = "";
        try{
            if(sheet1.ColSaveName(Col) == "down_btn" ) {

            	obj.fileType = sheet1.GetCellValue(Row,"file_type");
                obj.fileName = sheet1.GetCellValue(Row,"file_name");
                arrDown.push(obj);

                if(arrDown.length > 0){
                    if(!isPopup()) {return;}

                    var bFlag = false;
                    var logStdCd = "CPN_YEA_FILE_LOG_YN";// 임시param
                    var reasonMap = ajaxCall("../auth/beforeDownloadPopupRst.jsp?cmd=getDownReasonYn&logStdCd="+encodeURI(logStdCd), "queryId=getDownReasonYn",false).codeList;
                    if(reasonMap[0].log_yn_cd == "Y"){ // 다운로드 사유
                        bFlag = true;
                    }

                    if(bFlag){
                        // 사유 Popup open
                        var args = new Array();
                        args["type"] = 'Sheet';
                        args["type2"] = 'F';//E: 엑셀다운로드 , F: 파일다운로드, P: 출력물인쇄
                        args["menuNm"] = $(document).find("title").text();
                        openPopup("../auth/beforeDownloadPopup.jsp", args, "450","280");
                    }else{
                        $("#pWorkYy").val($("#searchWorkYy").val());
                        $("#pValue").val(JSON.stringify(arrDown));
                        $("#pfrm").attr("action", "<%=jspPath%>/withHoldRcptPdfUpload/withHoldRcptFileDownload.jsp");
                        $("#pfrm").submit();
                    }
                }
            }
            if(sheet1.ColSaveName(Col) == "del_btn" ) {
                obj.sabun = sheet1.GetCellValue(Row,"sabun");
                obj.workYy = sheet1.GetCellValue(Row,"work_yy");
                obj.adjustType = sheet1.GetCellValue(Row,"adjust_type");
                obj.fileType = sheet1.GetCellValue(Row,"file_type");
                obj.fileSeq = sheet1.GetCellValue(Row,"file_seq");
                obj.fileName = sheet1.GetCellValue(Row,"file_name");
                arrDown.push(obj);

                params += "&searchWorkYy=" + $("#searchWorkYy").val();
                params += "&pValue="      + pValue;

                var rtnResult = ajaxCall("<%=jspPath%>/withHoldRcptPdfUpload/withHoldRcptPdfUploadRst.jsp?cmd=deleteWithHoldRcptPdfUploadList",params,false);

                if(rtnResult.Result.Code == "1"){
                    doAction1("Search");
                }
            }
        }catch(ex){
            alert("OnClick Event Error : " + ex);
        }
    }
	function chkInVal(sAction) {
		if ($("#searchWorkYy").val() == "") {
			alert("귀속년도를 입력하십시오.");
			$("#searchWorkYy").focus();
			return false;
		}

		return true;
	}

	//pdf 업로드 팝업
	function openFileUploadPopup(){

		var args = [];
		args["searchWorkYy"] = $("#searchWorkYy").val();
		args["searchAdjustType"] = $("#searchAdjustType").val();
		args["searchSabun"] = $("#searchSabun").val();

		if(!isPopup()) {return;}
		pGubun = "fileUploadPop";
		var rv = openPopup("<%=jspPath%>/withHoldRcptPdfUpload/withHoldRcptFileUploadPop.jsp",args,'750','500');
	}

	//파일 다운로드
	function downloadFile(type, row) {
		arrDown = new Array();
		var obj = new Object();

		if(type == 'A') {
			var sCheckRow = sheet1.FindCheckedRow("ibsCheck");

			if ( sCheckRow == "" ){
				alert("선택된 내역이 없습니다.");
				return;
			}

			$(sCheckRow.split("|")).each(function(index,value){
				obj = new Object();
				obj.fileType = sheet1.GetCellValue(value,"file_type");
				obj.fileName = sheet1.GetCellValue(value,"file_name");
				arrDown.push(obj);
			});

		}
		/*else {
			obj.fileType = sheet1.GetCellValue(row,"file_type");
			obj.fileName = sheet1.GetCellValue(row,"file_name");
			arrDown.push(obj);
		}*/
        /*************************************************************
        * 2021.04.14 로그관리
        * 사유 저장 팝업 오픈
        *************************************************************/
        if(arrDown.length > 0){
            if(!isPopup()) {return;}

            //최초 다운로드 버튼 클릭시 다운로드 사유 여부 조회
            //IE에서는 인코딩 문제로  logStdCd => encodeURI(logStdCd)으로 변경
            var bFlag = false;
            var logStdCd = "CPN_YEA_FILE_LOG_YN";
            var reasonMap = ajaxCall("../auth/beforeDownloadPopupRst.jsp?cmd=getDownReasonYn&logStdCd="+encodeURI(logStdCd), "queryId=getDownReasonYn",false).codeList;
            if(reasonMap[0].log_yn_cd == "Y"){ // 다운로드 사유
                bFlag = true;
            }

            if(bFlag){
	            // 사유 Popup open
	            var args = new Array();
	            args["type"] = 'Sheet';
	            args["type2"] = 'F';//E: 엑셀다운로드 , F: 파일다운로드, P: 출력물인쇄
	            args["menuNm"] = $(document).find("title").text();
	            openPopup("../auth/beforeDownloadPopup.jsp", args, "450","280");
            }else{
                $("#pWorkYy").val($("#searchWorkYy").val());
                $("#pValue").val(JSON.stringify(arrDown));
                $("#pfrm").attr("action", "<%=jspPath%>/withHoldRcptPdfUpload/withHoldRcptFileDownload.jsp");
                $("#pfrm").submit();
            }
        }
	}
    /*************************************************************
    * 2021.04.14 로그관리
    * callDownFile 함수 추가
    * 사유 저장 후 콜백
    *************************************************************/
    function callDownFile(returnValue){
        $("#pWorkYy").val($("#searchWorkYy").val());
        $("#pValue").val(JSON.stringify(arrDown));
        $("#pfrm").attr("action", "<%=jspPath%>/withHoldRcptPdfUpload/withHoldRcptFileDownload.jsp");
        $("#pfrm").submit();
    }

	//파일 삭제
	function deleteFile(type, row) {
		if(confirm("선탁한 파일을 삭제하시겠습니까?")) {
			var arr = new Array();
			var obj = new Object();
			var params = "";
			var pValue = "";

			if(type == 'A') {
				var sCheckRow = sheet1.FindCheckedRow("ibsCheck");

				if ( sCheckRow == "" ){
					alert("선택된 내역이 없습니다.");
					return;
				}

				$(sCheckRow.split("|")).each(function(index,value){
					obj = new Object();
					obj.sabun = sheet1.GetCellValue(value,"sabun");
					obj.workYy = sheet1.GetCellValue(value,"work_yy");
					obj.adjustType = sheet1.GetCellValue(value,"adjust_type");
					obj.fileType = sheet1.GetCellValue(value,"file_type");
					obj.fileSeq = sheet1.GetCellValue(value,"file_seq");
					obj.fileName = sheet1.GetCellValue(value,"file_name");
					arr.push(obj);
				});

			}
			/*else {
				obj.sabun = sheet1.GetCellValue(row,"sabun");
				obj.workYy = sheet1.GetCellValue(row,"work_yy");
				obj.adjustType = sheet1.GetCellValue(row,"adjust_type");
				obj.fileType = sheet1.GetCellValue(row,"file_type");
				obj.fileSeq = sheet1.GetCellValue(row,"file_seq");
				obj.fileName = sheet1.GetCellValue(row,"file_name");
				arr.push(obj);
			}*/

			pValue = JSON.stringify(arr);

			params += "&searchWorkYy=" + $("#searchWorkYy").val();
			params += "&pValue="      + pValue;

			var rtnResult = ajaxCall("<%=jspPath%>/withHoldRcptPdfUpload/withHoldRcptPdfUploadRst.jsp?cmd=deleteWithHoldRcptPdfUploadList",params,false);

			if(rtnResult.Result.Code == "1"){
				doAction1("Search");
			}
		}
	}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="sendForm" id="sendForm" method="post">
	<input type="hidden" id="menuNm" name="menuNm" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>귀속년도</span>
							<%
							if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
							%>
								<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center required" maxlength="4" style="width: 35px;" value="<%=befSysYear%>" />
							<%}else{%>
								<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center required readonly" maxlength="4" style="width: 35px;" value="<%=befSysYear%>" readonly="readonly"/>
							<%}%>
						</td>
						<td>
							<span>사업장</span>
							<select id="searchBizPlaceCd" name ="searchBizPlaceCd" onChange="javascript:doAction1('Search')" class="box"></select>
						</td>
						<td>
                        	<span>정산구분</span>
                        	<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
                    	</td>
						<td>
							<span>사번/성명</span>
							<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
						</td>
						<td>
	                        <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
	                    </td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">원천징수영수증업로드</li>
				<li class="btn">
					<span><font class="txt red" style="text-overflow: ellipsis; white-space: nowrap;">&nbsp;해당년도 원천징수영수증 데이터가 없을 경우 PDF파일로 대체하기 위한 화면입니다.</font></span>
				    <a href="javascript:openFileUploadPopup();" 	class="basic btn-white out-line ico-popup authA">PDF등록</a>
					<a href="javascript:doAction1('PDF');" 			class="basic btn-download authA">PDF다운로드</a>
					<a href="javascript:doAction1('DEL');" 			class="basic btn-white authA">파일삭제</a>
					<a href="javascript:doAction1('Down2Excel');" 	class="basic btn-download authR">다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
</div>
<iframe name="hiddenIframe" id="hiddenIframe" style="display:none;"></iframe>
<form id="pfrm" name="pfrm" target="hiddenIframe" action="" method="post" >
<input type="hidden" id="pValue" name="pValue" />
<input type="hidden" id="pWorkYy" name="pWorkYy" />
</form>
</body>
</html>
