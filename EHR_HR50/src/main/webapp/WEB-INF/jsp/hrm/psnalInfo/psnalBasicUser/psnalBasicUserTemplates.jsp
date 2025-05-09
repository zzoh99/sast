<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--<c:set var="pbuTemplateVersion" value="<%= System.currentTimeMillis() %>" />--%>
<c:set var="pbuTemplateVersion" value="20250409" />
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/psnlInfo.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/contacts.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/workInfo.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/address.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/family.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/grntIns.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/post.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/rewardNPunish.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/education.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/license.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/school.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/career.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/language.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/overseasStudy.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/military.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/militaryException.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/veteransAffairs.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/assets/js/hrm/psnalInfo/psnalBasicUser/disability.js?v=${pbuTemplateVersion}" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
    /**
     * 인사기본_임직원공통 탭정보 예시템플릿
     */
    const defaultTemplate = `[
			{
				"tabId": "1",
				"tabNm": "기본",
				"seq": 1,
				"template": [
					{
						"rowSeq": 1,
						"colSeq": 1,
						"templateId": "PSNLINFO",
						"showYn": "Y"
					},
					{
						"rowSeq": 1,
						"colSeq": 2,
						"templateId": "CONTACTS",
						"showYn": "Y"
					},
					{
						"rowSeq": 2,
						"colSeq": 1,
						"templateId": "WORKINFO",
						"showYn": "Y"
					},
					{
						"rowSeq": 2,
						"colSeq": 2,
						"templateId": "ADDRESS",
						"showYn": "Y"
					},
					{
						"rowSeq": 3,
						"colSeq": 1,
						"templateId": "FAMILY",
						"showYn": "Y"
					},
					{
						"rowSeq": 4,
						"colSeq": 1,
						"templateId": "GRNTINS",
						"showYn": "Y"
					}
				]
			},
			{
				"tabId": "2",
				"tabNm": "발령/상벌",
				"seq": 2,
				"template": [
					{
						"rowSeq": 1,
						"colSeq": 1,
						"templateId": "POST",
						"showYn": "Y"
					},
					{
						"rowSeq": 1,
						"colSeq": 2,
						"templateId": "RWRDNPNSH",
						"showYn": "Y"
					}
				]
			},
			{
				"tabId": "3",
				"tabNm": "교육/자격",
				"seq": 3,
				"template": [
					{
						"rowSeq": 1,
						"colSeq": 1,
						"templateId": "EDUCATION",
						"showYn": "Y"
					},
					{
						"rowSeq": 1,
						"colSeq": 2,
						"templateId": "LICENSE",
						"showYn": "Y"
					}
				]
			},
			{
				"tabId": "4",
				"tabNm": "경력/학력",
				"seq": 4,
				"template": [
					{
						"rowSeq": 1,
						"colSeq": 1,
						"templateId": "SCHOOL",
						"showYn": "Y"
					},
					{
						"rowSeq": 1,
						"colSeq": 2,
						"templateId": "CAREER",
						"showYn": "Y"
					}
				]
			},
			{
				"tabId": "5",
				"tabNm": "어학/해외연수",
				"seq": 5,
				"template": [
					{
						"rowSeq": 1,
						"colSeq": 1,
						"templateId": "LANGUAGE",
						"showYn": "Y"
					},
					{
						"rowSeq": 1,
						"colSeq": 2,
						"templateId": "OVRSSTUDY",
						"showYn": "Y"
					}
				]
			},
			{
				"tabId": "6",
				"tabNm": "병역/보훈/장애",
				"seq": 6,
				"template": [
					{
						"rowSeq": 1,
						"colSeq": 1,
						"templateId": "MILITARY",
						"showYn": "Y"
					},
					{
						"rowSeq": 1,
						"colSeq": 2,
						"templateId": "MLTRYEXPT",
						"showYn": "Y"
					},
					{
						"rowSeq": 1,
						"colSeq": 3,
						"templateId": "VTRNAFFRS",
						"showYn": "Y"
					},
					{
						"rowSeq": 1,
						"colSeq": 4,
						"templateId": "DISABILITY",
						"showYn": "Y"
					}
				]
			}
		]`;

    /**
     * templateId 별로 Object 호출 함수
     * @param templateId 템플릿 ID
     * @param $el 붙여야할 target
     * @param isPreview 예시 여부. true 일 경우 예시 데이터를 사용한다. 기본값 false.
     * @returns {Promise<void>}
     */
    async function renderSection(templateId, $el, isPreview = false) {
        if (templateId === "PSNLINFO") {
            await PSNLINFO.init($el, isPreview);
        } else if (templateId === "CONTACTS") {
            await CONTACTS.init($el, isPreview);
        } else if (templateId === "WORKINFO") {
            await WORKINFO.init($el, isPreview);
        } else if (templateId === "ADDRESS") {
            await ADDRESS.init($el, isPreview);
        } else if (templateId === "FAMILY") {
            await FAMILY.init($el, isPreview);
        } else if (templateId === "GRNTINS") {
            await GRNTINS.init($el, isPreview);
        } else if (templateId === "POST") {
            await POST.init($el, isPreview);
        } else if (templateId === "RWRDNPNSH") {
            await RWRDNPNSH.init($el, isPreview);
        } else if (templateId === "EDUCATION") {
            await EDUCATION.init($el, isPreview);
        } else if (templateId === "LICENSE") {
            await LICENSE.init($el, isPreview);
        } else if (templateId === "CAREER") {
            await CAREER.init($el, isPreview);
        } else if (templateId === "SCHOOL") {
            await SCHOOL.init($el, isPreview);
        } else if (templateId === "LANGUAGE") {
            await LANGUAGE.init($el, isPreview);
        } else if (templateId === "OVRSSTUDY") {
            await OVRSSTUDY.init($el, isPreview);
        } else if (templateId === "MILITARY") {
            await MILITARY.init($el, isPreview);
        } else if (templateId === "MLTRYEXPT") {
            await MLTRYEXPT.init($el, isPreview);
        } else if (templateId === "VTRNAFFRS") {
            await VTRNAFFRS.init($el, isPreview);
        } else if (templateId === "DISABILITY") {
            await DISABILITY.init($el, isPreview);
        }
    }
</script>