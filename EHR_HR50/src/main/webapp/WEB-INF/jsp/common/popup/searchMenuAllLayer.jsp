<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>전체메뉴</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<script type="text/javascript" src="/common/js/cookie.js"></script>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		doAction1("Search");
	});
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회

			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/SearchMenuAllLayer.do?cmd=getSearchMenuAllLayerList", "",false);
			var list = data.DATA;
			var colCnt = 0, subCnt = 0, tableHtml = "", ulHtml = "";
			if ( data != null && data.DATA != null ){
				
				for( var i = 0; i < list.length ; i++){
					var map = list[i];
					if( map.lev == "1"){
						if( ulHtml != "" && subCnt > 0 ){
							tableHtml += "<td>"+ulHtml +"</ul></td>";
							colCnt++;
						}
						subCnt = 0
						ulHtml = "<ul><li class='title'>"+map.menuNm+"</li>";
					}else{
						ulHtml += "<li class='li-"+map.lev+" tp-"+map.lev+map.type+"'>";
						if( map.type == "P" ||  map.type == "S" || map.type == "L"){
							ulHtml += "- <a onClick=\"onMenuOpen('"+map.mainMenuCd+"','"+map.prgCd+"')\">"+map.menuNm+"</a>";
						}else{
							ulHtml += map.menuNm;	
						}
						ulHtml += "</li>";	
						
						subCnt++; 
					}
				}
				if( ulHtml != "" && subCnt > 0 ){
					tableHtml += "<td>"+ulHtml +"</ul></td>";
					colCnt++;
				}
				var colGrp = "";
				for( var i=0; i < colCnt-1 ; i++ ){
					colGrp += "<col width='"+parseInt(100/colCnt)+"%' />";
				} 
				colGrp = "<colgroup>" + colGrp + "<col width=''/></colgroup>";
				$("#table").html(colGrp+"<tr>"+tableHtml+"</tr>");
			}
			
			// 로딩바 미출력..
			if( p != undefined && p.hideGrLayerPopLoadingBar != undefined ) {
				p.hideGrLayerPopLoadingBar();
			}
		}
    } 
	
	function onMenuOpen(mainMenuCd, prgCd){
		
		console.log(mainMenuCd +"-->"+prgCd);

		try{
			var str = "mainMenuCd="+ mainMenuCd + "&menuSeq=&prgCd="+prgCd ;
			var result = ajaxCall("/geSubDirectMap.do",str,false).map;

			if(result==null){
				alert("해당메뉴에 대한 조회 권한이 없습니다.");
				return;
			}
			parent.closeLayerPop();
			if(parent.location.href.indexOf("/Hr.do") > -1){
				$("#majorMenu1 li", parent.document).each(function(){
					if( $(this).attr("mainMenuCd") == mainMenuCd && $(this).hasClass("lnb_selected") == false ){
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
<style type="text/css">
body { overflow: auto}
table {width:100%;}
td { vertical-align: top;}
li {padding:2px;}
li.title {font-weight: bold; font-size:1.2em; text-align:center;padding:3px; background-color:#666; color:#fff;}
li.li-2 {padding-left:2px;}
li.li-3 {padding-left:7px;}
li.li-4 {padding-left:12px;}
li.tp-2M {font-weight: bold;background-color:#FDF0F5; font-size:1.1em;}
li.tp-3M {background-color:#f4f4f4; }
li.tp-4M {background-color:#f4f4f4; }
li a:hover { text-decoration:underline; color:blue; cursor: pointer; }
</style>
</head>
<body>
<div class="wrapper">
	<table id="table" class="table"></table>
</div>
</body>
</html>



