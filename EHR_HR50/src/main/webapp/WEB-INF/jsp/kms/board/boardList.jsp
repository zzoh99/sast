<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {

		var contactYn = 1;
		if("${map.contactYn}" == "Y" ){contactYn =0;}

		//공지사항유무에 따라  공지시작일, 종료일을 보여주거나 감춘다.
		var notiYn = 1;
		if("${map.notifyYn}" == "Y" ){notiYn=0;}

/*

		if($("#manageYn").val() == "Y" || $("#adminYn").val() == "Y"){
			$(".btn").show();
		} else {
			$(".btn").hide();
		}
*/
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"Text",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"rn" , UpdateEdit:0},
			{Header:"<sht:txt mid='bbsNmV1' mdef='게시판명'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"bbsNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='title' mdef='제목'/>",		Type:"Html",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"title", UpdateEdit:0 },
			{Header:"<sht:txt mid='chargeNameV2' mdef='담당자'/>",		Type:"Text",	Hidden:contactYn,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"contact", UpdateEdit:0 },
			{Header:"<sht:txt mid='fileCnt' mdef='파일'/>",		Type:"Image",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"fileCnt", UpdateEdit:0 },
			{Header:"<sht:txt mid='regDate' mdef='작성일시'/>",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"regDate", UpdateEdit:0 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",	Type:"Date",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate", UpdateEdit:0 },
			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",	Type:"Date",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"edate", UpdateEdit:0 },
			{Header:"<sht:txt mid='notifySdate' mdef='공지시작일'/>",	Type:"Date",	Hidden:notiYn,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"notifySdate", UpdateEdit:0 },
			{Header:"<sht:txt mid='notifyEdate' mdef='공지종료일'/>",	Type:"Date",	Hidden:notiYn,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"notifyEdate", UpdateEdit:0 },
			{Header:"<sht:txt mid='writer' mdef='작성자'/>",		Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"writer", UpdateEdit:0 },
			{Header:"<sht:txt mid='viewCount' mdef='조회수'/>",		Type:"Int",	    Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"viewCount", UpdateEdit:0 },
			{Header:"B",		Type:"Text",	Hidden:1,	Width:45,	Align:"Left",	ColMerge:0,	SaveName:"burl", UpdateEdit:0 },
			{Header:"",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"bbsCd", UpdateEdit:0 },
			{Header:"",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"bbsSeq", UpdateEdit:0 },
			{Header:"",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"priorBbsSeq", UpdateEdit:0 },
			{Header:"",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"masterBbsSeq", UpdateEdit:0 }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");


		if("${map.headYn}" == "Y" ){
			var bizCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","${map.head}"), "<tit:txt mid='111914' mdef='선택'/>");	//카테고리
			$("#boardHead").html(bizCd[2]);
		}

		$("#mainMenuCd").val("20"); //메인메뉴

		$("input[name='chk_all']").click(function () {
			var chk_listArr = $("input[name='chk_list']");
			for (var i=0; i < chk_listArr.length; i++) {
					chk_listArr[i].checked = this.checked;
			}
		});

		$("input[name='chk_list']").click(function () { //리스트 항목이 모두 선택되면 전체 선택 체크
			if ($("input[name='chk_list']:checked").length == 3) {
				$("input[name='chk_all']")[0].checked = true;
			} else  {                                                //리스트 항목 선택 시 전체 선택 체크를 해제함
				$("input[name='chk_all']")[0].checked = false;
			}
		});

		$("#searchWord").bind("keyup",function(event){

			if( event.keyCode == 13 ){
				checkSelectedValue();
				if( $("#chkText").val() ==""){
					alert("<msg:txt mid='alertCondOver2' mdef='검색조건을 선택해 주세요.'/>");
					return;
				}

				doAction1("Search");
				$(this).focus();
			}
		});


		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});



	/**
	 * 선택된 체크박스의 값을 배열에 담는다
	 */
	function checkSelectedValue(){
			var valueArr = new Array();
			var list = $("input[name='chk_list']");
			for(var i = 0; i < list.length; i++){
					if(list[i].checked){ //선택되어 있으면 배열에 값을 저장함
							valueArr.push(list[i].value);
					}
			}

			//선택된 체크박스의 값을 모아서 넘김
			var str = '';
			for(var i in valueArr){
					str += valueArr[i]+',';
			}
			$("#chkField").val(str);
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			checkSelectedValue();
			$("#bbsSort").val("${map.bbsSort}");
			sheet1.DoSearch( "${ctx}/Board.do?cmd=getBoardList", $("#srchFrm").serialize() );
			break;
<c:if test="${map.wCheckYn=='Y'}">
		case "Insert":
			$("#saveType").val("insert");
				submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=viewBoardWrite");
				break;
</c:if>
		case "Read":
			$("#saveType").val("select");
				submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=viewBoardRead");
				break;
		}
	}


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheetResize();
			for(var i = 1 ; i <= sheet1.RowCount() ; i++) {
				if(sheet1.GetCellValue(i, "rn") == "공지") {
					sheet1.SetRowBackColor(i, "#FFFFB3");
					sheet1.SetCellFontBold(i, "rn", 1);
					sheet1.SetCellFontColor(i, "rn", "#FF8224");
					//sheet1.SetCellFontUnderline(i, "title", 1);

				}
			}
		}catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}


	function sheet1_OnDblClick(Row, Col) {
		try{

			$("#bbsSeq").val(sheet1.GetCellValue(Row, "bbsSeq"));
			$("#burl").val(sheet1.GetCellValue(Row, "burl"));
			doAction1("Read");

		}catch(ex) {alert("OnDblClick Event Error : " + ex);}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type=hidden id=saveType  name="saveType"/>
	<input type=hidden id=chkField 	name=chkField>
	<input type=hidden id=bbsCd 	name=bbsCd		value="${map.bbsCd}">
	<input type=hidden id=bbsSeq	name=bbsSeq>
	<input type=hidden id=burl	  	name=burl>


		<div class="sheet_search outer">
			<div>
				<table>
				<tr>
					<td <c:if test="${map.headYn!='Y'}">style="display:none""</c:if>> <span>업무구분  </span> <select id="boardHead" name="boardHead"> </select> </td>
					<td><input type="checkbox" id="chk_all"  name="chk_all" value="ALL" />&nbsp; ALL</td>
					<td><input type="checkbox" id="chk_list" name="chk_list" value="TITLE" />&nbsp; 제목</td>
					<td><input type="checkbox" id="chk_list" name="chk_list" value="CONTENTS" />&nbsp; 내용</td>
					<td><input type="checkbox" id="chk_list" name="chk_list" value="NAME" />&nbsp; 작성자</td>
					<td><input type="text"     id="searchWord" name="searchWord" value="" class="text center" style="width: 100%" /></td>
					<td><btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/></td>
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
							<li id="txt" class="txt"> ${map.bbsNm}</li>
<c:if test="${map.wCheckYn=='Y'}">
							<li class="btn">
								<a href="javascript:doAction1('Insert')" id="writeBtn", name="writeBtn" class="basic"><tit:txt mid='104267' mdef='입력'/></a>
							</li>
</c:if>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
