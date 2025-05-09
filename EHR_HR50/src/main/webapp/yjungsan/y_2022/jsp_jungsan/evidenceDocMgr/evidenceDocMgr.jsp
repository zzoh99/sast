<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>증빙자료관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var arrDown = "";
var ssnSearchType = "";
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
            {Header:"상태",      Type:"<%=sSttTy%>", Hidden:0,  Width:40, Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"성명",		Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"대상자성명",  Type:"Text",        Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"nm_txt",      KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"조직명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"org_nm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사업장",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"biz_place_cd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"귀속년도",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"정산구분",	Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"상태",      Type:"Combo",       Hidden:0,   Width:60,  Align:"Center", ColMerge:0, SaveName:"status_cd",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"피드백",     Type:"Text",        Hidden:0,   Width:80,  Align:"Center", ColMerge:0, SaveName:"feedback",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"파일구분",	Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일순번",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_seq",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일경로",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_path",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일명",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_name",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attr1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"업로드일자",	Type:"Text",		Hidden:0,	Width:142,	Align:"Center",	ColMerge:0,	SaveName:"upload_date",	KeyField:0,	Format:"YmdHms",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"삭제",		Type:"Html",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"del_btn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"다운",		Type:"Html",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"down_btn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );
		var fileTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y", "YEA001"), "전체" );

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
		$("#ssnSearchType").val(ssnSearchType);
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

		sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
		sheet1.SetColProperty("file_type",    {ComboText:"|"+fileTypeList[0], ComboCode:"|"+fileTypeList[1]} );
		sheet1.SetColProperty("biz_place_cd",    {ComboText:"|"+bizPlaceCdList[0], ComboCode:"|"+bizPlaceCdList[1]} );
		sheet1.SetColProperty("status_cd",    {ComboText:"직원등록|담당자반려|담당자확인완료", ComboCode:"1|5|9"} );

		$("#searchAdjustType").html(adjustTypeList[2]).val("");
		$("#searchFileType").html(fileTypeList[2]).val("");
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]).val("");

		$(window).smartresize(sheetResize); sheetInit();

		//doAction1("Search");

		/* $("#searchWorkYy,#searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchAdjustType").bind("change",function(event){
			doAction1("Search");
		}); */

        if(ssnSearchType == "P") {
            sheet1.GetColEditable("feedback",false);
            sheet1.GetColEditable("status_cd",false);
            $("#setBtnUp").hide();
            $("#searchAuthR").hide();
        }else{
            sheet1.GetColEditable("feedback",true);
            sheet1.GetColEditable("status_cd",true);
            $("#setBtnUp").show();
            $("#searchAuthR").show();
        }

        getConFileFunc();// 파일기능 제어
        setBtn();        // 파일기능 제어 세팅

        doAction1("Search");
	});

	$(function(){
		$("#searchWorkYy").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		$("#searchSbNm,#searchNmTxt").bind("keyup",function(event){
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
						sheet1.DoSearch( "<%=jspPath%>/evidenceDocMgr/evidenceDocMgrRst.jsp?cmd=selectEvidenceDocMgrList", $("#sendForm").serialize(), 1 );
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
        case "Save":
            var params = $("#sendForm").serialize();
            sheet1.DoSave( "<%=jspPath%>/evidenceDocMgr/evidenceDocMgrRst.jsp?cmd=saveYeaDataFileList2", params);
            break;
        case "StsUpdate":
        	if(!chkStsCd()){
        		return;
        	}else{
        		var adjusType = $("#searchAdjustType").val();
        		var bizPlCd   = $("#searchBizPlaceCd").val();
        		var fileType  = $("#searchFileType").val();
        		var statusCd  = $("#searchStatusCd").val();

        		if(adjusType == "" || adjusType == null) adjusType = "전체";
        		if(bizPlCd   == "" || bizPlCd   == null) bizPlCd   = "전체";
        		if(fileType  == "" || fileType  == null) fileType  = "전체";
        		if(statusCd  == "" || statusCd  == null) {
        			statusCd  = "전체";
        		}else{
        			if(statusCd == "1") statusCd = "직원 등록";
        			if(statusCd == "5") statusCd = "담당자반려";
        		}

                var msg  = "귀속년도  : "+$("#searchWorkYy").val() + "년 ";
                    msg += "\n정산구분  : " + adjusType;
                    msg += "\n사업장     : " + bizPlCd;
                    msg += "\n파일구분  : " + fileType;
                    msg += "\n상태       : " + statusCd;

                if(!confirm(msg + "\n위의 조건으로 조회된 데이터를 일괄결재 하시겠습니까?")){
                    return;
                }else{
                    var params = $("#sendForm").serialize();
                    sheet1.DoSave( "<%=jspPath%>/evidenceDocMgr/evidenceDocMgrRst.jsp?cmd=updateStatusCd", params);
                    break;
                }
        	}
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
                if(ssnSearchType != "P"){
                    if(stsCd == "5"){
                        //반려일 경우에만 멘트 활성화
                        sheet1.SetCellEditable(i,"feedback",1);
                    }else{
                        sheet1.SetCellEditable(i,"feedback",0);
                    }
                }
                sheet1.SetCellValue(i,"sStatus","")
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
                obj.fileName = sheet1.GetCellValue(Row,"attr1");

                obj.dbFileName = sheet1.GetCellValue(Row,"file_name");
                obj.sabun = sheet1.GetCellValue(Row,"sabun");
                arrDown.push(obj);

                 if(arrDown.length > 0){
                     if(!isPopup()) {return;}

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
                         $("#pfrm").attr("action", "<%=jspPath%>/evidenceDocMgr/evidenceFileDownload.jsp");
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

                pValue = JSON.stringify(arrDown);

                params += "&searchWorkYy=" + $("#searchWorkYy").val();
                params += "&pValue="      + pValue;

                var rtnResult = ajaxCall("<%=jspPath%>/evidenceDocMgr/evidenceDocMgrRst.jsp?cmd=deleteEvidenceDocMgrList",params,false);

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
		var rv = openPopup("<%=jspPath%>/evidenceDocMgr/evidenceFileUploadPop.jsp",args,'750','500');
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
            var logStdCd = "CPN_YEA_FILE_LOG_YN";// 임시param
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
                $("#pfrm").attr("action", "<%=jspPath%>/evidenceDocMgr/evidenceFileDownload.jsp");
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
        $("#pfrm").attr("action", "<%=jspPath%>/evidenceDocMgr/evidenceFileDownload.jsp");
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

			var rtnResult = ajaxCall("<%=jspPath%>/evidenceDocMgr/evidenceDocMgrRst.jsp?cmd=deleteEvidenceDocMgrList",params,false);

			if(rtnResult.Result.Code == "1"){
				doAction1("Search");
			}
		}
	}
    function sheet1_OnChange(Row, Col, Value) {
        try{
            if(ssnSearchType != "P"){
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
           //setBtn();
       }catch(ex){alert("OnChange Event Error : " + ex);}
   }
   //상태값 체크
   function chkStsCd(){
	   var rtn = "";

	   if(!sheet1.RowCount() > 0) {
		   alert("조회된 내역이 없습니다.");
		   return;
	   }

	   if($("#searchStatusCd").val() == ""){
		   alert("상태값을 선택해주세요.");
		   rtn = false;
	   }else if($("#searchStatusCd").val() == "9"){
           alert("이미 확인이 완료되었습니다.");
           rtn = false;
	   }else{
		   for(var i = 1; i < sheet1.RowCount()+1; i++) {
			   sheet1.SetCellValue(i,"sStatus","U");
		   }
		   rtn = true;
	   }
	   return rtn;
   }
   // 파일기능 제어(조회)
   function getConFileFunc(){

       var fileUploadYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_ADD_FILE_UPLOAD", "queryId=getSystemStdData",false).codeList;
       var fileDownYn   = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_ADD_FILE_DOWN", "queryId=getSystemStdData",false).codeList;
       var fileDelYn    = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_ADD_FILE_DEL", "queryId=getSystemStdData",false).codeList;

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
	   if(ssnSearchType != "P"){
		   $("#orgAuthDiv").show();
	   }else{
           //파일다운로드
           if($("input:radio[name='cpn_yea_add_file_down']:checked").val() == "Y"){
        	   $("#setBtnDown").show();
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
	   }
   }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="sendForm" id="sendForm" method="post">
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	<input type="hidden" id="ssnSearchType" name="ssnSearchType" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>귀속년도</span>
							<%
							if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
							%>
								<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center required" maxlength="4" style="width: 35px;" value="<%=yeaYear%>" />
							<%}else{%>
								<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center required readonly" maxlength="4" style="width: 35px;" value="<%=yeaYear%>" readonly/>
							<%}%>

						</td>
						<td>
							<span>정산구분</span>
							<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
						</td>
						<td>
							<span>사업장</span>
							<select id="searchBizPlaceCd" name ="searchBizPlaceCd" onChange="javascript:doAction1('Search')" class="box"></select>
						</td>
						<td>
							<span>파일구분</span>
							<select id="searchFileType" name ="searchFileType" onChange="javascript:doAction1('Search')" class="box"></select>
						</td>
					</tr>
					<tr>
                        <td>
                            <span>상태</span>
                            <select id="searchStatusCd" name="searchStatusCd" onChange="javascript:doAction1('Search')">
                                <option value="">전체</option>
                                <option value="1">직원등록</option>
                                <option value="5">담당자반려</option>
                                <option value="9">담당자확인완료</option>
                            </select>
                        </td>
                        <td>
                            <span>대상자 성명</span>
                            <input id="searchNmTxt" name ="searchNmTxt" type="text" class="text" maxlength="15" style="width:100px"/>
                        </td>
						<td id="searchAuthR">
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
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">증빙자료관리</li>
				<li class="btn">
<!-- 				    <a href="javascript:openFileUploadPopup();" 	class="button authA">PDF 등록</a> -->
					<a href="javascript:doAction1('StsUpdate');"    class="basic ico-check authA" id="setBtnUp">일괄결재</a>
					<a href="javascript:doAction1('PDF');" 			class="basic btn-download authA" id="setBtnDown">파일다운로드</a>
					<a href="javascript:doAction1('DEL');" 			class="basic btn-white out-line authA" id="setBtnDel">파일삭제</a>
					<a href="javascript:doAction1('Save');"         class="basic btn-save authR">저장</a>
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
