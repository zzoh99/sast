var userSabun 	= "";
var enterCd 	= ""; 
$(function() {
	//getUser();
	var inputId = "searchKeyword";
	var url = "/Employee.do?cmd=employeeList";
	var formId = "empForm";
	initEmployeeHeader(inputId,url,formId,employeeResponse,employeeReturn);

	if(comBtnAuthPg=="R"){
		$("#searchKeyword").addClass("transparent");
		$("#searchKeyword").attr("readonly","readonly");
	}
	
	$("#searchKeyword").click(function() {
		$(this).select();
	});
});

function initEmployeeHeader(inputId,url,formId,employeeResponse,employeeReturn) {
	$("#"+inputId).autocomplete(employeeOption(inputId,url,formId,employeeResponse,employeeReturn)).data("uiAutocomplete")._renderItem = employeeRenderItem;
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
							label: item.empSabun + ", " + item.enterCd  + ", " + item.enterNm,
							searchNm : $("#"+inputId).val(),
							enterNm :	item.enterNm,	// 회사명
							enterCd :	item.enterCd,	// 회사코드
							empName :	item.empName,	// 사원명
							empSabun :	item.empSabun,	// 사번
							orgNm :		item.orgNm,		// 조직명
							jikweeNm :	item.jikweeNm,	// 직위
							resNo : 	item.resNo,		// 주민번호
							resNoStr:	item.resNoStr,	// 주민번호 앞자리
							statusNm :	item.statusNm,	// 재직/퇴직
							value :		item.empName
						};
					}));
				}
			});
		},
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

function employeeRenderItem(ul, item) {
	return $("<li />")
		.data("item.autocomplete", item)
		.append("<a class='employeeLIst'>"
		+"<span class='list_txt0'>"+String(item.empName).split(item.searchNm).join('<b>'+item.searchNm+'</b>')+"</span>"
		// +"<span style='display:inline-block;width:50px;'>"+item.resNoStr+"</span>"
		// +"<span style='display:inline-block;width:100px;'>"+item.enterNm+"</span>"
		+"<span class='list_txt1'>"+item.empSabun+"</span>"
		+"<span class='list_txt2'>"+item.orgNm+"</span>"
		+"<span class='list_txt3'>"+item.jikweeNm+"</span>"
		+"<span class='list_txt4'>"+item.statusNm+"</span>"
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
		orgNm :		item.orgNm,		// 조직명
		jikweeNm :	item.jikweeNm,	// 직위
		resNo : 	item.resNo,		// 주민번호
		resNoStr:	item.resNoStr,	// 주민번호 앞자리
		statusNm :	item.statusNm,	// 재직/퇴직
		value :		item.empName
	};
}

// 리턴 값
function employeeReturn( event, ui ) {
	$("#searchUserId").val(ui.item.empSabun);
	//각 페이지 함수 호출
	setEmpPage();
}

