<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var subRowYn = false;
	var skk = "";
	var stdCol = "";
	var stdPos = "";
	var sumCols = "";
	var avgCols = "";	
	$(function() {
		var arg = p.popDialogArgumentAll();
		var srchSeq = p.opener.$("#srchSeq").val()+"";

		$("#srchSeq").val(srchSeq);
		//var srchSeq = "${srchSeq}";

		var initdata = {};

		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata.Cols = [];

		var typeArr = {};
		typeArr["Ymd"] 		= {Type:"Date",	Align:"Center",	Format:"Ymd"	};
		typeArr["Ym"] 		= {Type:"Date",	Align:"Center",	Format:"Ym"		};
		typeArr["Number"] 	= {Type:"Int",	Align:"Right",	Format:"Integer"};
		typeArr["Float"] 	= {Type:"Float",Align:"Right",	Format:"Float"	};
		typeArr["Integer"] 	= {Type:"Int",	Align:"Right",	Format:"Integer"};
		typeArr["IdNo"] 	= {Type:"Text",	Align:"Center",	Format:"IdNo"	};
		typeArr["dfNone"] 	= {Type:"Text",	Align:"Center",	Format:"\"\""	};
		typeArr[""] 		= {Type:"Text",	Align:"Center",	Format:"\"\""	};
		//var rtn = ajaxCall("${ctx}/PwrSrchResultPopup.do?cmd=getPwrSrchResultPopupIBSheetColsList","&srchSeq="+srchSeq,false).data;
		var rtn = ajaxCall("${ctx}/PwrSrchResultPopup.do?cmd=getPwrSrchResultPopupIBSheetColsList",$("#sheet1Form").serialize(),false ).data;
		var tv="";
		var str="";
		if (rtn.length > 0) {
			// 퇴직추계액계산결과 검색결과 팝업
			if ($.trim(rtn[0].searchSeq) == "750") {
				typeArr["Number"] = {Type:"AutoSum",	Align:"Right",	Format:"Integer"};
			}
		}

		for(var i=0; i<rtn.length; i++){
			tv = $.trim(rtn[i].inqType);

			str+=rtn[i].columnNm+"_"+tv+"\n";
			initdata.Cols[i] = { Header:rtn[i].columnNm, Type:typeArr[tv].Type, Hidden:0, Width:rtn[i].widthRate, Align:rtn[i].align, ColMerge:under2camel(rtn[i].mergeYn), SaveName:under2camel(rtn[i].columnNm), KeyField:0, Format:typeArr[tv].Format, UpdateEdit:0};
			skk = skk + "{ Header:"+rtn[i].columnNm+", Type:"+typeArr[tv].Type+", Hidden:0, Width:"+rtn[i].widthRate+", Align:"+rtn[i].align+", ColMerge:0, SaveName:under2camel("+rtn[i].columnNm+"), KeyField:0, Format:"+typeArr[tv].Format+", UpdateEdit:0}";

//			console.log("rtn[i].languageNm : "+ rtn[i].languageNm);
//			initdata.Cols[i] = { Header:(rtn[i].languageNm == null || rtn[i].languageNm == undefined || rtn[i].languageNm == '' ? rtn[i].columnNm : rtn[i].languageNm ), Type:typeArr[tv].Type, Hidden:0, Width:100, Align:typeArr[tv].Align, ColMerge:under2camel(rtn[i].mergeYn), SaveName:under2camel(rtn[i].columnNm), KeyField:0, Format:typeArr[tv].Format, PointCount:0, UpdateEdit:0};
//			skk = skk + "{ Header:"+(rtn[i].languageNm == null || rtn[i].languageNm == undefined || rtn[i].languageNm == '' ? rtn[i].columnNm : rtn[i].languageNm )+", Type:"+typeArr[tv].Type+", Hidden:0, Width:100, Align:"+typeArr[tv].Align+", ColMerge:0, SaveName:under2camel("+rtn[i].languageNm+"), KeyField:0, Format:"+typeArr[tv].Format+", PointCount:0, UpdateEdit:0}";


			if(rtn[i].subSumType == "STD") {
				stdCol = under2camel(rtn[i].columnNm);
				stdPos = i;
				subRowYn = true; //subrow있음을 확인
			}
			if(rtn[i].subSumType == "SUM") {
				if(sumCols == "") {
					sumCols = sumCols + i;
				} else {
					sumCols =  sumCols + "|" + i;
				}
			} else if(rtn[i].subSumType == "AVG"){
				if(avgCols == "") {
					avgCols = avgCols + i;
				} else {
					avgCols = avgCols + "|" +  i;
				}
			}
		}

		if (rtn.length <= 0) {
			initdata.Cols[0] = { Header:"조회된 데이터가 없습니다.", Sort:0 };
		}

		//subtotal이 출력시에는 smLazyLoad로 표시해야함
		if(subRowYn) {
			initdata.Cfg = {SearchMode:smLazyLoad,Page:100,MergeSheet:msAll};
		} else {
			initdata.Cfg = {SearchMode:smServerPaging,Page:100,MergeSheet:msAll};
		}



		/*
		var info =[{StdCol:"priorOrgNm", SumCols:sumColsInfo, ShowCumulate:0, CaptionCol:3}];
		sheet1.ShowSubSum(info) ;
		*/

 		//alert(skk);
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);
		$(window).smartresize(sheetResize); sheetInit();sheetResize();
	    $(".close").click(function() {
	    	p.self.close();
	    });
	    doAction("Search");

		//$("#name").bind("keyup",function(event){if( event.keyCode == 13){findName();}});

	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {	//만건단위로 변경  by JSG=> 스크롤 내렸을때 서버 다운됨(2013.8.28일) ic => ServerPaging
		case "Search":
			var page = sheet1.GetSheetPageLength();
			$("#defaultRow").val(page);
			var param = {"Param":"cmd=getPwrSrchResultPopupList&"+$("#sheet1Form").serialize()};
			if(stdCol != "") {
				var info ={StdCol:stdCol, SumCols:sumCols, AvgCols:avgCols, ShowCumulate:0, CaptionCol:stdPos};
				sheet1.ShowSubSum(info) ;
			}			
			sheet1.DoSearchPaging( "${ctx}/PwrSrchResultPopup.do", param );
			break;
		//case "Down2Excel":	sheet1.Down2Excel(); break;
		case "Down2Excel":

			//subtotal이 출력시에는 smLazyLoad로 표시해야함
 			if(subRowYn) {
				sheet1.Down2Excel();
			} else {
				var param = {
						URL:"${ctx}/PwrSrchResultPopup.do"
					    ,ExtendParam:"&cmd=getPwrSrchResultPopupDown&" + $("#sheet1Form").serialize()
					    ,FileName:"PersonList${curSysYyyyMMdd}.xls"
					    , Merge:1 /*속도 문제가 있지만 크게 문제 없으므로 추가함*/
					};
					sheet1.DirectDown2Excel(param);
			}

			//sheet1.Down2Excel();

			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}


	/* 카멜표기법으로 치환하여 줌 by JSG *///  ==>common.js under2camel 참조바람 ic
	/*
	function setCamelExp( expStr ) {
		var before = expStr.toLowerCase();
		//테이블 . 필드명 으로 접근된 경우 제거
		before.indexOf(".") != -1 ? before = before.substr( before.indexOf(".")+1, before.length ) : "" ;
		var result = "";

		var bs = before.split("_");
		if(bs.length < 2) { return before ; }
		for(i=0; i<bs.length; i++){
			if(bs[i].length > 0){
				if(i==0)
					result += bs[i].toLowerCase();
				else
					result += bs[i].toLowerCase().substr(0,1).toUpperCase()+bs[i].substr(1,bs[i].length-1) ;
			}
		}
		return result ;
	}
	*/
// 검색한 이름을 sheet에서 선택
 function checkEnter() {
	if (event.keyCode==13) findName();
}

// 검색한 이름을 sheet에서 선택
 function findName() {
	if ($("#name").val() == "") return;
	var Row = 0;
	var startRow = sheet1.GetSelectRow()+1;
	if (startRow <= sheet1.LastRow()) {Row = sheet1.FindText("성명", $("#name").val(), startRow, 2);}
	if (Row > 0) {sheet1.SelectCell(Row,"성명");}
	$("#name").focus();
}

 </script>
</head>

<body class="bodywrap">
	<form id="sheet1Form" name="sheet1Form">
		<input id="srchSeq" name="srchSeq" type="hidden" >
		<input id="defaultRow" name="defaultRow" type="hidden" >
		<input id="dfIdvSabun" name="dfIdvSabun" type="hidden" value="${ ssnSabun }" >
	</form>
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>검색결과 조회</li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt">타이틀</li>
									<li class="btn">
										<!--
										<span>성명</span>
										<input type="text" id="name" name="name" class="text" value="" size="20" style="ime-mode:active" onKeyUp="checkEnter();" />
										<a onclick="javascript:findName();"  class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
										-->
										<btn:a href="javascript:doAction('Search')" css="button authA" mid='search' mdef="조회"/>
										<a href="javascript:doAction('Down2Excel')" class="basic authR">다운로드</a>
									</li>
								</ul>
							</div>
						</div> <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
			<div class="popup_button outer">
				<ul>
					<li><btn:a href="javascript:p.self.close();" css="gray large" mid='close' mdef="닫기"/>
					</li>
				</ul>
			</div>
		</div>

	</div>
</body>
</html>