var btnObj = {
	init : function() {
		this.bindEvent();
	},
	bindEvent : function() {

		// 줌 기능 버튼
		$("#zoom").change(function(){
			orgObj.Zoom( parseFloat($(this).val()) );
		});

		// 이미지 저장
		$("#btnImageSave").click(function() {
			orgObj.Down2Image();
		});

		// 엑셀 저장
		$("#btnFileSave").click(function() {
			orgObj.Down2Excel();
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