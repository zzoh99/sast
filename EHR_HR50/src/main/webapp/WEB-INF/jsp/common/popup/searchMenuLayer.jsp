<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>메뉴검색</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>

<script type="text/javascript" src="/common/js/cookie.js"></script>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"메뉴명",		Type:"Html",		Hidden:0,	Width:300,	Align:"Left", SaveName:"searchPath",  Edit:0, HoverUnderline:1, Cursor:"Pointer" },
			
			//Hidden 
			{Header:"Hidden",	Type:"Text",	Hidden:1,	SaveName:"prgCd" },
			{Header:"Hidden",	Type:"Text",	Hidden:1,	SaveName:"mainMenuCd"}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		
		sheet1.FocusAfterProcess = false;
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		
		sheet1.FitColWidth();
		
		$(window).smartresize(sheetResize); sheetInit();
		
		// 로딩바 미출력..
		if( p != undefined && p.hideGrLayerPopLoadingBar != undefined ) {
			p.hideGrLayerPopLoadingBar();
		}
	});
	
	$(function() {
		
        $("#searchText").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

	});
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			var param = "searchText="+$("#searchText").val();
		    sheet1.DoSearch( "${ctx}/SearchMenuLayer.do?cmd=getSearchMenuLayerList", param);
            break;
		}
    } 
	
	// 조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	
	// 클릭 시 
	function sheet1_OnClick(Row, Col, Value) {
		try{
			/*
			$form = $("#menuForm")
		    if ($form.length > 0) {
		        $form.remove();
		    }
		    $form = $("<form><form/>").attr({
		        id: "menuForm",
		        name: "menuForm",
		        method: 'POST'
		    });
		    $(parent.document.body).append($form);

		    
		    
			var mainMenuCd = sheet1.GetCellValue(Row, "mainMenuCd");
			var prgCd = sheet1.GetCellValue(Row, "prgCd");
		    
			var str = "mainMenuCd="+ mainMenuCd + "&menuSeq=&prgCd="+prgCd ;
			var result = ajaxCall("/geSubDirectMap.do",str,false).map;
			if(result==null){
				alert("해당메뉴에 대한 조회 권한이 없습니다.");
				return;
			}

		    $("<input></input>", {
		        id: "murl",
		        name: "murl",
		        type: "hidden",
		        value:result.surl
		    }).appendTo($form);
			
			submitCall($form,"","post","/Hr.do");
			*/

		    
			var mainMenuCd = sheet1.GetCellValue(Row, "mainMenuCd");
			var prgCd = sheet1.GetCellValue(Row, "prgCd");
			var str = "mainMenuCd="+ mainMenuCd + "&menuSeq=&prgCd="+prgCd ;
			var result = ajaxCall("/geSubDirectMap.do",str,false).map;

			if(result==null){
				alert("해당메뉴에 대한 조회 권한이 없습니다.");
				return;
			}
			
			if(parent.location.href.indexOf("/Hr.do") > -1){
				$("#majorMenu1 li", parent.document).each(function(){
					if( $(this).attr("mainMenuCd") == sheet1.GetCellValue(Row, "mainMenuCd") && $(this).hasClass("lnb_selected") == false ){
						parent.majorMenuOpen( $(this).attr("mainMenuCd") );
					}
				});
		
				checkOpenMenu(result.surl, result.menuId);
				
			}else{
				parent.goSubPage(mainMenuCd,"","","",prgCd);
			}
	
	  	}catch(ex){
	  		alert("OnClick Event Error : " + ex);
	  	}
	}
	function onView(){
		//console.log("searchMenuLayer.jsp onView()");
		
		sheetResize();
		setTimeout(function(){ sheetResize(); $("#searchText").focus();},100);
	}
	
	function checkOpenMenu(s, m){
		//console.log( "Check Menu Open !!");
		var isOpen = false;
		$("#subMenuCont>li, #subMenuCont>li>dl>dt, #subMenuCont>li>dl>dt>dd", parent.document).each(function() {
			if( $(this).attr("menuId") == m ) {
				isOpen = true;
			}
		});
		if( isOpen ){
			//console.log( "Check Menu Open !! true");
			parent.openSubMenuCd(s, m);
			return true;
		} else{
			//console.log( "Check Menu Open !! false");
			return setTimeout(function(){ checkOpenMenu(s, m) }, 500 ); 
		}
				
	}
	
</script>

</head>
<body>
<div class="wrapper">
	<div class="outer">
		<table class="table">
		<colgroup>
			<col width="80" />
			<col width="" />
			<col width="50" />
		</colgroup>
		<tr>
			<th>메뉴명</th>
			<td>
				<input type="text" id="searchText" name="searchText" class="text w90p center" />
			</td>
			<td>
				<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
			</td>
		</tr>
		</table>
	</div>         
	<div class="h10 outer"></div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>



