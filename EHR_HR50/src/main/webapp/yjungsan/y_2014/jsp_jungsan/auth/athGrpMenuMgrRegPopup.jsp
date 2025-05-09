<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>권한그룹프로그램팝업</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script	type="text/javascript">

	var p = eval("<%=popUpStatus%>");
	var mainMenuCd = "";
	var athGrpCd   = "";
	
	$(function() {
		var arg = p.window.dialogArguments;	
	    if( arg != undefined ) {
	    	mainMenuCd  = arg["mainMenuCd"];
	    	athGrpCd    = arg["athGrpCd"];
	    }else{
			mainMenuCd 	= p.popDialogArgument("mainMenuCd");
			athGrpCd 	= p.popDialogArgument("athGrpCd");
		}
		
		$("#mainMenuCd").val(mainMenuCd);
		$("#athGrpCd").val(athGrpCd);
		var	initdata = {};
		initdata.Cfg = {FrozenCol:10,SearchMode:smLazyLoad,Page:22, ChildPage:5};
		initdata.HeaderMode	= {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols =	[
			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"메인메뉴코드",			Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"main_menu_cd",	KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"상위메뉴",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"prior_menu_cd",	KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"메뉴",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menu_cd",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"순번",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menu_seq",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"권한그룹",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"grp_cd",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"구분",				Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"type",		KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"메뉴/프로그램명",		Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"menu_nm",		KeyField:1,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TreeCol:1	},
			{Header:"프로그램",				Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"prg_cd",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"조건검색코드",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"search_seq",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:100	},
			{Header:"조건검색",				Type:"Text",	Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"search_desc",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:100	},
			{Header:"적용권한",				Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"data_prg_type",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"프로그램\n권한",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"data_rw_type",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"사용\n여부",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"use_yn",		KeyField:0,	Format:"",		 UpdateEdit:1,	 InsertEdit:1,	 EditLen:1 },
			{Header:"사용시작일",			Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"inq_s_ymd",		KeyField:0,	Format:"Ymd",	 UpdateEdit:1,	 InsertEdit:1,	 EditLen:8 },
			{Header:"사용종료일",			Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"inq_e_ymd",		KeyField:0,	Format:"Ymd",	 UpdateEdit:1,	 InsertEdit:1,	 EditLen:8 },
			{Header:"ONEPAGE\nROWS",	Type:"Int",		Hidden:1,	Width:45,	Align:"Right",	ColMerge:0,	SaveName:"cnt",			KeyField:0,	Format:"Integer",UpdateEdit:1,	 InsertEdit:1,	 EditLen:20	},
			{Header:"순서",				Type:"Int",		Hidden:0,	Width:45,	Align:"Right",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"Integer",UpdateEdit:1,	 InsertEdit:1,	 EditLen:20	},
			{Header:"비밀번호\n체크여부",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"popup_use_yn",	KeyField:0,	Format:"",		 UpdateEdit:1,	 InsertEdit:1,	 EditLen:20	},
			{Header:"최종조회사원\n유지여부",	Type:"Text",	Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"last_session_use_yn",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"조회가능범위\n사용여부",	Type:"Text",	Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"search_use_yn",			KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);
		
		sheet1.SetCountPosition(4);
		
		sheet1.SetColProperty("type",					{ComboText:"메뉴|프로그램|조건검색|탭",	ComboCode:"M|P|S|T"} );
		sheet1.SetColProperty("data_rw_type",			{ComboText:"읽기/쓰기|읽기",			ComboCode:"A|R"} );
		sheet1.SetColProperty("data_prg_type",			{ComboText:"사용자권한|프로그램권한",	ComboCode:"U|P"} );
		sheet1.SetColProperty("use_yn",					{ComboText:"사용|사용안함",			ComboCode:"Y|N"} );
		sheet1.SetColProperty("popup_use_yn",			{ComboText:"사용|사용안함",			ComboCode:"Y|N"} );
		sheet1.SetColProperty("last_session_use_yn",	{ComboText:"유지|유지안함",			ComboCode:"Y|N"} );
		sheet1.SetColProperty("search_use_yn",			{ComboText:"사용|자신만조회",			ComboCode:"Y|N"} );

		$(window).smartresize(sheetResize);	sheetInit();

		doAction("Search");
		$(".close").click(function() {
			p.self.close();
		});

		$("#btnPlus").click(function() {
			sheet1.ShowTreeLevel(-1);
		});

		$("#btnStep1").click(function()	{
			sheet1.ShowTreeLevel(0, 1);
		});

		$("#btnStep2").click(function()	{
			sheet1.ShowTreeLevel(1,2);
		});

		$("#btnStep3").click(function()	{
			sheet1.ShowTreeLevel(-1);
		});

	});

	//Sheet	Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":		
			sheet1.DoSearch( "<%=jspPath%>/auth/athGrpMenuMgrRst.jsp?cmd=selectAthGrpMenuMgrRegPopList", $("#mySheetForm").serialize()	);
			break;
		case "Save":
			sheet1.DoSave(	"<%=jspPath%>/auth/athGrpMenuMgrRst.jsp?cmd=saveAthGrpMenuMgrRegPop");
			break;
		case "Insert":
			insertAction();
			break;
		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy());
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			sheet1.Down2Excel();
			break;
		case "LoadExcel":
			var	params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	function insertAction()	{
		var	Row	= sheet1.GetSelectRow();
		if(	sheet1.GetRowLevel(Row) ==	4 )	{
			alert("현 단계	이하의	메뉴/프로그램/탭은 등록할 수 없습니다.");
			return;
		}
		//조건검색,	탭일때
		if(sheet1.GetCellValue(Row, "type") ==	"S"	|| sheet1.GetCellValue(Row, "type") ==	"T"){
			alert("조건검색/탭 의	하위메뉴를 작성할 수	없습니다.");
			return;
		}else {
			Row	= sheet1.DataInsert();
			sheet1.SetCellValue(Row, "main_menu_cd",mainMenuCd);
			sheet1.SetCellValue(Row, "prior_menu_cd",sheet1.GetCellValue(Row-1,	"menu_cd"));
			sheet1.SetCellValue(Row, "menu_cd",getColMaxValue(sheet1, "menu_cd"));
			sheet1.SetCellValue(Row, "grp_cd",athGrpCd);
			sheet1.InitCellProperty(Row, "menu_nm",	{Type: "Text", Align: "Left", Edit:1});
			sheet1.SetCellValue(Row, "prg_cd","");
			sheet1.SetCellEditable(Row, "cnt",false);
			sheet1.SetCellValue(Row, "data_rw_type","");
			sheet1.SetCellValue(Row, "data_prg_type","");
			sheet1.SetCellEditable(Row, "data_rw_type",false);
			sheet1.SetCellEditable(Row, "data_prg_type",false);
			sheet1.SetCellValue(Row, "inq_s_ymd","");
			sheet1.SetCellValue(Row, "inq_e_ymd","");
			sheet1.SetCellEditable(Row, "inq_s_ymd",false);
			sheet1.SetCellEditable(Row, "inq_e_ymd",false);
			sheet1.InitCellProperty(Row, "search_desc",	{Type: "Text", Align: "Left", Edit:1});
			sheet1.SetCellValue(Row, "search_seq","");
			sheet1.SetCellValue(Row, "search_desc","");
			sheet1.SetCellEditable(Row, "search_desc",false);
			sheet1.SetCellEditable(Row, "popup_use_yn",false);
			sheet1.SetCellEditable(Row, "last_session_use_yn",false);
			sheet1.SetCellEditable(Row, "search_use_yn",false);
			sheet1.SetCellValue(Row, "popup_use_yn","");
			sheet1.SetCellValue(Row, "last_session_use_yn","");
			sheet1.SetCellValue(Row, "search_use_yn","");
			//프로그램일때 탭선택후 수정불가 처리
			if(sheet1.GetCellValue(Row-1, "type") == "P"){
				sheet1.SetCellValue(Row, "type","T");
				sheet1.SetCellEditable(Row,"type",false);
				sheet1.InitCellProperty(Row, "menu_nm",	{Type: "PopupEdit",	Align: "Left", Edit:1});
				sheet1.SetCellValue(Row, "cnt",'100');
				sheet1.SetCellEditable(Row, "cnt",true);
				sheet1.SetCellEditable(Row, "data_prg_type",true);
				if(sheet1.GetCellValue(Row, "data_prg_type")	== "P" ) { //프로그램권한
					sheet1.SetCellEditable(Row, "data_rw_type",true);
					if(sheet1.GetCellValue(Row, "data_rw_type") == "") {
						sheet1.SetCellValue(Row, "data_rw_type","A");
					}
				} else if(sheet1.GetCellValue(Row,	"data_prg_type") == "U" )	{ //사용자권한
					sheet1.SetCellValue(Row, "data_rw_type","");
					sheet1.SetCellEditable(Row, "data_rw_type",false);
				} else {
					sheet1.SetCellValue(Row, "data_prg_type","U");
					sheet1.SetCellValue(Row, "data_rw_type","");
					sheet1.SetCellEditable(Row, "data_rw_type",false);
				}

				sheet1.SetCellValue(Row, "use_yn","Y");
				sheet1.SetCellValue(Row, "inq_s_ymd","<%=curSysYyyyMMdd%>");
				sheet1.SetCellValue(Row, "inq_e_ymd","99991231");

				sheet1.SetCellValue(Row, "popup_use_yn","");
				//sheet1.CellValue(Row, "last_session_use_yn") = "Y";
				//sheet1.CellValue(Row, "search_use_yn")	= "Y";
				sheet1.SetCellEditable(Row, "use_yn",true);
				sheet1.SetCellEditable(Row, "inq_s_ymd",true);
				sheet1.SetCellEditable(Row, "inq_e_ymd",true);
				sheet1.InitCellProperty(Row, "search_desc",	{Type: "Text", Align: "Left", Edit:1});
				sheet1.SetCellValue(Row, "search_seq","");
				sheet1.SetCellValue(Row, "search_desc","");
				sheet1.SetCellEditable(Row, "search_desc",false);
				sheet1.SetCellEditable(Row, "popup_use_yn",true);
				sheet1.SetCellEditable(Row, "last_session_use_yn",true);
				sheet1.SetCellEditable(Row, "search_use_yn",true);
			}
			sheet1.SelectCell(Row,	"menu_nm");
		}
	}
	
	function sheet1_OnSearchEnd(Code, Msg,	StCode,	StMsg){
		try{
			if (Msg != ""){
				alert(Msg);
			}

			sheet1.SetRowEditable(1,false);
			sheet1.ShowTreeLevel(-1);
			sheet1.SetRowEditable(1,false);
	
			for(i	= 1; i<=sheet1.LastRow(); i++)	{
				if (sheet1.GetCellValue(i, "type") == "M") {
					sheet1.InitCellProperty(i, "menu_nm",	{Type: "Text", Align: "Left", Edit:1});
					sheet1.SetCellValue(i, "prg_cd","");
					sheet1.SetCellEditable(i, "cnt",false);
					
					sheet1.SetCellValue(i, "data_rw_type","");
					sheet1.SetCellValue(i, "data_prg_type","");
					sheet1.SetCellEditable(i,	"data_rw_type",false);
					sheet1.SetCellEditable(i, "data_prg_type",false);
	
					//sheet1.CellValue(i, "use_yn") =	"";
					sheet1.SetCellValue(i, "inq_s_ymd","");
					sheet1.SetCellValue(i, "inq_e_ymd","");
					
					//sheet1.CellEditable(i,	"use_yn") = false;
					sheet1.SetCellEditable(i,	"inq_s_ymd",false);
					sheet1.SetCellEditable(i, "inq_e_ymd",false);
	
					sheet1.InitCellProperty(i, "search_desc",	{Type: "Text", Align: "Left", Edit:1});
					sheet1.SetCellValue(i, "search_seq","");
					sheet1.SetCellValue(i, "search_desc","");
					sheet1.SetCellEditable(i, "search_desc",false);
					sheet1.SetCellEditable(i, "popup_use_yn",false);
					sheet1.SetCellEditable(i, "last_session_use_yn",false);
					sheet1.SetCellEditable(i, "search_use_yn",false);
				}
				else if (sheet1.GetCellValue(i, "type") == "P") {
					sheet1.InitCellProperty(i, "menu_nm",	{Type: "PopupEdit",	Align: "Left", Edit:1});
					
					sheet1.InitCellProperty(i, "search_desc",	{Type: "Text", Align: "Left", Edit:1});
					sheet1.SetCellValue(i, "search_seq","");
					sheet1.SetCellValue(i, "search_desc","");
					sheet1.SetCellEditable(i, "search_desc",false);
					
					sheet1.SetCellEditable(i, "data_prg_type",true);
	
					if(sheet1.GetCellValue(i, "data_prg_type")	== "P" ) { //프로그램권한
						sheet1.SetCellEditable(i, "data_rw_type",true);
					} else if(	sheet1.GetCellValue(i,	"data_prg_type") == "U" )	{ //사용자권한
						sheet1.SetCellValue(i, "data_rw_type","");
						sheet1.SetCellEditable(i, "data_rw_type",false);
					}
	
					sheet1.SetCellEditable(i, "use_yn",true);
					sheet1.SetCellEditable(i,	"inq_s_ymd",true);
					sheet1.SetCellEditable(i, "inq_e_ymd",true);
				}
				else if (sheet1.GetCellValue(i, "type") == "S") {
					sheet1.InitCellProperty(i, "menu_nm",	{Type: "PopupEdit",	Align: "Left", Edit:1});
					
					sheet1.InitCellProperty(i, "search_desc",	{Type: "Popup",	Align: "Left", Edit:1});
					sheet1.SetCellEditable(i, "search_desc",true);
					
					sheet1.SetCellEditable(i, "data_prg_type",true);
					if( sheet1.GetCellValue(i, "data_prg_type")	== "P" ) { //프로그램권한
						sheet1.SetCellEditable(i, "data_rw_type",true);
					} else if(	sheet1.GetCellValue(i,	"data_prg_type") == "U" )	{ //사용자권한
						sheet1.SetCellValue(i, "data_rw_type","");
						sheet1.SetCellEditable(i, "data_rw_type",false);
					}
					
					sheet1.SetCellEditable(i, "use_yn",true);
					sheet1.SetCellEditable(i,	"inq_s_ymd",true);
					sheet1.SetCellEditable(i, "inq_e_ymd",true);
				}
				else if (sheet1.GetCellValue(i, "type") == "T") {
					sheet1.InitCellProperty(i, "menu_nm",	{Type: "PopupEdit",	Align: "Left", Edit:1});
					
					sheet1.InitCellProperty(i, "search_desc",	{Type: "Text", Align: "Left", Edit:1});
					sheet1.SetCellValue(i, "search_seq","");
					sheet1.SetCellValue(i, "search_desc","");
					sheet1.SetCellEditable(i, "search_desc",false);
					
					sheet1.SetCellEditable(i, "data_prg_type",true);
					if(	 sheet1.GetCellValue(i, "data_prg_type")	== "P" ) { //프로그램권한
						sheet1.SetCellEditable(i, "data_rw_type",true);
					} else if(	sheet1.GetCellValue(i,	"data_prg_type") == "U" )	{ //사용자권한
						sheet1.SetCellValue(i, "data_rw_type","");
						sheet1.SetCellEditable(i, "data_rw_type",false);
					}
	
					sheet1.SetCellEditable(i, "use_yn",true);
					sheet1.SetCellEditable(i,	"inq_s_ymd",true);
					sheet1.SetCellEditable(i, "inq_e_ymd",true);
				}
	
				if( "A" == "A" ) {
					sheet1.SetCellValue(i, "sStatus", "R");
				}
			}
		}catch(ex){alert("OnSearchEnd Event	Error :	" +	ex);}
	}
	
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg){
		try{
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction("Search");
			}
		}catch(ex){alert("OnSaveEnd	Event Error	: "	+ ex);}
	}
	
	function sheet1_OnChange(Row, Col,	Value){

		//try{
			if(sheet1.ColSaveName(Col)	== "inq_s_ymd" ||	sheet1.ColSaveName(Col) ==	"inq_e_ymd") {
				//시작일자 종료일자	체크하기
				var	message	= "권한별프로그램리스트의 ";
				checkNMDate(sheet1, Row, Col, message,	"inq_s_ymd", "inq_e_ymd");
			}
			if(sheet1.ColSaveName(Col)=="type") {
				if (sheet1.GetCellValue(Row, "type") == "M") {
					sheet1.InitCellProperty(Row, "menu_nm",	{Type: "Text", Align: "Left", Edit:1});
					sheet1.SetCellValue(Row, "prg_cd","");
					sheet1.SetCellValue(Row, "cnt",0);
					sheet1.SetCellEditable(Row, "cnt",false);
					sheet1.SetCellValue(Row, "data_rw_type","");
					sheet1.SetCellValue(Row, "data_prg_type","");
					sheet1.SetCellEditable(Row, "data_rw_type",false);
					sheet1.SetCellEditable(Row, "data_prg_type",false);
					sheet1.SetCellValue(Row, "inq_s_ymd","");
					sheet1.SetCellValue(Row, "inq_e_ymd","");
					sheet1.SetCellValue(Row, "popup_use_yn","");
					sheet1.SetCellValue(Row, "last_session_use_yn","");
					sheet1.SetCellValue(Row, "search_use_yn","");
					sheet1.SetCellEditable(Row, "inq_s_ymd",false);
					sheet1.SetCellEditable(Row, "inq_e_ymd",false);
					sheet1.InitCellProperty(Row, "search_desc",	{Type: "Text", Align: "Left", Edit:1});
					sheet1.SetCellValue(Row, "search_seq","");
					sheet1.SetCellValue(Row, "search_desc","");
					sheet1.SetCellEditable(Row, "search_desc",false);
					sheet1.SetCellEditable(Row, "popup_use_yn",false);
					sheet1.SetCellEditable(Row, "last_session_use_yn",false);
					sheet1.SetCellEditable(Row, "search_use_yn",false);
				}
				else if (sheet1.GetCellValue(Row,	"type")	== "P")	{
					if (sheet1.IsHaveChild(Row)) {
						alert("하위 매뉴가 존재하므로 프로그램으로 수정할 수 없습니다.");
						sheet1.SetCellValue(Row, "type","M");
						return false;
					}

					sheet1.InitCellProperty(Row, "menu_nm",	{Type: "PopupEdit",	Align: "Left", Edit:1});
					sheet1.SetCellValue(Row, "cnt",'100');
					sheet1.SetCellEditable(Row, "cnt",true);
					sheet1.SetCellEditable(Row, "data_prg_type",true);

					if(sheet1.GetCellValue(Row, "data_prg_type")	== "P" ) { //프로그램권한
						sheet1.SetCellEditable(Row, "data_rw_type",true);
						if(sheet1.GetCellValue(Row, "data_rw_type") == "") {
							sheet1.SetCellValue(Row, "data_rw_type","A");
						}
					}
					else if(	  sheet1.GetCellValue(Row,	"data_prg_type") == "U" )	{ //사용자권한
						sheet1.SetCellValue(Row, "data_rw_type","");
						sheet1.SetCellEditable(Row, "data_rw_type",false);
					}
					else {
						sheet1.SetCellValue(Row, "data_prg_type","U");
						sheet1.SetCellValue(Row, "data_rw_type","");
						sheet1.SetCellEditable(Row, "data_rw_type",false);
					}
					sheet1.SetCellValue(Row, "use_yn","Y");
					sheet1.SetCellValue(Row, "inq_s_ymd","<%=curSysYyyyMMdd%>");
					sheet1.SetCellValue(Row, "inq_e_ymd","99991231");
					sheet1.SetCellValue(Row, "popup_use_yn","");
					sheet1.SetCellEditable(Row, "use_yn",true);
					sheet1.SetCellEditable(Row, "inq_s_ymd",true);
					sheet1.SetCellEditable(Row, "inq_e_ymd",true);
					sheet1.InitCellProperty(Row, "search_desc",	{Type: "Text", Align: "Left", Edit:1});
					sheet1.SetCellValue(Row, "search_seq","");
					sheet1.SetCellValue(Row, "search_desc","");
					sheet1.SetCellEditable(Row, "search_desc",false);
					sheet1.SetCellEditable(Row, "popup_use_yn",true);
					sheet1.SetCellEditable(Row, "last_session_use_yn",true);
					sheet1.SetCellEditable(Row, "search_use_yn",true);
				}
				else if (sheet1.GetCellValue(Row,	"type")	== "S")	{
					if (sheet1.IsHaveChild(Row)) {
						alert("하위 매뉴가 존재하므로 조건검색으로 수정할 수 없습니다.");
						sheet1.SetCellValue(Row, "type","M");
						return false;
					}
					sheet1.SetCellValue(Row, "menu_nm","");
					sheet1.SetCellValue(Row, "prg_cd","/PwrSrchAdminUser.do?cmd=viewPwrSrchAdminUser");
					sheet1.SetCellValue(Row, "cnt",'100');
					sheet1.SetCellEditable(Row, "cnt",true);
					sheet1.SetCellEditable(Row, "data_prg_type",true);
					if(sheet1.GetCellValue(Row, "data_prg_type")	== "P" ) { //프로그램권한
						sheet1.SetCellEditable(Row, "data_rw_type",true);
						if(sheet1.GetCellValue(Row, "data_rw_type") == "") {
							sheet1.SetCellValue(Row, "data_rw_type","A");
						}
					}
					else if(sheet1.GetCellValue(Row,	"data_prg_type") == "U" )	{ //사용자권한
						sheet1.SetCellValue(Row, "data_rw_type","");
						sheet1.SetCellEditable(Row, "data_rw_type",false);
					}
					else {
						sheet1.SetCellValue(Row, "data_prg_type","U");
						sheet1.SetCellValue(Row, "data_rw_type","");
						sheet1.SetCellEditable(Row, "data_rw_type",false);
					}
					sheet1.SetCellValue(Row, "use_yn","Y");
					sheet1.SetCellValue(Row, "inq_s_ymd","<%=curSysYyyyMMdd%>");
					sheet1.SetCellValue(Row, "inq_e_ymd","99991231");
					sheet1.SetCellValue(Row, "popup_use_yn","");
					sheet1.SetCellEditable(Row, "use_yn",true);
					sheet1.SetCellEditable(Row, "inq_s_ymd",true);
					sheet1.SetCellEditable(Row, "inq_e_ymd",true);
					sheet1.InitCellProperty(Row, "search_desc",	{Type: "Popup",	Align: "Left", Edit:1});
					sheet1.SetCellEditable(Row, "search_desc",true);
					sheet1.SetCellEditable(Row, "popup_use_yn",true);
					sheet1.SetCellEditable(Row, "last_session_use_yn",true);
					sheet1.SetCellEditable(Row, "search_use_yn",true);
				}
				else if (sheet1.GetCellValue(Row,	"type")	== "T")	{
					if(sheet1.GetCellValue(Row-1, "type") != "P"){
						alert("탭은 프로그램만 선택 가능합니다.");
						sheet1.SetCellValue(Row, "type","M");
						return;
					}
				}
			}

			if(sheet1.ColSaveName(Col)=="data_prg_type") {
				if(sheet1.GetCellValue(Row, "data_prg_type")	== "P" ) { //프로그램권한
					sheet1.SetCellValue(Row, "data_rw_type","A");
					sheet1.SetCellEditable(Row, "data_rw_type",true);
				}
				else if(sheet1.GetCellValue(Row,	"data_prg_type") == "U" )	{ //사용자권한
					sheet1.SetCellValue(Row, "data_rw_type","");
					sheet1.SetCellEditable(Row, "data_rw_type",false);
				}
			}
		//}catch(ex){alert("OnChange Event Error : " + ex);}
	}

	var gPRow  = "";
	var pGubun = "";
	
	function sheet1_OnPopupClick(Row, Col){
		var	args	= new Array();
	//		args["viewCd"]	= sheet1.GetCellValue(Row,	"viewCd");
	//		args["viewNm"]	= sheet1.GetCellValue(Row,	"viewNm");
	//		args["seq"]		= sheet1.GetCellValue(Row,	"seq");
	//		args["viewDesc"]= sheet1.GetCellValue(Row,	"viewDesc");
		var	rv = null;
		try{

			if(sheet1.ColSaveName(Col)=="menu_nm") {
				
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "prgMgrPopup";
				var	rv = openPopup("<%=jspPath%>/auth/prgMgrPopup.jsp",	args, "640","520");
				/*
				if(rv!=null){
					sheet1.SetCellValue(Row, "menu_nm",		rv["menuNm"] );
					sheet1.SetCellValue(Row, "prg_cd",		rv["prgCd"]	);
				}
				*/
			}
			if(sheet1.ColSaveName(Col)=="search_desc") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "pwrSrchMgrPopup";
				var	rv = openPopup("/Popup.do?cmd=pwrSrchMgrPopup",	args, "740","520");
				/*
				if(rv!=null){
					sheet1.SetCellValue(Row, "search_seq",	rv["searchSeq"]	);
					sheet1.SetCellValue(Row, "search_desc",	rv["searchDesc"] );
				}
				*/
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}

	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "prgMgrPopup" ){
        	sheet1.SetCellValue(gPRow, "menu_nm",		rv["menuNm"] );
			sheet1.SetCellValue(gPRow, "prg_cd",		rv["prgCd"]	);
		} else if ( pGubun == "pwrSrchMgrPopup" ){
			sheet1.SetCellValue(gPRow, "search_seq",	rv["searchSeq"]	);
			sheet1.SetCellValue(gPRow, "search_desc",	rv["searchDesc"] );
		}
	}

</script>
</head>
<body class="bodywrap">
	<form id="mySheetForm">
		<input id="mainMenuCd"	name="mainMenuCd"	type="hidden"/>
		<input id="athGrpCd"	name="athGrpCd"		type="hidden"/>
	</form>
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>권한별	등록 프로그램	세부내역</li>
				<li	class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li	id="txt" class="txt">
										권한별	등록 프로그램	세부내역

										<div class="util">
										<ul>
											<li	id="btnPlus"></li>
											<li	id="btnStep1"></li>
											<li	id="btnStep2"></li>
											<li	id="btnStep3"></li>
										</ul>
										</div>
									</li>
									<li	class="btn">
										<a href="javascript:doAction('Search');"		class="basic"authR>조회</a>
										<a href="javascript:doAction('Insert');"		class="basic authA">입력</a>
										<a href="javascript:doAction('Save');"			class="basic authA">저장</a>
										<a href="javascript:doAction('Down2Excel');"	class="basic authR">다운로드</a>
									</li>
								</ul>
							</div>
						</div> <script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
					</td>
				</tr>
			</table>
			<div class="popup_button outer">
				<ul>
					<li><a href="javascript:p.self.close();" class="gray large">닫기</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>



