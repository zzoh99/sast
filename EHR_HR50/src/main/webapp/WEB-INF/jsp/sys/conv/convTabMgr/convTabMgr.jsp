<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='113292' mdef='이관테이블관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("0"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("0"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='owner_V4276' mdef='유저명n(계정ID)'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"owner",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30},
			{Header:"<sht:txt mid='authScopeCdV3' mdef='테이블명'/>",			Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"tabNm",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='tabComment' mdef='테이블코맨트'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"tabComment",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000},
			{Header:"<sht:txt mid='useYnV8' mdef='사용구분'/>",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"convType",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			//{Header:"<sht:txt mid='convYn' mdef='담당자\n확인여부'/>",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"convYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, DefaultValue:"N"},
			{Header:"<sht:txt mid='convYn' mdef='담당자\n확인여부'/>",		Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"convYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, DefaultValue:"N", TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='numRows' mdef='실데이터수'/>",		Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"numRows",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25},
			{Header:"<sht:txt mid='copyNumRows' mdef='복사데이터수'/>",	Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"copyNumRows",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25},
			{Header:"<sht:txt mid='destTabNm' mdef='복사\n테이블명'/>",	Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"destTabNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='destTabComment' mdef='복사\n테이블코맨트'/>",	Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"destTabComment",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000},
			//{Header:"<sht:txt mid='compYnV2' mdef='반영\n완료여부'/>",	Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, DefaultValue:"N"},
			{Header:"<sht:txt mid='compYnV2' mdef='반영\n완료여부'/>",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, DefaultValue:"N", TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='attr3_V1' mdef='직접쿼리입력'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"attr3",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000, MultiLineText:true},
			{Header:"<sht:txt mid='etc1V1' mdef='기타1'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"attr1",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},
			{Header:"<sht:txt mid='etc2V1' mdef='기타2'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"attr2",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},
			{Header:"<sht:txt mid='errMsg_V1' mdef='에러메시지'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"errMsg",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},			
			{Header:"<sht:txt mid='attr4' mdef='기타4'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"attr4",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},
			{Header:"<sht:txt mid='chkdate' mdef='수정일자'/>",			Type:"Text",	Hidden:0,	Width:110,	Align:"Left",	ColMerge:0,	SaveName:"chkdate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetAutoRowHeight(0);

		sheet1.SetColProperty("convType", {ComboText:"사용|사용안함|예외처리", ComboCode:"1|0|2"} );
		//sheet1.SetColProperty("convYn", {ComboText:"확인|미확인", ComboCode:"Y|N"} );
		//sheet1.SetColProperty("compYn", {ComboText:"완료|미완료", ComboCode:"Y|N"} );


		$("#searchOwner,#searchTabNm,#searchTabComment,#searchDestTabNm,#searchDestTabComment").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/ConvTabMgr.do?cmd=getConvTabMgrList", $("#mySheetForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"owner|tabNm", true, true)){break;}
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave( "${ctx}/ConvTabMgr.do?cmd=saveConvTabMgr", $("#mySheetForm").serialize());
			break;
		case "Insert":
			var searchOwner = $.trim($("#searchOwner").val());

 			if(searchOwner == "") {
 				alert("유저명(계정ID)를 입력하여 주십시오.");
				return;
			}
			var row = sheet1.DataInsert();
			sheet1.SetCellValue(row, "owner" , searchOwner);
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Prc1":
			var searchOwner = $.trim($("#searchOwner").val());
			var searchTabNm = $.trim($("#searchTabNm").val());

			if(searchOwner == "") {
				alert("유저명(계정ID)를 입력하여 주십시오.");
			}

			if(searchTabNm != "") {
				if(!confirm("<msg:txt mid='114785' mdef='" + searchTabNm + " 테이블 데이터를 생성 하시겠습니까?'/>")) {
					return;
				}
			} else {
				if(!confirm("<msg:txt mid='114810' mdef='전체 테이블 데이터를 생성 하시겠습니까?'/>")) {
					return;
				}
			}

	    	var data = ajaxCall("/ConvTabMgr.do?cmd=prcConvTabMgr",$("#mySheetForm").serialize(),false);

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
				if(!confirm("<msg:txt mid='114771' mdef='" + searchTabNm + " 이관을 실행 하시겠습니까?'/>")) {
					return;
				}
			} else {
				if(!confirm("전체 이관을 실행 하시겠습니까?")) {
					return;
				}
			}

	    	var data = ajaxCall("/ConvTabMgr.do?cmd=prcConvTabMgrApp",$("#mySheetForm").serialize(),false);

	    	if(data.Result.Code == null) {
	    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
	    	} else {
		    	alert(data.Result.Message);
	    	}

	    	doAction1("Search");
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
						<th><tit:txt mid='112240' mdef='코멘트'/></th>
						<td>
							<input id="searchTabComment" name ="searchTabComment" type="text" class="text" />
						</td>
						<th><tit:txt mid='113664' mdef='복사테이블명'/></th>
						<td>
							<input id="searchDestTabNm" name ="searchDestTabNm" type="text" class="text" />
						</td>
						<th><tit:txt mid='114730' mdef='복사코멘트'/></th>
						<td>
							<input id="searchDestTabComment" name ="searchDestTabComment" type="text" class="text" />
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='112921' mdef='사용구분'/></th>
						<td>
							<select name="searchConvType" id="searchConvType" onChange="javascript:doAction1('Search');">
								<option value=""><tit:txt mid='103895' mdef='전체'/></option>
								<option value="1"><tit:txt mid='113321' mdef='사용'/></option>
								<option value="0"><tit:txt mid='112598' mdef='사용안함'/></option>
								<option value="2"><tit:txt mid='113289' mdef='예외처리'/></option>
							</select>
						</td>
						<th><tit:txt mid='113740' mdef='확인여부'/></th>
						<td>
							<select name="searchConvYn" id="searchConvYn" onChange="javascript:doAction1('Search');">
								<option value=""><tit:txt mid='103895' mdef='전체'/></option>
								<option value="Y"><tit:txt mid='104435' mdef='확인'/></option>
								<option value="N"><tit:txt mid='113023' mdef='미확인'/></option>
							</select>
						</td>
						<th><tit:txt mid='114731' mdef='반영완료여부'/></th>
						<td>
							<select name="searchCompYn" id="searchCompYn" onChange="javascript:doAction1('Search');">
								<option value=""><tit:txt mid='103895' mdef='전체'/></option>
								<option value="Y"><tit:txt mid='114352' mdef='완료'/></option>
								<option value="N"><tit:txt mid='113020' mdef='미완료'/></option>
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
			<li class="txt"><tit:txt mid='114004' mdef='이관테이블관리 '/><font color="blue"><tit:txt mid='114353' mdef='(이관실행시 사용구분:사용, 담당자확인여부:확인, 반영완료여부:미완료 인경우만 적용됩니다.)'/></font></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Prc1')" id="btnSearch" css="button authA" mid='111549' mdef="1.테이블생성"/>
				<btn:a href="javascript:doAction1('Prc2')" id="btnSearch" css="button authA" mid='110962' mdef="4.이관실행"/>
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
