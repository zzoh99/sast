<%@	page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@	include	file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCtype html>	<html class="bodywrap">	<head>
<%@	include	file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@	include	file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@	include	file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script	type="text/javascript">

	var p = eval("${popUpStatus}");
	var mainMenuCd = "";
	var athGrpCd   = "";
	var gPRow = "";
	var pGubun = "";

	//var mainMenuCd = dialogArguments["mainMenuCd"];
	//var athGrpCd   = dialogArguments["athGrpCd"];
	//var mainMenuCd = "${param.mainMenuCd}";
	//var athGrpCd   = "${param.athGrpCd}";

	$(function() {
		var arg = p.window.dialogArguments;
	    if( arg != undefined ) {
	    	mainMenuCd  = arg["mainMenuCd"];
	    	athGrpCd    = arg["athGrpCd"];
	    }else{
	    	if(p.popDialogArgument("mainMenuCd")!=null)		mainMenuCd  	= p.popDialogArgument("mainMenuCd");
	    	if(p.popDialogArgument("athGrpCd")!=null)		athGrpCd  		= p.popDialogArgument("athGrpCd");
	    }

		$("#mainMenuCd").val(mainMenuCd);
		$("#athGrpCd").val(athGrpCd);

		var	initdata = {};
		initdata.Cfg = {FrozenCol:10,SearchMode:smLazyLoad,Page:22, ChildPage:5};
		initdata.HeaderMode	= {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols =	[
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='mainMenuCd' mdef='메인메뉴코드'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"mainMenuCd",	KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='priorMenuCd' mdef='상위메뉴'/>",					Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"priorMenuCd",	KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='menuCd' mdef='메뉴'/>",						Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menuCd",		KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",						Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menuSeq",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>",					Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"grpCd",		KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",						Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"type",		KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='koKrV5' mdef='메뉴/프로그램명'/>",				Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"menuNm",		KeyField:1,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TreeCol:1	},
			{Header:"<sht:txt mid='prgCdV2' mdef='프로그램'/>",					Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"prgCd",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='searchSeqV2' mdef='조건검색코드'/>",				Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"searchSeq",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:100	},
			{Header:"<sht:txt mid='searchDescV1' mdef='조건검색'/>",					Type:"Text",	Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"searchDesc",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:100	},
			{Header:"<sht:txt mid='dataPrgType' mdef='적용권한'/>",					Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"dataPrgType",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='dataPrgTypeV2' mdef='프로그램\n권한'/>",				Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"dataRwType",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='useYnV3' mdef='사용\n여부'/>",					Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",		 UpdateEdit:1,	 InsertEdit:1,	 EditLen:1 },
			{Header:"<sht:txt mid='inqSYmd' mdef='사용시작일'/>",					Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"inqSYmd",		KeyField:0,	Format:"Ymd",	 UpdateEdit:1,	 InsertEdit:1,	 EditLen:10 },
			{Header:"<sht:txt mid='inqEYmd' mdef='사용종료일'/>",					Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"inqEYmd",		KeyField:0,	Format:"Ymd",	 UpdateEdit:1,	 InsertEdit:1,	 EditLen:10 },
			{Header:"<sht:txt mid='cnt' mdef='ONEPAGE\nROWS'/>",			Type:"Int",		Hidden:1,	Width:45,	Align:"Right",	ColMerge:0,	SaveName:"cnt",			KeyField:0,	Format:"Integer",UpdateEdit:1,	 InsertEdit:1,	 EditLen:20	},
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",						Type:"Int",		Hidden:0,	Width:45,	Align:"Right",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"Integer",UpdateEdit:1,	 InsertEdit:1,	 EditLen:20	},
			{Header:"<sht:txt mid='popupUseYn' mdef='비밀번호\n체크여부'/>",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"popupUseYn",	KeyField:0,	Format:"",		 UpdateEdit:1,	 InsertEdit:1,	 EditLen:20	},
			{Header:"<sht:txt mid='lastSessionUseYn' mdef='최종조회사원\n유지여부'/>",		Type:"Text",	Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"lastSessionUseYn",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='searchUseYn' mdef='조회가능범위\n사용여부'/>",		Type:"Text",	Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"searchUseYn",			KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);
		sheet1.SetColProperty("type",			{ComboText:"메뉴|프로그램|조건검색|탭",	ComboCode:"M|P|S|T"} );
		sheet1.SetColProperty("dataRwType",	{ComboText:"읽기/쓰기|읽기",			ComboCode:"A|R"} );
		sheet1.SetColProperty("dataPrgType",	{ComboText:"사용자권한|프로그램권한",	ComboCode:"U|P"} );
		sheet1.SetColProperty("useYn",			{ComboText:"사용|사용안함",				ComboCode:"Y|N"} );
		sheet1.SetColProperty("popupUseYn",	{ComboText:"사용|사용안함",				ComboCode:"Y|N"} );
		sheet1.SetColProperty("lastSessionUseYn",	{ComboText:"유지|유지안함",			ComboCode:"Y|N"} );
		sheet1.SetColProperty("searchUseYn",	{ComboText:"사용|자신만조회",				ComboCode:"Y|N"} );
		$(window).smartresize(sheetResize);	sheetInit();

		//sheet1.SetVisible(1);

		doAction("Search");
		$(".close").click(function() {
			p.self.close();
		});

		$("#btnPlus").toggleClass("minus");

		// 트리레벨 정의
		$("#btnStep1").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			if(!$("#btnPlus").hasClass("minus")){
				$("#btnPlus").toggleClass("minus");
				sheet1.ShowTreeLevel(-1);
			}
		});
		$("#btnPlus").click(function() {
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?sheet1.ShowTreeLevel(-1):sheet1.ShowTreeLevel(0, 1);
		});

	});

	//Sheet	Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":		sheet1.DoSearch( "${ctx}/AthGrpMenuMgr.do?cmd=getAthGrpMenuMgrRegPopupList", $("#mySheetForm").serialize()	); break;
		case "Save":
							IBS_SaveName(document.mySheetForm,sheet1);
							sheet1.DoSave( "${ctx}/AthGrpMenuMgr.do?cmd=saveAthGrpMenuMgrRegPopup", $("#mySheetForm").serialize() ); break;

		case "Insert":		insertAction();	break; //	sheet1.SelectCell(sheet1.DataInsert(0), "column1"); break;
		case "Copy":		sheet1.SelectCell(sheet1.DataCopy(), "column1"); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var	params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	function insertAction()	{
		var	Row	= sheet1.GetSelectRow();
		if(	sheet1.GetRowLevel(Row) ==	4 )	{
			alert("<msg:txt mid='110068' mdef='현 단계	이하의	메뉴/프로그램/탭은 등록할 수 없습니다.'/>");
			return;
		}
		//조건검색,	탭일때
		if(sheet1.GetCellValue(Row, "type") ==	"S"	|| sheet1.GetCellValue(Row, "type") ==	"T"){
			alert("<msg:txt mid='109623' mdef='조건검색/탭 의	하위메뉴를 작성할 수	없습니다.'/>");
			return;
		}else {
			Row	= sheet1.DataInsert();
			sheet1.SetCellValue(Row, "mainMenuCd",mainMenuCd);
			sheet1.SetCellValue(Row, "priorMenuCd",sheet1.GetCellValue(Row-1,	"menuCd"));
			sheet1.SetCellValue(Row, "menuCd",getColMaxValue(sheet1, "menuCd"));
			sheet1.SetCellValue(Row, "grpCd",athGrpCd);
			sheet1.InitCellProperty(Row, "menuNm",	{Type: "Text", Align: "Left", Edit:1});
			sheet1.SetCellValue(Row, "prgCd","");
			sheet1.SetCellEditable(Row, "cnt",false);
			sheet1.SetCellValue(Row, "dataRwType","");
			sheet1.SetCellValue(Row, "dataPrgType","");
			sheet1.SetCellEditable(Row, "dataRwType",false);
			sheet1.SetCellEditable(Row, "dataPrgType",false);
			sheet1.SetCellValue(Row, "inqSYmd","");
			sheet1.SetCellValue(Row, "inqEYmd","");
			sheet1.SetCellEditable(Row, "inqSYmd",false);
			sheet1.SetCellEditable(Row, "inqEYmd",false);
			sheet1.InitCellProperty(Row, "searchDesc",	{Type: "Text", Align: "Left", Edit:1});
			sheet1.SetCellValue(Row, "searchSeq","");
			sheet1.SetCellValue(Row, "searchDesc","");
			sheet1.SetCellEditable(Row, "searchDesc",false);
			sheet1.SetCellEditable(Row, "popupUseYn",false);
			sheet1.SetCellEditable(Row, "lastSessionUseYn",false);
			sheet1.SetCellEditable(Row, "searchUseYn",false);
			sheet1.SetCellValue(Row, "popupUseYn","");
			sheet1.SetCellValue(Row, "lastSessionUseYn","");
			sheet1.SetCellValue(Row, "searchUseYn","");
			//프로그램일때 탭선택후 수정불가 처리
			if(sheet1.GetCellValue(Row-1, "type") == "P"){
				sheet1.SetCellValue(Row, "type","T");
				sheet1.SetCellEditable(Row,"type",false);
				sheet1.InitCellProperty(Row, "menuNm",	{Type: "PopupEdit",	Align: "Left", Edit:1});
				sheet1.SetCellValue(Row, "cnt",'100');
				sheet1.SetCellEditable(Row, "cnt",true);
				sheet1.SetCellEditable(Row, "dataPrgType",true);
				if(sheet1.GetCellValue(Row, "dataPrgType")	== "P" ) { //프로그램권한
					sheet1.SetCellEditable(Row, "dataRwType",true);
					if(sheet1.GetCellValue(Row, "dataRwType") == "") {
						sheet1.SetCellValue(Row, "dataRwType","A");
					}
				} else if(	  sheet1.GetCellValue(Row,	"dataPrgType") == "U" )	{ //사용자권한
					sheet1.SetCellValue(Row, "dataRwType","");
					sheet1.SetCellEditable(Row, "dataRwType",false);
				} else {
					sheet1.SetCellValue(Row, "dataPrgType","U");
					sheet1.SetCellValue(Row, "dataRwType","");
					sheet1.SetCellEditable(Row, "dataRwType",false);
				}

				sheet1.SetCellValue(Row, "useYn","Y");
				sheet1.SetCellValue(Row, "inqSYmd","${curSysYyyyMMdd}");
				sheet1.SetCellValue(Row, "inqEYmd","99991231");

				sheet1.SetCellValue(Row, "popupUseYn","");
				sheet1.SetCellEditable(Row, "useYn",true);
				sheet1.SetCellEditable(Row, "inqSYmd",true);
				sheet1.SetCellEditable(Row, "inqEYmd",true);
				sheet1.InitCellProperty(Row, "searchDesc",	{Type: "Text", Align: "Left", Edit:1});
				sheet1.SetCellValue(Row, "searchSeq","");
				sheet1.SetCellValue(Row, "searchDesc","");
				sheet1.SetCellEditable(Row, "searchDesc",false);
				sheet1.SetCellEditable(Row, "popupUseYn",true);
				sheet1.SetCellEditable(Row, "lastSessionUseYn",true);
				sheet1.SetCellEditable(Row, "searchUseYn",true);
			}
			sheet1.SelectCell(Row,	"menuNm");
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
				  sheet1.InitCellProperty(i, "menuNm",	{Type: "Text", Align: "Left", Edit:1});
				  sheet1.SetCellValue(i, "prgCd","");
				  sheet1.SetCellEditable(i, "cnt",false);

				  sheet1.SetCellValue(i, "dataRwType","");
				  sheet1.SetCellValue(i, "dataPrgType","");
				  sheet1.SetCellEditable(i,	"dataRwType",false);
				  sheet1.SetCellEditable(i, "dataPrgType",false);

				  sheet1.SetCellValue(i, "inqSYmd","");
				  sheet1.SetCellValue(i, "inqEYmd","");

				  sheet1.SetCellEditable(i,	"inqSYmd",false);
				  sheet1.SetCellEditable(i, "inqEYmd",false);

				  sheet1.InitCellProperty(i, "searchDesc",	{Type: "Text", Align: "Left", Edit:1});
				  sheet1.SetCellValue(i, "searchSeq","");
				  sheet1.SetCellValue(i, "searchDesc","");
				  sheet1.SetCellEditable(i, "searchDesc",false);
				  sheet1.SetCellEditable(i, "popupUseYn",false);
				  sheet1.SetCellEditable(i, "lastSessionUseYn",false);
				  sheet1.SetCellEditable(i, "searchUseYn",false);
			  }
			  else if (sheet1.GetCellValue(i, "type") == "P") {
				  sheet1.InitCellProperty(i, "menuNm",	{Type: "PopupEdit",	Align: "Left", Edit:1});

				  sheet1.InitCellProperty(i, "searchDesc",	{Type: "Text", Align: "Left", Edit:1});
				  sheet1.SetCellValue(i, "searchSeq","");
				  sheet1.SetCellValue(i, "searchDesc","");
				  sheet1.SetCellEditable(i, "searchDesc",false);

				  sheet1.SetCellEditable(i, "dataPrgType",true);

				  if(	 sheet1.GetCellValue(i, "dataPrgType")	== "P" ) { //프로그램권한
					  sheet1.SetCellEditable(i, "dataRwType",true);
				  }	else if(	sheet1.GetCellValue(i,	"dataPrgType") == "U" )	{ //사용자권한
					  sheet1.SetCellValue(i, "dataRwType","");
					  sheet1.SetCellEditable(i, "dataRwType",false);
				  }

				  sheet1.SetCellEditable(i, "useYn",true);
					 sheet1.SetCellEditable(i,	"inqSYmd",true);
				  sheet1.SetCellEditable(i, "inqEYmd",true);
			  }
			  else if (sheet1.GetCellValue(i, "type") == "S") {
				  sheet1.InitCellProperty(i, "menuNm",	{Type: "PopupEdit",	Align: "Left", Edit:1});

				  sheet1.InitCellProperty(i, "searchDesc",	{Type: "Popup",	Align: "Left", Edit:1});
				  sheet1.SetCellEditable(i, "searchDesc",true);

				  sheet1.SetCellEditable(i, "dataPrgType",true);
				  if(	 sheet1.GetCellValue(i, "dataPrgType")	== "P" ) { //프로그램권한
					  sheet1.SetCellEditable(i, "dataRwType",true);
				  }	else if(	sheet1.GetCellValue(i,	"dataPrgType") == "U" )	{ //사용자권한
					  sheet1.SetCellValue(i, "dataRwType","");
					  sheet1.SetCellEditable(i, "dataRwType",false);
				  }

				  sheet1.SetCellEditable(i, "useYn",true);
					 sheet1.SetCellEditable(i,	"inqSYmd",true);
				  sheet1.SetCellEditable(i, "inqEYmd",true);
			  }
			  else if (sheet1.GetCellValue(i, "type") == "T") {
				  sheet1.InitCellProperty(i, "menuNm",	{Type: "PopupEdit",	Align: "Left", Edit:1});

				  sheet1.InitCellProperty(i, "searchDesc",	{Type: "Text", Align: "Left", Edit:1});
				  sheet1.SetCellValue(i, "searchSeq","");
				  sheet1.SetCellValue(i, "searchDesc","");
				  sheet1.SetCellEditable(i, "searchDesc",false);

				  sheet1.SetCellEditable(i, "dataPrgType",true);
				  if(	 sheet1.GetCellValue(i, "dataPrgType")	== "P" ) { //프로그램권한
					  sheet1.SetCellEditable(i, "dataRwType",true);
				  }	else if(	sheet1.GetCellValue(i,	"dataPrgType") == "U" )	{ //사용자권한
					  sheet1.SetCellValue(i, "dataRwType","");
					  sheet1.SetCellEditable(i, "dataRwType",false);
				  }

				  sheet1.SetCellEditable(i, "useYn",true);
					 sheet1.SetCellEditable(i,	"inqSYmd",true);
				  sheet1.SetCellEditable(i, "inqEYmd",true);
			  }

			  if( "A" == "A" ) {
				  sheet1.SetCellValue(i, "sStatus", "R");
			  }
		  }
		}catch(ex){alert("OnSearchEnd Event	Error :	" +	ex);}
	}
	function sheet1_OnResize(lWidth, lHeight){
		try{
		  //높이 또는 너비가 변경된 경우 각 컬럼의 너비를 새로 맞춘다.
		  //setSheetSize(this);
		}catch(ex){alert("OnResize Event Error : " + ex);}
	}
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg){
		try{
		  if (Msg != ""){
		  	alert(Msg);
		  	doAction("Search");
		  }
		}catch(ex){alert("OnSaveEnd	Event Error	: "	+ ex);}
	}
	function sheet1_OnChange(Row, Col,	Value){

		//try{
			if(sheet1.ColSaveName(Col)	== "inqSYmd" ||	sheet1.ColSaveName(Col) ==	"inqEYmd") {
				//시작일자 종료일자	체크하기
				var	message	= "권한별프로그램리스트의 ";
				checkNMDate(sheet1, Row, Col, message,	"inqSYmd", "inqEYmd");
			}
			if(sheet1.ColSaveName(Col)=="type") {
				if (sheet1.GetCellValue(Row, "type") == "M") {
					sheet1.InitCellProperty(Row, "menuNm",	{Type: "Text", Align: "Left", Edit:1});
					sheet1.SetCellValue(Row, "prgCd","");
					sheet1.SetCellValue(Row, "cnt",0);
					sheet1.SetCellEditable(Row, "cnt",false);
					sheet1.SetCellValue(Row, "dataRwType","");
					sheet1.SetCellValue(Row, "dataPrgType","");
					sheet1.SetCellEditable(Row, "dataRwType",false);
					sheet1.SetCellEditable(Row, "dataPrgType",false);
					sheet1.SetCellValue(Row, "inqSYmd","");
					sheet1.SetCellValue(Row, "inqEYmd","");
					sheet1.SetCellValue(Row, "popupUseYn","");
					sheet1.SetCellValue(Row, "lastSessionUseYn","");
					sheet1.SetCellValue(Row, "searchUseYn","");
					sheet1.SetCellEditable(Row, "inqSYmd",false);
					sheet1.SetCellEditable(Row, "inqEYmd",false);
					sheet1.InitCellProperty(Row, "searchDesc",	{Type: "Text", Align: "Left", Edit:1});
					sheet1.SetCellValue(Row, "searchSeq","");
					sheet1.SetCellValue(Row, "searchDesc","");
					sheet1.SetCellEditable(Row, "searchDesc",false);
					sheet1.SetCellEditable(Row, "popupUseYn",false);
					sheet1.SetCellEditable(Row, "lastSessionUseYn",false);
					sheet1.SetCellEditable(Row, "searchUseYn",false);
				}
				else if (sheet1.GetCellValue(Row,	"type")	== "P")	{
					if (sheet1.IsHaveChild(Row)) {
						alert("<msg:txt mid='110069' mdef='하위 매뉴가 존재하므로	프로그램으로 수정할 수 없습니다.'/>");
						sheet1.SetCellValue(Row, "type","M");
						return false;
					}

					sheet1.InitCellProperty(Row, "menuNm",	{Type: "PopupEdit",	Align: "Left", Edit:1});
					sheet1.SetCellValue(Row, "cnt",'100');
					sheet1.SetCellEditable(Row, "cnt",true);
					sheet1.SetCellEditable(Row, "dataPrgType",true);

					if(sheet1.GetCellValue(Row, "dataPrgType")	== "P" ) { //프로그램권한
						sheet1.SetCellEditable(Row, "dataRwType",true);
						if(sheet1.GetCellValue(Row, "dataRwType") == "") {
							sheet1.SetCellValue(Row, "dataRwType","A");
						}
					}
					else if(	  sheet1.GetCellValue(Row,	"dataPrgType") == "U" )	{ //사용자권한
						sheet1.SetCellValue(Row, "dataRwType","");
						sheet1.SetCellEditable(Row, "dataRwType",false);
					}
					else {
						sheet1.SetCellValue(Row, "dataPrgType","U");
						sheet1.SetCellValue(Row, "dataRwType","");
						sheet1.SetCellEditable(Row, "dataRwType",false);
					}
					sheet1.SetCellValue(Row, "useYn","Y");
					sheet1.SetCellValue(Row, "inqSYmd","${curSysYyyyMMdd}");
					sheet1.SetCellValue(Row, "inqEYmd","99991231");
					sheet1.SetCellValue(Row, "popupUseYn","");
					sheet1.SetCellEditable(Row, "useYn",true);
					sheet1.SetCellEditable(Row, "inqSYmd",true);
					sheet1.SetCellEditable(Row, "inqEYmd",true);
					sheet1.InitCellProperty(Row, "searchDesc",	{Type: "Text", Align: "Left", Edit:1});
					sheet1.SetCellValue(Row, "searchSeq","");
					sheet1.SetCellValue(Row, "searchDesc","");
					sheet1.SetCellEditable(Row, "searchDesc",false);
					sheet1.SetCellEditable(Row, "popupUseYn",true);
					sheet1.SetCellEditable(Row, "lastSessionUseYn",true);
					sheet1.SetCellEditable(Row, "searchUseYn",true);
				}
				else if (sheet1.GetCellValue(Row,	"type")	== "S")	{
					if (sheet1.IsHaveChild(Row)) {
						alert("<msg:txt mid='109444' mdef='하위 매뉴가 존재하므로	조건검색으로 수정할 수 없습니다.'/>");
						sheet1.SetCellValue(Row, "type","M");
						return false;
					}
					sheet1.SetCellValue(Row, "menuNm","");
					sheet1.SetCellValue(Row, "prgCd","/PwrSrchAdminUser.do?cmd=viewPwrSrchAdminUser");
					sheet1.SetCellValue(Row, "cnt",'100');
					sheet1.SetCellEditable(Row, "cnt",true);
					sheet1.SetCellEditable(Row, "dataPrgType",true);
					if(sheet1.GetCellValue(Row, "dataPrgType")	== "P" ) { //프로그램권한
						sheet1.SetCellEditable(Row, "dataRwType",true);
						if(sheet1.GetCellValue(Row, "dataRwType") == "") {
							sheet1.SetCellValue(Row, "dataRwType","A");
						}
					}
					else if(sheet1.GetCellValue(Row,	"dataPrgType") == "U" )	{ //사용자권한
						sheet1.SetCellValue(Row, "dataRwType","");
						sheet1.SetCellEditable(Row, "dataRwType",false);
					}
					else {
						sheet1.SetCellValue(Row, "dataPrgType","U");
						sheet1.SetCellValue(Row, "dataRwType","");
						sheet1.SetCellEditable(Row, "dataRwType",false);
					}
					sheet1.SetCellValue(Row, "useYn","Y");
					sheet1.SetCellValue(Row, "inqSYmd","${curSysYyyyMMdd}");
					sheet1.SetCellValue(Row, "inqEYmd","99991231");
					sheet1.SetCellValue(Row, "popupUseYn","");
					sheet1.SetCellEditable(Row, "useYn",true);
					sheet1.SetCellEditable(Row, "inqSYmd",true);
					sheet1.SetCellEditable(Row, "inqEYmd",true);
					sheet1.InitCellProperty(Row, "searchDesc",	{Type: "Popup",	Align: "Left", Edit:1});
					sheet1.SetCellEditable(Row, "searchDesc",true);
					sheet1.SetCellEditable(Row, "popupUseYn",true);
					sheet1.SetCellEditable(Row, "lastSessionUseYn",true);
					sheet1.SetCellEditable(Row, "searchUseYn",true);
				}
				else if (sheet1.GetCellValue(Row,	"type")	== "T")	{
					if(sheet1.GetCellValue(Row-1, "type") != "P"){
						alert("<msg:txt mid='109775' mdef='탭은 프로그램만	선택 가능합니다.'/>");
						sheet1.SetCellValue(Row, "type","M");
						return;
					}
				}
			}

			if(sheet1.ColSaveName(Col)=="dataPrgType") {
				if(sheet1.GetCellValue(Row, "dataPrgType")	== "P" ) { //프로그램권한
					sheet1.SetCellValue(Row, "dataRwType","A");
					sheet1.SetCellEditable(Row, "dataRwType",true);
				}
				else if(sheet1.GetCellValue(Row,	"dataPrgType") == "U" )	{ //사용자권한
					sheet1.SetCellValue(Row, "dataRwType","");
					sheet1.SetCellEditable(Row, "dataRwType",false);
				}
			}
			/* 상위 사용여부 변경시 하위 사용여부를 모두 같게 변경 시킴 by JSG */
			if(sheet1.ColSaveName(Col)=="useYn") {
				var children = sheet1.GetChildRows(Row).split("|") ;
				for(var i = 0; i < children.length; i++) {
					sheet1.SetCellValue( children[i], "useYn", sheet1.GetCellValue(Row, "useYn") ) ;
				}
			}

		//}catch(ex){alert("OnChange Event Error : " + ex);}
	}

	function sheet1_OnPopupClick(Row, Col){

		var	args	= new Array();
	//		args["viewCd"]	= sheet1.GetCellValue(Row,	"viewCd");
	//		args["viewNm"]	= sheet1.GetCellValue(Row,	"viewNm");
	//		args["seq"]		= sheet1.GetCellValue(Row,	"seq");
	//		args["viewDesc"]= sheet1.GetCellValue(Row,	"viewDesc");
		var	rv = null;
		try{

			if(sheet1.ColSaveName(Col)=="menuNm") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "prgMgrPopup";

				var	rv = openPopup("/Popup.do?cmd=prgMgrPopup",	args, "640","520");
				/*
				if(rv!=null){
					sheet1.SetCellValue(Row, "menuNm",		rv["menuNm"] );
					sheet1.SetCellValue(Row, "prgCd",		rv["prgCd"]	);
				}
				*/
			}

			if(sheet1.ColSaveName(Col)=="searchDesc") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "pwrSrchMgrPopup";

				var	rv = openPopup("/Popup.do?cmd=pwrSrchMgrPopup",	args, "1100","520");
				/*
				if(rv!=null){
					sheet1.SetCellValue(Row, "searchSeq",	rv["searchSeq"]	);
					sheet1.SetCellValue(Row, "searchDesc",	rv["searchDesc"] );
				}
				*/
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}

	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "prgMgrPopup"){
			sheet1.SetCellValue(gPRow, "menuNm",		rv["menuNm"] );
			sheet1.SetCellValue(gPRow, "prgCd",		rv["prgCd"]	);

	    }else if(pGubun == "pwrSrchMgrPopup"){
			sheet1.SetCellValue(gPRow, "searchSeq",	rv["searchSeq"]	);
			sheet1.SetCellValue(gPRow, "searchDesc",	rv["searchDesc"] );
	    }
	}

</script>
</head>
<body class="bodywrap">
	<form id="mySheetForm" name="mySheetForm">
		<input id="mainMenuCd"	name="mainMenuCd"	type="hidden"/>
		<input id="athGrpCd"	name="athGrpCd"		type="hidden"/>
	</form>
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='112924' mdef='권한별	등록 프로그램	세부내역'/></li>
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
										<btn:a href="javascript:doAction('Search');"		css="basic"authR mid='110697' mdef="조회"/>
										<btn:a href="javascript:doAction('Insert');"		css="basic authA" mid='110700' mdef="입력"/>
										<btn:a href="javascript:doAction('Save');"			css="basic authA" mid='110708' mdef="저장"/>
										<a href="javascript:doAction('Down2Excel');"	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
									</li>
								</ul>
							</div>
						</div> <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
			<div class="popup_button outer">
				<ul>
					<li><btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>



