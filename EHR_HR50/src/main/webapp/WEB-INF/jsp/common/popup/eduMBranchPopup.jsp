<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='eduMBranchPop' mdef='교육분류 리스트 조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
// 	var srchBizCd = null;
// 	var srchTypeCd = null;
	var p = eval("${popUpStatus}");

	$(function() {

		var enterCd = "";
		var arg = p.popDialogArgumentAll();
	    if( arg != undefined ) {
	    }
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='eduMBranchCdV3' mdef='교육분류코드'/>",			Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"eduMBranchCd",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='eduMBranchNmV2' mdef='교육분류명'/>",				Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"eduMBranchNm",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		$("#searchEduMBranchNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#searchEduMBranchCd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});
	});

	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
	    switch(sAction){
	        case "Search":      //조회
	        	sheet1.DoSearch( "${ctx}/EduCourseMgr.do?cmd=getEduMBranchMgrList", $("#sheet1Form").serialize() );
	            break;
	    }
	}

	  function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
	  try{
	    if (ErrMsg != ""){
	        alert(ErrMsg);
	    }
	    sheetResize();
	    //setSheetSize(this);
	  }catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	  function sheet1_OnResize(lWidth, lHeight){
	  try{
	    //높이 또는 너비가 변경된 경우 각 컬럼의 너비를 새로 맞춘다.
	    //setSheetSize(this);
	  }catch(ex){alert("OnResize Event Error : " + ex);}
	}

	  function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
	  try{
	    if (ErrMsg != ""){
	        alert(ErrMsg) ;
	        doAction1("Search") ;
	    }
	  }catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

	  function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
	  try{
	    selectSheet = sheet1;
	  }catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	  function sheet1_OnValidation(Row, Col, Value){
	  try{
	  }catch(ex){alert("OnValidation Event Error : " + ex);}
	}

	function sheet1_OnDblClick(Row, Col){
		var rv = new Array(5);
		rv["eduMBranchCd"]	= sheet1.GetCellValue(Row, "eduMBranchCd");
		rv["eduMBranchNm"]	= sheet1.GetCellValue(Row, "eduMBranchNm");

		p.popReturnValue(rv);
		p.window.close();
	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='eduMBranchPop' mdef='교육분류 리스트 조회'/></li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="sheet1Form" name="sheet1Form" tabindex="1">
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
					<th><tit:txt mid='114122' mdef='교육분류코드'/></th>
                       <td> 
                            <input type="text" id="searchEduMBranchCd" name="searchEduMBranchCd" class="text" value="" />
                       </td>
                       <th><tit:txt mid='113070' mdef='교육분류명'/></th>
					   <td>  <input id="searchEduMBranchNm" name ="searchEduMBranchNm" type="text" class="text" /> </td>
                       <td>
						<a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
					</td>
				</tr>
				</table>
				</div>
			</div>
		</form>

		<table class="sheet_main">
			<tr>
				<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='eduMBranchPopV1' mdef='교육분류'/></li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>



