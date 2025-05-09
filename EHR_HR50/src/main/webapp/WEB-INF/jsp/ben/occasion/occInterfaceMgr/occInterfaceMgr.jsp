<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var INTERFACE_ROW = 0 ;
	$(function() {

		$("#searchSDate").datepicker2({startdate:"searchEDate"});
		$("#searchEDate").datepicker2({enddate:"searchSDate"});

// 		$("#searchMonthFrom").datepicker2({ymonly:true});
// 		$("#searchMonthTo").datepicker2({ymonly:true});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
       			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
       			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
       			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				
       			{Header:"<sht:txt mid='check_V4873' mdef='전송\n선택'/>",		Type:"Radio",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"check",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
				{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",		Type:"Image",	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"detail",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
      			
				{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",			Type:"Text", Hidden:0, Width:80 , Align:"Left",	  ColMarge:1,  SaveName:"orgNm",		KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text", Hidden:0, Width:60 , Align:"Center", ColMarge:1,  SaveName:"sabun",		KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text", Hidden:0, Width:60 , Align:"Center", ColMarge:1,  SaveName:"name",			KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='occDate_V770' mdef='경조일자'/>",		Type:"Date", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"occDate",		KeyField:0,   CalcLogic:"", Format:"Ymd",     PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='occCd_V763' mdef='경조구분'/>",		Type:"Combo",Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"occCd",		KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='famCd' mdef='가족관계'/>",		Type:"Combo",Hidden:0, Width:60 , Align:"Center", ColMarge:1,  SaveName:"famCd",		KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='basicMon' mdef='금액'/>",			Type:"Int",  Hidden:0, Width:70 , Align:"Right",  ColMarge:1,  SaveName:"payMon",		KeyField:0,   CalcLogic:"", Format:"Integer", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='exSendYn' mdef='전송여부'/>",		Type:"Text", Hidden:0, Width:50 , Align:"Center", ColMarge:1,  SaveName:"exSendYn",		KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='paymentYmd_V1741' mdef='기표일자'/>",		Type:"Date", Hidden:0, Width:80 , Align:"Center", ColMarge:0,  SaveName:"paymentYmd",	KeyField:0,   CalcLogic:"", Format:"Ymd",     PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='cDType' mdef='차대\n구분'/>",		Type:"Combo",Hidden:0, Width:55 , Align:"Center", ColMarge:0,  SaveName:"bschl",		KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='hkontCd' mdef='계정과목코드'/>",	Type:"Combo",Hidden:0, Width:100, Align:"Left",	  ColMarge:0,  SaveName:"hkontCd",		KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='acctCd' mdef='계정과목'/>",		Type:"Text", Hidden:0, Width:70 , Align:"Left",	  ColMarge:0,  SaveName:"hkont",		KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='ccCd' mdef='코스트센터'/>",		Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:0,  SaveName:"ccNm",			KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='resultMon' mdef='계산금액'/>",		Type:"Int",  Hidden:0, Width:70 , Align:"Right",  ColMarge:0,  SaveName:"dmbtr",			KeyField:0,   CalcLogic:"", Format:"Integer", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='exBelnr' mdef='회계전표번호'/>",	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:0,  SaveName:"exBelnr",		KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
				{Header:"<sht:txt mid='applSeqV7' mdef='APPL_SEQ'/>",		Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:0,  SaveName:"applSeq",		KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50}
      			];
			IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);
// 		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetMergeSheet( msNone );
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet1.SetDataLinkMouse("detail", 1) ;

		// 경조 구분
		var occCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B60020"), "");
		sheet1.SetColProperty("occCd", 			{ComboText:"|"+occCd[0], ComboCode:"|"+occCd[1]} );

		// 가족 관계
		var famCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20120"), "");
		sheet1.SetColProperty("famCd", 			{ComboText:"|"+famCd[0], ComboCode:"|"+famCd[1]} );

		// 차대구분
		var bschl 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C14020"), "");
		sheet1.SetColProperty("bschl", 			{ComboText:"|"+bschl[0], ComboCode:"|"+bschl[1]} );
		
		// 계정과목코드
		var hkontCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C14000"), "");
		sheet1.SetColProperty("hkontCd", 			{ComboText:"|"+hkontCd[0], ComboCode:"|"+hkontCd[1]} );
		
		$("#searchSbNm,#searchSDate,#searchEDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OccInterfaceMgr.do?cmd=getOccInterfaceMgrList", $("#sheetForm").serialize() ); break;
		case "Save":
// 			if(!dupChk(sheet1,"issueNo|sabun|stockGubunCd", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/OccInterfaceMgr.do?cmd=saveOccInterfaceMgr", $("#sheetForm").serialize()); break;
		case "Insert":
		        var newRow = sheet1.DataInsert(0);
				sheet1.SetCellValue(newRow, "issueNo", $("#searchIssueCnt").val());
				break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param); break;
		}
	}
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {

			if (Msg != "") {
				alert(Msg);
			}
			else {
				for(var i = 1; i < sheet1.RowCount()+1; i+=2) {
					for(var j = 3; j < 13; j++) {
						sheet1.SetMergeCell(i, j, 2, 1) ;//앞쪽 두줄씩 머지
					}
				}
			}
			sheetResize();

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}


    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{

          var colName = sheet1.ColSaveName(Col);
          var args    = new Array();

          args["name"]   = sheet1.GetCellValue(Row, "name");
          args["sabun"]  = sheet1.GetCellValue(Row, "sabun");

          var rv = null;

          if(colName == "name") {

              var rv = openPopup("/Popup.do?cmd=employeePopup", args, "840","520");
              if(rv!=null){
                  sheet1.SetCellValue(Row, "name",   rv["name"] );
                  sheet1.SetCellValue(Row, "sabun",  rv["sabun"] );
              }
          }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }


//  소속 팝업
    function orgSearchPopup(){
        try{

         var args    = new Array();
         var rv = openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","520");
            if(rv!=null){


             $("#searchOrgCd").val(rv["orgCd"]);
             $("#searchOrgNm").val(rv["orgNm"]);

            }
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }


//  사원 팝업
    function employeePopup(){
        try{

         var args    = new Array();
         var rv = openPopup("/Popup.do?cmd=employeePopup", args, "840","520");
            if(rv!=null){


             $("#searchName").val(rv["name"]);
             $("#searchSabun").val(rv["sabun"]);

            }
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }


	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	var searchSabun = sheet1.GetCellValue(Row,"sabun");
	    		var applSeq = sheet1.GetCellValue(Row,"applSeq");
	    		var applSabun = sheet1.GetCellValue(Row,"sabun");
	    		var applYmd = "" ;

	    		showApplPopup("R",applSeq,searchSabun,applSabun,applYmd, Row);

		    }
		    sheet1.ColSaveName(Col) == "check" ? (sheet1.GetCellValue(Row, "check") == 1 ? INTERFACE_ROW = Row : INTERFACE_ROW = 0) : "" ;
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	//신청 팝업
	function showApplPopup(auth,seq,sabun,applSabun,applYmd, Row) {
		if(auth == "") {
			alert("<msg:txt mid='alertInputAuth' mdef='권한을 입력하여 주십시오.'/>");
			return;
		}
		
		var p = {
				searchApplCd: '104'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: 'R'
			  , searchSabun: applSabun
			  , searchApplSabun: sabun
			  , searchApplYmd: applYmd 
			};
		var url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';
		var args = new Array(5);
		if(Row != ""){
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		}else{
			args["applStatusCd"] = "11";
		}

		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '근태신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
		doAction1("Search");
	}
	
	function callInterface() {
		if( INTERFACE_ROW == 0 ) {
			alert("<msg:txt mid='110284' mdef='전송 대상을 선택하여 주십시오.'/>") ;
			return  ;
		}
		
		if(!confirm("전표전송을 실행하시겠습니까?")) return ;

		var result = ajaxCall("${ctx}/ApprovalMgrResult.do?cmd=interfaceJejuApplCd104&searchApplSeq="+sheet1.GetCellValue(INTERFACE_ROW, "applSeq"),"",false);
		var resultMsg = result.Result.Message ;
		if(resultMsg != null) {
			alert("전송완료!\n경조금 전표전송 메시지 : "+resultMsg) ;
		} else {
			alert("전송완료!\n응답받은 전표전송 결과메시지가 없습니다.") ;
		}
		doAction1("Search") ;
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<!-- 조회조건 -->
	<input type="hidden" id="searchOrgCd" name="searchOrgCd" value =""/>
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />

	<!-- 조회조건 -->
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114541' mdef='경조일자'/></th>
						<td>
							<input id="searchSDate" name="searchSDate" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>">~
							<input id="searchEDate" name="searchEDate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
						</td>
						<th><tit:txt mid='113810' mdef='전송여부'/></th>
						<td>
							<select id="searchExSendYn" name ="searchExSendYn" onChange="javascript:doAction1('Search')" class="box">
								<option value="">전체</option>
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
						</td>
						<th><tit:txt mid='112277' mdef='사번/성명 '/></th>
						<td>
							<input id="searchSbNm" name ="searchSbNm" type="text" class="text" />
						</td>
						<td><a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a></td>
					</tr>
				</table>

			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112740' mdef='경조금인터페이스(수동)'/></li>
							<li class="btn">
								<a href="javascript:callInterface()" class="pink authA"><tit:txt mid='112741' mdef='전표전송'/></a>
								<a href="javascript:doAction1('Down2Excel')" class="basic"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
