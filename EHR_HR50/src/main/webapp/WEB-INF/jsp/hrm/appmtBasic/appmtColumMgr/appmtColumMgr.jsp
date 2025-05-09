<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>발령항목정의</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:100,MergeSheet:msHeaderOnly}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"발령|발령",				Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			
		]; 
		// 발령항목 조회
		var postItems = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false);
		
		
		var postItemsNames = "";
		for(var ind in postItems.DATA){
			var postItem = postItems.DATA[ind];
			postItemsNames += ","+postItem.postItem;
			//postItemsNames += ","+"visibleY"+convCamel("n_"+postItem.postItem)+","+"mandatoryY"+convCamel("n_"+postItem.postItem);
			//console.log("visibleY"+convCamel("n_"+postItem.postItem));
			initdata1.Cols.push({Header:postItem.postItemNm+"|항목",Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:convCamel(postItem.postItem+"_VISIBLE_YN"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N"});
			initdata1.Cols.push({Header:postItem.postItemNm+"|필수",	Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:convCamel(postItem.postItem+"_MANDATORY_YN"),			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N"});
		}
		
		$("<input></input>",{id:"s_SAVENAME2",name:"s_SAVENAME2",type:"hidden"}).appendTo($("#mySheetForm"));
		$("#mySheetForm #s_SAVENAME2").val(postItemsNames);
		
		
		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var userCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeCdList",false).codeList, "전체");	//발령종류
		
		sheet1.SetColProperty("ordTypeCd", 		{ComboText:"|"+userCd[0], ComboCode:"|"+userCd[1]} );
		
		//검색조건의 발령
		$("#searchOrdTypeCd").html(userCd[2]);

		$("#searchOrdTypeCd, #useYn").bind("change",function(event){
			doAction1("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 
			sheet1.DoSearch( "${ctx}/AppmtColumMgr.do?cmd=getAppmtColumMgrList", $("#mySheetForm").serialize() ); 
			break;
		case "Save":
			
			//if(!dupChk(sheet1,"ordTypeCd", true, true)){break;}  
			IBS_SaveName(document.mySheetForm,sheet1);			
			sheet1.DoSave( "${ctx}/AppmtColumMgr.do?cmd=saveAppmtColumMgr", $("#mySheetForm").serialize()); 
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			sheet1.DataCopy(); 
			break;
		case "Clear":		
			sheet1.RemoveAll(); 
			break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "발령항목정의_" + d.getTime();
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			}
				
			sheetResize();
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") {
				alert(Msg); 
			}
			
			doAction1("Search");
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th>발령</th>
				<td>
					<select id="searchOrdTypeCd" name="searchOrdTypeCd"></select>
				</td>
				<th>사용여부</th>
				<td>
					<select id="useYn" name="useYn">
						<option value="">전체</option>
						<option value="Y">사용</option>
						<option value="N">사용안함</option>
					</select>
				</td>
				<td>
					<a href="javascript:doAction1('Search');" class="button">조회</a>
				</td>				
			</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">발령항목정의</li>
			<li class="btn">
				<!-- <a href="javascript:doAction1('Insert');" class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy');" class="basic authA">복사</a> -->
				<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>