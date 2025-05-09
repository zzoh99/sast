<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>재정산계산</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	//급여계산중이거나, 급여계산취소 중이면 true
	var waitFlag    = false;
	var msg = "";
	
	var newIframe;
	var oldIframe;
	var iframeIdx;
	var tabObj;

	var scrollRange = 60;

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchWorkYy").val("<%=yeaYear%>") ;
		
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00303"), "전체");        
        var bizPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
        
        $("#searchAdjustType").html(adjustTypeList[2]); //전체로 초기 세팅
        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
        
    	tabObj = $( "#tabs" ).tabs({
    		beforeActivate: function(event, ui) {
    			if( -1 < ui.oldTab.index() ) {
    				try{
    					if( $(ui.oldPanel).find('iframe')[0].contentWindow.sheetChangeCheck() ) {
    						if ( !confirm("현재 화면에서 저장되지 않은 내역이 있습니다.\n\n무시하고 이동하시겠습니까? ") ) {
    							return false;
    						}
    					}
    				} catch(e) {}

    			}

    			iframeIdx = ui.newTab.index();
    			newIframe = $(ui.newPanel).find('iframe');
    			oldIframe = $(ui.oldPanel).find('iframe');
    			oldIframe.attr("id","oldIframe");
    			newIframe.attr("id","newIframe");
    			showIframe();
    		}
    	});

    	createTabFrame();

        $("#searchWorkYy, #searchSbNm").bind("keyup",function(event){
            if( event.keyCode == 13){
            	searchIframe();
            }
        });
        

		<%-- 속도저하 때문에 아래와 같이 변경 20240710
		//해당 년도의 재정산 차수 리스트 조회
		var strUrl = "<%=jspPath%>/yeaCalcSearch/yeaCalcSearchRst.jsp?cmd=selectYeaReSeqList&searchYear=<%=yeaYear%>" ;
		var searchReSeq = stfConvCode( codeList(strUrl,"") , "");   			
		$("#searchReSeq").html(searchReSeq[2]); //전체로 초기 세팅 --%>
		var searchReSeq = "";
		for (var i=1; i<11; i++) { // 디폴트로 10회차까지 표시
			searchReSeq = searchReSeq + "<option value='" + i + "'>" + i + "회차</option>";
		}
		$("#searchReSeq").html(searchReSeq); //전체로 초기 세팅
		$("#searchReSeq").select2({
		placeholder: "전체"
		, maximumSelectionSize:5
		});
		
	});

	// 탭 생성
	function createTabFrame() {
	
		tabObj.find(".ui-tabs-nav")
		.append("<li><a href='#tabs-1' id='tabs1'>대상선정</a></li>")
		.append("<li><a href='#tabs-2' id='tabs2'>재정산계산</a></li>")
		.append("<li><a href='#tabs-3' id='tabs3'>대상자정보수정</a></li>")
		;
	
		tabObj
		.append("<div id='tabs-1'><div class='layout_tabs'><iframe src='' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-2'><div class='layout_tabs'><iframe src='' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-3'><div class='layout_tabs'><iframe src='' frameborder='0' class='tab_iframes'></iframe></div></div>")
		;
	
		$("#tabs")
		.append("<div id='moveL' class='btn-tab-move btn-left'><a href='#' onclick='javascript:moveTabScroll(\"L\"); return false;'></a></div>")
		.append("<div id='moveR' class='btn-tab-move btn-right'><a href='#' onclick='javascript:moveTabScroll(\"R\"); return false;'></a></div>")
		;
	
		newIframe = $('#tabs-1 iframe');
		iframeIdx = 0;
	
		tabObj.tabs( "refresh" );
		tabObj.tabs( "option", "active", 0 );
	
		/* Tab Scroll Button 관련 */
		var tabWidth = 0;
		$(".ui-tabs-nav li").each(function(index, item) {
			tabWidth += $(this).width()+21; //margin +1
		});
	
		$("#defTabWidth").val(tabWidth);
	
	
		if(tabWidth < $(window).width()) {
			$(".ui-tabs-nav").width($(window).width());
		}
		else {
			$(".ui-tabs-nav").width(tabWidth);
		}
		$(".ui-tabs-nav").css("position", "absolute");
	
		setMoveButtonPosition();
	}
	
	function setMoveButtonPosition() {
		var iframeWidth = $(document).width();
		var tabWidth = parseInt($("#defTabWidth").val());
		var tabLeft = isNaN(parseInt($(".ui-tabs-nav > li").css("left").split("px")[0])) ? 0 : parseInt($(".ui-tabs-nav > li").css("left").split("px")[0]);
	
		if(iframeWidth < tabWidth+tabLeft+39) {
			$("#moveL").show();
			$("#moveR").show();
	
			$("#moveL").css("right", "29px");
			$("#moveR").css("right", "0");
		}
		else {
			if(tabLeft < 0) {
				tabLeft = 0;
				$(".ui-tabs-nav > li").css("left", tabLeft);
			}
	
			$("#moveL").show();
			$("#moveR").show();
	
			$("#moveL").css("right", "29px");
			$("#moveR").css("right", "0");
	
		}
	}
	
	function moveTabScroll(param) {
		var docWidth = $(window).width();
		var tabWidth = $(".ui-tabs-nav").width();
		var tabLeft = isNaN(parseInt($(".ui-tabs-nav > li").css("left").split("px")[0])) ? 0 : parseInt($(".ui-tabs-nav > li").css("left").split("px")[0]);
	
		if(param == "L") {
			if(tabLeft >= 0) {
				return false;
			}
			$(".ui-tabs-nav > li").animate({left: (tabLeft + scrollRange) + "px"}, 100);
		}
		else if(param == "R") {
			if(tabWidth + tabLeft+39 <= docWidth) {
				return false;
			}
			$(".ui-tabs-nav > li").animate({left: (tabLeft - scrollRange) + "px"}, 100);
		}
	}
	
	$(window).resize(function() {
		var timer = setTimeout(function() {
			if(parseInt($("#defTabWidth").val()) < $(window).width()) {
				$(".ui-tabs-nav").width($(window).width());
			}
			else {
				$(".ui-tabs-nav").width($("#defTabWidth").val());
			}
			setMoveButtonPosition();
		}, 100);
	});
	
	//탭로딩
	function showIframe() {
		if(typeof oldIframe != 'undefined') oldIframe.attr("src","");
		
		var param = "?authPg=<%=authPg%>"
		          + "&searchAdjustType=" + $('#searchAdjustType').val()
		          + "&searchBizPlaceCd=" + $('#searchBizPlaceCd').val()
		          + "&searchSbNm=" + encodeURI($('#searchSbNm').val())
		          + "&searchDDD=" + $('#searchDDD').val()
		          + "&searchGubun=" + $('#searchGubun').val()
		          //+ "&searchReSeq=" + ($("#searchReSeq").val()==null?"":getMultiSelect($("#searchReSeq").val()))
		          + "&searchReSeq=" + ($("#searchReSeq").val()==null?"":$("#searchReSeq").val())
		          ;

		var strSearchPayPeopleStatus = $('#searchPayPeopleStatus').val() ;		
		if (strSearchPayPeopleStatus == "search884") param = param + "&search884=Y" ; // 대상선정
		else if (strSearchPayPeopleStatus == "PM" || strSearchPayPeopleStatus == "J") param = param + "&searchPayPeopleStatus=PM" ; // 작업대상(재계산)
		else if (strSearchPayPeopleStatus == "Y" || strSearchPayPeopleStatus == "N") param = param + "&searchCloseYn=" + strSearchPayPeopleStatus ; // 마감여부
		
		if(iframeIdx == 0) newIframe.attr("src","<%=jspPath%>/yeaReCalc/yeaReCalcNav1.jsp" + param);
		else if(iframeIdx == 1) newIframe.attr("src","<%=jspPath%>/yeaReCalc/yeaReCalcNav2.jsp" + param);
		else if(iframeIdx == 2) newIframe.attr("src","<%=jspPath%>/yeaReCalc/yeaReCalcNav3.jsp" + param);
	}

	//탭로딩-자동조회
	function searchIframe() {
		$('#newIframe').contents().find('#searchAdjustType').val($('#searchAdjustType').val());
		$('#newIframe').contents().find('#searchBizPlaceCd').val($('#searchBizPlaceCd').val());
		$('#newIframe').contents().find('#searchSbNm').val($('#searchSbNm').val());
		$('#newIframe').contents().find('#searchDDD').val($('#searchDDD').val());
		$('#newIframe').contents().find('#searchGubun').val($('#searchGubun').val());
		//$('#newIframe').contents().find('#searchReSeq').val(($("#searchReSeq").val()==null?"":getMultiSelect($("#searchReSeq").val())));
		$('#newIframe').contents().find('#searchReSeq').val(($("#searchReSeq").val()==null?"":$("#searchReSeq").val()));

		var strSearchPayPeopleStatus = $('#searchPayPeopleStatus').val() ;
		if (strSearchPayPeopleStatus == "search884") $('#newIframe').contents().find('#search884').val("Y") ; // 대상선정
		else if (strSearchPayPeopleStatus == "PM" || strSearchPayPeopleStatus == "J") $('#newIframe').contents().find('#searchPayPeopleStatus').val(strSearchPayPeopleStatus) ; // 작업대상(재계산)
		else if (strSearchPayPeopleStatus == "Y" || strSearchPayPeopleStatus == "N")  $('#newIframe').contents().find('#searchCloseYn').val(strSearchPayPeopleStatus) ; // 마감여부
		
        var iframeWindow = document.getElementById('newIframe').contentWindow;
        
         // iframe 내 정의된 함수 호출
         if (iframeWindow && iframeWindow.sheetSearch) {
             iframeWindow.sheetSearch();
         } else {
             console.error("newIframe의 sheetSearch 함수에 접근할 수 없습니다.");
         }		
	}

	//	"최종" 일 경우 차수를 선택하는 selectbox 비활성화 처리. (차수는 수정(이력) 에서만 부여되기 때문에 최종에서는 의미가 없음)
    function searchGubun_onChange() {
		var searchGubun = $("#searchGubun").val();
		
    	/* searchReSeq 콤보박스는 Select2 플러그인을 사용하여 다중선택콤보로 커스텀 UI가 적용되어 있음. (위 338 라인)
    	---------------------------------------------------------------------------------------------
    	<select> 요소에 스타일과 기능을 추가하면 기본적으로 HTML <select> 요소의 UI가 Select2의 커스텀 UI로 대체되므로
    	disabled를 설정하려면 Select2 API를 통해 해당 상태를 전달해야 함. 
    	(Select2는 자체적으로 UI를 관리하며, 기본 <select> 요소의 disabled 상태를 감지하지 않음.) */
		if(searchGubun == "F") {
			$('#searchReSeq').val(null).trigger('change'); // 선택된 옵션을 초기화하고 Select2에 변경사항을 알림
			$('#searchReSeq').prop('disabled', true);      // 기본 select 요소 비활성화
		} else {
			$('#searchReSeq').prop('disabled', false);
		}
		
		// 설정한 내용을 기준으로 Select2 인스턴스를 다시 초기화하여 반영
   		$("#searchReSeq").select2({
		  	  placeholder: "전체" // 아무것도 선택되지 않았을 때 표시할 텍스트
			, maximumSelectionSize:5
		});
	}

</script>


</head>
<body class="hidden">
<input type="hidden" id="defTabWidth" name="defTabWidth" />	
<div id="progressCover" style="display:none;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
		
	<form id="sheetForm" name="sheetForm">
		<input type="hidden" id="menuNm" name="menuNm"/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> <span>귀속년(월)</span>
							<input type="text" id="searchWorkYy" name="searchWorkYy" maxlength="6" class="text w45 center readonly " onFocus="this.select()" readonly/>
						</td>
						<td>
							<span>정산구분</span>
							<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:searchIframe();" class="box"></select>
						</td>						
						<td>
		                    <span>재정산</span>
		                    <select id="searchGubun" name ="searchGubun" class="box" onChange="javascript:searchGubun_onChange()">
		                    	<option value="">전체</option>
		                    	<option value="F">최종</option>
		                    	<option value="H">수정(이력)</option>
		                    </select>
		                    <select id="searchReSeq" name="searchReSeq" multiple onChange="javascript:searchIframe();"></select>
							<select id="searchPayPeopleStatus" name ="searchPayPeopleStatus" onChange="javascript:searchIframe();" class="box">
								<option value="" selected="selected">전체</option>
		                    	<option value="search884">선정대상</option>
		                    	<option value="PM">작업대상</option> <%-- searchPayPeopleStatus --%>
		                    	<option value="J">작업완료</option> <%-- searchPayPeopleStatus --%>
		                    	<option value="N">미마감</option>   <%-- searchCloseYn --%>
		                    	<option value="Y">마감</option>    <%-- searchCloseYn --%>
							</select>
							<select id="searchDDD" name ="searchDDD" onChange="javascript:searchIframe();" class="box">
								<option value="">삭제자료포함</option>
								<option value="1" selected="selected">삭제자료제외</option>
								<option value="2">삭제자료만</option>
							</select>
						</td>
						<td> 
							<span>사업장</span>
							<select id="searchBizPlaceCd" name ="searchBizPlaceCd" onChange="javascript:searchIframe();" class="box">
								<option value="" selected="selected">전체</option>
							</select>
						</td>
						<td><span>사번/성명</span>
							<input type="text" id="searchSbNm" name ="searchSbNm" maxlength="15" class="text w100 center " onFocus="this.select()" /> 
						</td>	
						<td>
							<a href="javascript:searchIframe();" id="btnSearch" class="button">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
	<div class="insa_tab" style="top:45px;" id="div_insa_tab">
		<div id="tabs" class="tab">
			<ul></ul>
		</div>
	</div>
	
</div>
</body>
</html>