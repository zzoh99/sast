<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='mainMuPrg' mdef='메인메뉴프로그램관리'/></title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:9,SearchMode:smLazyLoad,Page:22,ChildPage:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='mainMenuCd' mdef='메인메뉴코드'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"mainMenuCd", 	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='priorMenuCd' mdef='상위메뉴'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"priorMenuCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='menuCd' mdef='메뉴'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menuCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menuSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",					Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"type",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='koKrV5' mdef='메뉴/프로그램명'/>",		Type:"Text",	Hidden:0,	Wid0h:180,	Align:"Left",	ColMerge:0,	SaveName:"menuNm",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TreeCol:1  },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",			Type:"Text",	Hidden:1,Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Left",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='prgCdV2' mdef='프로그램'/>",			Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"prgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='searchSeqV2' mdef='조건검색코드'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"searchSeq",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='searchDesc' mdef='검색설명'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"searchDesc",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='dataPrgType' mdef='적용권한'/>",		Type:"Combo",	Hidden:0,	Wid0h:80,	Align:"Center",	ColMerge:0,	SaveName:"dataPrgType",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"신청서",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"<sht:txt mid='dataPrgTypeV2' mdef='프로그램\n권한'/>",	Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"dataRwType",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",					Type:"Int",		Hidden:0,	Width:30,	Align:"Right",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='cnt' mdef='ONEPAGE\nROWS'/>",		Type:"Int",		Hidden:1,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"cnt",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			// 2019 개선, 아래 항목을 사용하려면 새로 만드는게 빠름. 동작안함
			{Header:"<sht:txt mid='authHelp' mdef='도움말'/>",				Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"helpPop",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='mgrHelpYn' mdef='담당자용'/>",			Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mgrHelpYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='empHelpYn' mdef='직원용'/>",			Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"empHelpYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" }
		];
// 		sheetSplice(initdata.Cols,9, "${localeCd2}", ["메뉴/프로그램명","180","Left"], true);
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");

		sheet1.SetDataLinkMouse("helpPop", 1);

		sheet1.SetColProperty("type", 			{ComboText:"<sht:txt mid='typeV3' mdef='메뉴|프로그램|조건검색|탭'/>", 	ComboCode:"M|P|S|T"} );
		sheet1.SetColProperty("dataRwType", 	{ComboText:"<sht:txt mid='dataRwTypeV3' mdef='읽기/쓰기|읽기'/>", 			ComboCode:"A|R"} );
		sheet1.SetColProperty("dataPrgType",	{ComboText:"<sht:txt mid='dataPrgTypeV1' mdef='사용자권한|프로그램권한'/>", 	ComboCode:"U|P"} );

		
		//[공통신청서]신청서코드 2020.09.16
		var applCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getMainMuPrgApplCdList",false).codeList, "");
		sheet1.SetColProperty("applCd",  {ComboText:"|"+applCdList[0], 	ComboCode:"|"+applCdList[1]} );

		//var menuList = convCodeIdx( ajaxCall("${ctx}/MainMuPrg.do?cmd=getMainMuPrgMainMenuList","",false).DATA,"",1);
		var menuList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getMainMuPrgMainMenuList",false).codeList, "");
		$("#mainMenuCd").html(menuList[2]);
		$("#mainMenuCd").change(function(){
			$("#mainMenuNm").val($("#mainMenuCd  option:selected").text());
			doAction("Search");
		});
		$("#mainMenuNm").val( $("#mainMenuCd option:selected").text() );
		$(window).smartresize(sheetResize); sheetInit();

		$("#btnPlus").toggleClass("minus");

		// 트리레벨 정의
		$("#btnStep1").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(1, 2);
		});
		$("#btnStep3").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(2, 3);
			/*if(!$("#btnPlus").hasClass("minus")){
				$("#btnPlus").toggleClass("minus");
				sheet1.ShowTreeLevel(-1);
			}*/
		});
		$("#btnPlus").click(function() {
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?sheet1.ShowTreeLevel(-1):sheet1.ShowTreeLevel(0, 1);
		});

		doAction("Search");
	});

	var RowLevel = 0, ParentRow = 0;
	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/MainMuPrg.do?cmd=getMainMuPrgList", $("#sheet1Form").serialize() ); break;
		case "Save":
// 							sheetLangSave(sheet1, "tsys303", "mainMenuCd, priorMenuCd, menuCd, menuSeq" , "menuNm");
							IBS_SaveName(document.sheet1Form,sheet1);
							sheet1.DoSave( "${ctx}/MainMuPrg.do?cmd=saveMainMuPrg" , $("#sheet1Form").serialize()); break;
		case "Insert1": //동일레벨
			var Row = sheet1.GetSelectRow();
			RowLevel = sheet1.GetRowLevel(Row);

            if( RowLevel == 0 ) {
                alert("현 단계의 동일레벨 메뉴는 등록할 수 없습니다.");
                return;
            }

            var _type = sheet1.GetCellValue(Row, "type");
            Row = sheet1.DataInsert(Row, RowLevel);
            ParentRow = sheet1.GetParentRow(Row); 
            
			sheet1.SetCellValue(Row, "mainMenuCd",sheet1.GetCellValue(ParentRow, "mainMenuCd"));
			sheet1.SetCellValue(Row, "priorMenuCd",sheet1.GetCellValue(ParentRow, "menuCd"));
			sheet1.SetCellValue(Row, "menuCd",getColMaxValue(sheet1, "menuCd"));
			
			sheet1.InitCellProperty(Row, "menuNm", {Type: "Text", Align: "Left", Edit:1});
			sheet1.SetCellValue(Row, "prgCd","");
			sheet1.SetCellEditable(Row, "cnt",false);
			
			sheet1.SetCellValue(Row, "dataRwType","");
			sheet1.SetCellValue(Row, "dataPrgType","");
			sheet1.SetCellEditable(Row, "dataRwType",false);
			sheet1.SetCellEditable(Row, "dataPrgType",false);
			
			sheet1.InitCellProperty(Row, "searchDesc", {Type: "Text", Align: "Left", Edit:1});
			sheet1.SetCellValue(Row, "searchSeq","");
			sheet1.SetCellValue(Row, "searchDesc","");
			sheet1.SetCellEditable(Row, "searchDesc",false);
			
			sheet1.SetCellValue(Row, "type", _type);
			
			
			sheet1.SelectCell(Row, "menuNm");
            
			break;
		case "Insert2": //하위레벨

			var Row = sheet1.GetSelectRow();
			RowLevel = sheet1.GetRowLevel(Row); 

            if( RowLevel == 3 ) {
                alert("현 단계 이하의 메뉴/프로그램/탭은 등록할 수 없습니다.");
                return;
            }

            //조건검색, 탭일때
            if(sheet1.GetCellValue(Row, "type") == "S" || sheet1.GetCellValue(Row, "type") == "T"){
                alert("조건검색/탭 의 하위메뉴를 작성할 수 없습니다.");
                return;
            }

            ParentRow = Row;
            Row = sheet1.DataInsert();

			sheet1.SetCellValue(Row, "mainMenuCd",sheet1.GetCellValue(ParentRow, "mainMenuCd"));
			sheet1.SetCellValue(Row, "priorMenuCd",sheet1.GetCellValue(ParentRow, "menuCd"));
			sheet1.SetCellValue(Row, "menuCd",getColMaxValue(sheet1, "menuCd"));
			
			sheet1.InitCellProperty(Row, "menuNm", {Type: "Text", Align: "Left", Edit:1});
			sheet1.SetCellValue(Row, "prgCd","");
			sheet1.SetCellEditable(Row, "cnt",false);
			
			sheet1.SetCellValue(Row, "dataRwType","");
			sheet1.SetCellValue(Row, "dataPrgType","");
			sheet1.SetCellEditable(Row, "dataRwType",false);
			sheet1.SetCellEditable(Row, "dataPrgType",false);
			
			sheet1.InitCellProperty(Row, "searchDesc", {Type: "Text", Align: "Left", Edit:1});
			sheet1.SetCellValue(Row, "searchSeq","");
			sheet1.SetCellValue(Row, "searchDesc","");
			sheet1.SetCellEditable(Row, "searchDesc",false);
			
			//프로그램일때 탭선택후 수정불가 처리
			if(sheet1.GetCellValue(ParentRow, "type") == "P"){
				sheet1.SetCellValue(Row, "type","T");
				sheet1.SetCellEditable(Row,"type",false);
				
				sheet1.InitCellProperty(Row, "menuNm", {Type: "PopupEdit", Align: "Left", Edit:1});
				sheet1.SetCellValue(Row, "cnt",'100');
				
				sheet1.SetCellEditable(Row, "cnt",true);
				
				sheet1.SetCellEditable(Row, "dataPrgType",true);
				if( sheet1.GetCellValue(Row, "dataPrgType=") == "P" ) { //프로그램권한
					sheet1.SetCellEditable(Row, "dataRwType",true);
					if(sheet1.GetCellValue(Row, "dataRwType") == "") {
						sheet1.SetCellValue(Row, "dataRwType","A");
					}
			    } else if( sheet1.GetCellValue(Row, "dataPrgType") == "U" ) { //사용자권한
					sheet1.SetCellValue(Row, "dataRwType","");
					sheet1.SetCellEditable(Row, "dataRwType",false);
				} else {
					sheet1.SetCellValue(Row, "dataPrgType","U");
					sheet1.SetCellValue(Row, "dataRwType","");
					sheet1.SetCellEditable(Row, "dataRwType",false);
				}
			
				sheet1.InitCellProperty(Row, "searchDesc", {Type: "Text", Align: "Left", Edit:1});
				sheet1.SetCellValue(Row, "searchSeq","");
				sheet1.SetCellValue(Row, "searchDesc","");
				sheet1.SetCellEditable(Row, "searchDesc",false);
			
			}
			
			sheet1.SelectCell(Row, "menuNm");
	           
			break;
			case "Insert":
			 var Row = sheet1.GetSelectRow();
	            if( sheet1.GetRowLevel(Row) == 3 ) {
	                alert("<msg:txt mid='alertMainMuPrg1' mdef='현 단계 이하의 메뉴/프로그램/탭은 등록할 수 없습니다.'/>");
	                return;
	            }
	            //조건검색, 탭일때
	            if(sheet1.GetCellValue(Row, "type") == "S" || sheet1.GetCellValue(Row, "type") == "T"){
	                alert("<msg:txt mid='alertMainMuPrg2' mdef='조건검색/탭 의 하위메뉴를 작성할 수 없습니다.'/>");
	                return;
	            }
	            else {
	                Row = sheet1.DataInsert();

	                sheet1.SetCellValue(Row, "mainMenuCd",sheet1.GetCellValue(Row-1, "mainMenuCd"));
	                sheet1.SetCellValue(Row, "priorMenuCd",sheet1.GetCellValue(Row-1, "menuCd"));
	                sheet1.SetCellValue(Row, "menuCd",getColMaxValue(sheet1, "menuCd"));

	                sheet1.InitCellProperty(Row, "menuNm", {Type: "Text", Align: "Left", Edit:1});
	                sheet1.SetCellValue(Row, "prgCd","");
	                sheet1.SetCellEditable(Row, "cnt",false);

	                sheet1.SetCellValue(Row, "dataRwType","");
	                sheet1.SetCellValue(Row, "dataPrgType","");
	                sheet1.SetCellEditable(Row, "dataRwType",false);
	                sheet1.SetCellEditable(Row, "dataPrgType",false);

	                sheet1.InitCellProperty(Row, "searchDesc", {Type: "Text", Align: "Left", Edit:1});
	                sheet1.SetCellValue(Row, "searchSeq","");
	                sheet1.SetCellValue(Row, "searchDesc","");
	                sheet1.SetCellEditable(Row, "searchDesc",false);

	                //프로그램일때 탭선택후 수정불가 처리
	                if(sheet1.GetCellValue(Row-1, "type") == "P"){
	                    sheet1.SetCellValue(Row, "type","T");
	                    sheet1.SetCellEditable(Row,"type",false);

	                    sheet1.InitCellProperty(Row, "menuNm", {Type: "PopupEdit", Align: "Left", Edit:1});
	                    sheet1.SetCellValue(Row, "cnt",'100');

	                    sheet1.SetCellEditable(Row, "cnt",true);

	                    sheet1.SetCellEditable(Row, "dataPrgType",true);
	                    if(    sheet1.GetCellValue(Row, "dataPrgType=") == "P" ) { //프로그램권한
	                        sheet1.SetCellEditable(Row, "dataRwType",true);
	                        if(sheet1.GetCellValue(Row, "dataRwType") == "") {
	                            sheet1.SetCellValue(Row, "dataRwType","A");
	                        }
	                    } else if(    sheet1.GetCellValue(Row, "dataPrgType") == "U" ) { //사용자권한
	                        sheet1.SetCellValue(Row, "dataRwType","");
	                        sheet1.SetCellEditable(Row, "dataRwType",false);
	                    } else {
	                        sheet1.SetCellValue(Row, "dataPrgType","U");
	                        sheet1.SetCellValue(Row, "dataRwType","");
	                        sheet1.SetCellEditable(Row, "dataRwType",false);
	                    }

	                    sheet1.InitCellProperty(Row, "searchDesc", {Type: "Text", Align: "Left", Edit:1});
	                    sheet1.SetCellValue(Row, "searchSeq","");
	                    sheet1.SetCellValue(Row, "searchDesc","");
	                    sheet1.SetCellEditable(Row, "searchDesc",false);

	                }

	                sheet1.SelectCell(Row, "menuNm");
	            }
			break;
		//case "Insert":		mySheet.SelectCell(mySheet.DataInsert(0), "column1"); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);

							break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
 		try{
		    if (Msg != ""){
		        alert(Msg);
		    }
		    sheet1.SetRowEditable(1,false);
		    sheet1.ShowTreeLevel(-1);
		    //document.form.rdoShowLevel[2].checked = true;
		    sheet1.SetRowEditable(1,false);

		    for(i = 1; i<=sheet1.LastRow(); i++) {
		        if (sheet1.GetCellValue(i, "type") == "M") {
		            sheet1.InitCellProperty(i, "menuNm", {Type: "Text", Align: "Left", Edit:1});
		            sheet1.SetCellValue(i, "prgCd","");
		            sheet1.SetCellEditable(i, "cnt",false);

		            sheet1.SetCellValue(i, "dataRwType","");
		            sheet1.SetCellValue(i, "dataPrgType","");
		            sheet1.SetCellEditable(i, "dataRwType",false);
		            sheet1.SetCellEditable(i, "dataPrgType",false);

		            sheet1.InitCellProperty(i, "searchDesc", {Type: "Text", Align: "Left", Edit:1});
		            sheet1.SetCellValue(i, "searchSeq","");
		            sheet1.SetCellValue(i, "searchDesc","");
		            sheet1.SetCellEditable(i, "searchDesc",false);
		        }
		        else if (sheet1.GetCellValue(i, "type") == "P") {
		            sheet1.InitCellProperty(i, "menuNm", {Type: "PopupEdit", Align: "Left", Edit:1});
		            sheet1.SetCellEditable(i, "dataPrgType",true);
		            if(    sheet1.GetCellValue(i, "dataPrgType") == "P" ) { //프로그램권한
		                sheet1.SetCellEditable(i, "dataRwType",true);
		            } else if(    sheet1.GetCellValue(i, "dataPrgType") == "U" ) { //사용자권한
		                sheet1.SetCellValue(i, "dataRwType","");
		                sheet1.SetCellEditable(i, "dataRwType",false);
		            }

		            sheet1.InitCellProperty(i, "searchDesc", {Type: "Text", Align: "Left", Edit:1});
		            sheet1.SetCellValue(i, "searchSeq","");
		            sheet1.SetCellValue(i, "searchDesc","");
		            sheet1.SetCellEditable(i, "searchDesc",false);
		        }
		        else if (sheet1.GetCellValue(i, "type") == "S") {
		            sheet1.InitCellProperty(i, "menuNm", {Type: "PopupEdit", Align: "Left", Edit:1});

		            sheet1.SetCellEditable(i, "dataPrgType",true);
		            if(    sheet1.GetCellValue(i, "dataPrgType") == "P" ) { //프로그램권한
		                sheet1.SetCellEditable(i, "dataRwType",true);
		            } else if(    sheet1.GetCellValue(i, "dataPrgType") == "U" ) { //사용자권한
		                sheet1.SetCellValue(i, "dataRwType","");
		                sheet1.SetCellEditable(i, "dataRwType",false);
		            }

		            sheet1.InitCellProperty(i, "searchDesc", {Type: "PopupEdit", Align: "Left", Edit:1});
		            sheet1.SetCellEditable(i, "searchDesc",true);
		        }
		        else if (sheet1.GetCellValue(i, "type") == "T") {
		            sheet1.InitCellProperty(i, "menuNm", {Type: "PopupEdit", Align: "Left", Edit:1});

		            sheet1.SetCellEditable(i, "dataPrgType",true);
		            if(    sheet1.GetCellValue(i, "dataPrgType") == "P" ) { //프로그램권한
		                sheet1.SetCellEditable(i, "dataRwType",true);
		            } else if(    sheet1.GetCellValue(i, "dataPrgType") == "U" ) { //사용자권한
		                sheet1.SetCellValue(i, "dataRwType","");
		                sheet1.SetCellEditable(i, "dataRwType",false);
		            }

		            sheet1.InitCellProperty(i, "searchDesc", {Type: "Text", Align: "Left", Edit:1});
		            sheet1.SetCellValue(i, "searchSeq","");
		            sheet1.SetCellValue(i, "searchDesc","");
		            sheet1.SetCellEditable(i, "searchDesc",false);
		        }    else if (sheet1.GetCellValue(i, "type") == "L" ){ //링크 추가 2020.11.16
		            sheet1.InitCellProperty(i, "menuNm", {Type: "PopupEdit", Align: "Left", Edit:1});
		            sheet1.SetCellEditable(i, "dataPrgType",false);
	                sheet1.SetCellEditable(i, "dataRwType",false);
		            sheet1.SetCellEditable(i, "searchDesc",false);
		            sheet1.SetCellEditable(i, "applCd",false);
		        }


		        if( "A" == "A" ) {
		            sheet1.SetCellValue(i, "sStatus", "R");
		        }
		    }

		    sheetResize();
 		  }catch(ex){alert("OnSearchEnd Event Error : " + ex);}

	}

	function sheet1_OnChange(Row, Col, Value){
	  try{
	    if( sheet1.ColSaveName(Col) == "type") {
	        if (sheet1.GetCellValue(Row, "type") == "M") {
	            sheet1.InitCellProperty(Row, "menuNm", {Type: "Text", Align: "Left", Edit:1});
	            sheet1.SetCellValue(Row, "prgCd","");
	            sheet1.SetCellValue(Row, "cnt",0);
	            sheet1.SetCellEditable(Row, "cnt",false);
	            sheet1.SetCellValue(Row, "dataRwType","");
	            sheet1.SetCellValue(Row, "dataPrgType","");
	            sheet1.SetCellEditable(Row, "dataRwType",false);
	            sheet1.SetCellEditable(Row, "dataPrgType",false);
	            sheet1.InitCellProperty(Row, "serachDesc", {Type: "Text", Align: "Left", Edit:1});
	            sheet1.SetCellValue(Row, "searchSeq","");
	            sheet1.SetCellValue(Row, "serachDesc","");
	            sheet1.SetCellEditable(Row, "serachDesc",false);
	        }
	        else if (sheet1.GetCellValue(Row, "type") == "P") {
	            if (sheet1.IsHaveChild(Row)) {
	                alert("<msg:txt mid='alertMainMuPrg4' mdef='하위 매뉴가 존재하므로 조건검색으로 수정할 수 없습니다.'/>");
	                sheet1.SetCellValue(Row, "type","M");
	                return false;
	            }
	            sheet1.InitCellProperty(Row, "menuNm", {Type: "PopupEdit", Align: "Left", Edit:1});
	            sheet1.SetCellValue(Row, "cnt",'100');
	            sheet1.SetCellEditable(Row, "cnt",true);
	            sheet1.SetCellEditable(Row, "dataPrgType",true);
	            if(    sheet1.GetCellValue(Row, "dataPrgType") == "P" ) { //프로그램권한
	                sheet1.SetCellEditable(Row, "dataRwType",true);
	                if(sheet1.GetCellValue(Row, "dataRwType") == "") {
	                    sheet1.SetCellValue(Row, "dataRwType","A");
	                }
	            } else if(    sheet1.GetCellValue(Row, "dataPrgType") == "U" ) { //사용자권한
	                sheet1.SetCellValue(Row, "dataRwType","");
	                sheet1.SetCellEditable(Row, "dataRwType",false);
	            } else {
	                sheet1.SetCellValue(Row, "dataPrgType","U");
	                sheet1.SetCellValue(Row, "dataRwType","");
	                sheet1.SetCellEditable(Row, "dataRwType",false);
	            }
	            sheet1.InitCellProperty(Row, "serachDesc", {Type: "Text", Align: "Left", Edit:1});
	            sheet1.SetCellValue(Row, "searchSeq","");
	            sheet1.SetCellValue(Row, "serachDesc","");
	            sheet1.SetCellEditable(Row, "serachDesc",false);
	        }
	        else if (sheet1.GetCellValue(Row, "type") == "S") {
	            if (sheet1.IsHaveChild(Row)) {
	                alert("<msg:txt mid='alertMainMuPrg4' mdef='하위 매뉴가 존재하므로 조건검색으로 수정할 수 없습니다.'/>");
	                sheet1.SetCellValue(Row, "type","M");
	                return false;
	            }
	            sheet1.SetCellValue(Row, "menuNm","");
	            sheet1.SetCellValue(Row, "prgCd","/PwrSrchAdminUser.do?cmd=viewPwrSrchAdminUser");

	            //sheet1.InitCellProperty(Row, "menuNm", {Type: "PopupEdit", Align: "Left", Edit:1});
	            sheet1.SetCellValue(Row, "cnt",'100');

	            sheet1.SetCellEditable(Row, "cnt",true);

	            sheet1.SetCellEditable(Row, "dataPrgType",true);
	            if(    sheet1.GetCellValue(Row, "dataPrgType") == "P" ) { //프로그램권한
	                sheet1.SetCellEditable(Row, "dataRwType",true);
	                if(sheet1.GetCellValue(Row, "dataRwType") == "") {
	                    sheet1.SetCellValue(Row, "dataRwType","A");
	                }
	            } else if(    sheet1.GetCellValue(Row, "dataPrgType") == "U" ) { //사용자권한
	                sheet1.SetCellValue(Row, "dataRwType","");
	                sheet1.SetCellEditable(Row, "dataRwType",false);
	            } else {
	                sheet1.SetCellValue(Row, "dataPrgType","U");
	                sheet1.SetCellValue(Row, "dataRwType","");
	                sheet1.SetCellEditable(Row, "dataRwType",false);
	            }

	            sheet1.InitCellProperty(Row, "searchDesc", {Type: "Popup", Align: "Left", Edit:1});

	            sheet1.SetCellEditable(Row, "searchDesc",true);
	        }
	        else if (sheet1.GetCellValue(Row, "type") == "T") {

	            if(sheet1.GetCellValue(Row-1, "type") != "P"){
	                alert("<msg:txt mid='alertMainMuPrg5' mdef='탭은 프로그램만 선택 가능합니다.'/>");
	                sheet1.SetCellValue(Row, "type","M");
	                return;
	            }
	        }
	        else if (sheet1.GetCellValue(Row, "type") == "L" ){ //링크 추가 2020.11.16
	            sheet1.InitCellProperty(Row, "menuNm", {Type: "PopupEdit", Align: "Left", Edit:1});
	            sheet1.SetCellEditable(Row, "dataPrgType",false);
                sheet1.SetCellEditable(Row, "dataRwType",false);
	            sheet1.SetCellEditable(Row, "searchDesc",false);
	            sheet1.SetCellEditable(Row, "applCd",false);
	        }
	    }

	    if( sheet1.ColSaveName(Col) == "dataPrgType" ) {
	        if(    sheet1.GetCellValue(Row, "dataPrgType") == "P" ) { //프로그램권한
	            sheet1.SetCellValue(Row, "dataRwType","A");
	            sheet1.SetCellEditable(Row, "dataRwType",true);
	        } else if(    sheet1.GetCellValue(Row, "dataPrgType") == "U" ) { //사용자권한
	            sheet1.SetCellValue(Row, "dataRwType","");
	            sheet1.SetCellEditable(Row, "dataRwType",false);
	        }
	    }
	    
		if ( sheet1.ColSaveName(Col) == "languageNm" ){
			if ( sheet1.GetCellValue( Row, Col ) == "" ){
				sheet1.SetCellValue( Row, "languageCd", "");
			}
		}
	  }catch(ex){alert("OnChange Event Error : " + ex);}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") { alert(Msg); }
			if( Code > 0 ) {doAction("Search");}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col){
		var args = {viewCd 	: sheet1.GetCellValue(Row, "viewCd"),
				viewNm 	: sheet1.GetCellValue(Row, "viewNm"),
				seq 	: sheet1.GetCellValue(Row, "seq"),
				viewDesc: sheet1.GetCellValue(Row, "viewDesc")};
		var rv = null;
		var url = null;
		try{
			if(sheet1.ColSaveName(Col) == "menuNm") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "prgMgrPopup";
				//프로그램관리 
				url = "/Popup.do?cmd=viewPrgMgrLayer";
				prgMgrPopup(url, args);
			}
			if(sheet1.ColSaveName(Col) == "searchDesc") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "pwrSrchMgrPopup";
				//var rv = openPopup("/Popup.do?cmd=pwrSrchMgrPopup", args, "1100","620");
				let layerModal = new window.top.document.LayerModal({
					  id : 'pwrSrchMgrLayer'
					, url : '/Popup.do?cmd=viewPwrSrchMgrLayer&authPg=${authPg}'
					, parameters : args
					, width : 740
					, height : 520
					, title : "<tit:txt mid='112392' mdef='조건 검색 관리'/>"
					, trigger :[
						{
							name : 'pwrTrigger'
							, callback : function(result){
								sheet1.SetCellValue(gPRow, "searchSeq", result["searchSeq"] );
								sheet1.SetCellValue(gPRow, "searchDesc", result["searchDesc"] );
							}
						}
					]
				});
				layerModal.show();
			}
			if (sheet1.ColSaveName(Col) == "languageNm") {
				if(!isPopup()) {return;}
				args["keyLevel"]	= "tsys303";       //레별
				args["keyId"]		= "languageCd";    //
				args["keyNm"]		= "languageNm";    //
				args["keyText"]		= "menuNm";
				var url = "/DictMgr.do?cmd=viewDictLayer&is=_popup";
				let layerModal = new window.top.document.LayerModal({
					id : 'dictLayer'
					, url : url
					, parameters : args
					, width : 1000
					, height : 650
					, title : "<tit:txt mid='104444' mdef='사전 검색'/>"
					, trigger :[
						{
							name : 'dictTrigger'
							, callback : function(result){
								sheet1.SetCellValue(Row, 'languageCd', result["keyId"]);
								var chkData = { "keyLevel": parameters.keyLevel, "languageCd": result.keyId};
								var dtWord = ajaxCall( "${ctx}/LangId.do?cmd=getLangCdTword", chkData, false);
								sheet1.SetCellValue(Row, 'languageNm', dtWord.map.seqNumTword);
							}
						}
					]
				});
				layerModal.show();
			}

		}catch(ex){
			alert("OnPopupClick Event Error : " + ex);
			}

	}
	
    // 프로그램관리 레이어 팝업 layer popup
    function prgMgrPopup(pUrl, param) {
         let layerModal = new window.top.document.LayerModal({
               id : 'prgMgrLayer'
             , url : pUrl
             , parameters : param
             , width : 740
             , height : 620
             , title : '프로그램관리'
             , trigger :[
                 {
                       name : 'prgMgrTrigger'
                     , callback : function(result){
                         sheet1.SetCellValue(gPRow, "menuNm",    result.menuNm );
                         sheet1.SetCellValue(gPRow, "prgCd",     result.prgCd );
                     }
                 }
             ]
         });
         layerModal.show();
    }
    
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(sheet1.ColSaveName(Col) == "helpPop"	&& Row >= sheet1.HeaderRows()) {
				if (sheet1.GetCellValue(Row, "sStatus") == "I") {
					alert("<msg:txt mid='alertMainMuPrg6' mdef='입력상태에서는 도움말을 등록 할 수 없습니다.'/>");
					return;
				}

				if (sheet1.GetCellValue(Row, "helpPop") == "") return;

				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "viewMainMuPrgPop";

				var args = {mainMenuCd  : sheet1.GetCellValue(Row, "mainMenuCd"),
						priorMenuCd : sheet1.GetCellValue(Row, "priorMenuCd"),
						menuCd      : sheet1.GetCellValue(Row, "menuCd"),
						menuSeq     : sheet1.GetCellValue(Row, "menuSeq"),
						prgCd       : sheet1.GetCellValue(Row, "prgCd"),
						menuNm      : sheet1.GetCellValue(Row, "menuNm")};
				//var rv = openPopup("${ctx}/MainMuPrg.do?cmd=viewMainMuPrgPop&authPg=A", args, "1520","820");
				mainMuPrgPopup("${ctx}/MainMuPrg.do?cmd=viewMainMuPrgLayer&authPg=A", args);
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	// 도움말 레이어 팝업 layer popup
	function mainMuPrgPopup(pUrl, param) {
	     let layerModal = new window.top.document.LayerModal({
	           id : 'mainMuPrgLayer'
	         , url : pUrl
	         , parameters : param
	         , width : 1520
	         , height : 820
	         , title : '도움말 등록'
	         , trigger :[
	             {
	                   name : 'mainMuPrgTrigger'
	                 , callback : function(result){
	                       doAction('Search');
	                 }
	             }
	         ]
	     });
	     layerModal.show();
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="mainMenuNm" name="mainMenuNm"/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><sch:txt mid='mainMenuNmV1' mdef='메뉴명'/> </th>
						<td>  <select id="mainMenuCd" name="mainMenuCd"> </select> </td>
						<td> <btn:a href="javascript:doAction('Search');" id="btnSearch" mid="110697" mdef="조회" css="btn dark"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='mainMuPrg' mdef='메인메뉴프로그램관리'/>
								&nbsp;
								<div class="util">
								<ul>
									<li	id="btnPlus"></li>
									<li	id="btnStep1"></li>
									<li	id="btnStep2"></li>
									<li	id="btnStep3"></li>
								</ul>
								</div>
							</li>
							<li class="btn">
								<btn:a href="javascript:doAction('Down2Excel');" mid="110698" mdef="다운로드" css="btn outline-gray authR"/>
								<a href="javascript:doAction('Insert1');" class="btn outline-gray authA">동일레벨추가</a>
								<a href="javascript:doAction('Insert2');" class="btn outline-gray authA">하위레벨추가</a>
								<btn:a href="javascript:doAction('Save');" mid="110708" mdef="저장" css="btn filled authA"/>
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