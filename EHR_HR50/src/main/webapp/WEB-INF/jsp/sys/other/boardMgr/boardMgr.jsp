<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly,ChildPage:5};
		initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
		initdata.Cols = [
    		{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",							    Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",								Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",								Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='mainMenuCdV1' mdef='메인메뉴코드|메인메뉴코드'/>",					Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"mainMenuCd",         	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='priorMenuCdV1' mdef='상위메뉴|상위메뉴'/>",						Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"priorMenuCd",        	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='menuCdV1' mdef='메뉴|메뉴'/>",								Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"menuCd",             	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='appIndexGubunCd1' mdef='구분|구분'/>",								Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"type",               	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
   			{Header:"<sht:txt mid='bbsCd' mdef='게시판코드|게시판코드'/>",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bbsCd",              	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='bbsNm' mdef='게시판명|게시판명'/>",						Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"bbsNm",              	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100,  TreeCol:1,  LevelSaveName:"sLevel"  },
   			{Header:"<sht:txt mid='orderSeq' mdef='순서|순서'/>",								Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",                	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='useYnV4' mdef='사용유무|사용유무'/>",						Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useYn",              	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
   			{Header:"<sht:txt mid='notifyYn' mdef='공지사항여부|공지사항여부'/>",						Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"notifyYn",              	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
   			{Header:"<sht:txt mid='adminImg' mdef='관리자|관리자'/>",							Type:"Image",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adminImg",           	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='manageAllYn' mdef='작성권한|전사구분'/>",						Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageAllYn",        	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
   			{Header:"<sht:txt mid='manageAllSeq' mdef='작성권한|seq'/>",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageAllSeq",          	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='manageAllDesc' mdef='작성권한|대상자검색설명'/>",					Type:"Popup",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"manageAllDesc",          	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='manageImg' mdef='작성권한|권한'/>",							Type:"Image",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageImg",          	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='searchAllYn' mdef='조회권한|전사구분'/>",						Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"searchAllYn",        	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
   			{Header:"<sht:txt mid='searchAllSeq' mdef='조회권한|seq'/>",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"searchAllSeq",          	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='searchAllDesc' mdef='조회권한|대상자검색설명'/>",					Type:"Popup",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"searchAllDesc",          	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='searchImg' mdef='조회권한|권한'/>",							Type:"Image",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"searchImg",          	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='replyYn' mdef='답글여부|답글여부'/>",						Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"replyYn",            	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
   			{Header:"<sht:txt mid='commentYn' mdef='덧글여부|덧글여부'/>",						Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"commentYn",          	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
   			{Header:"<sht:txt mid='fileYnV3' mdef='첨부파일|첨부파일'/>",						Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"fileYn",          	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
   			{Header:"<sht:txt mid='fileName' mdef='서식파일|서식파일'/>",						Type:"Popup",		Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"fileName",           	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='bigo' mdef='비고|비고'/>",								Type:"Text",		Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"bigo",            	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='manageOrgCd' mdef='MANAGE_ORG_CD|MANAGE_ORG_CD'/>",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"manageOrgCd" },
   			{Header:"<sht:txt mid='manageOrgNm' mdef='MANAGE_ORG_NM|MANAGE_ORG_NM'/>",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"manageOrgNm" },
   			{Header:"<sht:txt mid='manageJobCd' mdef='MANAGE_JOB_CD|MANAGE_JOB_CD'/>",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"manageJobCd" },
   			{Header:"<sht:txt mid='manageJobNm' mdef='MANAGE_JOB_NM|MANAGE_JOB_NM'/>",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"manageJobNm" },
   			{Header:"<sht:txt mid='manageJikchakCd' mdef='MANAGE_JIKCHAK_CD|MANAGE_JIKCHAK_CD'/>",	Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"manageJikchakCd" },
   			{Header:"<sht:txt mid='manageJikchakNm' mdef='MANAGE_JIKCHAK_NM|MANAGE_JIKCHAK_NM'/>",	Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"manageJikchakNm" },
   			{Header:"<sht:txt mid='searchOrgCd' mdef='SEARCH_ORG_CD|SEARCH_ORG_CD'/>",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"searchOrgCd" },
   			{Header:"<sht:txt mid='searchOrgNm' mdef='SEARCH_ORG_NM|SEARCH_ORG_NM'/>",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"searchOrgNm" },
   			{Header:"<sht:txt mid='searchJobCd' mdef='SEARCH_JOB_CD|SEARCH_JOB_CD'/>",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"searchJobCd" },
   			{Header:"<sht:txt mid='searchJobNm' mdef='SEARCH_JOB_NM|SEARCH_JOB_NM'/>",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"searchJobNm" },
   			{Header:"<sht:txt mid='searchJikchakCd' mdef='SEARCH_JIKCHAK_CD|SEARCH_JIKCHAK_CD'/>",	Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"searchJikchakCd" },
   			{Header:"<sht:txt mid='searchJikchakNm' mdef='SEARCH_JIKCHAK_NM|SEARCH_JIKCHAK_NM'/>",	Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"searchJikchakNm" }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet1.SetColProperty("type", 			{ComboText:"카테고리|게시판",	ComboCode:"C|B"} );
		sheet1.SetColProperty("useYn", 			{ComboText:"사용|미사용", 	ComboCode:"Y|N"} );
		sheet1.SetColProperty("notifyYn", 		{ComboText:"N|Y", 			ComboCode:"N|Y"} );
		sheet1.SetColProperty("manageAllYn", 	{ComboText:"Y|N", 			ComboCode:"Y|N"} );
		sheet1.SetColProperty("searchAllYn", 	{ComboText:"Y|N", 			ComboCode:"Y|N"} );
		sheet1.SetColProperty("replyYn", 		{ComboText:"Y|N", 			ComboCode:"Y|N"} );
		sheet1.SetColProperty("commentYn", 		{ComboText:"Y|N", 			ComboCode:"Y|N"} );
		sheet1.SetColProperty("fileYn", 		{ComboText:"Y|N", 			ComboCode:"Y|N"} );



		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/BoardMgr.do?cmd=tsys700SelectBoardList", $("#srchFrm").serialize() ); break;
		case "Save":
			for(var i = sheet1.HeaderRows() ; i < sheet1.LastRow(); i++){
				if(sheet1.GetCellValue(i, "sStatus") != "D" && sheet1.GetCellValue(i, "type") == "B" && sheet1.GetCellValue(i, "bbsCd") == "" ) {
					alert("<msg:txt mid='110373' mdef='게시판코드를 반드시 입력해 주시기 바랍니다.'/>");
					return;
				}
			}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/BoardMgr.do?cmd=tsys700SaveBoard", $("#srchFrm").serialize()); break;
		case "Insert":
			//sheet1.SelectCell(sheet1.DataInsert(0), "type");
			//break;

            var	Row	= sheet1.GetSelectRow();
            if( sheet1.GetRowLevel(Row) == 3 ) {
                alert("<msg:txt mid='alertBoardMgr1' mdef='현 단계 이하의 카테고리/게시판은 등록할 수 없습니다.'/>");
                return;
            }


            //게시판일때
            if( sheet1.GetCellValue(Row, "type") == "B"){
                alert("<msg:txt mid='alertBoardMgr2' mdef='게시판 의 하위메뉴를 작성할 수 없습니다.'/>");
                return;
            }
            else { //카테고리일때
            	Row = sheet1.DataInsert();

            	sheet1.SetCellValue(Row, "mainMenuCd" ,sheet1.GetCellValue(Row-1, "mainMenuCd"));
            	sheet1.SetCellValue(Row, "priorMenuCd", sheet1.GetCellValue(Row-1, "menuCd"));
            	sheet1.SetCellValue(Row, "menuCd", getColMaxValue(sheet1, "menuCd"));

            	sheet1.InitCellProperty(Row, "bbsNm",	{Type: "Text", Align: "Left", Edit:1});
                //mySheet.InitCellProperty(Row, "BBS_NM", dtData, daNull, "BBS_NM");

                //mySheet.CellEditable(Row, "CNT") = false;

                sheet1.SetCellValue(Row, "bbsCd", "");
                sheet1.SetCellValue(Row, "useYn", "");
                sheet1.SetCellValue(Row, "notifyYn", "");
                sheet1.SetCellValue(Row, "manageAllYn", "");
                sheet1.SetCellValue(Row, "searchAllYn", "");
                sheet1.SetCellValue(Row, "replyYn", "");
                sheet1.SetCellValue(Row, "commentYn", "");

                sheet1.SetCellValue(Row, "adminImg", "");
                sheet1.SetCellValue(Row, "manageImg", "");
                sheet1.SetCellValue(Row, "searchImg", "");

                sheet1.SetCellEditable(Row, "bbsCd",false);
                sheet1.SetCellEditable(Row, "useYn",false);
                sheet1.SetCellEditable(Row, "notifyYn",false);
                sheet1.SetCellEditable(Row, "manageAllYn", false);
                sheet1.SetCellEditable(Row, "searchAllYn", false);
                sheet1.SetCellEditable(Row, "adminImg", false);
                sheet1.SetCellEditable(Row, "manageImg", false);
                sheet1.SetCellEditable(Row, "searchImg", false);
                sheet1.SetCellEditable(Row, "replyYn", false);
                sheet1.SetCellEditable(Row, "commentYn", false);
                sheet1.SetCellEditable(Row, "fileName", false);

                sheet1.SelectCell(Row, "bbsNm");
            }

            break;

		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {if (Msg != "") {alert(Msg);}sheetResize();

			sheet1.SetRowEditable(2,0);

		    for(i=2 ; i<= sheet1.LastRow(); i++) {
		        if (sheet1.GetCellValue(i, "type") == "C") {  //카테고리일때
		        	//sheet1.InitCellProperty(i, "BBS_NM", dtData, daNull, "BBS_NM");
		        	sheet1.InitCellProperty(i, "bbsNm",	{Type: "Text", Align: "Left", Edit:1});

	                sheet1.SetCellValue(i, "bbsCd", "");
	                sheet1.SetCellValue(i, "useYn", "");
	                sheet1.SetCellValue(i, "notifyYn", "");
	                sheet1.SetCellValue(i, "manageAllYn", "");
	                sheet1.SetCellValue(i, "searchAllYn", "");
	                sheet1.SetCellValue(i, "replyYn", "");
	                sheet1.SetCellValue(i, "commentYn", "");

	                //sheet1.SetCellValue(i, "adminImg", "");
	                //sheet1.SetCellValue(i, "manageImg", "");
	                //sheet1.SetCellValue(i, "searchImg", "");

	                sheet1.SetCellEditable(i, "bbsCd", false);
	                sheet1.SetCellEditable(i, "useYn", false);
	                sheet1.SetCellEditable(i, "notifyYn", false);
	                sheet1.SetCellEditable(i, "manageAllYn", false);
	                sheet1.SetCellEditable(i, "searchAllYn", false);
	                sheet1.SetCellEditable(i, "adminImg", false);
	                sheet1.SetCellEditable(i, "manageImg", false);
	                sheet1.SetCellEditable(i, "searchImg", false);
	                sheet1.SetCellEditable(i, "replyYn", false);
	                sheet1.SetCellEditable(i, "commentYn", false);
	                sheet1.SetCellEditable(i, "fileName", false);

	                //DB에  잘못들어간경우 수정상태로 변경됨
	                sheet1.SetCellValue(i, "sStatus" ,"R");

		        }
		        else if (sheet1.GetCellValue(i, "type") == "B") {  //게시판일때
		        	sheet1.InitCellProperty(i, "bbsNm",	{Type: "Text", Align: "Left", Edit:1});
		            //mySheet.InitCellProperty(i, "BBS_NM", dtData, daNull, "BBS_NM");
		        }
		    }

		}
		catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}



	function sheet1_OnChange(Row, Col,	Value){

		//try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnChange Event Error " + ex); }
		if(sheet1.ColSaveName(Col)=="searchAllYn") {
			if (sheet1.GetCellValue(Row, "searchAllYn") == "Y") {
				sheet1.SetCellValue(Row, "searchAllSeq", "");
				sheet1.SetCellValue(Row, "searchAllDesc", "");
			}
		}
		if(sheet1.ColSaveName(Col)=="manageAllYn") {
			if (sheet1.GetCellValue(Row, "manageAllYn") == "Y") {
				sheet1.SetCellValue(Row, "manageAllSeq", "");
				sheet1.SetCellValue(Row, "manageAllDesc", "");
			}
		}
		if(sheet1.ColSaveName(Col)=="type") {
			if (sheet1.GetCellValue(Row, "type") == "C") {  //카테고리일때
				sheet1.InitCellProperty(Row, "bbsNm",	{Type: "Text", Align: "Left", Edit:1});

	            sheet1.SetCellValue(Row, "bbsCd", "");
                sheet1.SetCellValue(Row, "useYn", "");
                sheet1.SetCellValue(Row, "notifyYn", "");
                sheet1.SetCellValue(Row, "manageAllYn", "");
                sheet1.SetCellValue(Row, "searchAllYn", "");
                sheet1.SetCellValue(Row, "replyYn", "");
                sheet1.SetCellValue(Row, "commentYn", "");

                sheet1.SetCellValue(Row, "adminImg", "");
                sheet1.SetCellValue(Row, "manageImg", "");
                sheet1.SetCellValue(Row, "searchImg", "");

                sheet1.SetCellEditable(Row, "bbsCd",false);
                sheet1.SetCellEditable(Row, "useYn",false);
                sheet1.SetCellEditable(Row, "notifyYn",false);
                sheet1.SetCellEditable(Row, "manageAllYn", false);
                sheet1.SetCellEditable(Row, "searchAllYn", false);
                sheet1.SetCellEditable(Row, "replyYn", false);
                sheet1.SetCellEditable(Row, "commentYn", false);

                sheet1.SetCellEditable(Row, "adminImg", false);
                sheet1.SetCellEditable(Row, "manageImg", false);
                sheet1.SetCellEditable(Row, "searchImg", false);
                sheet1.SetCellEditable(Row, "fileName", false);

	        }
	        else if(sheet1.GetCellValue(Row, "type") == "B"){

	        	if ( sheet1.IsHaveChild(Row)) {
	                alert("<msg:txt mid='alertBoardMgr3' mdef='하위 매뉴가 존재하므로 게시판으로 수정할 수 없습니다.'/>");
	                sheet1.SetCellValue(Row, "TYPE", "C");
	                return false;
	            }
	            sheet1.InitCellProperty(Row, "bbsNm",	{Type: "Text", Align: "Left", Edit:1});
                sheet1.SetCellValue(Row, "bbsCd", "");
                sheet1.SetCellValue(Row, "useYn", "");
                sheet1.SetCellValue(Row, "notifyYn", "");
                sheet1.SetCellValue(Row, "manageAllYn", "N");
                sheet1.SetCellValue(Row, "searchAllYn", "N");
                sheet1.SetCellValue(Row, "replyYn", "N");
                sheet1.SetCellValue(Row, "commentYn", "N");
                sheet1.SetCellValue(Row, "adminImg", 0);
                sheet1.SetCellValue(Row, "manageImg", 0);
                sheet1.SetCellValue(Row, "searchImg", 0);
                sheet1.SetCellEditable(Row, "bbsCd",true);
                sheet1.SetCellEditable(Row, "useYn",true);
                sheet1.SetCellEditable(Row, "notifyYn",true);
                sheet1.SetCellEditable(Row, "manageAllYn", true);
                sheet1.SetCellEditable(Row, "searchAllYn", true);
                sheet1.SetCellEditable(Row, "adminImg", true);
                sheet1.SetCellEditable(Row, "manageImg", true);
                sheet1.SetCellEditable(Row, "searchImg", true);
                sheet1.SetCellEditable(Row, "replyYn", true);
                sheet1.SetCellEditable(Row, "commentYn", true);
                sheet1.SetCellEditable(Row, "fileName", true);
	        }
    	}
	}

	   //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
	   function sheet1_OnPopupClick(Row, Col){
	       try{

	         var colName = sheet1.ColSaveName(Col);
	         var args    = new Array();

	         var rv = null;

			 if(colName == "manageAllDesc") {
		    	 if(!isPopup()) {return;}
				 if(sheet1.GetCellValue(Row, "manageAllYn") == "Y") {
					 alert("<msg:txt mid='alertBoardMgr4' mdef='작성권한이 전사일때는 대상자를 지정할 수 없습니다.'/>");
					 return;
				 }

				 var args = { searchSeq:sheet1.GetCellValue(Row, "manageAllSeq"), searchDesc: sheet1.GetCellValue(Row, "manageAllDesc") };
	             let layerModal = new window.top.document.LayerModal({
					  id : 'pwrSrchMgrLayer', 
					  url : '/Popup.do?cmd=viewPwrSrchMgrLayer&authPg=${authPg}', 
					  parameters : args, 
					  width : 760, 
					  height : 520, 
					  title : "<tit:txt mid='112392' mdef='조건 검색 관리'/>",
					  trigger :[
						{
							name : 'pwrTrigger', 
							callback : function(result){
								sheet1.SetCellValue(Row, "manageAllSeq", result["searchSeq"] );
								sheet1.SetCellValue(Row, "manageAllDesc", result["searchDesc"] );
							}
						}
					]
				});
				layerModal.show();
	         }else if(colName == "searchAllDesc") {
		    	 if(!isPopup()) {return;}
				 if(sheet1.GetCellValue(Row, "searchAllYn") == "Y") {
					 alert("<msg:txt mid='alertBoardMgr4' mdef='작성권한이 전사일때는 대상자를 지정할 수 없습니다.'/>");
					 return;
				 }
		         // 대상자검색설명
				 var args = { searchSeq: sheet1.GetCellValue(Row, "searchAllSeq"), searchDesc: sheet1.GetCellValue(Row, "searchAllDesc") };
	             let layerModal = new window.top.document.LayerModal({
					  id : 'pwrSrchMgrLayer', 
					  url : '/Popup.do?cmd=viewPwrSrchMgrLayer&authPg=R', 
					  parameters : args, 
					  width : 760, 
					  height : 520, 
					  title : "<tit:txt mid='112392' mdef='조건 검색 관리'/>",
					  trigger :[
						{
							name : 'pwrTrigger', 
							callback : function(result){
								sheet1.SetCellValue(Row, "searchAllSeq", result["searchSeq"] );
								sheet1.SetCellValue(Row, "searchAllDesc", result["searchDesc"] );
							}
						}
					]
				});
				layerModal.show();
	         }

	       }catch(ex){alert("OnPopupClick Event Error : " + ex);}
	   }

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
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

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		switch(sheet1.ColSaveName(Col)){

	        case "adminImg":  //관리자
	        	if(!isPopup()) {return;}
	        	if(sheet1.GetCellValue(Row, "sStatus") != "R"	&& Row >= sheet1.HeaderRows()){alert("<msg:txt mid='alertBoardMgr5' mdef='해당 로우를 저장후 선택하세요'/>");return;}
	        	if(sheet1.GetCellImage(Row, "adminImg") == "") return;
				var args = { bbsCd: sheet1.GetCellValue( Row, "bbsCd" ) };
				var url = '/BoardMgr.do?cmd=viewBoardAdminMgrLayer&authPg=A';
				var layerModal = new window.top.document.LayerModal({
					  id : 'boardAdminMgrLayer', 
					  url : url, 
					  parameters : args, 
					  width : 760, 
					  height : 520, 
					  title : "<tit:txt mid='boardAdminMgr' mdef='게시판관리자'/>"
				});
				layerModal.show();
	        	break;
	        case "manageImg":  //작성권한
	        	if(sheet1.GetCellValue(Row, "sStatus") != "R"	&& Row >= sheet1.HeaderRows()){alert("<msg:txt mid='alertBoardMgr5' mdef='해당 로우를 저장후 선택하세요'/>");return;}
	        	if(sheet1.GetCellImage(Row, "manageImg") == "") return;
	        	var args = { bbsCd: sheet1.GetCellValue( Row, "bbsCd" ),
	    	        		 gbCd: 'A002',
	    	        		 Row: Row,
	    	        		 Col: Col };
       		 	var title = "<tit:txt mid='boardAuthMgr' mdef='게시판관리자'/>";
       		 	var url = "/BoardMgr.do?cmd=viewBoardAuthMgrLayer&authPg=A";
       		 	var w = 740, h = 520;
	       		var layerModal = new window.top.document.LayerModal({
					  id : 'boardAuthMgrLayer', 
					  url : url, 
					  parameters : args, 
					  width : w, 
					  height : h,
					  title : title
				});
				layerModal.show();
	            break;
	        case "searchImg":  //조회권한
	        	if(sheet1.GetCellValue(Row, "sStatus") != "R"	&& Row >= sheet1.HeaderRows()){alert("<msg:txt mid='alertBoardMgr5' mdef='해당 로우를 저장후 선택하세요'/>");return;}
	        	if(sheet1.GetCellImage(Row, "searchImg") == "") return;
				var args = { bbsCd: sheet1.GetCellValue( Row, "bbsCd" ),
		   	        		 gbCd: 'A003',
		   	        		 Row: Row,
		   	        		 Col: Col };
	  		 	var title = "<tit:txt mid='boardAuthMgr' mdef='게시판관리자'/>";
	  		 	var url = "/BoardMgr.do?cmd=viewBoardAuthMgrLayer&authPg=A";
	  		 	var w = 740, h = 520;
	      		var layerModal = new window.top.document.LayerModal({
					  id : 'boardAuthMgrLayer', 
					  url : url, 
					  parameters : args, 
					  width : w, 
					  height : h,
					  title : title
				});
				layerModal.show();
	            break;
	        case "fileName": //파일업로드
	        	if(sheet1.GetCellValue(Row, "sStatus") != "R"	&& Row >= sheet1.HeaderRows()){alert("<msg:txt mid='alertBoardMgr5' mdef='해당 로우를 저장후 선택하세요'/>");return;}
	        	alert(4);
	            break;
	    }

	}



	function sheet1_OnMouseMove(Button, Shift, X, Y) {
		try {
			var Row = sheet1.MouseRow();
			var Col = sheet1.MouseCol();

			switch(sheet1.ColSaveName(Col)){
		        case "adminImg":  //관리자
		        	if(sheet1.GetCellValue(Row, "sStatus") != "R"){return;}
		        	(sheet1.GetCellImage(Row, "adminImg") == "") ? sheet1.SetDataLinkMouse("adminImg", 0):sheet1.SetDataLinkMouse("adminImg", 1);
		        	break;

		        case "manageImg":  //작성권한
		        	if(sheet1.GetCellValue(Row, "sStatus") != "R"){return;}
		        	(sheet1.GetCellImage(Row, "manageImg") == "") ? sheet1.SetDataLinkMouse("manageImg", 0):sheet1.SetDataLinkMouse("manageImg", 1);
		            break;

		        case "searchImg":  //조회권한
		        	if(sheet1.GetCellValue(Row, "sStatus") != "R"){return;}
		        	(sheet1.GetCellImage(Row, "searchImg") == "") ? sheet1.SetDataLinkMouse("searchImg", 0):sheet1.SetDataLinkMouse("searchImg", 1);
		            break;
		        case "fileName": //파일업로드
		        	if(sheet1.GetCellValue(Row, "sStatus") != "R"){return;}
		            break;
		    }


		}catch(ex){alert("OnMouseMove Event Error : " + ex);}
	}





</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='boardMgr' mdef='게시판관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Search')" css="btn dark authR" mid='110697' mdef="조회"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
