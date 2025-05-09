<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='114003' mdef='이관컬럼관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:1000,MergeSheet:msAll,FrozenCol:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("1"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:Number("0"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:Number("0"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='owner_V4277' mdef='유저명n(계정ID)|유저명n(계정ID)'/>",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"owner",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30},
			{Header:"<sht:txt mid='tabNm' mdef='원본|테이블명'/>",						Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"tabNm",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='srcColNm' mdef='원본|컬럼명'/>",						Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"srcColNm",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2000},
			{Header:"<sht:txt mid='srcColId' mdef='원본|컬럼ID'/>",						Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"srcColId",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='srcColType' mdef='원본|컬럼타입'/>",						Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"srcColType",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='srcColComment' mdef='원본|컬럼코맨트'/>",					Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"srcColComment",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000},
			{Header:"<sht:txt mid='srcAvgColLen' mdef='원본|평균n데이터길이'/>",				Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"srcAvgColLen",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:25},
			{Header:"<sht:txt mid='destTabNm_V1' mdef='복사|테이블명'/>",						Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"destTabNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100},
			{Header:"<sht:txt mid='destColNm' mdef='복사|컬럼명'/>",						Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"destColNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000},
			{Header:"<sht:txt mid='destColType' mdef='복사|컬럼타입'/>",						Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"destColType",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='destColComment' mdef='복사|컬럼코맨트'/>",					Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"destColComment",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000},
			{Header:"<sht:txt mid='convType' mdef='사용구분|사용구분'/>",					Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"convType",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='attr1_V1' mdef='입력구분|입력구분'/>",					Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"attr1",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='attr2_V1' mdef='기타|기타2'/>",						Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"attr2",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='attr3' mdef='기타|기타3'/>",						Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"attr3",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='attr4_V1' mdef='기타|기타4'/>",						Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"attr4",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='convYn_V1' mdef='확인여부|확인여부'/>",					Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"convYn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, DefaultValue:"N"},
			{Header:"<sht:txt mid='compYn_V2422' mdef='반영완료여부|반영완료여부'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"compYn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, DefaultValue:"N"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("convType", {ComboText:"사용|사용안함|예외처리", ComboCode:"1|0|2"} );
		sheet1.SetColProperty("attr1", {ComboText:"시스템입력|사용자입력|사용자수정", ComboCode:"S|I|U"} );


		$("#searchOwner,#searchTabNm,#searchSrcColNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/ConvColMapMgr.do?cmd=getConvColMapMgrList", $("#mySheetForm").serialize() );			
			break;
		case "Save":
			if(!dupChk(sheet1,"owner|tabNm|srcColNm", true, true)){break;}
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave( "${ctx}/ConvColMapMgr.do?cmd=saveConvColMapMgr", $("#mySheetForm").serialize());
			break;
		case "Insert":
			var searchOwner = $.trim($("#searchOwner").val());

 			if(searchOwner == "") {
 				alert("유저명(계정ID)를 입력하여 주십시오.");
				return;
			}
			var row = sheet1.DataInsert();
			sheet1.SetCellValue(row, "owner" , searchOwner);
			sheet1.SetCellValue(row, "attr1" , "I");
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
			
		case "Prc":
			var searchOwner = $.trim($("#searchOwner").val());
			var searchTabNm = $.trim($("#searchTabNm").val());

			if(searchOwner == "") {
				alert("유저명(계정ID)를 입력하여 주십시오.");
			}

			if(searchTabNm != "") {
				if(!confirm("<msg:txt mid='114778' mdef='" + searchTabNm + " 컬럼 데이터를 생성 하시겠습니까?'/>")) {
					return;
				}
			} else {
				if(!confirm("전체 컬럼 데이터를 생성 하시겠습니까?")) {
					return;
				}
			}

	    	var data = ajaxCall("/ConvColMapMgr.do?cmd=prcConvColMapMgr",$("#mySheetForm").serialize(),false);

	    	if(data.Result.Code == null) {
	    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
	    		doAction1("Search");
	    	} else {
		    	alert(data.Result.Message);
	    	}
			break;
			
		case "Prc2":
			var searchOwner = $.trim($("#searchOwner").val());
			var searchTabNm = $.trim($("#searchTabNm").val());

			if(searchOwner == "") {
				alert("유저명(계정ID)를 입력하여 주십시오.");
			}

			if(searchTabNm != "") {
				if(!confirm("<msg:txt mid='114778' mdef='" + searchTabNm + "에 대한 복사본의 빈 칼럼을 원본의 칼럼으로 복사하시겠습니까?'/>")) {
					return;
				}
			} else {
				if(!confirm("전체 복사본의 빈 칼럼을 원본의 칼럼으로 복사하시겠습니까?")) {
					return;
				}
			} 

	    	var data = ajaxCall("/ConvColMapMgr.do?cmd=prcConvColMapMgr2",$("#mySheetForm").serialize(),false);

	    	if(data.Result.Code == null) {
	    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
	    		doAction1("Search");
	    	} else {
		    	alert(data.Result.Message);
	    	}
			break;			
			
		case "Clear":
			sheet1.RemoveAll();
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

			for(var i = 2; i < sheet1.RowCount()+2; i++) {
				if(sheet1.GetCellValue(i, "convYn") == "Y" || sheet1.GetCellValue(i, "compYn") == "Y") {
					sheet1.SetRowEditable(i, false);
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

	//대상 테이블 생성
	function prcCreate() {
		var args    = new Array();
		args["searchAppStepCd"] = '5';
		args["searchAppraisalCd"] = $("#searchAppraisalCd").val();

	    var rv = openPopup("/AppPeopleMgr.do?cmd=viewAppPeopleMgrPop", args, "740","520");
	    doAction1('Search');
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='113662' mdef='원본 유저명(계정ID)'/></th>
						<td>
							<input id="searchOwner" name ="searchOwner" type="text" class="text" value="EHR_IDS"/>
						</td>
						<th><tit:txt mid='112918' mdef='테이블명'/></th>
						<td>
							<input id="searchTabNm" name ="searchTabNm" type="text" class="text" />
						</td>
						<th><tit:txt mid='113288' mdef='컬럼명'/></th>
						<td>
							<input id="searchSrcColNm" name ="searchSrcColNm" type="text" class="text" />
						</td>
						<th><tit:txt mid='114348' mdef='테이블사용구분'/></th>
						<td>
							<select name="searchTabConvType" id="searchTabConvType" onChange="javascript:doAction1('Search');">
								<option value=""><tit:txt mid='103895' mdef='전체'/></option>
								<option value="1"><tit:txt mid='113321' mdef='사용'/></option>
								<option value="0"><tit:txt mid='112598' mdef='사용안함'/></option>
								<option value="2"><tit:txt mid='113289' mdef='예외처리'/></option>
							</select>
						</td>
						<th><tit:txt mid='114727' mdef='컬럼처리구분'/></th>
						<td>
							<select name="searchConvType" id="searchConvType" onChange="javascript:doAction1('Search');">
								<option value=""><tit:txt mid='103895' mdef='전체'/></option>
								<option value="1"><tit:txt mid='113321' mdef='사용'/></option>
								<option value="0"><tit:txt mid='112598' mdef='사용안함'/></option>
								<option value="2"><tit:txt mid='113289' mdef='예외처리'/></option>
							</select>
						</td>
						<th><tit:txt mid='112920' mdef='입력구분'/></th>
						<td>
							<select name="searchAttr1" id="searchAttr1" onChange="javascript:doAction1('Search');">
								<option value=""><tit:txt mid='103895' mdef='전체'/></option>
								<option value="S"><tit:txt mid='112239' mdef='시스템입력'/></option>
								<option value="I"><tit:txt mid='113291' mdef='사용자입력'/></option>
								<option value="U"><tit:txt mid='114729' mdef='사용자수정'/></option>
							</select>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='114003' mdef='이관컬럼관리'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Prc')" id="btnSearch" css="button authA" mid='111548' mdef="2.컬럼생성"/>
				<btn:a href="javascript:doAction1('Prc2')" id="btnSearch" css="button authA" mid='111548' mdef="3.복사본의 빈 컬럼 맞춤"/>
				<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" css="basic authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
