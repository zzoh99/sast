<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<script type="text/javascript">

	<%--var p = eval("${popUpStatus}");--%>
	var subRowYn = false;
	var skk = "";
	var stdCol = "";
	var stdPos = "";
	var sumCols = "";
	var avgCols = "";
	var modal;
	$(function() {
		createIBSheet3(document.getElementById('pwrSrchResultLayerSht-wrap'), "pwrSrchResultLayerSht", "100%", "100%", "${ssnLocaleCd}");

		// var arg = p.popDialogArgumentAll();
		// var srchSeq = p.opener.$("#srchSeq").val()+"";

		modal = window.top.document.LayerModalUtility.getModal('pwrResultLayer');
		$("#pwrSrchResultLayerShtForm  #srchSeq").val(modal.parameters.srchSeq);

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
		
		var param = { ...formToJson($('#pwrSrchResultLayerShtForm')), ...modal.parameters };
		
		var rtn = ajaxCall("${ctx}/PwrSrchResultPopup.do?cmd=getPwrSrchResultPopupIBSheetColsList", queryStringToJson(param), false).data;
		var tv="";
		var str="";
		if (rtn.length > 0) {
			// 퇴직추계액계산결과 검색결과 팝업
			if ($.trim(rtn[0].searchSeq) == "750") {
				typeArr["Number"] = {Type:"AutoSum",	Align:"Right",	Format:"Integer"};
			}
		}

		let shtWidth = 0;
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
			if(rtn[i].widthRate > 0)
				shtWidth += Number(rtn[i].widthRate);
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

		// sheet의 width가 Layer body의 width 보다 작은 경우, AutoFitColWidth 속성 적용
		if($("#pwrSrchResultLayerBody").width() > shtWidth)
			initdata.Cfg.AutoFitColWidth = 'init|search|resize|rowtransaction';


		/*
		var info =[{StdCol:"priorOrgNm", SumCols:sumColsInfo, ShowCumulate:0, CaptionCol:3}];
		pwrSrchResultLayerSht.ShowSubSum(info) ;
		*/

 		//alert(skk);
		IBS_InitSheet(pwrSrchResultLayerSht, initdata); pwrSrchResultLayerSht.SetCountPosition(4);pwrSrchResultLayerSht.SetEditableColorDiff (0);
		//var sheetHeight = $('#pwrSrchResultLayerBody').height() - $('#pwrSrchResultLayerShtMain').outerHeight(true);
		var sheetHeight = $('#pwrSrchResultLayerBody').height() - $("#pwrSrchResultLayerShtForm").height() - $(".sheet_title").height()- 2;
		if(sheetHeight > 0) pwrSrchResultLayerSht.SetSheetHeight(sheetHeight);

		$(window).smartresize(sheetResize); sheetInit();

	    // $(".close").click(function() {
	    // 	p.self.close();
	    // });
	    doAction("Search");

		//$("#name").bind("keyup",function(event){if( event.keyCode == 13){findName();}});

	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {	//만건단위로 변경  by JSG=> 스크롤 내렸을때 서버 다운됨(2013.8.28일) ic => ServerPaging
		case "Search":
			var page = pwrSrchResultLayerSht.GetSheetPageLength();
			$("#defaultRow").val(page);
			var p = { ...formToJson($('#pwrSrchResultLayerShtForm')), ...modal.parameters };
			var param = {"Param":"cmd=getPwrSrchResultPopupList&" + queryStringToJson(p)};
			if(stdCol != "") {
				var info = {StdCol:stdCol, SumCols:sumCols, AvgCols:avgCols, ShowCumulate:0, CaptionCol:stdPos};
				pwrSrchResultLayerSht.ShowSubSum(info) ;
			}			
			pwrSrchResultLayerSht.DoSearchPaging( "${ctx}/PwrSrchResultPopup.do", param );
			break;
		//case "Down2Excel":	pwrSrchResultLayerSht.Down2Excel(); break;
		case "Down2Excel":
			/*
			//subtotal이 출력시에는 smLazyLoad로 표시해야함
			if(subRowYn) {
				pwrSrchResultLayerSht.Down2Excel();
			} else {
				var param = {
						URL:"${ctx}/PwrSrchResultPopup.do"
					    ,ExtendParam:"&cmd=getPwrSrchResultPopupDown&" + $("#pwrSrchResultLayerShtForm").serialize()
					    ,FileName:"PersonList${curSysYyyyMMdd}.xls"
					    , Merge:1 /!*속도 문제가 있지만 크게 문제 없으므로 추가함*!/
					};
				pwrSrchResultLayerSht.DirectDown2Excel(param);
			}
			*/

 			var param = {
				URL:"${ctx}/PwrSrchResultPopup.do"
				, ExtendParam:"&cmd=getPwrSrchResultPopupDown&srchSeq=" + $("#srchSeq").val()
				, FileName:"검색결과_${curSysYyyyMMdd}"
				, Merge:1 /*속도 문제가 있지만 크게 문제 없으므로 추가함*/
			};
			pwrSrchResultLayerSht.DirectDown2Excel(param);

			break;
		}
	}
// 검색한 이름을 sheet에서 선택
 function checkEnter() {
	if (event.keyCode==13) findName();
}

// 검색한 이름을 sheet에서 선택
 function findName() {
	if ($("#name").val() == "") return;
	var Row = 0;
	var startRow = pwrSrchResultLayerSht.GetSelectRow()+1;
	if (startRow <= pwrSrchResultLayerSht.LastRow()) {Row = pwrSrchResultLayerSht.FindText("성명", $("#name").val(), startRow, 2);}
	if (Row > 0) {pwrSrchResultLayerSht.SelectCell(Row,"성명");}
	$("#name").focus();
}

 </script>
</head>

<body class="bodywrap">
	<form id="pwrSrchResultLayerShtForm" name="pwrSrchResultLayerShtForm">
		<input id="srchSeq" name="srchSeq" type="hidden" >
		<input id="defaultRow" name="defaultRow" type="hidden" >
		<input id="dfIdvSabun" name="dfIdvSabun" type="hidden" value="${ ssnSabun }" >
	</form>
	<div class="wrapper modal_layer">
		<div class="modal_body" id="pwrSrchResultLayerBody">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" id="pwrSrchResultLayerShtMain">
				<tr>
					<td>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt">타이틀</li>
									<li class="btn">
										<a href="javascript:doAction('Down2Excel')" class="btn outline-gray">다운로드</a>
										<btn:a href="javascript:doAction('Search')" css="btn dark authA" mid='search' mdef="조회"/>
									</li>
								</ul>
							</div>
						</div>
						<div id="pwrSrchResultLayerSht-wrap"></div>
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('pwrResultLayer');" css="btn outline_gray large" mid='close' mdef="닫기"/>
		</div>
	</div>
</body>
</html>