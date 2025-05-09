var dialogObj = {

		/**
		 * Dialog 팝업에 동적 버튼 생성을 위한 json 정의[저장 버튼 이벤트 실행]
		 * @param dialogObj
		 * @param btnNm
		 * @param fn
		 * @returns
		 */
		getDialogBtn : function(dialogObj, btnNm, fn) {
			//console.log('dialogObj', dialogObj);
			var ret = {};
			var compYn = $("#compYn").val();
			
			if(compYn == "N") {
				ret[btnNm] = fn;
			}

			ret["취소"] = function() {
				$(dialogObj).dialog( "close" );
			}

			return ret;
		},
		
		
		/**
		 * 조직 조회 팝업 출력
		 * @param flag
		 * @returns
		 */
		orgBasicPopup : function( flag ){
			try{
				if(!isPopup()) {return;}

				var args = new Array();
				args["chkVisualYn"] = "N";

				var $modal = $("#dialog_search_org");
				
				$("#pGubun", $modal).val("orgBasicPopup" + flag);
				
				// Reset Modal List
				var html = "";
				for(var idx = 1; idx < sheetObj.RowCount() + 1; idx++) {
					var radioId = "chooseOrg_" + idx;
					html += '<tr>';
					html += '	<td><a href="javascript:dialogObj.setOrgValue(\'' + sheetObj.GetCellValue(idx, "orgNm") + '\', \'' + sheetObj.GetCellValue(idx, "orgCd") + '\');" class="button" title="조직원 선택">선택</a></td>';
					html += '	<td><label for="' + radioId + '">' + sheetObj.GetCellValue(idx, "orgCd") + '</label></td>';
					html += '	<td><label for="' + radioId + '">' + sheetObj.GetCellValue(idx, "orgNm") + '</label></td>';
					html += '</tr>';
				}
				
				$("table tbody", $modal).html(html);
				
				// Open Modal..
				$modal.dialog({
					modal: true,
					width : "430px",
					buttons: {
						Cancel: function(){
							$modal.dialog( "close" );
						}
					}
				});

			} catch(ex){
				alert("Open Popup Event Error : " + ex);
			}
		},
		
		
		/**
		 * 선택 조직원 데이터 부모화면입력항목에 삽입
		 * @param orgNm
		 * @param orgCd
		 * @returns
		 */
		setOrgValue : function(orgNm, orgCd) {
			var $modal = $("#dialog_search_org");
			var pGubun = $("#pGubun", $modal).val();
			
			// 하위부서추가팝업 > 부서
			if ( pGubun == "orgBasicPopup0" ) {
				$("#orgCd", "#dialog_append_child").val( orgCd );
				$("#orgNm", "#dialog_append_child").val( orgNm );
			}
			
			// 하위부서추가팝업 > 상위부서
			if ( pGubun == "orgBasicPopup1" ) {
				$("#priorOrgCd", "#dialog_append_child").val( orgCd );
				$("#priorOrgNm", "#dialog_append_child").val( orgNm );
			}
			
			// 상세보기팝업 > 상위부서 변경전
			if ( pGubun == "orgBasicPopup2" ) {
				$("#priorOrgCdPre", "#dialog_detail_info").val( orgCd );
				$("#priorOrgNmPre", "#dialog_detail_info").val( orgNm );
			}
			
			// 상세보기팝업 > 상위부서 변경후
			if ( pGubun == "orgBasicPopup3" ) {
				$("#priorOrgCdAfter", "#dialog_detail_info").val( orgCd );
				$("#priorOrgNmAfter", "#dialog_detail_info").val( orgNm );
			}
			
			// 상위조직변경팝업 > 상위부서 변경후
			if ( pGubun == "orgBasicPopup4" ) {
				$("#priorOrgCdAfter", "#dialog_prior_change").val( orgCd );
				$("#priorOrgNmAfter", "#dialog_prior_change").val( orgNm );
			}
			
			$modal.dialog( "close" );
		},
		
		
		/**
		 * 입력된 부서 데이터 초기화
		 * @param flag
		 */
		resetOrg : function(flag) {
			var orgCdId = "";
			var orgNmId = "";
			var $dialog = null;
			
			// 하위부서추가팝업 > 부서
			if ( flag == 0 ) {
				$dialog = $("#dialog_append_child");
				orgCdId = "#orgCd";
				orgNmId = "#orgNm";
			}
			
			// 하위부서추가팝업 > 상위부서
			if ( flag == 1 ) {
				$dialog = $("#dialog_append_child");
				orgCdId = "#priorOrgCd";
				orgNmId = "#priorOrgNm";
			}
			
			// 상세보기팝업 > 상위부서 변경전
			if ( flag == 2 ) {
				$dialog = $("#dialog_detail_info");
				orgCdId = "#priorOrgCdPre";
				orgNmId = "#priorOrgNmPre";
			}
			
			// 상세보기팝업 > 상위부서 변경후
			if ( flag == 3 ) {
				$dialog = $("#dialog_detail_info");
				orgCdId = "#priorOrgCdAfter";
				orgNmId = "#priorOrgNmAfter";
			}
			
			// 상위조직변경팝업 > 상위부서 변경후
			if ( flag == 4 ) {
				$dialog = $("#dialog_prior_change");
				orgCdId = "#priorOrgCdAfter";
				orgNmId = "#priorOrgNmAfter";
			}
			
			if($(orgCdId, $dialog).val() != "" && confirm("입력된 조직 정보를 [초기화] 하시겠습니까?")) {
				$(orgCdId, $dialog).val("");
				$(orgNmId, $dialog).val("");
			}
		},
		
		
		/**
		 * 조직원 검색 팝업 출력
		 * @param flag
		 * @returns
		 */
		empBasicPopup : function( flag ) {
			try{
				if(!isPopup()) {return;}
				
				var $modal = $("#dialog_search_emp");
				var args = new Array();
				args["chkVisualYn"] = "N";
				
				$("#pGubun", $modal).val("empBasicPopup" + flag);
				
				// 검색 박스 초기화
				$("#searchKeyword", $modal).val("");
				
				// Reset Modal List
				var html = "";
					html += '<tr>';
					html += '	<td colspan="6" class="alignC" style="width:700px !important;">검색된 조직원이 존재하지 않습니다.</td>';
					html += '</tr>';
				
				$("table tbody", $modal).html(html);
				
				// Open Modal..
				$modal.dialog({
					modal: true,
					width : "730px",
					buttons: {
						Cancel: function(){
							$modal.dialog( "close" );
						}
					}
				});
				
			} catch(ex){
				alert("Open Popup Event Error : " + ex);
			}
		},
		
		
		/**
		 * 조직원 검색 실행
		 * @returns
		 */
		empSearch : function() {
			var $modal = $("#dialog_search_emp");
			var html = "";
			
			if( ( $.trim( $("#searchKeyword", "#empSearchForm").val( )) ) == "" ){
				alert("성명 또는 사번을 입력하세요.");
				$("#searchKeyword").focus();
			}else{
				var data = ajaxCall("/Employee.do?cmd=employeeList", $("#empSearchForm").serialize(), false );
				if(data != null && data != undefined && data.DATA != null && data.DATA != undefined && data.DATA.length > 0) {
					
					var item = null;
					for(var i = 0; i < data.DATA.length; i++) {
						item = data.DATA[i];
						html += '<tr>';
						html += '	<td><a href="javascript:dialogObj.setEmpValue(\'' + item.empName + '\', \'' + item.empSabun + '\', \'' + item.jikweeNm + '\');" class="button" title="조직원 선택">선택</a></td>';
						html += '	<td>' + item.empName + '</td>';
						html += '	<td>' + item.empSabun + '</td>';
						html += '	<td>' + item.jikweeNm + '</td>';
						html += '	<td>' + item.orgNm + '</td>';
						html += '	<td>' + item.statusNm + '</td>';
						html += '</tr>';
					}
					
				} else {
					html += '<tr>';
					html += '	<td colspan="6" class="alignC" style="width:700px !important;">검색된 조직원이 존재하지 않습니다.</td>';
					html += '</tr>';
					
				}
				$("table tbody", $modal).html(html);
			}
		},
		
		
		/**
		 * 선택 조직원 데이터 부모화면입력항목에 삽입
		 * @param empNm
		 * @param empSabun
		 * @param positionNm
		 * @returns
		 */
		setEmpValue : function(empNm, empSabun, positionNm) {
			var $modal = $("#dialog_search_emp");
			var pGubun = $("#pGubun", $modal).val();
			
			// 하위부서추가팝업
			if( pGubun == "empBasicPopup1" ) {
				$( "#chiefSabun"           , "#dialog_append_child" ).val(empSabun);
				$( "#chiefPositionNm"      , "#dialog_append_child" ).val(positionNm);
				$ ("#chiefNm"              , "#dialog_append_child" ).val(empNm);
			}
			
			// 상세보기팝업 조직장 변경전
			if( pGubun == "empBasicPopup2" ) {
				$( "#chiefSabunPre"        , "#dialog_detail_info"  ).val(empSabun);
				$( "#chiefPositionNmPre"   , "#dialog_detail_info"  ).val(positionNm);
				$( "#chiefNmPre"           , "#dialog_detail_info"  ).val(empNm);
			}
			
			// 상세보기팝업 조직장 변경후
			if( pGubun == "empBasicPopup3" ) {
				$( "#chiefSabunAfter"      , "#dialog_detail_info" ).val(empSabun);
				$( "#chiefPositionNmAfter" , "#dialog_detail_info" ).val(positionNm);
				$( "#chiefNmAfter"         , "#dialog_detail_info" ).val(empNm);
			}
			
			// 조직장변경팝업 조직장 변경후
			if( pGubun == "empBasicPopup4" ) {
				$( "#chiefSabunAfter"      , "#dialog_chief_change" ).val(empSabun);
				$( "#chiefPositionNmAfter" , "#dialog_chief_change" ).val(positionNm);
				$( "#chiefNmAfter"         , "#dialog_chief_change" ).val(empNm);
			}
			
			$modal.dialog( "close" );
		},
		
		
		/**
		 * 선택 조직원 데이터 부모화면입력항목에 삽입
		 * @param pGubun
		 * @returns
		 */
		resetChief : function(pGubun) {
			var sabunId = "";
			var positionNmId = "";
			var nmId = "";
			var $dialog = null;
			
			if( pGubun == "1" ) {
				$dialog = $("#dialog_append_child");
				sabunId = "#chiefSabun";
				positionNmId = "#chiefPositionNm";
				nmId = "#chiefNm";
			} else if( pGubun == "2" ) {
				$dialog = $("#dialog_detail_info");
				sabunId = "#chiefSabunPre";
				positionNmId = "#chiefPositionNmPre";
				nmId = "#chiefNmPre";
			} else if( pGubun == "3" ) {
				$dialog = $("#dialog_detail_info");
				sabunId = "#chiefSabunAfter";
				positionNmId = "#chiefPositionNmAfter";
				nmId = "#chiefNmAfter";
			} else if( pGubun == "4" ) {
				$dialog = $("#dialog_chief_change");
				sabunId = "#chiefSabunAfter";
				positionNmId = "#chiefPositionNmAfter";
				nmId = "#chiefNmAfter";
			}
			
			if($(sabunId, $dialog).val() != "" && confirm("입력된 조직장 정보를 [초기화] 하시겠습니까?")) {
				$(sabunId, $dialog).val("");
				$(positionNmId, $dialog).val("");
				$(nmId, $dialog).val("");
			}
		},
		
		
		/**
		 * 하위부서 추가 다이얼로그 출력
		 * @param evt
		 * @returns
		 */
		openNewOrgRegDialog : function(evt) {
			var $dialog = $("#dialog_append_child");
			
			// 부서코드,부서명 초기화
			$("#orgCd"      , $dialog).val( "" );
			$("#orgNm"      , $dialog).val( "" );
			$("#orgEngNm"   , $dialog).val( "" );
		
			// 상위부서 기본값을 설정
			$("#priorOrgCd" , $dialog).val( "" );
			$("#priorOrgNm" , $dialog).val( "" );
		
			// 조직장 초기화
			$("#chiefSabun" , $dialog).val( "" );
			$("#chiefPositionNm" , $dialog).val( "" );
			$("#chiefNm" , $dialog).val( "" );
			
			var title = "하위 조직 추가";
			if(evt == null) {
				$("label[for=chkNew]", $dialog).hide();
				$("#chkNew"          , $dialog).attr( "checked", "checked" );
				$("#chkNew"          , $dialog).attr( "disabled", "disabled" );
				$("#orgCd"           , $dialog).removeClass( "w70p" ).addClass( "w80p" );
				$("#orgCd, #orgNm"   , $dialog).removeClass( "readonly" );
				$("#orgCd, #orgNm"   , $dialog).removeAttr("readonly");
				$("#btnSabunPop0"    , $dialog).hide();
				$("#input_etc"       , $dialog).show();
				
				title = "신규 조직 추가";
			} else {
				$("label[for=chkNew]", $dialog).show();
				$("#chkNew"          , $dialog).removeAttr( "checked" );
				$("#chkNew"          , $dialog).removeAttr( "disabled" );
				$("#orgCd"           , $dialog).removeClass( "w80p" ).addClass( "w70p" );
				$("#orgCd, #orgNm"   , $dialog).addClass( "readonly" );
				$("#orgCd, #orgNm"   , $dialog).attr( "readonly", "readonly" );
				$("#btnSabunPop0"    , $dialog).show();
				$("#input_etc"       , $dialog).hide();

				// 상위부서 기본값을 설정
				$("#priorOrgCd"      , $dialog).val( evt.node.fields("deptcd").value() );
				$("#priorOrgNm"      , $dialog).val( evt.node.fields("deptnm").value() );
			}
			
			$dialog.attr("title", title);
			$dialog.dialog({
				modal     : true,
				title     : title,
				width     : "400px",
				buttons   : dialogObj.getDialogBtn($dialog, "추가", function(){dialogObj.appendChild( evt );}),
				resizable : false
			});
		},
		
		/**
		 * 하위부서 추가 모드 변경
		 * @param chkObj
		 * @returns
		 */
		toggleAppendMode : function(chkObj) {
			var $dialog = $("#dialog_append_child");
			
			// 신규 조직
			if(chkObj.checked) {
				$("#input_etc"    , $dialog).show();
				$("#orgCd"        , $dialog).removeClass( "w70p" ).addClass( "w80p" );
				$("#orgCd, #orgNm", $dialog).removeClass( "readonly" );
				$("#orgCd, #orgNm", $dialog).removeAttr("readonly");
				$("#btnSabunPop0" , $dialog).hide();
				
			// 기존 조직 추가
			} else {
				$("#input_etc"    , $dialog).hide();
				$("#chkNew"       , $dialog).removeAttr( "checked", "checked" );
				$("#orgCd"        , $dialog).removeClass( "w80p" ).addClass( "w70p" );
				$("#orgCd, #orgNm", $dialog).addClass( "readonly" );
				$("#orgCd, #orgNm", $dialog).attr( "readonly", "readonly" );
				$("#btnSabunPop0" , $dialog).show();
			}
		},

		/**
		 * 추가 조직 정보 sheet에 저장 처리
		 * @param evt
		 * @returns
		 */
		appendChild : function( evt ){
			
			var $dialog            = $("#dialog_append_child");
			var valOrgCd           = $("#orgCd"           , $dialog).val();
			var valOrgNm           = $("#orgNm"           , $dialog).val();
			var valOrgEngNm        = $("#orgEngNm"        , $dialog).val();
			var valPriorOrgCd      = $("#priorOrgCd"      , $dialog).val();
			var valPriorOrgNm      = $("#priorOrgNm"      , $dialog).val();
			var valChiefSabun      = $("#chiefSabun"      , $dialog).val();
			var valChiefNm         = $("#chiefNm"         , $dialog).val();
			var valChiefPositionNm = $("#chiefPositionNm" , $dialog).val();
			
			// 신규부서추가여부
			var isNewOrgReg         = $("input[name=chkNew]", $dialog).is(":checked");
			
			if(valOrgCd == "") {
				alert("조직코드를 입력해주십시오.");
			} else if(valOrgNm == "") {
				alert("조직명을 입력해주십시오.");
			} else if(valPriorOrgCd == "" || valPriorOrgNm == "") {
				alert("상위조직을 선택해주십시오.");
			} else {
				
				// 신규 부서 추가인 경우
				if(isNewOrgReg) {
					
					// 상위부서 노드
					var priorOrgNode   = null;
					var priorOrgMaxNum = 0;
					var priorOrgIdx    = sheetObj.GetNodeSheetIdx(valPriorOrgCd);
					var level          = Number(sheetObj.GetCellValue(priorOrgIdx, "orgLevel")) + 1;
					
					var Row = null;
					
					if( evt == null ) {
						priorOrgNode   = orgObj.GetNode(valPriorOrgCd);
					} else {
						priorOrgNode   = evt.org.nodes(valPriorOrgCd);
					}
					
					var cnt = ajaxCall("/GetDataList.do?cmd=getSchemeSimulationOrgExistOrgCd", "&orgCd=" + valOrgCd, false).DATA[0].cnt;
					
					// 부서코드 중복 체크
					if(sheetObj.GetNodeSheetIdx(valOrgCd) > -1 || cnt > 0) {
						
						if(cnt > 0) {
							alert("기존에 사용되었던 조직코드입니다.");
						} else {
							alert("사용중인 조직코드입니다.");
						}
						$("#orgCd", $dialog).val("");
						$("#orgCd", $dialog).focus();
						
					} else {

						// get max num
						//console.log('valPriorOrgCd', valPriorOrgCd);
						for(var idx = 1; idx < sheetObj.RowCount() + 1; idx++) {
							var num = Number(sheetObj.GetCellValue(idx, "num"));
							if(num > priorOrgMaxNum) {
								priorOrgMaxNum = num;
							}
						}
						priorOrgMaxNum++;
						
						var orgTemplate = $("#viewType").val() + "_Move";
						
						// insert sheet row
						Row = sheetObj.DataInsert();
						// set value
						sheetObj.SetCellValue( Row , "sdate"                , sdate1              );
						sheetObj.SetCellValue( Row , "versionNm"            , versionNm           );
						sheetObj.SetCellValue( Row , "changeGubun"          , "1"                 );
						sheetObj.SetCellValue( Row , "orgCd"                , valOrgCd            );
						sheetObj.SetCellValue( Row , "orgNm"                , valOrgNm            );
						sheetObj.SetCellValue( Row , "orgNmPre"             , ""                  );
						sheetObj.SetCellValue( Row , "orgNmAfter"           , valOrgNm            );
						sheetObj.SetCellValue( Row , "orgEngNmAfter"        , valOrgEngNm         );
						sheetObj.SetCellValue( Row , "orgLevel"             , level               );
						sheetObj.SetCellValue( Row , "nodedesign"           , orgTemplate         );
						sheetObj.SetCellValue( Row , "num"                  , priorOrgMaxNum + "" );
						sheetObj.SetCellValue( Row , "seq"                  , priorOrgMaxNum + "" );
						sheetObj.SetCellValue( Row , "priorOrgCd"           , valPriorOrgCd       );
						sheetObj.SetCellValue( Row , "priorOrgCdAfter"      , valPriorOrgCd       );
						sheetObj.SetCellValue( Row , "priorOrgNmAfter"      , valPriorOrgNm       );
						sheetObj.SetCellValue( Row , "chiefSabunAfter"      , valChiefSabun       );
						sheetObj.SetCellValue( Row , "chiefNmAfter"         , valChiefNm          );
						sheetObj.SetCellValue( Row , "chiefPositionNmAfter" , valChiefPositionNm  );
						sheetObj.SetCellValue( Row , "chiefNm"              , valChiefNm          );
						sheetObj.SetCellValue( Row , "chiefPositionNm"      , valChiefPositionNm  );
			
						var orgJson  = {
								template : orgTemplate,
								layout   : {
									'level' : level	// Layout 레벨값
								},
								fields   : {
									'pkey'              : valOrgCd,
									'rkey'              : priorOrgNode.pkey(),
									'deptcd'            : valOrgCd,
									'deptnm'            : valOrgNm,
									'updeptcd'          : valPriorOrgCd,
									'chief_nm'          : valChiefNm,
									'chief_position_nm' : valChiefPositionNm
								}
							};
						
						var jsonData = {
								orgData : [orgJson]
							};
			
						// 노드 추가
						orgObj.appendByJson(jsonData);
						
						// Close dialog
						$dialog.dialog( "close" );
					}
					
				} else {
					
					// sheet idx
					Row = sheetObj.GetNodeSheetIdx(valOrgCd);

					// 상위부서코드 이전값
					var oldPriorOrgCd = sheetObj.GetCellValue( Row , "priorOrgCdAfter" );
					
					// 상위부서코드가 변경된 경우
					if(valPriorOrgCd != oldPriorOrgCd) {
						// set value
						sheetObj.SetCellValue( Row , "orgLevel"        , level + ""    );
						sheetObj.SetCellValue( Row , "priorOrgCd"      , valPriorOrgCd );
						sheetObj.SetCellValue( Row , "priorOrgCdAfter" , valPriorOrgCd );
						sheetObj.SetCellValue( Row , "priorOrgNmAfter" , valPriorOrgNm );
						
						// 상위부서 변경
						orgObj.GetNode(valOrgCd).rkey(valPriorOrgCd);
					}
					
					// close modal dialog
					$dialog.dialog( "close" );
					
				}
				
			}
		},
		
		
		/**
		 * 조직명변경 다이얼로그 출력(신규 추가된 조직인 경우)
		 * @param evt
		 * @returns
		 */
		openNameChangeDialog : function(evt) {
			var $dialog  = $("#dialog_append_child");
			var orgCd    = evt.node.fields("deptcd").value();
			var sheetIdx = sheetObj.GetNodeSheetIdx(orgCd);
			
			if(sheetIdx > -1) {
				$( "#orgCd"            , $dialog ).val( orgCd );
				$( "#orgNm"            , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "orgNm"                ) );
				$( "#orgEngNm"         , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "orgEngNmAfter"        ) );
				
				$( "label[for=chkNew]" , $dialog ).hide();
				$( "#btnSabunPop0"     , $dialog ).hide();
				$( "#input_etc"        , $dialog ).hide();
				
				$( "#chkNew"           , $dialog ).attr( "checked", "checked" );
				$( "#chkNew"           , $dialog ).attr( "disabled", "disabled" );
				$( "#orgCd"            , $dialog ).attr("readonly", "readonly");
				$( "#orgCd"            , $dialog ).removeClass( "w70p" ).addClass( "w80p" );
				$( "#orgNm"            , $dialog ).removeClass( "readonly" );
				$( "#orgNm"            , $dialog ).removeAttr("readonly");
				
				$( "#orgNm"            , $dialog ).focus();
				
				var title = "조직명 변경";
				$dialog.attr("title", title);
				$dialog.dialog({
					modal     : true,
					title     : title,
					width     : "400px",
					buttons   : dialogObj.getDialogBtn($dialog, "저장", function(){dialogObj.modifiedOrgName( evt );}),
					resizable : false
				});
			}
		},
		
		
		/**
		 * 추가 조직 수정 정보 sheet에 저장 처리
		 * @param evt
		 * @returns
		 */
		modifiedOrgName : function( evt ) {
			
			var $dialog            = $("#dialog_append_child");
			var valOrgCd           = $("#orgCd" , $dialog).val();
			var valOrgNm           = $("#orgNm" , $dialog).val();
			
			if(valOrgCd == "") {
				alert("조직코드를 입력해주십시오.");
			} else if(valOrgNm == "") {
				alert("조직명을 입력해주십시오.");
			} else {
				
				// sheet idx
				var sheetIdx = sheetObj.GetNodeSheetIdx(valOrgCd);

				// 시트의 조직코드, 조직명, 조직장 정보 수정
				sheetObj.SetCellValue( sheetIdx , "orgNm"      , valOrgNm );
				sheetObj.SetCellValue( sheetIdx , "orgNmAfter" , valOrgNm );
				
				// 조직도 정보 변경
				evt.node.fields("deptnm").value( valOrgNm );
				
				// close modal dialog
				$dialog.dialog( "close" );
			}
		},
		
		
		/**
		 * 상위조직변경 팝업 출력
		 * @param evt
		 * @returns
		 */
		openPriorChangeDialog : function ( evt ) {
			var $dialog = $("#dialog_prior_change");
			
			var orgCd    = evt.node.pkey();
			var sheetIdx = sheetObj.GetNodeSheetIdx(orgCd);
			
			$( "#orgCd"           , $dialog ).val( orgCd );
			$( "#priorOrgCdPre"   , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "priorOrgCdPre"        ) );
			$( "#priorOrgNmPre"   , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "priorOrgNmPre"        ) );
			$( "#priorOrgCdAfter" , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "priorOrgCdAfter"      ) );
			$( "#priorOrgNmAfter" , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "priorOrgNmAfter"      ) );

			$dialog.dialog({
				modal     : true,
				width     : "700px",
				buttons   : dialogObj.getDialogBtn($dialog, "변경", function(){dialogObj.changePrior( evt );}),
				resizable : false
			});
		},
		
		
		/**
		 * 상위조직변경 처리
		 * @param evt
		 * @returns
		 */
		changePrior : function( evt ) {
			var $dialog              = $("#dialog_prior_change");
			var orgCd                = $( "#orgCd"                , $dialog ).val();
			var priorOrgCdPre        = $( "#priorOrgCdPre"        , $dialog ).val();
			var priorOrgNmPre        = $( "#priorOrgNmPre"        , $dialog ).val();
			var priorOrgCdAfter      = $( "#priorOrgCdAfter"      , $dialog ).val();
			var priorOrgNmAfter      = $( "#priorOrgNmAfter"      , $dialog ).val();
			
			if(priorOrgCdPre == "" && priorOrgCdAfter == "") {
				alert("상위조직을 선택해주십시오.");
			} else {
				
				// 변경 대상이 하위 노드인지 체크
				var isChildNode = (priorOrgCdAfter != "") ? orgObj.IsChildren(orgCd, priorOrgCdAfter) : false;
				if(isChildNode) {
					alert("선택하신 상위조직은 현조직의 하위조직입니다.");
				} else {
					
					// 수정된 노드의 sheet idx
					var sheetIdx = sheetObj.GetNodeSheetIdx(orgCd);
					
					// 변경전 상위부서로 설정된 경우
					if(priorOrgCdPre == priorOrgCdAfter) {
						priorOrgCdAfter = "";
						priorOrgNmAfter = "";
					}
					
					if(sheetObj.GetCellValue( sheetIdx , "priorOrgCdAfter" ) != priorOrgCdAfter) {
						// update sheet data
						sheetObj.SetCellValue( sheetIdx , "priorOrgCdPre"        , priorOrgCdPre        );
						sheetObj.SetCellValue( sheetIdx , "priorOrgNmPre"        , priorOrgNmPre        );
						sheetObj.SetCellValue( sheetIdx , "priorOrgCdAfter"      , priorOrgCdAfter      );
						sheetObj.SetCellValue( sheetIdx , "priorOrgNmAfter"      , priorOrgNmAfter      );
						
						var changeGubun = sheetObj.GetCellValue( sheetIdx, "changeGubun" );
						
						if(priorOrgCdAfter == "" && changeGubun == "3") {
							sheetObj.SetCellValue( sheetIdx , "changeGubun" , "" );
						}
						
						if(changeGubun == "" && sheetObj.GetCellValue( sheetIdx , "sStatus" ) == "U") {
							sheetObj.SetCellValue( sheetIdx , "changeGubun" , "3" );
						}
						
						// 상위부서 설정
						if(priorOrgCdAfter != null && priorOrgCdAfter != undefined && priorOrgCdAfter != "") {
							if(priorOrgCdAfter != evt.node.rkey()) {
								evt.node.rkey(priorOrgCdAfter);
							}
						} else {
							if(priorOrgCdPre != evt.node.rkey()) {
								evt.node.rkey(priorOrgCdPre);
							}
						}
						
						// IBOrg Node Template 변경
						var template = orgObj.GetNodeTemplateBase(evt.node.pkey());
						if(sheetObj.GetCellValue( sheetIdx, "changeGubun" ) != "" || sheetObj.IsChange(sheetIdx, orgCd)) {
							evt.node.template(template + "_Move");
						} else {
							evt.node.template(template);
						}
					}
					
					$dialog.dialog( "close" );
					
				}
			}
		},
		
		
		/**
		 * 조직장변경 팝업 출력
		 * @param evt
		 * @returns
		 */
		openChiefChangeDialog : function( evt ) {
			var $dialog = $("#dialog_chief_change");
			
			var orgCd         = evt.node.pkey();
			var sheetIdx      = sheetObj.GetNodeSheetIdx(orgCd);
			var chiefSabunPre = sheetObj.GetCellValue( sheetIdx , "chiefSabunPre" );
			
			$( "#orgCd"                , $dialog ).val( orgCd );
			$( "#chiefSabunPre"        , $dialog ).val( chiefSabunPre );
			$( "#chiefPositionNmPre"   , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "chiefPositionNmPre"   ) );
			$( "#chiefNmPre"           , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "chiefNmPre"           ) );
			$( "#chiefSabunAfter"      , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "chiefSabunAfter"      ) );
			$( "#chiefPositionNmAfter" , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "chiefPositionNmAfter" ) );
			$( "#chiefNmAfter"         , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "chiefNmAfter"         ) );
			
			// 공석여부 체크 박스 상태 초기화
			$( "#vacancyYn"           , $dialog ).removeAttr("checked");
			$( "label[for=vacancyYn]" , $dialog ).show();
			$( "#btnEmpPop4"          , $dialog ).show();
			$( "#btnResetChief4"      , $dialog ).show();
			
			
			// 변경전 데이터가 있는 경우 출력
			if(chiefSabunPre != "") {
				
				// 변경후 설정이 [공석처리] 인 경우
				if( $( "#chiefSabunAfter" , $dialog ).val() == "IS_VACANCY" ) {
					// 체크박스 체크 처리
					$( "#vacancyYn"      , $dialog ).attr("checked", "checked");
					
					// 검색, 초기화 버튼 숨김
					$( "#btnEmpPop4"     , $dialog ).hide();
					$( "#btnResetChief4" , $dialog ).hide();
				}
				
			} else {
				$( "label[for=vacancyYn]" , $dialog ).hide();
			}
			
			$dialog.dialog({
				modal     : true,
				width     : "700px",
				buttons   : dialogObj.getDialogBtn($dialog, "변경", function(){dialogObj.changeChief( evt );}),
				resizable : false
			});
		},
		
		
		/**
		 * 조직장변경 처리
		 * @param evt
		 * @returns
		 */
		changeChief : function( evt ) {
			var $dialog              = $("#dialog_chief_change");
			var orgCd                = $( "#orgCd"                , $dialog ).val();
			var chiefSabunPre        = $( "#chiefSabunPre"        , $dialog ).val();
			var chiefPositionNmPre   = $( "#chiefPositionNmPre"   , $dialog ).val();
			var chiefNmPre           = $( "#chiefNmPre"           , $dialog ).val();
			var chiefSabunAfter      = $( "#chiefSabunAfter"      , $dialog ).val();
			var chiefPositionNmAfter = $( "#chiefPositionNmAfter" , $dialog ).val();
			var chiefNmAfter         = $( "#chiefNmAfter"         , $dialog ).val();
			var vacancyYn            = $( "#vacancyYn"            , $dialog ).is(":checked");

			// 수정된 노드의 sheet idx
			var sheetIdx    = sheetObj.GetNodeSheetIdx(orgCd);
			
			// 변경된 조직장 정보가 변경전 조직장 정보와 동일한 경우
			// [공석처리 해제] 변경전 데이터가 있으며, 공석여부 체크박스 해제인 상태
			if(chiefSabunPre == chiefSabunAfter || (chiefSabunAfter == "" && chiefSabunPre != "" && vacancyYn == false)) {
				chiefSabunAfter      = "";
				chiefPositionNmAfter = "";
				chiefNmAfter         = "";
			}
			
			// 조직장 공석 처리인 경우
			if(vacancyYn == true) {
				chiefSabunAfter      = "IS_VACANCY";
				chiefPositionNmAfter = "";
				chiefNmAfter         = "";
			}
			
			if(sheetObj.GetCellValue( sheetIdx , "chiefSabunAfter" ) != chiefSabunAfter) {
				// update sheet data
				sheetObj.SetCellValue( sheetIdx , "chiefSabunAfter"      , chiefSabunAfter      );
				sheetObj.SetCellValue( sheetIdx , "chiefPositionNmAfter" , chiefPositionNmAfter );
				sheetObj.SetCellValue( sheetIdx , "chiefNmAfter"         , chiefNmAfter         );
				sheetObj.SetCellValue( sheetIdx , "chiefNm"              , chiefNmAfter         );
				sheetObj.SetCellValue( sheetIdx , "chiefPositionNm"      , chiefPositionNmAfter );
				
				// [공석처리 해제] 변경전 데이터가 있으며, 공석여부 체크박스 해제인 상태
				if(chiefSabunPre != "" && vacancyYn == false) {
					sheetObj.SetCellValue( sheetIdx , "chiefNm"          , chiefNmPre           );
					sheetObj.SetCellValue( sheetIdx , "chiefPositionNm"  , chiefPositionNmPre   );
				}
				
				var changeGubun = sheetObj.GetCellValue( sheetIdx, "changeGubun" );
				
				// 조직장 지정이 취소되며, 이전 변경구분값이 조직장 변경인 경우 변경구분값 초기화.
				if(chiefSabunAfter == "" && changeGubun == "7") {
					sheetObj.SetCellValue( sheetIdx , "changeGubun" , "" );
				}
				
				// 변경구분값이 지정되지 않은 경우 설정
				if(changeGubun == "" && sheetObj.GetCellValue( sheetIdx , "sStatus" ) == "U") {
					sheetObj.SetCellValue( sheetIdx , "changeGubun" , "7" );
				}
				
				// 조직장명 표시 변경
				if(!vacancyYn && chiefNmAfter == "" && chiefNmPre != "") {
					evt.node.fields("chief_nm").value( chiefNmPre );
					evt.node.fields("chief_position_nm").value( chiefPositionNmPre );
				} else {
					evt.node.fields("chief_nm").value( chiefNmAfter );
					evt.node.fields("chief_position_nm").value( chiefPositionNmAfter );
				}
				
				// IBOrg Node Template 변경
				var template = orgObj.GetNodeTemplateBase(evt.node.pkey());
				if(sheetObj.GetCellValue( sheetIdx, "changeGubun" ) != "" || sheetObj.IsChange(sheetIdx, orgCd)) {
					evt.node.template(template + "_Move");
				} else {
					evt.node.template(template);
				}
			}
			
			$dialog.dialog( "close" );
		},
		
		
		/**
		 * 조직장 검색, 초기화 버튼 처리 토글...
		 * @param evt
		 * @returns
		 */
		toggleChiefSearchBtn : function() {
			var $dialog   = $("#dialog_chief_change");
			var vacancyYn = $( "#vacancyYn" , $dialog ).is(":checked");
			
			if(vacancyYn) {
				// 검색, 초기화 버튼 숨김
				$( "#btnEmpPop4"     , $dialog ).hide();
				$( "#btnResetChief4" , $dialog ).hide();
			} else {
				// 검색, 초기화 버튼 출력
				$( "#btnEmpPop4"     , $dialog ).show();
				$( "#btnResetChief4" , $dialog ).show();
			}
		},
		
		
		/**
		 * 조직순서변경 팝업 출력
		 * @param evt
		 * @returns
		 */
		openOrderChangeDialog : function( evt ) {
			var $dialog   = $("#dialog_order_change");
			var orgCd     = evt.node.pkey();
			var childrens = orgObj.GetChildren(orgCd);
			var html      = "";
			var child     = null;
			
			$( "#orderEditList", $dialog ).html("");
			
			if(childrens != null && childrens != undefined && childrens.length > 0) {
				
				for(var i = 0; i < childrens.length; i++) {
					child = childrens[i];
					
					html += '<li class="ui-state-default center strong" style="padding:0 0 15px;">';
					html += '<span class="ui-icon ui-icon-arrowthick-2-n-s"></span>';
					html += '<input type="hidden" name="orgCd" id="orgCd_' + i + '" value="' + child.key + '" />';
					html += orgObj.GetNodeDBData(child.key, "deptnm");
					html += '</li>';
					
				}
				
				html = "<ul id='sortableList'>" + html + "</ul>";
				
				$( "#orderEditList", $dialog ).html(html);
				$( "#sortableList" , $dialog ).sortable();
				$( "#sortableList" , $dialog ).disableSelection();
				
				$dialog.dialog({
					modal     : true,
					width     : "400px",
					buttons   : dialogObj.getDialogBtn($dialog, "변경", function(){dialogObj.changeOrder( evt );}),
					resizable : false
				});
			}
			
		},
		
		
		/**
		 * 조직순서변경 처리
		 * @param evt
		 * @returns
		 */
		changeOrder : function( evt ) {
			if(confirm("설정하신 순서로 정렬 하시겠습니까?")) {
				var $dialog  = $("#dialog_order_change");
				var $list    = $("#sortableList li", $dialog);
				var orgCd    = null;
				var sheetIdx = null;
				
				if($list != null && $list != undefined && $list.length > 0) {
					$list.each(function(idx){
						orgCd    = $("input[name=orgCd]", this).val();
						sheetIdx = sheetObj.GetNodeSheetIdx(orgCd);
						sheetObj.SetCellValue( sheetIdx , "seq", idx+1 );
						orgObj.SetNodeDBData(orgCd, "seq", idx+1);
					});
				}
				
				$dialog.dialog( "close" );
			}
		},
		
		
		/**
		 * 조직 상세 정보 팝업 출력
		 * @param evt
		 * @returns
		 */
		openDetailInfoDialog : function(evt) {
			
			var $dialog = $("#dialog_detail_info");
			var orgCd = evt.node.fields("deptcd").value();
			var sheetIdx = sheetObj.GetNodeSheetIdx(orgCd);
			
			if(sheetIdx > -1) {
				var changeGubun = sheetObj.GetCellValue( sheetIdx , "changeGubun" );
				
				$( "#orgCd"                , $dialog ).val( orgCd );
				$( "#changeGubun"          , $dialog ).val( changeGubun );
				$( "#orgNm"                , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "orgNm"                ) );
				$( "#orgNmPre"             , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "orgNmPre"             ) );
				$( "#orgNmAfter"           , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "orgNmAfter"           ) );
				$( "#orgEngNmPre"          , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "orgEngNmPre"          ) );
				$( "#orgEngNmAfter"        , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "orgEngNmAfter"        ) );
				$( "#priorOrgCdPre"        , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "priorOrgCdPre"        ) );
				$( "#priorOrgNmPre"        , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "priorOrgNmPre"        ) );
				$( "#priorOrgCdAfter"      , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "priorOrgCdAfter"      ) );
				$( "#priorOrgNmAfter"      , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "priorOrgNmAfter"      ) );
				$( "#chiefSabunPre"        , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "chiefSabunPre"        ) );
				$( "#chiefPositionNmPre"   , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "chiefPositionNmPre"   ) );
				$( "#chiefNmPre"           , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "chiefNmPre"           ) );
				$( "#chiefSabunAfter"      , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "chiefSabunAfter"      ) );
				$( "#chiefPositionNmAfter" , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "chiefPositionNmAfter" ) );
				$( "#chiefNmAfter"         , $dialog ).val( sheetObj.GetCellValue( sheetIdx , "chiefNmAfter"         ) );
				if (sheetObj.GetCellValue( sheetIdx , "vrtclOrderYn" ) === "Y")
					$( "#vrtclOrderYn", $dialog ).prop("checked", true);
				else
					$( "#vrtclOrderYn", $dialog ).prop("checked", false);

				/*
				if(changeGubun == "1") {
					$( "#changeGubun", $dialog ).attr("disabled", "disabled");
				} else {
					$( "#changeGubun", $dialog ).removeAttr("disabled");
				}
				*/
				
				$dialog.dialog({
					modal     : true,
					width     : "700px",
					buttons   : dialogObj.getDialogBtn($dialog, "저장", function(){dialogObj.saveDetailInfo( evt );}),
					resizable : false
				});			
			}

		},
		
		
		/**
		 * 조직 상세 정보 sheet에 저장
		 * @param evt
		 * @returns
		 */
		saveDetailInfo : function( evt ){
			// sheet 에 값 설정
			// org 에 값 설정
			var $dialog					= $("#dialog_detail_info");
			var orgCd 					= $( "#orgCd"                , $dialog ).val();
			var changeGubun 			= $( "#changeGubun"          , $dialog ).val();
			var orgNmPre 				= $( "#orgNmPre"             , $dialog ).val();
			var orgNmAfter 				= $( "#orgNmAfter"           , $dialog ).val();
			var orgEngNmPre 			= $( "#orgEngNmPre"          , $dialog ).val();
			var orgEngNmAfter 			= $( "#orgEngNmAfter"        , $dialog ).val();
			var priorOrgCdPre 			= $( "#priorOrgCdPre"        , $dialog ).val();
			var priorOrgNmPre 			= $( "#priorOrgNmPre"        , $dialog ).val();
			var priorOrgCdAfter 		= $( "#priorOrgCdAfter"      , $dialog ).val();
			var priorOrgNmAfter 		= $( "#priorOrgNmAfter"      , $dialog ).val();
			
			var chiefSabunPre 			= $( "#chiefSabunPre"        , $dialog ).val();
			var chiefPositionNmPre 		= $( "#chiefPositionNmPre"   , $dialog ).val();
			var chiefNmPre 				= $( "#chiefNmPre"           , $dialog ).val();
			var chiefSabunAfter 		= $( "#chiefSabunAfter"      , $dialog ).val();
			var chiefPositionNmAfter 	= $( "#chiefPositionNmAfter" , $dialog ).val();
			var chiefNmAfter 			= $( "#chiefNmAfter"         , $dialog ).val();
			var vrtclOrderYn 			= ( $( "#vrtclOrderYn", $dialog ).is(":checked") ? "Y" : "N" );

			// 수정된 노드의 sheet idx
			var sheetIdx = sheetObj.GetNodeSheetIdx(orgCd);

			// update sheet data
			sheetObj.SetCellValue( sheetIdx , "changeGubun"          , changeGubun          );
			sheetObj.SetCellValue( sheetIdx , "orgNmPre"             , orgNmPre             );
			sheetObj.SetCellValue( sheetIdx , "orgNmAfter"           , orgNmAfter           );
			sheetObj.SetCellValue( sheetIdx , "orgEngNmPre"          , orgEngNmPre          );
			sheetObj.SetCellValue( sheetIdx , "orgEngNmAfter"        , orgEngNmAfter        );
			sheetObj.SetCellValue( sheetIdx , "priorOrgCdPre"        , priorOrgCdPre        );
			sheetObj.SetCellValue( sheetIdx , "priorOrgNmPre"        , priorOrgNmPre        );
			sheetObj.SetCellValue( sheetIdx , "priorOrgCdAfter"      , priorOrgCdAfter      );
			sheetObj.SetCellValue( sheetIdx , "priorOrgNmAfter"      , priorOrgNmAfter      );
			sheetObj.SetCellValue( sheetIdx , "chiefSabunPre"        , chiefSabunPre        );
			sheetObj.SetCellValue( sheetIdx , "chiefPositionNmPre"   , chiefPositionNmPre   );
			sheetObj.SetCellValue( sheetIdx , "chiefNmPre"           , chiefNmPre           );
			sheetObj.SetCellValue( sheetIdx , "chiefSabunAfter"      , chiefSabunAfter      );
			sheetObj.SetCellValue( sheetIdx , "chiefPositionNmAfter" , chiefPositionNmAfter );
			sheetObj.SetCellValue( sheetIdx , "chiefNmAfter"         , chiefNmAfter         );
			sheetObj.SetCellValue( sheetIdx , "vrtclOrderYn"         , vrtclOrderYn         );

			// 조직명이 변경된 경우
			if(orgNmAfter != null && orgNmAfter != undefined && orgNmAfter != '') {
				sheetObj.SetCellValue( sheetIdx , "orgNm" , orgNmAfter );
			}
			
			// 조직장이 변경된 경우
			if(chiefNmAfter != null && chiefNmAfter != undefined && chiefNmAfter != '') {
				sheetObj.SetCellValue( sheetIdx , "chiefNm"         , chiefNmAfter         );
				sheetObj.SetCellValue( sheetIdx , "chiefPositionNm" , chiefPositionNmAfter );
			}

			// 조직명 표시 변경
			if ( orgNmAfter != "" ){
				evt.node.fields("deptnm").value( orgNmAfter );
			} else if (orgNmPre != "" ) {
				evt.node.fields("deptnm").value( orgNmPre );
			} else {
				evt.node.fields("deptnm").value( sheetObj.GetCellValue( sheetIdx, "orgNm" ) );
			}
			
			// 조직장명 표시 변경
			if(chiefNmAfter != null && chiefNmAfter != undefined && chiefNmAfter != '') {
				evt.node.fields("chief_nm").value( chiefNmAfter );
				evt.node.fields("chief_position_nm").value( chiefPositionNmAfter );
			} else {
				evt.node.fields("chief_nm").value( chiefNmPre );
				evt.node.fields("chief_position_nm").value( chiefPositionNmPre );
			}
			
			// 상위부서 설정
			if(priorOrgCdAfter != null && priorOrgCdAfter != undefined && priorOrgCdAfter != "") {
				if(priorOrgCdAfter != evt.node.rkey()) {
					evt.node.rkey(priorOrgCdAfter);
				}
			} else {
				if(priorOrgCdPre != evt.node.rkey()) {
					evt.node.rkey(priorOrgCdPre);
				}
			}
			
			// IBOrg Node Template 변경
			var template = orgObj.GetNodeTemplateBase(evt.node.pkey());
			if(sheetObj.GetCellValue( sheetIdx , "sStatus" ) == "U") {
				evt.node.template(template + "_Move");
			} else {
				if(changeGubun == "") {
					evt.node.template(template);
				}
			}
			
			$dialog.dialog( "close" );
		}
};
