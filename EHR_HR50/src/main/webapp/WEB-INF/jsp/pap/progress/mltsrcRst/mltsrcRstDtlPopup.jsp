<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var checkType="";

	var arg = p.popDialogArgumentAll();

	$(function() {

		if( arg != "undefined" ) {
			$("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
			$("#searchSabun").val(arg["searchSabun"]);
			$("#searchAppOrgCd").val(arg["searchAppOrgCd"]);
			$("#searchAppSeqCd").val(arg["searchAppSeqCd"]);
			$("#searchAppSabun").val(arg["searchAppSabun"]);
		}

		if($("#searchAppSeqCd").val() == "0"){
			$("#titleNm").text("본인평가");
		} else if($("#searchAppSeqCd").val() == "3"){
			$("#titleNm").text("상사평가");
		} else if($("#searchAppSeqCd").val() == "4"){
			$("#titleNm").text("동료평가");
		} else if($("#searchAppSeqCd").val() == "5"){
			$("#titleNm").text("부하평가");
		}

	 	//평가등급기준 -- 평가종류에 따라 다른 등급을 가져옴.
 		//var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCdList&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, ""); // 평가등급
		var classCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00002"), ""); // 다면평가등급(P00002)

		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			   Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"삭제",			 	Type:"${sDelTy}",	Hidden:1,				   Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			{Header:"상태",			 	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"구분",			 	Type:"Text",		Hidden:1,				   Width:50,		   Align:"Center", ColMerge:1, SaveName:"mainAppTypeNm",	 	KeyField:0,			 UpdateEdit:0,   InsertEdit:0},
			{Header:"평가요소",		 	Type:"Text",		Hidden:0,				   Width:150,		  Align:"Center", ColMerge:0, SaveName:"competencyNm",	  	KeyField:0,			 UpdateEdit:0,   InsertEdit:0},
			{Header:"평가내용",		 	Type:"Text",		Hidden:0,				   Width:500,		  Align:"Left",   ColMerge:0, SaveName:"competencyDetail",  	KeyField:0,			 UpdateEdit:0,   InsertEdit:0, 	MultiLineText:1, Wrap:1 },
			{Header:"평가등급",			Type:"Combo",		Hidden:0,				   Width:80,		 	Align:"Center", ColMerge:0, SaveName:"compClassCd",  		KeyField:0, 			UpdateEdit:1, 	InsertEdit:1,   ComboText:classCdList[0], ComboCode:classCdList[1]},

			{Header:"평가ID",			Type:"Text",		Hidden:1,				   Width:50,		   Align:"Center", ColMerge:0, SaveName:"appraisalCd"},
			{Header:"사번",				Type:"Text",		Hidden:1,				   Width:50,		   Align:"Center", ColMerge:0, SaveName:"sabun"},
			{Header:"평가소속",		 	Type:"Text",		Hidden:1,				   Width:50,		   Align:"Center", ColMerge:0, SaveName:"appOrgCd"},
			{Header:"평가차수",			Type:"Text",		Hidden:1,				   Width:50,		   Align:"Center", ColMerge:0, SaveName:"appSeqCd"},
			{Header:"평가자사번",	   	Type:"Text",		Hidden:1,				   Width:50,		   Align:"Center", ColMerge:0, SaveName:"appSabun"},
			{Header:"역량코드",			Type:"Text",		Hidden:1,				   Width:50,		   Align:"Center", ColMerge:0, SaveName:"competencyCd"},
			{Header:"평가의견1",			Type:"Text",		Hidden:1,				   Width:50,		   Align:"Center", ColMerge:0, SaveName:"appMemo1"},
			{Header:"평가의견2",			Type:"Text",		Hidden:1,				   Width:50,		   Align:"Center", ColMerge:0, SaveName:"appMemo2"},
			{Header:"평가u의견1",	Type:"Text",		Hidden:1,				   Width:50,		   Align:"Center", ColMerge:0, SaveName:"appUpMemo1"},
			{Header:"평가u의견2",	Type:"Text",		Hidden:1,				   Width:50,		   Align:"Center", ColMerge:0, SaveName:"appUpMemo2"},
			{Header:"평가u의견3",	Type:"Text",		Hidden:1,				   Width:50,		   Align:"Center", ColMerge:0, SaveName:"appUpMemo3"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		// 평가항목 시트
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,				 	Width:"${sDelWdt}",	Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },

			{Header:"평가ID",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"appraisalCd"},
			{Header:"평가소속",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"appOrgCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"sabun"},
			{Header:"평가차수",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"appSeqCd"},
			{Header:"순번",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"seq"},
			{Header:"평가항목",	Type:"Text",	Hidden:0,	Width:50,	Align:"Left",   ColMerge:0, SaveName:"appItem",		KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:1000, Wrap:1, MultiLineText:1},
			{Header:"평가의견",	Type:"Text",	Hidden:0,	Width:50,	Align:"Left",   ColMerge:0, SaveName:"appOpinion",	KeyField:0, UpdateEdit:1, InsertEdit:1, EditLen:1300, Wrap:1, MultiLineText:1}
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		doAction("Search");

		$(".close").click(function() {
			p.self.close();
		});
	});

	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			 sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getMltsrcEvltList", $("#sheet1Form").serialize() );
			 sheet2.DoSearch( "${ctx}/GetDataList.do?cmd=getMltsrcEvltAppItemOpinionList", $("#sheet1Form").serialize() );
			 break;
		}
	}
   //조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			/*
			if ( $("#searchAppSeqCd").val() == '3' ){
				$("#appSeq3").addClass("show").removeClass("hide");

				$("#appUpMemo1").html( sheet1.GetCellValue(1, "appUpMemo1"));
				$("#appUpMemo2").html( sheet1.GetCellValue(1, "appUpMemo2"));
				$("#appUpMemo3").html( sheet1.GetCellValue(1, "appUpMemo3"));
			}

			if ( $("#searchAppSeqCd").val() == '4' ){
				$("#appSeq4").addClass("show").removeClass("hide");

				$("#appMemo1").html( sheet1.GetCellValue(1, "appMemo1"));
				$("#appMemo2").html( sheet1.GetCellValue(1, "appMemo2"));
			}
			*/
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
   
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			//sheetResize();
			
			if(sheet2.RowCount() > 0) {
				$("#tblAppItemOpinion tbody").html("");
				for(var i = 1; i < sheet2.RowCount()+1; i++) {
					var seq = sheet2.GetCellValue( i, "seq" );
					var appItem = sheet2.GetCellValue( i, "appItem" );
					var appOpinion = sheet2.GetCellValue( i, "appOpinion" );
					var html = "";
					html += "<tr>";
					html += "<th>" + seq + ". " + appItem + "</th>";
					html += "</tr>";
					html += "<tr>";
					html += "<td>";
					html += "<textarea id='appOpinion" + seq + "' name='appOpinion" + seq + "' style=\"width:100%; height:30px;\" readonly='readonly'></textarea>";
					html += "</td>";
					html += "</tr>";
					$("#tblAppItemOpinion tbody").append(html);
					$("#appOpinion" + seq).val(appOpinion);
				}
			} else {
				$(".appOpinion").hide();
			}
			
		}catch(ex){
			alert("[sheet2] OnSearchEnd Event Error : " + ex);
		}
	}
</script>


</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value=""/>
	<input type="hidden" id="searchSabun"	   name="searchSabun"	   value=""/>
	<input type="hidden" id="searchAppOrgCd"	name="searchAppOrgCd"	value=""/>
	<input type="hidden" id="searchAppSeqCd"	name="searchAppSeqCd"	value=""/>
	<input type="hidden" id="searchAppSabun"	name="searchAppSabun"	value=""/>
</form>
	<div class="wrapper" style="overflow-y:auto;">
		<div class="popup_title">
			<ul>
				<li>평가내역상세</li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="outer">
						<div class="sheet_title">
							<ul>
								<li class="txt" id="titleNm">평가항목</li>
								<li class="btn">
								</li>
							</ul>
						</div>
					</div>
					<div id="sheet1_box">
						<script type="text/javascript"> createIBSheet("sheet1", "100%", "390px"); </script>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="outer">
						<div class="sheet_title">
							<ul>
								<li class="txt appOpinion">평가의견</li>
								<li class="btn">
								</li>
							</ul>
						</div>
					</div>
					<div id="sheet2_box" class="hide">
						<script type="text/javascript">createIBSheet("sheet2", "100%", "15%","kr"); </script>
					</div>
<!-- 
					<table class="table outer hide" id="appSeq3">
						<tbody>
						<tr>
							<th>1. 보직자 장점 및 강점</th>
						</tr>
						<tr>
							<td height="30">
								<span id="appUpMemo1"></span>
							</td>
						</tr>
						<tr>
							<th>2. 보직자 개선점</th>
						</tr>
						<tr>
							<td height="30">
								<span id="appUpMemo2"></span>
							</td>
						</tr>
						<tr>
							<th>3. 회사에 바라는 사항</th>
						</tr>
						<tr>
							<td height="30">
								<span id="appUpMemo3"></span>
							</td>
						</tr>
						</tbody>
					</table>
					<table class="table outer hide" id="appSeq4">
						<tbody>
							<tr>
								<th>1. 평가대상조직의 강점</th>
							</tr>
							<tr>
								<td height="30">
									<span id="appMemo1"></span>
								</td>
							</tr>
							<tr>
								<th>2. 평가대상조직의 개선점</th>
							</tr>
							<tr>
								<td height="30">
									<span id="appMemo2"></span>
								</td>
							</tr>
						</tbody>
					</table>
 -->
 					<table class="table outer" id="tblAppItemOpinion">
						<tbody>
						</tbody>
					</table> 
				</td>
			</tr>
			</table>

			<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
			</div>
		</div>
	</div>
</body>
</html>