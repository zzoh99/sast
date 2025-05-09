package com.hr.api.front.layout;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpSession;
import java.io.StringReader;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service("FrontLayoutService")
public class FrontLayoutService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 권한별 등록된 레이아웃 개수 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLayoutMgrCount(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLayoutMgrCount", paramMap);
	}

	/**
	 * 권한별 레이아웃 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLayoutMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLayoutMgrList", paramMap);
	}

	/**
	 * 레이아웃 설정 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getLayoutMgrConfig(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map result = dao.getMap("getLayoutMgrConfig", paramMap);
        return result;
	}

	/**
	 * 권한 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthList", paramMap);
	}

	/**
	 * 메인메뉴 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMainMenuList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainMenuList", paramMap);
	}

	/**
	 * 레이아웃 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLayoutList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLayoutList", paramMap);
	}

	/**
	 * 레이아웃 배경 이미지 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLayoutMgrImageList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLayoutMgrImageList", paramMap);
	}

	/**
	 * 레이아웃 설정 저장
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveLayoutMgrConfig(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		// 레이아웃 배경 이미지 유무 확인
		List<Map<String, String>> list = (List<Map<String, String>>) dao.getList("getLayoutMgrImageList2", paramMap);

		if(list != null && !list.isEmpty()) {
			String configInfo = paramMap.get("configInfo").toString();

			// ObjectMapper 생성
			ObjectMapper objectMapper = new ObjectMapper();

			// JSON 문자열을 JsonNode로 변환
			JsonNode rootNode = objectMapper.readTree(configInfo);

			for(Map<String, String> map : list) {
				String imageUrl = map.get("imageUrl");
				String layoutNm	= map.get("sFileNm");

				if(layoutNm.equals("layoutBack")) {
					// layoutBack.backgroundImage 값 변경
					((ObjectNode) rootNode.get("layoutBack")).put("backgroundImage", imageUrl);
				}

				// layouts 배열의 각 styles.backgroundImage 값 변경
				JsonNode layoutsNode = rootNode.get("layouts");
				if (layoutsNode.isArray()) {
					for (int i = 0; i < layoutsNode.size(); i++) {
						JsonNode layoutNode = layoutsNode.get(i); // layout 노드
						String layoutNodeNm = "layout" + i;

						if(layoutNm.equals(layoutNodeNm)) {
							JsonNode stylesNode = layoutNode.get("styles"); // style 노드
							if (stylesNode != null && stylesNode.isObject()) {
								((ObjectNode) stylesNode).put("backgroundImage", imageUrl);
							}
							break;
						}
					}
				}
			}

			// 변경된 JSON 출력
			configInfo = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(rootNode);
			paramMap.put("configInfo", new StringReader(configInfo));
		}

		return dao.update("saveLayoutMgrConfig", paramMap);
	}

	/**
	 * 레이아웃 설정 삭제
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteLayoutMgrConfig(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("deleteLayoutMgrConfig", paramMap);
	}

	/**
	 * 레이아웃 적용
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int applyLayoutMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("applyLayoutMgr", paramMap);
	}

	/**
	 * 위젯 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLayoutMgrWidgetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLayoutMgrWidgetList", paramMap);
	}

	/**
	 * 위젯 테스트 쿼리 검색결과 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> execWidgetQuery(Map<String, Object> paramMap, HttpSession session) throws Exception {
		Log.Debug();

		String query = (String) paramMap.get("query");

		// @@c.XXX@@ 형태의 토큰을 찾아 세션 속성값으로 치환
		Pattern sessionPattern = Pattern.compile("@@c\\.([^@]+?)@@");
		Matcher sessionMatcher = sessionPattern.matcher(query);
		StringBuffer sessionSb = new StringBuffer();
		while (sessionMatcher.find()) {
			String key = sessionMatcher.group(1);
			Object value = session.getAttribute(key);
			String replacement = value != null ? value.toString() : "";
			sessionMatcher.appendReplacement(sessionSb, Matcher.quoteReplacement(replacement));
		}
		sessionMatcher.appendTail(sessionSb);
		query = sessionSb.toString();

		// @@f.XXX@@ 형태의 토큰을 찾아 paramMap 속성값으로 치환
		Pattern filterPattern = Pattern.compile("@@f\\.([^@]+?)@@");
		Matcher filterMatcher = filterPattern.matcher(query);
		StringBuffer filterSb = new StringBuffer();
		while (filterMatcher.find()) {
			String key = "f." + filterMatcher.group(1);
			Object value = paramMap.get(key);
			String replacement = value != null ? value.toString() : "";
			filterMatcher.appendReplacement(filterSb, Matcher.quoteReplacement(replacement));
		}
		filterMatcher.appendTail(filterSb);
		query = filterSb.toString();

		paramMap.put("query", query);
		return (List<?>) dao.getList("execWidgetQuery", paramMap);
	}

	/**
	 * 위젯 설정 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<String, Object> getWidgetConfig(Map<String, Object> paramMap, HttpSession session) throws Exception {
		Log.Debug();
		Map<String, Object> result = new HashMap<>();
		ObjectMapper mapper = new ObjectMapper();

		Map<String, Object> widgetInfo = (Map<String, Object>) dao.getMap("getWidgetInfo", paramMap);
		List<Map<String, Object>> subWidgetList = (List<Map<String, Object>>) dao.getList("getSubWidgetList", paramMap);
		List<Map<String, Object>> widgetFilterList = (List<Map<String, Object>>) dao.getList("getFilterList", paramMap);

		// subWidgetCd 별로 필터 리스트를 그룹화
		Map<String, List<Map<String, Object>>> filterMap = new HashMap<>();
		for (Map<String, Object> filter : widgetFilterList) {
			String subWidgetCd = filter.get("subWidgetCd") != null ? filter.get("subWidgetCd").toString() : "";
			filterMap.computeIfAbsent(subWidgetCd, k -> new ArrayList<>()).add(filter);
		}

		if (subWidgetList != null && !subWidgetList.isEmpty()) {
			for (Map<String, Object> subWidget : subWidgetList) {

				/* config 에 filters 정보 주입 처리 */
				// Json -> Map 으로 파싱
				String configJson = subWidget.get("configInfo") != null ? subWidget.get("configInfo").toString() : "{}";
				Map<String, Object> config = mapper.readValue(configJson, new TypeReference<Map<String, Object>>() {});

				// 서브위젯ID 와 일치하는 필터 목록 추출
				String subWidgetCd = subWidget.get("subWidgetCd") != null ? subWidget.get("subWidgetCd").toString() : "";
				List<Map<String, Object>> subWidgetFilterList = filterMap.getOrDefault(subWidgetCd, new ArrayList<>());
				List<Map<String, Object>> filters = new ArrayList<>();

				// 필터 선택값 맵 생성(최초 조회시에만 사용)
				Map<String, Object> selectFilterValue = new HashMap<>();

				// options Json 문자열을 자바 리스트로 변환
				for (Map<String, Object> subWidgetFilter : subWidgetFilterList) {
					String optionsJson = subWidgetFilter.get("options") != null ? subWidgetFilter.get("options").toString() : "[]";
					List<Map<String, Object>> options = mapper.readValue(optionsJson, new TypeReference<List<Map<String, Object>>>() {});

					// filters List에 필터 정보 입력
					Map<String, Object> filter = new HashMap<>();
					filter.put("filterKey", subWidgetFilter.get("filterKey"));
					filter.put("options", options);
					filters.add(filter);

					// selectFilterValue에 filterKey와 options[0].value 추가 (최초 조회시 필터 선택 값을 가장 첫번째 값으로 자동처리)
					if (!options.isEmpty()) {
						selectFilterValue.put("f."+subWidgetFilter.get("filterKey").toString(), options.get(0).get("value"));
					}
				}

				// filters 정보 주입 및 configInfo 업데이트
				config.put("filters", filters);
				subWidget.put("configInfo", mapper.writeValueAsString(config));

				// paramMap에 필터 선택 값 주입
				for (Map.Entry<String, Object> entry : selectFilterValue.entrySet()) {
					if(!paramMap.containsKey(entry.getKey())) {
						paramMap.put(entry.getKey(), entry.getValue());
					}
				}

				/* 데이터 쿼리 처리 */
				if(subWidget.get("sqlBody") != null && !subWidget.get("sqlBody").toString().isEmpty()) {
					paramMap.put("query", subWidget.get("sqlBody"));
					List subWidgetData = execWidgetQuery(paramMap, session);
					subWidget.put("data", subWidgetData);
				}

				/* 써머리 쿼리 처리 */
				if(subWidget.get("summarySqlBody") != null && !subWidget.get("summarySqlBody").toString().isEmpty()) {
					paramMap.put("query", subWidget.get("summarySqlBody"));
					List summaryData = execWidgetQuery(paramMap, session);
					subWidget.put("summaryData", summaryData);
				}

				if(!(boolean) paramMap.get("isEditPage")) {
					// 조회 모드인 경우 sqlBody, summarySqlBody 등 사용하지 않는 컬럼 response에 담지 않도록 함
					subWidget.remove("sqlBody");
					subWidget.remove("summarySqlBody");
				}

			}
		}

		result.put("basic", widgetInfo);
		result.put("tabs", subWidgetList);

		return result;
	}

	/**
	 * 서브위젯 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<String, Object> getSubWidgetData(Map<String, Object> paramMap, HttpSession session) throws Exception {
		Log.Debug();
		Map<String, Object> result = new HashMap<>();

		List<Map<String, Object>> subWidgetList = (List<Map<String, Object>>) dao.getList("getSubWidgetList", paramMap);

		if (subWidgetList != null && !subWidgetList.isEmpty()) {
			result = subWidgetList.get(0);

			/* 데이터 쿼리 처리 `*/
			if(result.get("sqlBody") != null && !result.get("sqlBody").toString().isEmpty()) {
				paramMap.put("query", result.get("sqlBody"));
				List subWidgetData = execWidgetQuery(paramMap, session);
				result.put("data", subWidgetData);
			}

			/* 써머리 쿼리 처리 */
			if(result.get("summarySqlBody") != null && !result.get("summarySqlBody").toString().isEmpty()) {
				paramMap.put("query", result.get("summarySqlBody"));
				List summaryData = execWidgetQuery(paramMap, session);
				result.put("summaryData", summaryData);
			}

			if(!(boolean) paramMap.get("isEditPage")) {
				// 조회 모드인 경우 sqlBody, summarySqlBody 등 사용하지 않는 컬럼 response에 담지 않도록 함
				result.remove("sqlBody");
				result.remove("summarySqlBody");
			}
		}

		return result;
	}

	/**
	 * 위젯 설정 저장
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int saveWidgetConfig(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;

		// widgetCd 생성 또는 가져오기
		String widgetCd = paramMap.get("widgetCd").toString();
		if (widgetCd == null || widgetCd.isEmpty()) {
			LocalDateTime now = LocalDateTime.now();
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS");
			String uuid = UUID.randomUUID().toString();
			widgetCd = now.format(formatter) + uuid.substring(0, 8);
			paramMap.put("widgetCd", widgetCd);
		}

		// TSYS362에 widgetCd, widgetNm, icon 저장
		Map<String, Object> widgetInfo = new HashMap<>();
		widgetInfo.put("widgetCd", widgetCd);
		widgetInfo.put("widgetNm", paramMap.get("widgetNm"));
		widgetInfo.put("icon", paramMap.get("icon"));
		dao.update("saveWidgetInfo", widgetInfo);

		// tabs 정보를 JSON 배열로 파싱
		ObjectMapper mapper = new ObjectMapper();
		String tabsJson = (String) paramMap.get("tabs");
		List<Map<String, Object>> tabs = mapper.readValue(tabsJson, new TypeReference<List<Map<String, Object>>>() {});

		// tabs 를 순회하면서 DB Insert 포맷용으로 만들기
		for (Map<String, Object> tab : tabs) {
			tab.put("widgetCd", widgetCd); // 외래 키로 widgetCd 사용

			// subWidgetCd 생성 또는 가져오기
			String subWidgetCd = tab.get("key").toString();
			if (subWidgetCd == null || subWidgetCd.isEmpty()) {
				LocalDateTime now = LocalDateTime.now();
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS");
				String uuid = UUID.randomUUID().toString();
				subWidgetCd = now.format(formatter) + uuid.substring(0, 8);
			}
			tab.put("subWidgetCd", subWidgetCd);

			// 필터 정보 분리
			Map<String, Object> config = (Map<String, Object>) tab.get("config");
			List<Map<String, Object>> filters = (List<Map<String, Object>>) config.get("filters");
			if(filters != null && !filters.isEmpty()) {
				// 필터 정보가 있다면 TSYS364에 저장
				for (Map<String, Object> filter : filters) {
					filter.put("widgetCd", widgetCd);
					filter.put("subWidgetCd", subWidgetCd);
					// option 정보는 JSON 문자열로 변환해서 저장
					filter.put("options", mapper.writeValueAsString(filter.get("options")));

					dao.update("saveFilterConfig", filter);
				}
			}

			// config 에 filters 정보 제외하고 JSON 문자열로 변환해서 저장
			config.put("filters", null);
			String configJson = mapper.writeValueAsString(config);
			tab.put("config", configJson);

			// TSYS363에 각 탭 저장
			cnt += dao.update("saveSubWidgetConfig", tab);
		}

		return cnt;
	}

	/**
	 * 위젯 메뉴 이동을 위한 surl 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> widgetActionMoveMenu(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
        return dao.getMap("getMenuSurl", paramMap);
	}

	/**
	 * 위젯 새창에서 열기 위한 URL 리턴
	 * 새창 띄우기 전 SSO 등 전처리 작업이 필요하다면 여기서 작업하도록 한다.
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> widgetActionOpenNewWindow(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<String, String> result = new HashMap<>();

       	// URL 별 작업이 필요하다면 여기서 작업하세요.
		String url = paramMap.get("url").toString();

		result.put("url", url);
		return result;
	}
}