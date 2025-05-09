<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<!DOCTYPE html><head><title>근태신청화면 연차시뮬레이션</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<html lang="ko">
  
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <meta name="robots" content="noindex" />
    <meta http-equiv="Imagetoolbar" content="no" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    

    <!-- 레거시 css -->
    <link rel="stylesheet" type="text/css" href="../../common/css/nanum.css" />
    <link rel="stylesheet" type="text/css" href="../../common/theme3/css/style.css" />
    <link rel="stylesheet" type="text/css" href="../../common/css/common.css" />
    <link rel="stylesheet" type="text/css" href="../../common/css/util.css" />
    <link rel="stylesheet" type="text/css" href="../../common/css/override.css" />
    <!--// 레거시 css -->

    <!-- HR UX 개선 신규 css -->
    <link rel="stylesheet" type="text/css" href="../assets/css/_reset.css" />
    <link rel="stylesheet" type="text/css" href="../assets/fonts/font.css" />
    <link rel="stylesheet" type="text/css" href="../assets/css/common.css" />
    <link rel="stylesheet" type="text/css" href="../assets/css/attendance.css"/>

    <!-- 개별 화면 css -->
    <link rel="stylesheet" type="text/css" href="../assets/plugins/jquery-ui-1.13.2/jquery-ui-1.13.2.css"/>
    <link rel="stylesheet" type="text/css" href="../assets/css/main.css" />
    <link rel="stylesheet" type="text/css" href="../assets/css/process_map.css"/>

    <!-- favicon -->
    <link rel="shortcut icon" type="image/x-icon" href="../../common/images/icon/favicon_IBKSB.ico"/>
    
    <!-- script -->
    <script src="../assets/plugins/jquery-3.6.0/jquery-3.6.0.min.js"></script>
    <script defer src="../assets/plugins/jquery-ui-1.13.2/jquery-ui-1.13.2.js"></script>
    <script defer src="../../common/js/jquery/jquery.datepicker.js" type="text/javascript" charset="utf-8"></script>
    <script defer src="../../common/js/jquery/datepicker_lang_KR.js" type="text/javascript" charset="utf-8"></script>
    <script defer src="../assets/js/common.js"></script>

    <!-- 개별 화면 script -->
    <script defer src="../assets/js/vacation_simulation.js"></script>
    
    <script type="text/javascript">
    

    $(function() {

    	// tab menu
    	$(".tab_menu").on("click", function () {
    		$(".tab_menu").removeClass("active");
    		$(this).addClass("active");
    		
    		var tabId = $(this).attr("id");
    	    $("div.tab_content_wrap div").removeClass("on");
    	    $("div.tab_content_wrap div#" + tabId).addClass("on");
    	    if (tabId === "executives") {
    	      $(".button_wrap.simulation").removeClass("hide");
    	    } else {
    	      $(".button_wrap.simulation").addClass("hide");
    	    }
      	});

    	$("input[name='radio1']:checked, input[name='radio2']:checked, input[name='radio3']:checked, input[name='radio4']:checked").bind("change", function(event) {
			doAction1("Search") ;
		});
        
		init_sheet();
		

		doAction1("Search");

	});

	function init_sheet(){ 


		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:6};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo'       mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete'   mdef='날짜'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='statusCd'  mdef='부여시기'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='gntCdV7'   mdef='1년 미만'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1},
			{Header:"<sht:txt mid='orgNm'     mdef='연차'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},

			{Header:"년도",	Hidden:1,	SaveName:"yy"},
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetHeaderRowHeight(50);

		var gntCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getGntListTTIM007"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("gntCd", 		{ComboText:"|"+gntCd[0], ComboCode:"|"+gntCd[1]} );
		$("#searchGntCd").html(gntCd[2]);

		//사원구분
		var manageCdList     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchManageCd").html(manageCdList[2]);
		//직군
		var workTypeList     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchWorkType").html(workTypeList[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
		
	}

    function doAction1(sAction) {
        switch (sAction) {
        case "Search1":

            var formData1 = $("#srchFrm").serializeArray();
            formData1 = Array.from(formData1); 
            
            formData1 = formData1.filter(function (field) {
                return field.name !== "employeeSearch" && field.name !== "saveYear";
            });
            var formDataObj1 = Object.fromEntries(formData1);
            var serializedData1 = $.param(formDataObj1);
                    
            sheet1.DoSearch( "${ctx}/AnnualSimulation.do?cmd=getAnnualSimulationList", serializedData1);
            break;

        case "Search2":

            var formData2 = $("#srchFrm").serializeArray();
            formData2 = Array.from(formData2); 
            
            formData2 = formData2.filter(function (field) {
                return field.name !== "selectedDate";
            });
            var formDataObj2 = Object.fromEntries(formData2);
            var serializedData2 = $.param(formDataObj2);
                    
            sheet1.DoSearch( "${ctx}/AnnualSimulation.do?cmd=getAnnualSimulationList", serializedData2);
            break;
        }
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var i = 1; i < sheet1.RowCount()+1; i++) {
				if( sheet1.GetCellValue(i, "endYn") == "Y" ) {
					sheet1.SetRowEditable(i,0);
				}
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

    </script>
    
  </head>

  <body class="iframe_content white">

    <!-- main_tab_content -->
    <div class="main_tab_content white">
      <div class="sub_menu_container vacation_simulation">
        <header class="header">
          <div class="title_wrap">
            <i class="mdi-ico filled">dashboard_customize</i>
            <span>연차시뮬레이션</span>
          </div>

          <div class="button_wrap simulation hide">
            <button class="btn outline icon_text">
              초기화
            </button>
            <button class="btn filled icon_text">
              조회
            </button>
          </div>
        </header>
	
        <main class="simulation_wrap">
        	<form id="srchFrm" name="srchFrm" >
	        	<section>
	            <h3 class="table_title">연차생성기준</h3>
	            	<table class="basic type5">
	            	<colgroup>
		                <col width="3%">
		                <col width="8%">
		                <col width="4%">
		                <col width="8%">
		                <col width="4%">
		                <col width="8%">
		                <col width="5%">
		                <col width="10%">
		              </colgroup>
		              <tbody>
		                <tr>
		                  <th><span class="req">연차생성기</th>
		                  <td>
		                    <div>
		                      <div>
		                        <input type="radio" name="radio1" id="generator1" class="form-radio" checked />
		                        <label for="generator1">입사일</label>
		                      </div>
		                      <div>
		                        <input type="radio" name="radio1" id="generator2" class="form-radio" />
		                        <label for="generator2">회계일</label>
		                      </div>
		                      <div>
		                        <input type="radio" name="radio1" id="generator3" class="form-radio" />
		                        <label for="generator3">입사월</label>
		                      </div>
		                    </div>
		                  </td>
		                  <th><span class="req">생성상세기준</th>
		                  <td>
		                    <div>
		                      <div>
		                        <input type="radio" name="radio2" id="standard1" class="form-radio" checked/>
		                        <label for="standard1">입사일</label>
		                      </div>
		                    </div>
		                  </td>
		                  <th><span class="req">회계일</th>
		                  <td>
		                  	<!-- datepicker로 사용 시 img 태그 지워서 사용 -->
		                    <input class="date2 bbit-dp-input" type="text" value="" id="searchYmd1"/><img class="ui-datepicker-trigger" src="/common/images/common/calendar.gif" alt="">
		                  </td>
		                  <th><span class="req">잔여연차</th>
		                  <td>
		                    <div>
		                      <div>
		                        <input type="radio" name="radio3" id="remaining1" class="form-radio" checked/>
		                        <label for="remaining1">이월</label>
		                      </div>
		                      <div>
		                        <input type="radio" name="radio3" id="remaining2" class="form-radio" />
		                        <label for="remaining2">보상</label>
		                      </div>
		                      <div>
		                        <input type="radio" name="radio3" id="remaining3" class="form-radio" />
		                        <label for="remaining3">소멸</label>
		                      </div>
		                    </div>
		                  </td>
		                </tr>
		              </tbody>
		            </table>
		          </section>
				
			          <section>
			            <div>
			              <h3 class="table_title">1년미만자(월차)설정</h3>
			              <table class="basic type5">
			                <colgroup>
			                  <col width="8%">
			                  <col width="22%">
			                  <col width="10%">
			                  <col width="30%">
			                  <col width="10%">
			                  <col width="20%">
			                </colgroup>
			
			                <tbody>
			                  <tr>
			                    <th><span class="req">자동생성여부</th>
			                    <td>
			                      <div class="toggle_wrap">
			                        <input type="checkbox" id="toggle" hidden  checked/>
			                        <label for="toggle" class="toggleSwitch">
			                          <span class="toggleButton"></span>
			                        </label>
			                      </div>
			                    </td>
			                    <th><span class="req">잔여연차</th>
			                    <td>
			                      <div>
			                        <div>
			                          <input type="radio" name="radio4" id="remaining4" class="form-radio" checked/>
			                          <label for="remaining4">이월</label>
			                        </div>
			                        <div>
			                          <input type="radio" name="radio4" id="remaining5" class="form-radio" />
			                          <label for="remaining5">보상</label>
			                        </div>
			                        <div>
			                          <input type="radio" name="radio4" id="remaining6" class="form-radio" />
			                          <label for="remaining6">소멸</label>
			                        </div>
			                      </div>
			                    </td>
			                    <th><span class="req">연차수당 급여월</th>
			                    <td>익월</td>
			                  </tr>
			                </tbody>
			              </table>
			            </div>
			            
			            <div>
			              <h3 class="table_title">근속년수 계산 시 소수점 처리방법</h3>
			
			              <table class="basic type5">
			                <colgroup>
			                  <col width="4%">
			                  <col width="46%">
			                  <col width="4%">
			                  <col width="46%">
			                </colgroup>
			
			                <tbody>
			                  <tr>
			                    <th><span class="req">단위자리수</th>
			                    <td>
			                      <select class="custom_select">
			                        <option value="">선택</option>
			                        <option value="10">1</option>
			                        <option value="11">2</option>
			                      </select>
			                    </td>
			                    <th><span class="req">올림기준</th>
			                    <td>
			                      <select class="custom_select">
			                        <option value="">선택</option>
			                        <option value="10">절상</option>
			                      </select>
			                    </td>
			                  </tr>
			                </tbody>
			              </table>
			            </div>
			          </section>
			
			          <section>
			            <div class="tab_wrap">
			              <div class="tab_menu active" id="all">전체보기</div>
			              <div class="tab_menu" id="executives">임직원조회</div>
			            </div>
			
			            <div class="tab_content_wrap">
			              <div id="all" class="tab_content all on">
			                <div class="col">
			                  <h3 class="table_title preview">연차미리보기 
			                    <div class="parent">
			                      <i class="mdi-ico">help</i>
			                      <div class="text_box">연차미리보기 설명입니다.연차미리보기 설명입니다.연차미리보기 설명입니다.</div>
			                      <div class="triangle"></div>
			                    </div>
			                  </h3>
			                  <table class="basic type5">
			                    <colgroup>
			                      <col width="10%">
			                      <col width="85%">
			                      <col width="5%">
			                    </colgroup>
			                    <tbody>
			                      <tbody>
			                        <tr>
			                          <th><span class="req">입사일</th>
			                          <td>
				                        <div class="vacation_desc">
				                          <!-- datepicker로 사용 시 img 태그 지워서 사용 -->
				                          <input class="date2 bbit-dp-input" type="text" value="" id="searchYmd2" /><img class="ui-datepicker-trigger" src="/common/images/common/calendar.gif" alt="">
				                          <span>
				                            <span class="number_text">2023</span> 년에 생성되는 연차는 <span class="number_text">15</span>개 입니다.
				                          </span>
				                        </div>
				                      </td>
			                          <td>
										  <a href="javascript:doAction1('Search1')" id="btnSearch" class="btn filled">조회</a>
									  </td>
			                        </tr>
			                      </tbody>
			                    </tbody>
			                  </table>
			                </div>
			                
			                <div class="sheet_area"><div id="mySheetContainer"></div></div>
		                
		              </div>
		
		              <div id="executives" class="tab_content executives">
		                <div>
		                  <h3 class="table_title preview">연차미리보기
		                  	<div class="parent">
		                      <i class="mdi-ico">help</i>
		                      <div class="text_box">연차미리보기 설명입니다.연차미리보기 설명입니다.연차미리보기 설명입니다.</div>
		                      <div class="triangle"></div>
		                    </div>
		                  </h3>
		                  <table class="basic type5">
		                    <colgroup>
		                      <col width="10%">
		                      <col width="25%">
		                      <col width="10%">
		                      <col width="50%">
		                      <col width="5%">
		                    </colgroup>
		                    <tbody>
		                      <tr>
		                        <th><span class="req">임직원 조회</th>
		                        <td>
		                          <div>
		                            <div class="search_input">
		                              <input class="form-input" name="employeeSearch" type="text" placeholder="사번/성명을 입력하세요" style="width: 240px;"/>
		                              <i class="mdi-ico">search</i>
		                            </div>
		                          </div>
		                        </td>
		                        <th><span class="req">저장년도</th>
		                        <td>
		                          <select class="custom_select">
			                        <option value="">선택</option>
			                        <option value="10">2023</option>
			                        <option value="10">2022</option>
			                        <option value="10">2021</option>
			                      </select>
		                        </td>
		                        <td>
									<a href="javascript:doAction1('Search2')" id="btnSearch" class="btn filled">조회</a>
								</td>
		                      </tr>
		                    </tbody>
		                  </table>
		                </div>
				
		                <div>
		                  <div class="executives_text">
		                    <div><b>김이수 20230901</b></div>
		                    <div>소속 <b>영업팀</b></div>
		                    <div>직급 <b>대리</b></div>
		                    <div>입사일 <b>2023-06-23</b></div>
		                  </div>
		                  <div class="sheet_area"></div>
		                </div>
		              </div>
		            </div>
	          	</section>
        	</form>
        </main>
      </div>
      <!-- <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script> -->
    </div>
    <!-- // main_tab_content -->
    </div>

  </body>
</html>
