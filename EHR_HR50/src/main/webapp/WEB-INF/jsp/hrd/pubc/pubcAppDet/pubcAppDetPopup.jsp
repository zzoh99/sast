<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>사내공모 리스트 조회</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
// 	var srchBizCd = null;
// 	var srchTypeCd = null;
	var p = eval("${popUpStatus}");
	
	var gPRow = "";
	var pGubun = "";

	$(function() {

		var arg = p.popDialogArgumentAll();
	    if( arg != undefined ) {
	    	$("#sabun").val(arg["searchApplSabun"]);
	    }
	    
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			
			{Header:"공모안내문",		Type:"Html",  		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0, SaveName:"btnFile",		    KeyField:0,	Format:"",	 	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"첨부번호",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		    KeyField:0,	Format:"",	 	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"공모구분",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pubcDivCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
			{Header:"공모명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"pubcNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
			{Header:"신청시작일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStaYmd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
			{Header:"신청종료일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applEndYmd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
			{Header:"공모상태",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pubcStatCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
			{Header:"공모내용",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"pubcContent",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
			{Header:"비고",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
			
			{Header:"공모ID",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"pubcId",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
			{Header:"직무명",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
			
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

    	var pubcDivCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1026"), "");	//공모구분
		var pubcStatCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1027"), "");	//공모상태

		sheet1.SetColProperty("pubcDivCd",		{ComboText:"|"+pubcDivCd[0], ComboCode:"|"+pubcDivCd[1]} );	//공모구분
		sheet1.SetColProperty("pubcStatCd",		{ComboText:"|"+pubcStatCd[0], ComboCode:"|"+pubcStatCd[1]} );	//공모상태

		$("#searchPubcNm").bind("keyup",function(event){
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

	        	sheet1.DoSearch( "${ctx}/PubcApp.do?cmd=getPubcAppDetPopupList", $("#sheet1Form").serialize() );
	            break;
	            
	        case "Down2Excel":  //엑셀내려받기

	            sheet1.Down2Excel();
	            break;

	    }
	}

	// 조회 후 에러 메시지
	  function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
	  try{
	    if (ErrMsg != ""){
	        alert(ErrMsg);
	    }
	    for(var i = 0; i < sheet1.RowCount(); i++) {
	    	sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='down2excel' mdef="다운로드"/>');
	    }
	    
	  }catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
			if(sheet1.ColSaveName(Col) == "btnFile"	&& Row >= sheet1.HeaderRows()){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");

				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup";

					var authPgTemp="R";
					var rv = openPopup("/Upload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType="+$("#uploadType").val(), param, "740","620");
				}
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	function sheet1_OnDblClick(Row, Col){
		var rv = new Array(5);
		rv["pubcId"]		= sheet1.GetCellValue(Row, "pubcId");
		rv["pubcNm"]		= sheet1.GetCellValue(Row, "pubcNm");
		rv["pubcDivNm"]		= sheet1.GetCellText(Row, "pubcDivCd");
		rv["pubcStatNm"]	= sheet1.GetCellText(Row, "pubcStatCd");
		rv["jobNm"]			= sheet1.GetCellValue(Row, "jobNm");
		rv["applStaYmd"]	= sheet1.GetCellValue(Row, "applStaYmd");
		rv["applEndYmd"]	= sheet1.GetCellValue(Row, "applEndYmd");
		rv["pubcContent"]	= sheet1.GetCellValue(Row, "pubcContent");

		p.popReturnValue(rv);
		p.window.close();
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "viewPubcAppDetPopup"){
			doAction1("Search");
		}

	}

</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>사내공모 리스트 조회</li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="sheet1Form" name="sheet1Form" tabindex="1">
			<input type="hidden" id="sabun" name="sabun">
			<input type="hidden" id="uploadType" 	name="uploadType" value=""/>
			
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
	                		<td> <span>사내공모명</span>
	                     		<input type="text" id="searchPubcNm" name="searchPubcNm" class="text" value="" />
	                		</td>
                       		<td>
								<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
		
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
