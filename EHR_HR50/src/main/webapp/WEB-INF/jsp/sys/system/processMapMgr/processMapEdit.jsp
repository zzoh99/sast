<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>공통신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<link href="${ ctx }/common/css/nanum.css" rel="stylesheet" />
<link href="${ ctx }/common/css/common.css" rel="stylesheet" />
<link href="${ ctx }/common/css/util.css" rel="stylesheet" />
<link href="${ ctx }/common/css/override.css" rel="stylesheet" />

<!-- HR UX 개선 신규 css -->
<link href="${ ctx }/assets/css/_reset.css" rel="stylesheet" />
<link href="${ ctx }/assets/fonts/font.css" rel="stylesheet" />
<link href="${ ctx }/assets/css/common.css" rel="stylesheet" />

<!-- 개별 화면 css  -->
<link href="${ ctx }/assets/plugins/jquery-ui-1.13.2/jquery-ui-1.13.2.css" rel="stylesheet" />
<%-- <link href="${ ctx }/assets/css/process_map.css" rel="stylesheet" > --%>

<!-- script -->
<script src="${ ctx }/assets/plugins/jquery-ui-1.13.2/jquery-ui-1.13.2.js"></script>
<%-- <script src="${ ctx }/assets/js/common.js"></script> --%>
<script src="${ ctx }/assets/js/util.js"></script>

<!-- 개별 화면 script -->  
<script src="${ ctx }/assets/js/process_map_editor.js"></script>
<!-- favicon -->
<link rel="shortcut icon" type="image/x-icon" href="${ ctx }/common/images/icon/favicon_.ico" />

<script type="text/javascript">
var procMap=null;

	$(function() {
		
		init_sheet0(); 
		$(window).smartresize(sheetResize); sheetInit();
		procMap={};
		procMap.procMapSeq = "${procMapSeq}";
		
		procMap.selectedGrpCd = "${selectedGrpCd}";
		procMap.selectedMainMenuCd = "${selectedMainMenuCd}";
		procMap.selectedProcMapNm = "${selectedProcMapNm}";
		
		if(procMap.selectedGrpCd!=""&&procMap.selectedMainMenuCd!=""){
			let tempauthGrp=$("#procMap_authGrp_select");
			let tempMainMenu=$("#procMap_menu_select");
			
			$(tempauthGrp).val(procMap.selectedGrpCd).prop("selected", true);
			$(tempauthGrp).css("color","#323232");
			$(tempMainMenu).val(procMap.selectedMainMenuCd).prop("selected", true);
			$(tempMainMenu).css("color","#323232");
			
			//검색 관련 값
			searchedOption.authGrp={ 
				grpNm: $(tempauthGrp).find('option[value="'+$(tempauthGrp).val()+'"]').attr("name"),
				grpCd:$(tempauthGrp).val() 
			};
			searchedOption.mainMenu={ 
				mainMenuNm: $(tempMainMenu).find('option[value="'+$(tempMainMenu).val()+'"]').attr("name"),
				mainMenuCd: $(tempMainMenu).val() 
			};
			searchedOption.tempAuthGrp={ 
				grpNm: $(tempauthGrp).find('option[value="'+$(tempauthGrp).val()+'"]').attr("name"), 
				grpCd:$(tempauthGrp).val() 
			};
			searchedOption.tempMainMenu={
				mainMenuNm: $(tempMainMenu).find('option[value="'+$(tempMainMenu).val()+'"]').attr("name"),
				mainMenuCd: $(tempMainMenu).val() 
			};
			
			//실제 사용자가 작성중인 적용된 값, API에 사용
			selectedOtionSetting(searchedOption.authGrp,searchedOption.mainMenu);
			
			fetchProcList();
			fetchMenuList();

		}else{
			setPorcAreaUI(false);
		}
		
		$('<div class="editor" id="temp_editor"><script src="/common/plugin/Editor/js/editor_loader_for_modal.js?environment=production" type="text/javascript" charset="utf-8"/></div').appendTo(window.top.document.body);
		setTimeout(function(){
			$(window.top.document.body).find("#temp_editor").remove();
		},500)
	});

	function init_sheet0(){
		try {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:20,UseHiddenFilter:1};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"메뉴명",	Type:"Text",		Hidden:0, Width:80, Align:"Left", SaveName:"menuNm",	KeyField:0,Format:"",  Edit:0 , TreeCol:1,  LevelSaveName:"sLevel" },
			{
		        "Header": "버튼",
		        "Type": "Button",
		        "Align": "Center",
		        "SaveName": "sButton",
		        "HeaderHtml": "<input type='button' value='버튼' />"
		    },
			{Header:"rnum", Hidden:1, SaveName:"rnum"},
  			{Header:"menuCd", Hidden:1, SaveName:"menuCd"},
  			{Header:"enterCd", Hidden:1, SaveName:"enterCd"},
  			{Header:"grpCd", Hidden:1, SaveName:"grpCd"},
  			{Header:"type", Hidden:1, SaveName:"type"},
  			{Header:"mainMenuCd", Hidden:1, SaveName:"mainMenuCd"},
  			{Header:"seq", Hidden:1, SaveName:"seq"},
  			{Header:"priorMenuCd", Hidden:1, SaveName:"priorMenuCd"},
  			{Header:"checkedYn", Hidden:1, SaveName:"checkedYn"}
  		]; IBS_InitSheet(sheet0, initdata1);sheet0.SetEditable(0);sheet0.SetVisible(true);sheet0.SetCountPosition(4);
		sheet0.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet0.SetRowHidden(0, 1);
		} catch (ex) { alert("init_sheet0 Event Error : " + ex); }
	}
	
	//-----------------------------------------------------------------------------------
	//		sheet0 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet0_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			sheet0.SetRowHidden(0, 1);
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
			sheet0.FitColWidth();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	function sheet0_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
	
		let type=sheet0.GetCellValue( NewRow, "type");
		
		if(NewCol==1&&type!="M"){
			//생성하기로 들어와서 맨 처음 선택이 아닌 경우
			if(selectedOtion.authGrp){
				// 현재 작업중인 메뉴와 조회하려는 메뉴가 같지 않으면 확인
				// if(
				// 	!(searchedOption.authGrp.grpCd==selectedOtion.authGrp.grpCd
				// 	&&searchedOption.mainMenu.mainMenuCd==selectedOtion.mainMenu.mainMenuCd)
				// ){
				// 	if(confirm("작업 중인 프로세스들과 다른 권한 또는 메뉴를 추가하실 경우 현재 작업한 내용이 사라집니다. 추가하시겠습니까?")){
				// 		drawProcList({procList:[]});
				// 		selectedOtionSetting(searchedOption.authGrp,searchedOption.mainMenu);
				// 		sheet0.SetDataFontColor(NewRow ,0 ,"#3379f8");
				// 	}else{
				// 		return;
				// 	}
				// }
			}else{
				selectedOtionSetting(searchedOption.authGrp,searchedOption.mainMenu);
			}
			
			let params={procMapSeq	:procMap.procMapSeq,
					mainMenuCd	:sheet0.GetCellValue( NewRow, "mainMenuCd"),
					priorMenuCd	:sheet0.GetCellValue( NewRow, "priorMenuCd"),
					menuCd:	sheet0.GetCellValue( NewRow, "menuCd"),
					menuSeq:	sheet0.GetCellValue( NewRow, "seq"),
					procNm:	sheet0.GetCellValue( NewRow, "menuNm")}
			ajaxCall3("/ProcessMapMgr.do?cmd=createProcess","post", JSON.stringify(params), true, null, function(data){
				let createdProc=  {
					      "procSeq": data.procSeq,
					      "enterCd": sheet0.GetCellValue( NewRow, "enterCd"),
					      "memo": "",
					      "helpTxtTitle": "",
					      "helpTxtContent": "",
					      "fileSeq": "",
					      "procNm": sheet0.GetCellValue( NewRow, "menuNm"),
					      "seq": ""
					    };
				if(addProc(createdProc,true)){
					sheet0.SetCellFontColor(NewRow ,0 ,"#3379f8");
				}
			});
		}
	}
	
	function sheet0_OnRowSearchEnd(row) {
		  if( sheet0.GetCellValue(row,"checkedYn") == "Y") {
			  sheet0.SetCellFontColor(row ,0 ,"#3379f8");
		}
	}
	
	function sheet0_search() {
		let text=$("#menu_search_iniput").val();
		sheet0.SetFilterValue(0, text, text==""?12:11);
	}
	
	function sheet0_showTreeLevel(level){
		switch(level){
		case 0:
			//모두 닫기
			sheet0.ShowTreeLevel(0, 1);
			break;
		case 1:
			sheet0.ShowTreeLevel(1);
			break;
		case 2:
			sheet0.ShowTreeLevel(2);
			break;
		default:
			//모두 열기
			sheet0.ShowTreeLevel(-1, 2);
			break;
		}
	}
	
</script>


</head>

  <body class="iframe_content">

    <!-- main_tab_content -->
    <div class="main_tab_content process_map_edit">

      <div class="process_map_edit_header">
        <div class="left_area">
          <span class="title">프로세스맵 생성하기</span>
          <div class="select">
            <span class="req">프로세스맵 명</span>
            <input id="procMapNm_input" type="text" class="text_input round" value="${selectedProcMapNm}">
          </div>
           <div class="select">
            <span class="req">권한선택</span>
            <!-- 개발 시 참고: 뷰어에서는 custom_select에 disabled 클래스 추가-->
            <div class="custom_select round disabled">
              <button class="select_toggle" >
                <span id="selected-authGrpNm-val"></span>
              </button>
            </div>
          </div>
          <div class="select">
            <span class="req">분류</span>
            <div class="custom_select round disabled">
              <button class="select_toggle" >
                <span id="selected-mainMenuNm-val"></span>
              </button>
            </div>
          </div>
        </div>
        <div class="right_area">
          <a class="guide_btn" style="display:none">
            <i class="mdi-ico">help</i><span>프로세스맵 설정 가이드</span>
          </a>
          <button class="btn outline-gray" onclick="cancelEditing()">취소</button>
          <button class="btn outline-gray" onclick="saveProcMap('T')">임시저장</button>
          <button class="btn filled icon_text" onclick="saveProcMap('Y')">
            <i class="mdi-ico">check</i>저장하기
          </button>
        </div>
      </div>

      <!-- process_map_edit_container -->
      <div class="process_map_edit_container">

        <!-- menu_wrap -->
        <div class="menu_wrap">
          <div class="select_wrap">
            <p class="title">메뉴조회</p>
            <div>
              <div class="select">
                <span>권한선택</span>            
                <select id="procMap_authGrp_select" class="custom_select round">
                	<option selected disabled>선택</option>
                <c:forEach	var="item" items="${authGrpList}" varStatus="status">
                	<option name="${item.grpNm}" value="${item.grpCd}">${item.grpNm}</option>			
				</c:forEach>
            	</select>
              </div>
              <div class="select">
                <span>분류</span>
                <select id="procMap_menu_select" class="custom_select round">
                	<option selected disabled>선택</option>
                <c:forEach	var="item" items="${mainMenuList}" varStatus="status">
                	<option name="${item.mainMenuNm}" value="${item.mainMenuCd}">${item.mainMenuNm}</option>			
				</c:forEach>
            	</select>
              </div>
              <button class="btn dark search_btn" onclick="fetchMenuList()">검색</button>
            </div>
          </div>
            <div class="btn_wrap">
              <span class="btn" title="전체보기" onclick="sheet0_showTreeLevel()"><i class="mdi-ico">add</i></span>
              <span class="btn" title="3레벨보기" onclick="sheet0_showTreeLevel(2)"><i class="mdi-ico">menu</i></span>
              <span class="btn" title="2레벨보기" onclick="sheet0_showTreeLevel(1)"><i class="mdi-ico">drag_handle</i></span>
              <span class="btn" title="1레벨보기" onclick="sheet0_showTreeLevel(0)"><i class="mdi-ico">horizontal_rule</i></span>
			<div class="menu_search">
              <input id="menu_search_iniput" class="form-input border_dark search_input" type="text" placeholder="메뉴 검색"/>
              <!-- 개발 시 참고 : cancel 아이콘은 input value가 빈값이 아닐 때만 노출 -->
              <i class="mdi-ico filled" onclick="clearMenuSearchInput()">cancel</i>
            </div>
            <button class="sheet_search_btn" onclick="sheet0_search()">검색</button>
            </div>
            <div>
              <!-- 개발 시 참고: ib sheet 영역 --> 
              	<table class="sheet_main">
              		<tr>
              			<td>
							<script type="text/javascript">createIBSheet("sheet0", "100%", "100%x","${ssnLocaleCd}"); </script>
						</td>
					</tr>
				</table>			
            </div>
        </div>
        <!-- // menu_wrap -->

        <!-- edit_wrap -->
        <div class="edit_wrap">
          <div class="no_content" style="display:none">
           	<img src="" alt="">
           	<p>프로세스를 생성해주세요.</p>
          </div>
          <!-- #Sortable -->
          <div id="sortable" >

            
          </div>
          <!-- // #Sortable -->
        </div>
        <!-- //edit_wrap -->

      </div>
      <!-- // process_map_edit_container -->

    </div>
    <!-- // main_tab_content -->

  </body>

</html>
