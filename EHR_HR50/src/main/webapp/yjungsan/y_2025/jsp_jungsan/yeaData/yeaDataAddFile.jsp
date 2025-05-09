<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<!DOCTYPE html> <html><head> <title>증빙자료관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>
<%
	String orgAuthPg  = request.getParameter("orgAuthPg");
	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
%>

<script type="text/javascript">
	var orgAuthPg = "<%=orgAuthPg%>";
	var vsSsnEnterCd = "<%=ssnEnterCd%>";
	var arrDown = "";//사유 저장 콜백 함수에 사용하기 위해 전역변수로 변경
	var fileUploadType = '0';
	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		/*필수 기본 세팅*/
		$("#searchWorkYy").val( 	$("#searchWorkYy", parent.document).val() 		) ;
		$("#searchAdjustType").val( $("#searchAdjustType", parent.document).val() 	) ;
		$("#searchSabun").val( 		$("#searchSabun", parent.document).val() 		) ;
		$("#searchSbNm").val( 		$("#searchKeyword", parent.document).val() 		) ;
	});
	

	$(function() {
		//파일업로드 type 조회
		fileUploadType = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_FILE_UPLOAD_TYPE&searchWorkYy="+$("#searchWorkYy").val(), "queryId=getYeaSystemStdData",false).codeList[0];
		if(fileUploadType != null){
			//fileUploadType = fileUploadTypeList.code_nm
			$("#fileUploadType").val(fileUploadType.code_nm);
		} else {
			$("#fileUploadType").val('0');
		}

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"선택",		Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
            {Header:"상태",      Type:"<%=sSttTy%>", Hidden:0,  Width:40, Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"성명",		Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"대상자성명",  Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"nm_txt",      KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"조직명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"org_nm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"귀속년도",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"정산구분",	Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"상태",      Type:"Combo",       Hidden:0,   Width:60,  Align:"Center", ColMerge:0, SaveName:"status_cd",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"피드백",     Type:"Text",       Hidden:0,   Width:80,  Align:"Center", ColMerge:0, SaveName:"feedback",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"파일구분",	Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일순번",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_seq",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일경로",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_path",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일명",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_name",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attr1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"fileId",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attr2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"업로드일자",	Type:"Text",		Hidden:0,	Width:142,	Align:"Center",	ColMerge:0,	SaveName:"upload_date",	KeyField:0,	Format:"YmdHms",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"삭제",		Type:"Html",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"del_btn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"다운",		Type:"Html",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"down_btn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
		var fileTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y&searchYear=<%=yeaYear%>", "YEA001"), "전체" );
<%-- 		//var bizPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체"); --%>
		sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
		sheet1.SetColProperty("file_type",    {ComboText:"|"+fileTypeList[0], ComboCode:"|"+fileTypeList[1]} );
        sheet1.SetColProperty("status_cd",    {ComboText:"|직원등록|담당자반려|담당자확인완료", ComboCode:"|1|5|9"} );
        $("#searchFileType").html(fileTypeList[2]).val("");

		$(window).smartresize(sheetResize); sheetInit();

		/*	close_0	본인마감전. close_1 대상자아님. close_2 본인마감. close_3 담당자마감. close_4 최종마감	*/
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");

		if(orgAuthPg == "R" && empStatus != "close_0") {
            sheet1.GetColEditable("feedback",false);
            sheet1.GetColEditable("status_cd",false);
		}else{
			sheet1.GetColEditable("feedback",true);
			sheet1.GetColEditable("status_cd",true);
		}

		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
		
		if(orgAuthPg == "R" && (empStatus == "close_2" ||empStatus == "close_3" || empStatus == "close_4")) {
			$("#btnDisplayYn01").hide() ;
			$("#btnDisplayYn02").hide() ;
		}
		
        getConFileFunc();// 파일기능 제어
        setBtn();        // 파일기능 제어 세팅
		doAction1("Search");
	});

	function doAction1(sAction, formCd) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataAddFileRst.jsp?cmd=selectYeaDataAddFileList", $("#sheetForm").serialize() );
			break;
		case "Save":
			var params = $("#sheetForm").serialize();
			sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataAddFileRst.jsp?cmd=saveYeaDataFileList", params);
			break;
		case "PDF":
			downloadFile('A', '0');
			break;
		case "DEL":
			deleteFile('A', '0');
			break;
		case "Reload":
			location.href = location.href;
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		}
	}

	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			for(var i = 1; i < sheet1.RowCount()+1; i++) {
				var fileType = sheet1.GetCellValue(i,"file_type");
				var fileName = sheet1.GetCellValue(i,"file_name");
				var stsCd    = sheet1.GetCellValue(i,"status_cd");

			    /*************************************************************
			     * 2021.04.16 로그관리
			     * 버튼 생성 수정
			     * sort후 달라지는 seq로 인해 기존 사용하던 개별 다운(downloadFile/deleteFile)
			     * 에서 OnClick 이벤트로 변경
			     *************************************************************/
				//sheet1.SetCellValue(i,"del_btn","<a href=\"javascript:deleteFile('B', '"+i+"')\" class='basic'>삭제</a>");
				//sheet1.SetCellValue(i,"down_btn","<a href=\"javascript:downloadFile('B', '"+i+"')\" class='basic'>다운</a>");
				sheet1.SetCellValue(i,"del_btn","<a class='basic btn-white out-line'>삭제</a>");
				sheet1.SetCellValue(i,"down_btn","<a class='basic btn-download'>다운</a>");
				if(orgAuthPg != "R"){
					if(stsCd == "5"){
						//반려일 경우에만 멘트 활성화
						sheet1.SetCellEditable(i,"feedback",1);
					}else{
						sheet1.SetCellEditable(i,"feedback",0);
					}
				}
				sheet1.SetCellValue(i,"sStatus","");
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            if(Code == 1) {
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
	function comma(str) {
		if ( str == "" ) return 0;

		str = String(str);
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}

	//파일 업로드 팝업
	function openFileUploadPopup(){

		var args = [];
		args["searchWorkYy"] 		= $("#searchWorkYy").val();
		args["searchAdjustType"] 	= $("#searchAdjustType").val();
		args["searchSabun"] 		= $("#searchSabun").val();
		args["searchSbNm"] 			= $("#searchSbNm").val();
		args["searchFileType"] 		= $("#searchFileType").val();

		if(!isPopup()) {return;}
		pGubun = "fileUploadPop";
		
		// ----------------------------------------------------
		// 20240109 브라우저 버전에 따라 pdf업로드 제어 Start
	    var _ua = navigator.userAgent;
		
		var trident = _ua.match(/Trident\/(\d.\d)/i);
		var chk = "N";
		
		if( trident != null )
		{
			if( trident[1] == "7.0" || trident[1] == "6.0" || trident[1] == "5.0" || trident[1] == "4.0" ) //IE 11,10,9,8 
			{
				chk = "Y";				
			}
		}
		
		if( navigator.appName == 'Microsoft Internet Explorer' ) //IE 7... 
		{ 
			chk = "Y";
		}
		else
		{
			chk = "N";
		}

		if(chk == "Y") {
			var rv = openPopup("<%=jspPath%>/yeaData/yeaDataAddFileUploadPop_IE.jsp",args,'750','500');
		} else {
			var rv = openPopup("<%=jspPath%>/yeaData/yeaDataAddFileUploadPop.jsp",args,'750','500');
		}
		// 20240109 브라우저 버전에 따라 pdf업로드 제어 End
		// ----------------------------------------------------
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
                obj.attr1 = sheet1.GetCellValue(Row,"attr1");
                obj.attr2 = sheet1.GetCellValue(Row,"attr2");

                obj.dbFileName = sheet1.GetCellValue(Row,"file_name");
                obj.sabun = sheet1.GetCellValue(Row,"sabun");
                arrDown.push(obj);

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
                         args["type2"] = 'F'; //E: 엑셀다운로드 , F: 파일다운로드, P: 출력물인쇄
                         args["menuNm"] = $(document).find("title").text();
                         openPopup("../auth/beforeDownloadPopup.jsp", args, "450","280");
                     }else{
                         $("#pWorkYy").val($("#searchWorkYy").val());
                         $("#pValue").val(JSON.stringify(arrDown));
                         if($("#fileUploadType").val() == '1'){//S3
                        	 $("#pfrm").attr("action", "<%=jspPath%>/yeaData/yeaDataAddFileDownloadS3.jsp");
                             $("#pfrm").submit();	
                         }
                         else if($("#fileUploadType").val() == '2'){//HMM S3 TYPE2
                        	 $("#pfrm").attr("action", "<%=jspPath%>/yeaData/yeaDataAddFileDownloadS3_TYPE2.jsp");
                             $("#pfrm").submit();
                         }
                         else{
                        	 $("#pfrm").attr("action", "<%=jspPath%>/yeaData/yeaDataAddFileDownload.jsp");
                             $("#pfrm").submit();	
                         }
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

                pValue = JSON.stringify(arrDown);
                                
                params += "&searchWorkYy=" + $("#searchWorkYy").val();
                params += "&pValue="      + pValue;
                params += "&fileUploadType="      + $("#fileUploadType").val();
                
                
                
                if($("#fileUploadType").val() == '2'){//HMM S3 TYPE2 (기존 소스에 HMM TYPE2만을 예외로 추가했습니다. TYPE1 S3에 대한 부분은 기존에도 없어서 추가하지 않았습니다.)
                	var rtnResult = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddFileRstS3_TYPE2.jsp?cmd=deleteYeaDataAddFileList",params,false);	
                }else{
                	var rtnResult = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddFileRst.jsp?cmd=deleteYeaDataAddFileList",params,false);	
                }
                

                if(rtnResult.Result.Code == "1"){
                    doAction1("Search");
                }
            }
        }catch(ex){
            alert("OnClick Event Error : " + ex);
        }
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
				obj.fileName = sheet1.GetCellValue(value,"attr1");
				obj.attr1 = sheet1.GetCellValue(value,"attr1");
				obj.attr2 = sheet1.GetCellValue(value,"attr2");
				obj.dbFileName = sheet1.GetCellValue(value,"file_name");
				obj.sabun = sheet1.GetCellValue(value,"sabun");
				arrDown.push(obj);
			});
		}
		/*else {
			obj.fileType = sheet1.GetCellValue(row,"file_type");
			obj.fileName = sheet1.GetCellValue(row,"attr1");
			obj.dbFileName = sheet1.GetCellValue(row,"file_name");
			obj.sabun = sheet1.GetCellValue(row,"sabun");
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
                if($("#fileUploadType").val() == '1'){//S3
               	 	$("#pfrm").attr("action", "<%=jspPath%>/yeaData/yeaDataAddFileDownloadS3.jsp");
                    $("#pfrm").submit();	
                }else if($("#fileUploadType").val() == '2'){//HMM S3 TYPE2
                	$("#pfrm").attr("action", "<%=jspPath%>/yeaData/yeaDataAddFileDownloadS3_TYPE2.jsp");
                    $("#pfrm").submit();
                } 
                else{
               	 	$("#pfrm").attr("action", "<%=jspPath%>/yeaData/yeaDataAddFileDownload.jsp");
                    $("#pfrm").submit();	
                }
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
        if($("#fileUploadType").val() == '1'){//S3
       	 	$("#pfrm").attr("action", "<%=jspPath%>/yeaData/yeaDataAddFileDownloadS3.jsp");
            $("#pfrm").submit();	
        }else if($("#fileUploadType").val() == '2'){//HMM S3 TYPE2
        	$("#pfrm").attr("action", "<%=jspPath%>/yeaData/yeaDataAddFileDownloadS3_TYPE2.jsp");
            $("#pfrm").submit();
        } 
        else{
       	 	$("#pfrm").attr("action", "<%=jspPath%>/yeaData/yeaDataAddFileDownload.jsp");
            $("#pfrm").submit();	
        }
    }

	//파일 삭제
	function deleteFile(type, row) {
		if(confirm("선택한 파일을 삭제하시겠습니까?")) {
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
			params += "&fileUploadType="      + $("#fileUploadType").val();
			
			if($("#fileUploadType").val() == '1'){//S3
				var rtnResult = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddFileRstS3.jsp?cmd=deleteYeaDataAddFileList",params,false);	
            }else if($("#fileUploadType").val() == '2'){//HMM S3 TYPE2
            	var rtnResult = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddFileRstS3_TYPE2.jsp?cmd=deleteYeaDataAddFileList",params,false);
            }
			else{
            	var rtnResult = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddFileRst.jsp?cmd=deleteYeaDataAddFileList",params,false);	
            }

			if(rtnResult.Result.Code == "1"){
				doAction1("Search");
			}
		}
	}

	function goSearch(fileType){
		if(fileType == null || fileType == undefined || fileType.length == 0) {
			$("#searchFileType").val("");
		} else {
			$("#searchFileType").val(fileType);
		}
		doAction1("Search");
	}

	function sheet1_OnChange(Row, Col, Value) {
	     try{
	    	 if(orgAuthPg != "R"){
	    		 //반려
                 if(sheet1.GetCellValue(Row,"status_cd") == "5"){
                	 sheet1.SetCellEditable(Row,"feedback",1);
                 }else{
                	 sheet1.SetCellEditable(Row,"feedback",0);
                 }
            }else{
                sheet1.SetCellEditable(Row,"feedback",0);
                sheet1.SetCellEditable(Row,"status_cd",0);
            }
            setBtn();
	    }catch(ex){alert("OnChange Event Error : " + ex);}
	}
	// 파일기능 제어(조회)
    function getConFileFunc(){

    	var fileUploadYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_ADD_FILE_UPLOAD&searchWorkYy="+$("#searchWorkYy").val(), "queryId=getYeaSystemStdData",false).codeList;
        var fileDownYn   = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_ADD_FILE_DOWN&searchWorkYy="+$("#searchWorkYy").val(), "queryId=getYeaSystemStdData",false).codeList;
        var fileDelYn    = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_ADD_FILE_DEL&searchWorkYy="+$("#searchWorkYy").val(), "queryId=getYeaSystemStdData",false).codeList;

        if(fileUploadYn != ""){
            if(fileUploadYn[0].code_nm != "N") {
                $("input:radio[name='cpn_yea_add_file_upload']:input[value='Y']").attr("checked",true);
            }else {
                $("input:radio[name='cpn_yea_add_file_upload']:input[value='N']").attr("checked",true);
            }
        }else {
            $("input:radio[name='cpn_yea_add_file_upload']:input[value='N']").attr("checked",true);
        }

        if(fileDownYn != ""){
            if(fileDownYn[0].code_nm != "N") {
                $("input:radio[name='cpn_yea_add_file_down']:input[value='Y']").attr("checked",true);
            }else {
            	$("input:radio[name='cpn_yea_add_file_down']:input[value='N']").attr("checked",true);
            }
        } else {
            $("input:radio[name='cpn_yea_add_file_down']:input[value='N']").attr("checked",true);
        }

        if(fileDelYn != ""){
            if(fileDelYn[0].code_nm != "N") {
                $("input:radio[name='cpn_yea_add_file_del']:input[value='Y']").attr("checked",true);
            }else {
            	$("input:radio[name='cpn_yea_add_file_del']:input[value='N']").attr("checked",true);
            }
        } else {
            $("input:radio[name='cpn_yea_add_file_del']:input[value='N']").attr("checked",true);
        }
    }
    // 파일기능 제어(저장)
	function setConFileFunc(gubun){
    	var params = "sStatus=U";

    	if(gubun == "1"){
			//파일업로드
            params += "&std_cd=CPN_YEA_ADD_FILE_UPLOAD";
            params += "&std_cd_value="+$("input:radio[name='cpn_yea_add_file_upload']:checked").val();
		}else if(gubun == "2"){
			//파일다운로드
			params += "&std_cd=CPN_YEA_ADD_FILE_DOWN";
            params += "&std_cd_value="+$("input:radio[name='cpn_yea_add_file_down']:checked").val();
		}else{
			//파일삭제
            params += "&std_cd=CPN_YEA_ADD_FILE_DEL";
            params += "&std_cd_value="+$("input:radio[name='cpn_yea_add_file_del']:checked").val();
		}
    	ajaxCall("<%=jspPath%>/yeaData/yeaDataAddFileRst.jsp?cmd=setConFileFunc",params,false);
	}
    //파일 기능 제어(세팅)
    function setBtn(){
        if(orgAuthPg == "R"){
            //파일업로드
            if($("input:radio[name='cpn_yea_add_file_upload']:checked").val() == "Y"){
                $("#setBtnUp").show();
            }else{
                $("#setBtnUp").hide();
            }
            //파일다운로드
            if($("input:radio[name='cpn_yea_add_file_down']:checked").val() == "Y"){
                $("#setBtnDown").show();
                sheet1.SetColHidden("down_btn",false);
            }else{
                $("#setBtnDown").hide();
                sheet1.SetColHidden("down_btn",true);
            }
            //파일삭제
            if($("input:radio[name='cpn_yea_add_file_del']:checked").val() == "Y"){
                $("#setBtnDel").show();
                sheet1.SetColHidden("del_btn",false);
            }else{
                $("#setBtnDel").hide();
                sheet1.SetColHidden("del_btn",true);
            }
            $("#orgAuthDiv").hide();
        }else{
            $("#orgAuthDiv").show();
        }
    }
</script>
</head>
<body style="overflow-x:hidden;overflow-y:auto;">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper" id="topNav">
	<form name="sheetForm" id="sheetForm" method="post">
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="searchSbNm" name="searchSbNm" value="" />
	<input type="hidden" id="menuNm" name="menuNm"/>
	<div class="sheet_search outer" style="margin-top:8px; ">
		<div>
        <table>
	        <tr>
	        	<td>
	        		<span>파일구분:</span>
					<select id="searchFileType" name ="searchFileType" onChange="javascript:doAction1('Search');" class="box"></select>
	            </td>
	            <td>
		            <div class="inner" id="div_button">
						<div class="sheet_title" style="white-space:nowrap;overflow:hidden;">
						<ul>
							<li class="right">
								<span>&nbsp;&nbsp;</span>
<!-- 								<span><a href="javascript:doAction1('Search');" class="basic authR">조회</a></span> -->
							</li>
						</ul>
						</div>
					</div>
	            </td>
	        </tr>
        </table>
        </div>
   	</div>
   	<div style="margin-top:8px;" class="outer" id="orgAuthDiv">
        <table border="0" cellpadding="0" cellspacing="0" class="default">
        <colgroup>
            <col width="16%">
            <col width="16%">
            <col width="16%">
            <col width="16%">
            <col width="16%">
            <col width="16%">
        </colgroup>
            <tr>
               <th><span>파일업로드 오픈</span></th>
               <td>
                   <input type="radio" class="radio" name="cpn_yea_add_file_upload" value = "Y" onchange="javascript:setConFileFunc('1');">&nbsp;YES&nbsp;&nbsp;&nbsp;
                   <input type="radio" class="radio" name="cpn_yea_add_file_upload" value = "N" onchange="javascript:setConFileFunc('1');">&nbsp;NO
               </td>
               <th><span>파일다운로드 오픈</span></th>
               <td>
                   <input type="radio" class="radio" name="cpn_yea_add_file_down" value = "Y" onchange="javascript:setConFileFunc('2');">&nbsp;YES&nbsp;&nbsp;&nbsp;
                   <input type="radio" class="radio" name="cpn_yea_add_file_down" value = "N" onchange="javascript:setConFileFunc('2');">&nbsp;NO
               </td>
               <th><span>파일삭제 오픈</span></th>
               <td colspan="2">
                   <input type="radio" class="radio" name="cpn_yea_add_file_del" value = "Y" onchange="javascript:setConFileFunc('3');">&nbsp;YES&nbsp;&nbsp;&nbsp;
                   <input type="radio" class="radio" name="cpn_yea_add_file_del" value = "N" onchange="javascript:setConFileFunc('3');">&nbsp;NO
               </td>
            </tr>
        </table>
    </div>
	<div class="outer">
		<div class="sheet_title" style="margin-top:0px; padding-top:0px;">
		<ul>
			<li class="txt">증빙자료관리</li>
			<li class="btn">
				<span><font class="txt red" style="text-overflow: ellipsis; white-space: nowrap;">&nbsp;원본제출이 원칙이며 원본은 5년간 보관해주시기 바랍니다.&nbsp;</font></span>
				<span id="btnDisplayYn01">
				<a href="javascript:openFileUploadPopup();" 	class="basic btn-white out-line authR" id="setBtnUp"  >파일 등록</a>
				</span>
				<a href="javascript:doAction1('PDF');" 			class="basic btn-download authR" id="setBtnDown">파일다운로드</a>
				<span id="btnDisplayYn02">
				<a href="javascript:doAction1('DEL');" 			class="basic btn-white out-line authR" id="setBtnDel" >파일삭제</a>
				</span>
				<a href="javascript:doAction1('Save');"         class="basic btn-save authR">저장</a>
				<a href="javascript:doAction1('Down2Excel');" 	class="basic btn-download authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<div style="height:410px"><script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script></div>
	</form>
</div>
<iframe name="hiddenIframe" id="hiddenIframe" style="display:none;"></iframe>
<form id="pfrm" name="pfrm" target="hiddenIframe" action="" method="post" >
<input type="hidden" id="pValue" name="pValue" />
<input type="hidden" id="pWorkYy" name="pWorkYy" />
<input type="hidden" id="fileUploadType" name="fileUploadType" />
</form>
</body>
