var btnObj = {
	init : function() {
		this.bindEvent();
	},
	bindEvent : function() {
		// 레벨 정렬 기능 체크박스
		$("#treeLevel").change(function(){
			var flag = ($(this).is(":checked"));
			orgObj.UseLevelAlign(flag);			// 조직도의 레벨 정렬 기능 사용 유무
		});

		// 졍렬 변경시
		$("#treeAlign").bind("change", function() {
			var flag;
			if(isNaN(Number($(this).val()))) {
				flag = Boolean($(this).val());
			}else {
				flag = Number($(this).val());
			}
			orgObj.UseLevelAlign(flag);
		});

		// 조직 트리 및 정보 창 체크박스
		$("#treeShow").change(function(){
			var flag = ($(this).is(":checked"));

			// 조직 트리 및 정보 창
			if (flag) {
				$("#ibContent").css("left", "1px");
				$("#orgDiv").css("left", "204px");
			} else {
				$("#ibContent").css("left", "-200px");
				$("#orgDiv").css("left", "1px");
			}

			// 조직도 영역 크기가 달라졌을때, 바로 적용하기 위해 사용
			myOrg.requestUpdate();
		});

		// 줌 기능 버튼
		$("#zoom").change(function(){
			orgObj.Zoom( parseFloat($(this).val()) );
		});

		// 이미지 저장 버튼
		$("#btnImageSave").click(function() {
			orgObj.Down2Image();
		});

		// 조직도 json 파일 열기
		$("#btnFileOpen").click(function() {
			orgObj.loadFile();
		});

		// 조직도 json 파일 저장
		$("#btnFileSave").click(function() {
			orgObj.saveFile();
		});

		// 확대
		$("#btnZoomIn").click(function() {
			orgObj.ZoomIn();
		});

		// 축소
		$("#btnZoomOut").click(function() {
			orgObj.ZoomOut();
		});

		// ZoomReset
		$("#btnZoomReset").click(function() {
			orgObj.Zoom(1);
		});

		// ZoomFit
		$("#btnZoomFit").click(function() {
			orgObj.FitScale();
		});
	}
}