/********************************************************************************************
 * 폼 전송 관련 공통 유틸리티 모음
 ********************************************************************************************/

/**
 * 보안 처리 폼 전송 처리
 * 
 * @param form
 * @returns
 */
function EncSubmit(form) {
	/** Yettie Soft VestWeb 파라미터 난독화 적용 (20191212-한국투자증권)
	if (typeof VestAjax != 'undefined' && typeof VestAjax == 'function') {
		VestSubmit(form);
	} else {
		$(form).submit();
	}
	*/
	$(form).submit();
}

/**
 * 파라미터 보안 처리 반환
 * 
 * @param paramObject
 * @returns
 */
function EncParams(paramObject) {
	var params = null;
	if(paramObject != null && paramObject != undefined) {
		params = paramObject;
		//console.log('[EncParams] origin', params);
		
		//console.log('[EncParams] paramObject', paramObject);
		//console.log('[EncParams] paramObject typeof', typeof paramObject);
		/** Yettie Soft VestWeb 파라미터 난독화 적용 (20191212-한국투자증권)
		if (typeof VestAjax != 'undefined' && typeof VestAjax == 'function') {
			
			if (typeof paramObject === "object") {
				params = $.param(params);
				//console.log('[EncParams] convert', params);
			}
			
			// 난독화
			params = VestAjax(params);
		}
		//console.log('[EncParams] result', params);
		 */
	}
	return params;
}