<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		// 공통코드조회
		var ldsGubunList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L90030"), "");
		var mainAppType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");	//역량구분

		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='competencyCd' mdef='역량코드'/>",	Type:"Popup",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ldsCompetencyCd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='comGubunCd' mdef='역량구분'/>",  		Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",    ColMerge:0,   SaveName:"mainAppType",     	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='competencyNmV1' mdef='역량'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"ldsCompetencyNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"역량 정의",										Type:"Text",	Hidden:0,	Width:600,	Align:"Left",	ColMerge:0,	SaveName:"ldsCompetencyMemo",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000, Wrap:1, MultiLineText:1 },
			{Header:"<sht:txt mid='useYnV8' mdef='사용구분'/>",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"useYn",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='surveyItemType' mdef='분류'/>",	Type:"Combo",	Hidden:1,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"ldsGubun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		
		
		sheet1.SetColProperty("ldsGubun",	{ComboText:ldsGubunList[0], ComboCode:ldsGubunList[1]} );
		sheet1.SetColProperty("useYn",		{ComboText:"사용|미사용", ComboCode:"Y|N"} );
		sheet1.SetColProperty("mainAppType", 			{ComboText:mainAppType[0], ComboCode:mainAppType[1]} );	//역량구분

		initdata.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

   			{Header:"<sht:txt mid='competencyCd' mdef='역량코드'/>",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ldsCompetencyCd",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='seqV7' mdef='행동지표'/>",			Type:"Int",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:22 },
   			{Header:"<sht:txt mid='orderSeqV3' mdef='문항번호'/>",		Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
   			{Header:"<sht:txt mid='ldsCompBenm' mdef='행동지표내용'/>",	Type:"Text",	Hidden:0,	Width:500,	Align:"Left",	ColMerge:0,	SaveName:"ldsCompBenm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500, Wrap:1, MultiLineText:1 }
   		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);
 		
		$(window).smartresize(sheetResize); sheetInit();

		// 조회조건 이벤트
		$("#searchLdsCompetencyNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		$("#searchLdsGubun, #searchUseYn").bind("change", function(){
			doAction1("Search");
		});

		// 조회조건 값 setting
		$("#searchLdsGubun").html("<option value=''>전체</option>"+ldsGubunList[2]);

		// 조회
		doAction1("Search");
	});
</script>

<!-- sheet1 -->
<script type="text/javascript">
	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				$("#searchLdsCompetencyCd").val("");

				//doAction2("Clear");

				sheet1.DoSearch( "${ctx}/LDSCompetencyMng.do?cmd=getLDSCompetencyMngList1", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
				if(sheet1.FindStatusRow("I") != ""){
					if(!dupChk(sheet1,"ldsCompetencyCd", true, true)){break;}
				}
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/LDSCompetencyMng.do?cmd=saveLDSCompetencyMng1", $("#srchFrm").serialize() );
				break;

			case "Insert":		//입력
				var Row = sheet1.DataInsert(0);
				sheet1.SelectCell(Row, "ldsCompetencyCd");
				break;

			case "Copy":		//행복사
				var Row = sheet1.DataCopy();
				sheet1.SetCellValue(Row, "compApprasialCd", "");
				sheet1.SelectCell(Row, "ldsCompetencyCd");
				break;

			case "Clear":		//Clear
				sheet1.RemoveAll();
				break;

			case "Down2Excel":	//엑셀내려받기
				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
				break;

			case "LoadExcel":	//엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
				break;
		}
	}

//<!-- 조회 후 에러 메시지 -->
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

//<!-- 저장 후 에러 메시지 -->
	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}

			if ( Code != "-1" ) doAction1("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

//<!--셀에서 키보드가 눌렀을때 발생하는 이벤트-->
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
			// Insert KEY
			if(Shift == 1 && KeyCode == 45){
				doAction1("Insert");
			}

			//Delete KEY
			if(Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row,"sStatus") == "I"){
				sheet1.SetCellValue(Row,"sStatus","D");
			}
		}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}

	// 체크 되기 직전 이벤트가 발생한다.
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
			sheet1.SetAllowCheck(true);

			if( sheet1.ColSaveName(Col) == "sDelete" ) {
				if ( sheet1.GetCellValue(Row, "sStatus") == "I" ) return;
				if ( sheet1.GetCellValue(Row, "sDelete") == "1" ) return;

				if( !confirm("현재 데이터를 삭제를 하게 되면 해당 역량의 행동지표 자료가 모두 삭제됩니다. \n계속 진행하시겠습니까?") ) {
					sheet1.SetAllowCheck(false);
				}
			}
		}catch(ex){alert("OnBeforeCheck Event Error : " + ex);}
	}

	//<!--셀에 마우스 클릭했을때 발생하는 이벤트-->
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			var Row = NewRow;

			if ( sheet1.GetCellValue(Row, "sStatus") == "I" ) return;
			if ( OldRow == NewRow ) return;

			$("#searchLdsCompetencyCd").val(sheet1.GetCellValue(Row, "ldsCompetencyCd"));
		    doAction2('Search');
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "ldsCompetencyCd") {
				competencyPopup(Row) ;
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
//  역량코드 조회
	function competencyPopup(Row){
	    try{
	    	if(!isPopup()) {return;}

	     	// var args    = new Array();

			gPRow = Row;
			pGubun = "competencyPopup";

	     	// openPopup("/Popup.do?cmd=competencyPopup&authPg=R", args, "740","720");
			var layer = new window.top.document.LayerModal({
				id : 'competencyLayer'
				, url : '/Popup.do?cmd=viewCompetencyLayer&authPg=R'
				, parameters: {}
				, width : 740
				, height : 720
				, title : "역량항목"
				, trigger :[
					{
						name : 'competencyLayerTrigger'
						, callback : function(rv){
							getReturnValue(rv);
						}
					}
				]
			});
			layer.show();

	    }catch(ex){alert("Open Popup Event Error : " + ex);}
	}
	
	//팝업 콜백 함수.
	function getReturnValue(rv) {
		// var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "competencyPopup"){
        	sheet1.SetCellValue(gPRow, "ldsCompetencyCd",		rv.competencyCd);
        	sheet1.SetCellValue(gPRow, "ldsCompetencyNm",		rv.competencyNm);
    		sheet1.SetCellValue(gPRow, "ldsCompetencyMemo",		rv.memo);
        }
	}
</script>

<!-- sheet2 -->

<script type="text/javascript">

	function doAction2(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet2.DoSearch( "${ctx}/LDSCompetencyMng.do?cmd=getLDSCompetencyMngList2", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
				IBS_SaveName(document.srchFrm,sheet2);
				sheet2.DoSave( "${ctx}/LDSCompetencyMng.do?cmd=saveLDSCompetencyMng2", $("#srchFrm").serialize() );
				break;

			case "Insert":		//입력
				if ($("#searchLdsCompetencyCd").val() == "") {
					alert("역량을 선택해 주세요");
					return;
				}

				var Row = sheet2.DataInsert(0);
				sheet2.SetCellValue(Row,"ldsCompetencyCd", $("#searchLdsCompetencyCd").val());
				sheet2.SelectCell(Row, "ldsCompBenm");
				sheet2.SetCellValue(Row, "seq", "");
				break;

			case "Copy":		//행복사
				var Row = sheet2.DataCopy();
				sheet2.SelectCell(Row, "ldsCompBenm");
				sheet2.SetCellValue(Row, "seq", "");
				break;

			case "Clear":		//Clear
				sheet2.RemoveAll();
				break;

			case "Down2Excel":	//엑셀내려받기
				sheet2.Down2Excel({DownCols:makeHiddenSkipCol(sheet2),SheetDesign:1,Merge:1});
				break;

			case "LoadExcel":	//엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet2.LoadExcel(params);
				break;
		}
	}


	function sheet2_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}


	function sheet2_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}

			if ( Code != "-1" ) doAction2("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}


	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
			// Insert KEY
			if(Shift == 1 && KeyCode == 45){
				doAction2("Insert");
			}

			//Delete KEY
			if(Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row,"sStatus") == "I"){
				sheet2.SetCellValue(Row,"sStatus","D");
			}
		}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}
</script>
 
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchLdsCompetencyCd" name="searchLdsCompetencyCd" value="" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span><tit:txt mid='appSelf3' mdef='역량'/></span>
							<input id="searchLdsCompetencyNm" name ="searchLdsCompetencyNm" type="text" class="text" />
						</td>
						<td class="hide">
							<span><tit:txt mid='112118' mdef='분류'/></span>
							<SELECT id="searchLdsGubun" name="searchLdsGubun" class="box"></SELECT>
						</td>
						<td>
							<span><tit:txt mid='112921' mdef='사용구분'/></span>
							<SELECT id="searchUseYn" name="searchUseYn" class="box">
								<option value="Y" selected>사용</option>
								<option value="" >전체</option>
								<option value="N" >미사용</option>
							</SELECT>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a>
						</td>
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
							<li id="txt" class="txt"><tit:txt mid='appSelf3' mdef='역량'/></li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction1('Copy')" 		 class="btn outline_gray authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction1('Insert')" 	 class="btn outline_gray authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('Save')" 		 class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='idsCompetencyMng2' mdef='행동지표'/></li>
							<li class="btn">
								<a href="javascript:doAction2('Down2Excel')" class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction2('Copy')" 		 class="btn outline_gray authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction2('Insert')" 	 class="btn outline_gray authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction2('Save')" 		 class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "50%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
