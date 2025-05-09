var headerInfoList;
var hiddenInfoList;

var headerDataMappingColumn = null;

$(function() {

	/*EmployeeHeader컬럼 구성정보 2015.03.20 Kosh*/
	headerInfoList = ajaxCall("/Employee.do?cmd=employeeHeaderColInfo",$("#empForm").serialize(),false);
	if(headerInfoList.DATA != null && headerInfoList.DATA != "undefine") headerInfoList = headerInfoList.DATA;
	hiddenInfoList = ajaxCall("/Employee.do?cmd=employeeHiddenInfo",$("#empForm").serialize(),false);
	if(hiddenInfoList.DATA != null && hiddenInfoList.DATA != "undefine") hiddenInfoList = hiddenInfoList.DATA;
	headerDataMap = ajaxCall("/Employee.do?cmd=getEmployeeHeaderColDataMap",$("#empForm").serialize(),false);
	if(headerDataMap.DATA != null && headerDataMap.DATA != "undefine") {
		$("#empForm").append("<input type='hidden' id='selectColumn' name='selectColumn' value='"+headerDataMap.DATA.selectColumn+"'/>");
		headerDataMappingColumn = JSON.parse("{" + headerDataMap.DATA.mappingColumn + "}");
		//console.log('headerDataMappingColumn', headerDataMappingColumn);
	}

	getUser();
	var inputId = "searchKeyword";
	var url = "/Employee.do?cmd=employeeList";
	var formId = "empForm";
	initEmployeeHeader(inputId,url,formId, employeeResponse, employeeReturn);

	$("#searchKeyword").click(function(e) {
		$(this).select();
	});
});

function initEmployeeHeader(inputId,url,formId,employeeResponse,employeeReturn) {
	if( $("#"+inputId).attr("type") != "hidden" ) {
		$("#"+inputId).autocomplete(employeeOption(inputId,url,formId,employeeResponse,employeeReturn)).data("uiAutocomplete")._renderItem = employeeRenderItem;
	}
}

function employeeOption(inputId,url,formId,employeeResponse,employeeReturn) {
	return {
		source: function( request, response ) {
			$.ajax({
				url :url,
				dateType : "json",
				type:"post",
				data: $("#"+formId).serialize(),
				async: false,
				success: function( data ) {
					response( $.map( data.DATA, function( item ) {
						return {
							label: item.empSabun + ", " + item.enterCd  + ", " + item.enterNm
							,searchNm : $("#"+inputId).val()
							,enterNm :	item.enterNm	// 회사명
							,enterCd :	item.enterCd	// 회사코드
							,empName :	item.empName	// 사원명
							,empAlias:	item.empAlias	// 호칭
							,empSabun :	item.empSabun	// 사번
							,orgNm :	item.orgNm		// 조직명
							,jikweeNm :	item.jikweeNm	// 직위
							//,resNo : 	item.resNo		// 주민번호
							//,resNoStr:	item.resNoStr	// 주민번호 앞자리
							,statusNm :	item.statusNm	// 재직/퇴직
							,value :	item.empName
							//,alias :    item.alias
						};
					}));
				}
			});
		},
		delay:50,
		autoFocus: true,
		minLength: 1,
		select: employeeReturn,
		focus: function() {
			return false;
		},
		open: function() {
			$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
		},
		close: function() {
			$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
		}
	};
}


//인사기본 상단 이름 검색 시 드롭다운 자동완성
function employeeRenderItem(ul, item) {
	return $("<li />")
	.data("item.autocomplete", item)
	.append("<a class='employeeLIst'>"
	+"<div class='inner-wrap'>"
    +"<span class='name'>"+String(item.empName).split(item.searchNm).join('<b class="f_blue f_bold">'+item.searchNm+'</b>')+"</span><span class='sabun'>["+String(item.empSabun).split(item.searchNm).join('<b class="f_gray_3 f_bold">'+item.searchNm+'</b>')+"]</span><span>"+item.jikweeNm+"</span>"
    +"<span class='ml-auto status'>"+item.statusNm+"</span>"
    +"</div>"
    +"<span>"+item.enterNm+"</span>"
    +"<span>"+item.orgNm+"</span>"
	+"</a>").appendTo(ul);
}

function employeeResponse() {
	return {
		label: item.empName + ", " + item.enterCd  + ", " + item.enterNm,
		searchNm : $("#"+inputId).val(),
		empName :	item.empName,	// 회사명
		enterCd :	item.enterCd,	// 회사코드
		enterNm :	item.enterNm,	// 사원명
		empSabun :	item.empSabun,	// 사번
		empAlias:	item.empAlias,	// 호칭
		orgNm :		item.orgNm,		// 조직명
		jikweeNm :	item.jikweeNm,	// 직위
		//resNo : 	item.resNo,		// 주민번호
		//resNoStr:	item.resNoStr,	// 주민번호 앞자리
		statusNm :	item.statusNm,	// 재직/퇴직
		value :		item.empName
	};
}

// 리턴 값
function employeeReturn( event, ui ) {
	$('#searchKeyword').blur();
	$("#searchUserId").val(ui.item.empSabun);
	$("#searchUserEnterCd").val(ui.item.enterCd);
	$("#searchUserStatusCd").val(ui.item.statusCd);
	// getUser();
	//각 페이지 함수 호출
	setEmpPage();
}

function getUser(){
	var user = ajaxCall("/Employee.do?cmd=getEmployeeHeaderDataMap",$("#empForm").serialize(),false);
	if(user.DATA != null && user.DATA != "undefine") user = user.DATA;
	var headerSeq = 0;
	$("#searchKeyword").val(user.name);
	$("#profile_summary_name").html(user.name); // 231022 김기용: 마크업 수정에 따른 사용자 이름 추가
	$("#tdSabun").html(user.sabun); //기존소스에서 참조하는 부분이 남아 있음[ 점차적으로 줄여야함]
	
	var rootEle = $("#area_employee_header");
	if( rootEle && rootEle != null ) {
		// 검색이 허용된 상태인 경우 이벤트 설정
		if( $("#searchKeyword", rootEle).attr("type") == "text" && $("#searchKeyword", rootEle).data("init") != "Y" ) {
			$("#searchKeyword", rootEle).focus(function(){
				// 검색 아이콘 숨김
				$("i.fa-search", rootEle).hide();
			});
			$("#searchKeyword", rootEle).blur(function(){
				// 검색 아이콘 출력
				$("i.fa-search", rootEle).show();
			});
			// 검색 아이콘 클릭 시 입력폼으로 포커스 이동
			$("i.fa-search", rootEle).on("click", function(e){
				$("#searchKeyword", rootEle).focus();
			});
			$("#searchKeyword", rootEle).data("init", "Y");
		}

		// 직위 숨김
		if( !$("#label_JikweeNm", rootEle).parent().hasClass("hide") ) {
			$("#label_JikweeNm", rootEle).parent().addClass("hide");
		}
		// add
		$("#label_OrgNm", rootEle).html(user.orgNm);
		$("#label_StatusNm", rootEle).removeClass("AA CA EA RA").addClass(user.statusCd).html(user.statusNm);
		$("#label_JikweeNm", rootEle).html(user.jikweeNm);

		// item list reset
		$("ul.item_list", rootEle).empty();

		var _itemEle, _dtEle, _ddEle, _ddHtml, _addText;
		for(var i = 1; i <= 5; i++) {
			for(var j = 1; j <= 4; j++) {
				// headerInfoList의 데이터가 더이상 없는 경우 에러발생. 데이터가 없을경우 빈칸으로 채움. by kwook. 2018.04.10
				if(headerInfoList[headerSeq]) {
					_itemEle = $("<li>");
					_dtEle   = $("<dt>").html(headerInfoList[headerSeq].eleNm);
					_ddEle   = $("<dd>");
					_ddHtml  = "";
					_addText = "";

					// headerInfoList의 데이터가 더이상 없는 경우 에러발생. by kwook. 2018.04.10
					if(headerInfoList[headerSeq] && headerInfoList[headerSeq].addText != "") {
						_addText = headerInfoList[headerSeq].addText ? headerInfoList[headerSeq].addText:'' ;
						for(var x = 0 ; x < hiddenInfoList.length ; x++) {
							_addText = _addText.replace("@@"+hiddenInfoList[x].eleId+"@@", eval("user." + convCamel(hiddenInfoList[x].eleId) + hiddenInfoList[x].eleCd));
						}
					}

					// headerInfoList의 데이터가 더이상 없는 경우 에러발생. 데이터가 없을경우 빈칸으로 채움. by kwook. 2018.04.10
					_ddHtml = eval("user." + convCamel(headerInfoList[headerSeq].eleId) + headerInfoList[headerSeq].eleCd);

					if($.trim(_ddHtml) != "") {
						// headerInfoList의 데이터가 더이상 없는 경우 에러발생. by kwook. 2018.04.10
						if(headerInfoList[headerSeq] && headerInfoList[headerSeq].eleType == "Int") {
							_ddEle.html(_ddHtml.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
						} else {
							_ddEle.html(_ddHtml);
						}

					// 직원 데이터를 조회할 때 데이터가 없을 경우 이미 이전 직원 데이터가 그대로 표시되는 경우 발생. else 부분 추가. by kwook. 2018.03.13
					} else {
						_ddEle.html(_ddHtml);
					}

					if(_addText != "") {
						_ddEle.html(_ddEle.html()+_addText);
					}

					_itemEle.append($("<dl />").append(_dtEle).append(_ddEle));
					$("ul.item_list", rootEle).eq(j - 1).append(_itemEle);

					headerSeq++;
				}
			}
		}

		// 헤더 항목 목록 최대 높이값
		var _maxHeightInItemLst = function(ele) {
			return Math.max.apply(null, ele.map(function(){
				return $(this).height();
			}).get());
		};
		$("ul.item_list", rootEle).css({
			"min-height" : _maxHeightInItemLst($("ul.item_list", rootEle)) + "px"
		});
	}
	
	// hiddenEle 엘레먼트가 존재하는 경우
	if( $("#hiddenEle") != undefined && $("#hiddenEle").length > 0 ) {
		var hiddenContent = "";
		for(var i = 0 ; i < hiddenInfoList.length ; i++) {
			hiddenContent += "<input type='hidden' id='" + hiddenInfoList[i].eleId + "' value='" + eval("user." + convCamel(headerInfoList[i].eleId) + headerInfoList[i].eleCd) + "'/>";
		}
		$("#hiddenEle").html(hiddenContent);
	}
	
	$("#searchEmpPayType"   ).val(user.payType);
	$("#searchCurrJikgubYmd").val(user.currJikgubYmd);
	$("#searchWorkYyCnt"    ).val(user.workYyCnt);
	$("#searchWorkMmCnt"    ).val(user.workMmCnt);
	$("#headName"           ).val(user.name);
	$("#headJikweeCd"       ).val(user.jikweeCd);
	$("#headJikweeNm"       ).val(user[ getEmployeeHeaderColumnMappingKey("직위명") ]);
	$("#headJikgubCd"       ).val(user.jikgubCd);
	$("#headJikgubNm"       ).val(user[ getEmployeeHeaderColumnMappingKey("직급명") ]);
	$("#headJikchakCd"      ).val(user.jikchakCd);
	$("#headJikchakNm"      ).val(user[ getEmployeeHeaderColumnMappingKey("직책명") ]);
	$("#headStatusCd"       ).val(user.statusCd);
	$("#headStatusNm"       ).val(user[ getEmployeeHeaderColumnMappingKey("재직상태명") ]);
	$("#headJobCd"          ).val(user.jobCd);
	$("#headJobNm"          ).val(user[ getEmployeeHeaderColumnMappingKey("직무명") ]);
	$("#headOrgCd"          ).val(user.orgCd);
	$("#headOrgNm"          ).val(user[ getEmployeeHeaderColumnMappingKey("부서명") ]);
	
	$("#headManageNm"       ).val(user[ getEmployeeHeaderColumnMappingKey("사원구분명") ]);
	$("#headHandPhone"      ).val(user[ getEmployeeHeaderColumnMappingKey("핸드폰번호") ]);
	$("#headMailId"         ).val(user[ getEmployeeHeaderColumnMappingKey("메일주소") ]);
	
	$("#searchSabunRef"     ).val(user.sabun);
	let userSabun = user.sabun;
	let enterCd = user.enterCd;

	//$("#userFace").attr("src","/EmpPhotoOut.do?t=" + (new Date()).getTime() + "&enterCd="+enterCd+"&searchKeyword="+userSabun);
	$("#userFace").attr("src","/EmpPhotoOut.do?enterCd="+enterCd+"&searchKeyword="+userSabun+"&t=" + (new Date()).getTime());

}

/**
 * 조회된 항목들의 user 객체에서의 키명 반환
 * @param colNm
 * @returns
 */
function getEmployeeHeaderColumnMappingKey(colNm) {
	var key = null;
	if( headerDataMappingColumn != null && headerDataMappingColumn != undefined && headerDataMappingColumn[colNm] != null && headerDataMappingColumn[colNm] != undefined ) {
		key = headerDataMappingColumn[colNm].toLowerCase();
	}
	return key;
}