<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114312' mdef='메뉴 검색'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(document).ready( function() {
		$("#sheet1Form").find("[name=menuKeyword]")
				.keypressEnter(function() {
					doActionSearchMenu('Search')
				}).on("click",function(){
					$(this).select()
				});
		createIBSheet3($("#divSearchMenu").get(0), "sheet1", "100%", "300px","${ssnLocaleCd}");
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = { SearchMode : smLazyLoad, MergeSheet : 0, Page : 22, FrozenCol : 0, DataRowMerge : 0 , AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = { Sort : 1, ColMove : 1, ColResize : 1, HeaderCheck : 0 };
		//InitColumns + Header Title
		initdata.Cols = [ { Header : "No", Type : "Seq", Hidden : 0, Width : 40, Align : "Center", ColMerge : 0, SaveName : "sNo" }, 
			{ Header : "메뉴경로", Type : "Text", Hidden : 0, Width : 500, Align : "Left", ColMerge : 0, SaveName : "sysMenuNm"}, 
			{ Header : "메뉴명", Type : "Text", Hidden : 1, Width : 100, Align : "Center", ColMerge : 0, SaveName : "menuNm"}, 
			{ Header : "프로그램코드", Type : "Text", Hidden : 1, Width : 100, Align : "Center", ColMerge : 0, SaveName : "prgCd"}, 
			{ Header : "인코딩된url", Type : "Text", Hidden : 1, Width : 100, Align : "Center", ColMerge : 0, SaveName : "surl"}, 
			{ Header : "메인메뉴코드", Type : "Text", Hidden : 1, Width : 170, Align : "Left", ColMerge : 0, SaveName : "mainMenuCd"}, 
			{ Header : "메뉴순번", Type : "Text", Hidden : 1, Width : 100, Align : "Center", ColMerge : 0, SaveName : "menuSeq"},
			{ Header : "메뉴ID", Type : "Text", Hidden : 1, Width : 100, Align : "Center", ColMerge : 0, SaveName : "menuId"}
		];
         
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetCountPosition(4);
		sheet1.SetEditableColorDiff(0);
		sheet1.SetEditable(0);
		sheetInit();
		$("#sheet1Form #menuKeyword").focus();
	});
	//메뉴검색 조회
	function doActionSearchMenu(sAction) {
		switch (sAction) {
		case "Search": //조회
			if (($.trim($("#sheet1Form #menuKeyword").val())) == "") {
				alert("검색할 메뉴명을 입력하세요.");
				$("#sheet1Form #menuKeyword").focus();
			} else {
				sheet1.DoSearch("${ctx}/getSearchMenuList.do",
						$("#sheet1Form").serialize(), 1);
			}
			break;
		}
	}
	// 메뉴검색 조회
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {

	}
	// 메뉴검색 클릭
	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if (Row > 0) {
			if(parent.location.href.indexOf("/Hr.do") > -1){
				var pos = sheet1.GetCellValue(Row, "sysMenuNm").lastIndexOf('>');
				var location = sheet1.GetCellValue(Row, "sysMenuNm").substring(0,pos) + " > <span>" + sheet1.GetCellValue(Row, "menuNm") + "</span>";
				
				parent.setSearchMenu();
				var newMajorMenu = $(parent.document).find("#majorMenu li").filter("[mainmenucd="+sheet1.GetCellValue(Row, "mainMenuCd")+"]"); 
				if(!newMajorMenu.hasClass("on")){
					newMajorMenu.trigger("click");
				}
				setTimeout(function(){
					parent.openContent( 
							sheet1.GetCellValue(Row, "menuNm")
							,sheet1.GetCellValue(Row, "prgCd")
							,location
							,sheet1.GetCellValue(Row, "menuId")
							,sheet1.GetCellValue(Row, "surl")
							)},100);
			}else{
				parent.goSubPage(sheet1.GetCellValue(Row, "mainMenuCd"),"",""
						        ,sheet1.GetCellValue(Row, "menuSeq")
						        ,sheet1.GetCellValue(Row, "prgCd"));
			}
			parent.closeDialogSearchMenu();
		}
	}
</script>
</head> 
<body class="bodywrap"  style="margin:20px 20px 0px 20px">
	<div class="wrapper">
		<div>
			<form id="sheet1Form" name="sheet1Form">
				<div class="sheet_search outer">
					<div>
						<table>
							<tr>
								<th><tit:txt mid='104233' mdef='메뉴명'/></th>
								<td>
									<input id="menuKeyword" name="menuKeyword" type="text" class="text" style="ime-mode: active;" />
								</td>
								<td><a href="javascript:doActionSearchMenu('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a></td>
							</tr>
						</table>
					</div>
				</div>
			</form>
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">메뉴조회</li>
					</ul>
				</div>
			</div>
			<div id="divSearchMenu" style="height: 300px"></div>
			
		</div>
	</div>	
</body>
</html>
