<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='PersonnelFormatApr' mdef='근로시간단축 승인관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		
		var config1 = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		var info1 = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		var headers1 = [
			{Text:"No|상태|일괄승인\n선택|세부\n내역|소속|직위|사번|성명|신청기간|신청기간|단축시간|단축시간|근무시간|신청일자|결재상태|신청서종류|신청서번호|NO|applSabun|applInSabun|조정여부",Align:"Center"},
			{Text:"No|상태|일괄승인\n선택|세부\n내역|소속|직위|사번|성명|시작일|종료일|출근단축|퇴근단축|근무시간|신청일자|결재상태|신청서종류|신청서번호|NO|applSabun|applInSabun|조정여부",Align:"Center"}
		];

		var cols1 = [
			{Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Type:"DummyCheck",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 },
			{Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"swtApplyStrYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"swtApplyEndYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"swtStrH",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"swtEndH",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appWorkHour",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Type:"Text",		Hidden:0,	Width:190,	Align:"Center",	ColMerge:0,	SaveName:"applNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"applCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"applSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"chkCol",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			
			];

		sheet1.SetConfig(config1);
		sheet1.InitHeaders(headers1, info1);
		sheet1.InitColumns(cols1);
		sheet1.SetEditable("${editable}");
		sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage",true);
		
		/* 신청서종류(근로시간 단축)*/
		var applCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getWorkingTypeCodeList",""), "전체");
		
		/* 결재상태 조회 */
		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "전체");

		sheet1.SetColProperty("applCd",			{ComboText:applCd[0], ComboCode:applCd[1]} );
		sheet1.SetColProperty("applStatusCd",	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );
		sheet1.SetColProperty("prtYn",			{ComboText:'Yes|No', ComboCode:'Y|N'} );

		$("#wtCd").html(applCd[2]);
		$("#applStatusCd").html(applStatusCd[2]);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	$(function() {
		$("#applYmdFrom").datepicker2({startdate:"applYmdTo"});
		$("#applYmdTo").datepicker2({enddate:"applYmdFrom"});

        $("#name").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			if($("#applYmdFrom").val() == "") {
				alert("<msg:txt mid='109719' mdef='신청일을 입력하여 주십시오.'/>");
				$("#applYmdFrom").focus();
				return;
			}
			if($("#applYmdTo").val() == "") {
				alert("<msg:txt mid='109719' mdef='신청일을 입력하여 주십시오.'/>");
				$("#applYmdTo").focus();
				return;
			}

			var param = "applCd="+$("#wtCd").val()
						+"&applYmdFrom="+$("#applYmdFrom").val().replace(/-/gi,"")
						+"&applYmdTo="+$("#applYmdTo").val().replace(/-/gi,"")
						+"&name="+encodeURIComponent($("#name").val())
						+"&applStatusCd="+$("#applStatusCd").val();

			sheet1.DoSearch( "${ctx}/WorkingTypeApr.do?cmd=getWorkingTypeAprList", param );
			break;
		case "Save":
			var param = "&applCd="+$("#wtCd").val()
						+"&applYmdFrom="+$("#applYmdFrom").val().replace(/-/gi,"")
						+"&applYmdTo="+$("#applYmdTo").val().replace(/-/gi,"")
						+"&name="+encodeURIComponent($("#name").val())
						+"&applStatusCd="+$("#applStatusCd").val();
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/WorkingTypeApr.do?cmd=saveWorkingTypeApr", $("#sheetForm").serialize()+param );
			break;

		case "AllAppr":
			if(sheet1.RowCount("U") > 0 || sheet1.RowCount("D") > 0) {
				alert("<msg:txt mid='110325' mdef='수정된 데이터가 있습니다. 저장 후 선택하여 주십시오.'/>");
				return;
			}

			if(sheet1.CheckedRows("ibsCheck") < 1) {
				alert("<msg:txt mid='110035' mdef='일괄승인할 데이터를 선택하여 주십시오.'/>");
				return;
			}

			var sRow = sheet1.FindCheckedRow("ibsCheck");
			var arrRow = sRow.split("|");

			for(var i = 0; i < arrRow.length; i++){
				if(arrRow[i] != "") {
					sheet1.SetCellValue(arrRow[i],"sStatus","U");
				}
			}

			if(!confirm("일괄승인 하시겠습니까?")) {
				for(var i = 0; i < arrRow.length; i++){
					if(arrRow[i] != "") {
						sheet1.SetCellValue(arrRow[i],"sStatus","R");
					}
				}
				return;
			}
			var param = "&applCd="+$("#wtCd").val()
						+"&applYmdFrom="+$("#applYmdFrom").val().replace(/-/gi,"")
						+"&applYmdTo="+$("#applYmdTo").val().replace(/-/gi,"")
						+"&name="+encodeURIComponent($("#name").val())
						+"&applStatusCd="+$("#applStatusCd").val();
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/WorkingTypeApr.do?cmd=saveWorkingTypeAprStatus", $("#sheetForm").serialize()+param,-1, 0 );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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
			for(var i = 2; i <= sheet1.RowCount()+1; i++) {
				if(sheet1.GetCellValue(i,"chkCol") == '1'){
					sheet1.SetCellFontColor(i,8, "red"); 
					sheet1.SetCellFontColor(i,9, "red"); 
				}
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "ibsImage" ) {

		    	if(sheet1.GetCellValue(Row,"ibsImage") != ""){
			    	pGubun = ""; //세부내역 창을 띄운후 '저장'시 ib시트 새로고침
	
			    	var applSabun = sheet1.GetCellValue(Row,"applSabun");
		    		var applSeq = sheet1.GetCellValue(Row,"applSeq");
		    		var applInSabun = sheet1.GetCellValue(Row,"applInSabun");
		    		var applYmd = sheet1.GetCellValue(Row,"applYmd");
		    		var applCd = sheet1.GetCellValue(Row,"applCd");
	
		    		showApplPopup("R",applSeq,applSabun,applInSabun,applYmd,applCd);
		    	}	
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 체크 되기 직전 발생.
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
            sheet1.SetAllowCheck(true);
		    if(sheet1.ColSaveName(Col) == "ibsCheck") {
		        if((sheet1.GetCellValue(Row, "applStatusCd") != "21" && sheet1.GetCellValue(Row, "applStatusCd") != "31")) {
		            //alert("<msg:txt mid='109584' mdef='결재중인 데이터만 선택하여 주십시오.'/>");
		            sheet1.SetAllowCheck(false);
		            return;
		        }
		    }
		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}

	//신청 팝업
	function showApplPopup(auth,seq,applSabun,applInSabun,applYmd,applCd) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("<msg:txt mid='110262' mdef='권한을 입력하여 주십시오.'/>");
			return;
		}

		const p = {
			searchApplCd: applCd,
			searchApplSeq: seq,
			adminYn: 'Y',
			authPg: auth,
			searchApplSabun: applSabun,
			searchSabun: applInSabun,
			searchApplYmd: applYmd
		};


		var url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";

		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 900,
			height: 600,
			title: '근로시간단축 신청',
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
	}

	function getReturnValue(returnValue) {
		if ( pGubun == "sheetAutocompleteEmp" ){
        	var rv = $.parseJSON('{' + returnValue+ '}');
	   		sheet1.SetCellValue(gPRow, "sabun",rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name",rv["name"]);

            sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
            sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
	    } else {
			doAction1("Search");
	    }
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<td>
					<span><tit:txt mid='113342' mdef='신청상태'/></span>
					<select id="applStatusCd" name="applStatusCd" style="margin-left: 3px;"></select>
				</td>
				<td colspan="2">
					<span><tit:txt mid='104084' mdef='신청일자'/></span>
					<input id="applYmdFrom" name="applYmdFrom" style="margin-left: 10px;" type="text" size="10" class="date2 required" value="${curSysYyyyMMHyphen}-01"/> ~
					<input id="applYmdTo" name="applYmdTo" type="text" size="10" class="date2 required" value="${curSysYyyyMMddHyphen}"/>
				</td>
			</tr>
			<tr>
				<td>
					<span><tit:txt mid='112947' mdef='성명/사번'/></span>
					<input id="name" name="name" type="text" class="text" style="width: 90px;"/>
				</td>
				
				<td>
					<span><tit:txt mid='112125' mdef='신청서종류'/></span>
					<select id="wtCd" name="wtCd"></select>
				</td>

				<td>
					<btn:a href="javascript:doAction1('Search');" css="button" mid='search' mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='PersonnelFormatApr' mdef='근로시간단축 승인관리'/></li>
			<li class="btn">
<%--				<btn:a href="javascript:doAction1('AllAppr');" css="green authA" mid='allApplV1' mdef="일괄승인"/>--%>
				<btn:a href="javascript:doAction1('Save')" css="basic authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
