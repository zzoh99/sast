package com.hr.common.pdfReader;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveInputStream;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.util.PDFTextStripper;
import org.apache.tika.Tika;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.PropertyResourceUtil;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import com.hr.common.util.securePath.SecurePathUtil;
import java.nio.file.Path;

@Controller
@SuppressWarnings("unchecked")
@RequestMapping(value="/PDFReader.do", method=RequestMethod.POST )
public class PDFReaderController {

	private static String adjustType1 = "근로소득원천징수영수증";
	private static String adjustType3 = "퇴직소득원천징수영수증";

	//String adjustTypeNm = "";

	@Inject
	@Named("PDFReaderService")
	private PDFReaderService pdfReaderService;

	@RequestMapping(params="cmd=viewPDFReader", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPDFReader() throws Exception{
		return "common/pdfReader/pdfReader";
	}

	/**
	 * 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPDFReaderList", method = RequestMethod.POST )
	public ModelAndView getPDFReaderList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> result = pdfReaderService.getPDFReaderList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * PDF 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePDFReader", method = RequestMethod.POST )
	public ModelAndView savePDFReader(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =pdfReaderService.savePDFReader(convertMap, request);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}


	@RequestMapping(params="cmd=insertPDFReaderTCPN574", method = RequestMethod.POST )
	public void insertPDFReaderTCPN574(
			HttpSession session,  HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap) throws Exception{
		
		String yyyy = (String) paramMap.get("yyyy");
		String adjustType = (String)paramMap.get("adjustType");
		String adjustTypeNm = "";
		if ( "1".equals(adjustType) ){
			adjustTypeNm = "근로소득원천징수영수증";
		}else if ( "3".equals(adjustType) ){
			adjustTypeNm = "퇴직소득원천징수영수증";
		}
		
		//String pathOld  =  request.getSession().getServletContext().getRealPath("/")+"hrfile" + File.separator + session.getAttribute("ssnEnterCd") + File.separator + "PDF" + File.separator + adjustTypeNm + File.separator + yyyy ;
		//String pathNew  =  request.getSession().getServletContext().getRealPath("/")+"hrfile" + File.separator + session.getAttribute("ssnEnterCd") + File.separator + "workcerti" + File.separator +adjustTypeNm + File.separator + yyyy;
		String pathOld = PropertyResourceUtil.getHrfilePath(request) + File.separator + session.getAttribute("ssnEnterCd") + File.separator + "PDF" + File.separator + adjustTypeNm + File.separator + yyyy ;
		String pathNew = PropertyResourceUtil.getHrfilePath(request) + File.separator + session.getAttribute("ssnEnterCd") + File.separator + "workcerti" + File.separator +adjustTypeNm + File.separator + yyyy;
		
		String message = "이관 할 내역이 없습니다.";
		
		int resultCnt = -1;
		
		try {
			File df = new File(pathNew);
			
			if ( !df.isDirectory() ){

				if ( df.mkdirs() ){
					Log.Debug("★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★Directory Create Success★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★");
				}
			}
			
			File[] destroy = df.listFiles();
			
			if ( destroy != null && destroy.length > 0 ) {
				for(File des : destroy){
					des.delete();
				}
				Log.Debug("★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★File Delete Success★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★");
			}
			
			paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
			paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
			paramMap.put("adjustType",adjustType);
			paramMap.put("yyyy",yyyy);
			
			List<?> list = pdfReaderService.getPDFReaderCopyList(paramMap);
			
			if ( !list.isEmpty() ) {
				for ( int i=0; i < list.size(); i++ ) {
					HashMap<String, String> map = (HashMap<String, String>) list.get(i);
					String fileNm   = (String) map.get("fileNm");
					fileNm = fileNm.replaceAll("[/\\\\]", "");
					oneFileCopy ( pathOld + File.separator + fileNm, pathNew + File.separator + fileNm);
				}
				//copyDirectory ( pathOld, pathNew );
				resultCnt = pdfReaderService.insertPDFReaderTCPN574(paramMap);
			}
			
			if(resultCnt > 0){ message="이관 되었습니다."; } else{ message="이관된 내용이 없습니다."; }
			
		} catch (Exception e) {
			resultCnt = -1; message="이관에 실패하였습니다.";
			Log.Debug(e.getLocalizedMessage());
			
		} finally{
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html;charset:UTF-8");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().print("<script>alert('"+message +"');</script>");
		}
		
	}
	
	@RequestMapping(params="cmd=createPDFReader", method = RequestMethod.POST )
	public void pdfReader(
			HttpSession session,  HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap) throws Exception{

		String yyyy = (String) paramMap.get("yyyy");
		String adjustType = "";
		if ( "1".equals((String)paramMap.get("adjustType")) ){
			adjustType = adjustType1;
		}else if ( "3".equals((String)paramMap.get("adjustType")) ){
			adjustType = adjustType3;
		}
		
		String basePath = PropertyResourceUtil.getHrfilePath(request);
		String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
		
		// 안전한 경로 생성
		Path securePath = SecurePathUtil.getSecurePath(basePath, ssnEnterCd, "PDF", adjustType, yyyy);
		String path = securePath.toString();

		int sizeLimit = 50 * 1024 * 1024;
		String message = "생성된 내역이 없습니다.";
		int resultCnt = -1;

		try {
			File df = new File(path);
			if (!df.isDirectory()) {
				SecurePathUtil.createSecureDirectory(basePath, path);
			}

			File[] destroy = df.listFiles();
			if (destroy != null && destroy.length > 0) {
				for(File des : destroy) {
					des.delete();
				}
				Log.Debug("★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★File Delete Success★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★");
			}

			MultipartRequest multi = new MultipartRequest(request, path, sizeLimit, "UTF-8" , new DefaultFileRenamePolicy());

			String fileName = multi.getOriginalFileName("inputFile");
			fileName = SecurePathUtil.sanitizeFileName(fileName);

			List<?> resNoList = read(request, response, fileName, path, ssnEnterCd, yyyy);
			
			if (!resNoList.isEmpty()) {

				HashMap<String, Object> map = new HashMap<String, Object>();

				map.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
				map.put("ssnSabun",session.getAttribute("ssnSabun"));
				map.put("yyyy", (String)paramMap.get("yyyy"));
				map.put("adjustType", (String)paramMap.get("adjustType"));
				map.put("list", resNoList);

				resultCnt = pdfReaderService.createPDFReader(map);


			}
			if(resultCnt > 0){ message="생성 되었습니다."; } else{ message="생성된 내용이 없습니다."; }

		} catch (Exception e) {
			resultCnt = -1; message="생성에 실패하였습니다.";
			Log.Debug(e.getLocalizedMessage());

		} finally{
//			adjustTypeNm = "";
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html;charset:UTF-8");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().print("<script>alert('"+message +"');</script>");
		}

	}

	public List<?> read(HttpServletRequest request, HttpServletResponse response, String fileName, String path, String ssnEnterCd, String yyyy) throws Exception {

		List<Serializable> list = new ArrayList<Serializable>();
		List<Serializable> returnList = new ArrayList<Serializable>();

		File file = new File(path + File.separator + fileName);
		InputStream in = null;
		Tika tika = new Tika();
		String mType = tika.detect(file);

		if (file.isFile()) {
			try {
				in = new FileInputStream(file);
				if ("application/pdf".equals(mType)) {
					list = (List<Serializable>) readMain(path + File.separator + fileName, path, ssnEnterCd, yyyy, fileName);
					if (!list.isEmpty()) {
						for (int i = 0; i < list.size(); i++) {
							HashMap<String, String> map = (HashMap<String, String>) list.get(i);
							returnList.add(map);
						}
					}
				}
			} catch (IOException e) {
				Log.Debug("ERROR: {}", e.getLocalizedMessage());
			} finally {
				if (in != null) {
					in.close();
					File df = new File(path + File.separator + fileName);
					if (df.isFile()) df.delete();
				}
			}
		}

		return returnList;
	}

	public List<?> readMain(String fileName, String path, String ssnEnterCd, String yyyy, String fileNameBefore) throws Exception {
		File file = null;
		List<Serializable> returnAllList = new ArrayList<Serializable>();
		List<Serializable> returnList = new ArrayList<Serializable>();

		PDDocument pdd = null;
		PDFTextStripper pdfts =  new PDFTextStripper();

		try {

			file = new File(fileName);
			pdd = PDDocument.load(file);
			if (pdd.getNumberOfPages() > 0) {
				int pageCount = pdd.getNumberOfPages();

				HashMap<String, Object> pageRetunMap = new HashMap<String, Object>();
				List<Serializable> page = new ArrayList<Serializable>();

				for (int r = 1; r <= pageCount; r++) {
					returnAllList.add(fileReNameAndDivision(pdd, pdfts, fileName, fileNameBefore, path,  r, r, ssnEnterCd, yyyy, false));
				}

				if ( !returnAllList.isEmpty() ){

					for ( int i = 0 ; i < returnAllList.size(); i ++ ){
						HashMap<String, Object> returnAllMap = (HashMap<String, Object>) returnAllList.get(i);
						String subjectText = (String) returnAllMap.get("subjectText");

						if ( subjectText != null && !"".equals(subjectText) ){
							pageRetunMap.put("pageNo", returnAllMap.get("pageNo"));
							pageRetunMap.put("subjectText", subjectText);
							page.add((Serializable) pageRetunMap);
							pageRetunMap = new HashMap<String, Object>();
						}
					}
				}

				if ( !page.isEmpty()){

					for ( int i=0; i < page.size(); i++ ){

						HashMap<String, Object> pageMap = (HashMap<String, Object>) page.get(i);

						int pageNo = (int) pageMap.get("pageNo");

						int start = pageNo;
						int end = 0;

						for ( int r = pageNo ; r < returnAllList.size(); r++ ){
							HashMap<String, Object> returnAllMap = (HashMap<String, Object>) returnAllList.get(r);

							int returnAllMapPageNo = (int) returnAllMap.get("pageNo");

							if ( r == returnAllList.size()-1 ) {
								end = returnAllList.size();
								break;
							}
							
							if ( pageNo != returnAllMapPageNo ){
								if ( r < returnAllList.size() ){
									HashMap<String, Object> returnAllMapIF = (HashMap<String, Object>) returnAllList.get(r);
									String subjectTextIF = (String) returnAllMapIF.get("subjectText");
									if ( subjectTextIF != null && !"".equals(subjectTextIF)){
										end = returnAllMapPageNo-1;
										break;
									}else{
										continue;
									}
								}
							}
						}
						returnList.add(fileReNameAndDivision(pdd, pdfts, fileName, fileNameBefore, path, start, end, ssnEnterCd, yyyy, true));
					}
				}
			}
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
		} finally {
			try {
				if (pdd != null) {
					pdd.close();
				}
			} catch (Exception e) {
			}
		}

		return returnList;
	}

	public HashMap<String, Object> fileReNameAndDivision(PDDocument pdd, PDFTextStripper pdfts, String fileName, String fileNameBefore, String path,
			int pageStart, int pageEnd, String ssnEnterCd, String yyyy, boolean flag) throws Exception {

		PDPage pdPage = null;
		String result = null;

		pdfts.setStartPage(pageStart);
		pdfts.setEndPage(pageStart);
		
		result = Pattern.compile("\\s").matcher( pdfts.getText(pdd) ).replaceAll("");

		if ( flag ){
			pdfts.setEndPage(pageEnd);
		}

		HashMap<String, Object> map = pMatch(result, fileName, fileNameBefore, path, pageStart);
		PDDocument outputDocument = new PDDocument();

		if ( flag ){

			int pageStartEnd = pageEnd - pageStart;
			
			if ( pageStartEnd > 0 ){
				for ( int i=0; i <= pageStartEnd; i++ ){
					pdPage = (PDPage) pdd.getDocumentCatalog().getAllPages().get(pageStart + ( -1 + i ));
					outputDocument.importPage(pdPage);
				}
			}
		}

		String resNo = (String) map.get("resNo");

		try {

			Map <?,?> returnMap = null;
			if (resNo != null && !"".equals(resNo)) {
				map.put("ssnEnterCd", ssnEnterCd);
				if ( flag ){
					returnMap = pdfReaderService.getTHRM100Sabun(map);
				}
			}

			String sabun = returnMap != null && !"".equals(returnMap.get("sabun")) ? (String) returnMap.get("sabun") : "";
			String newFileName;

			if (sabun != null && !"".equals(sabun)) {
				if (flag) {
					newFileName = SecurePathUtil.sanitizeFileName(sabun + "_" + yyyy + "_" + pageStart + ".pdf");
					Path outputPath = SecurePathUtil.getSecurePath(path, newFileName);
					outputDocument.save(outputPath.toString());
				}
				map.put("sabun", sabun);
				map.put("createYn", "Y");
				map.put("fileNm", sabun + "_" + yyyy + "_" + pageStart + ".pdf");
			} else {
				if (flag) {
					newFileName = SecurePathUtil.sanitizeFileName(yyyy + "_" + pageStart + ".pdf");
					Path outputPath = SecurePathUtil.getSecurePath(path, newFileName);
					outputDocument.save(outputPath.toString());
				}
				map.put("sabun", "");
				map.put("createYn", "Y");
				map.put("fileNm",  yyyy + "_" + pageStart + ".pdf");
			}

		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
			map.put("createYn", "N");
			map.put("fileNm", "");
		} finally {

			try {
				if (outputDocument != null) {
					outputDocument.close();
				}
			} catch (Exception e) {}
		}

		map.put("pageStart", pageStart);
		map.put("pageEnd", pageEnd);

		return map;
	}

	public HashMap<String, Object> pMatch(String input, String fileName, String fileNameBefore, String path, int pageNo) {

		ResNo r = new ResNo();
		SubjectText sT = new SubjectText();

		String pdfResno = input;
		String pdfSubjectText = input;

		HashMap<String, Object> returnMap = new HashMap<String, Object>();

		pdfResno = r.FindResNo(pdfResno);

		if (r.rrn != "Not found") {
			if (r.rrn != null && !"".equals(r.rrn)) {
				returnMap.put("resNo", r.rrn);
			} else {
				returnMap.put("resNo", "");
			}
		}
		
		pdfSubjectText = sT.FindSubjectText(pdfSubjectText);
		
		if (sT.rrn != "Not found") {
			if (sT.rrn != null && !"".equals(sT.rrn)) {
				returnMap.put("subjectText", sT.rrn);
			} else {
				returnMap.put("subjectText", "");
			}
		}

		returnMap.put("fileNmBefore", fileNameBefore);
		returnMap.put("filePath", path);
		returnMap.put("pageNo", pageNo);

		return returnMap;
	}

	class ResNo {
		
		String rrn;
		String PatternStr = "(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-[1-4][0-9]{6}";
		Pattern pat = Pattern.compile(PatternStr);
		
		Matcher mat;
		boolean found;
		boolean more = true;

		public String FindResNo(String str) {
			mat = pat.matcher(str);
			found = mat.find();
			if (found) {
				rrn = mat.group();
				more = true;
				str = str.substring(mat.end());
			} else {
				rrn = "Not found";
				more = false;
			}
			return str;
		}
	}
	
	class SubjectText {
		
		String rrn;
		String PatternStr; // adjustTypeNm; 사용안하는거 같다. 23.12.05 jyp
		Pattern pat = Pattern.compile(PatternStr);
		
		Matcher mat;
		boolean found;
		boolean more = true;
		
		public String FindSubjectText(String str) {
			
			mat = pat.matcher(str);
			found = mat.find();
			if (found) {
				rrn = mat.group();
				more = true;
				str = str.substring(mat.end());
			} else { 
				rrn = "Not found";
				more = false;
			}
			return str;
		}
	}

	public void decompress(String zipFileName, String directory) throws Throwable {

		File zipFile = new File(zipFileName);
		FileInputStream fis = null;
		ZipArchiveInputStream zis = null;
		ZipArchiveEntry zipArchiveEntry = null;

		try {

			fis = new FileInputStream(zipFile);
			zis = new ZipArchiveInputStream(fis);
			while ((zipArchiveEntry = zis.getNextZipEntry()) != null) {
				String filename = zipArchiveEntry.getName();
				File file = new File(directory, filename);
				if (zipArchiveEntry.isDirectory()) {
					file.mkdirs();
				} else {
					createFile(file, zis);
				}
			}

		} catch (Throwable e) {
			throw e;
		} finally {
			if (zis != null) {
				zis.close();
			}
			if (fis != null) {
				fis.close();
			}
		}

	}

	private void createFile(File file, ZipArchiveInputStream zis) throws Throwable {

		File parentDir = new File(file.getParent());
		if (!parentDir.exists()) {
			parentDir.mkdirs();
		}
		try (FileOutputStream fos = new FileOutputStream(file)) {
			byte[] buffer = new byte[256];
			int size = 0;
			while ((size = zis.read(buffer)) > 0) {
				fos.write(buffer, 0, size);
			}
		} catch (Throwable e) {
			throw e;
		}
	}
	
	public static void oneFileCopy(String inFileName, String outFileName) {
		try {
			
			FileInputStream fis = null;
			FileOutputStream fos = null;
			try {
				fis = new FileInputStream(inFileName);
				fos = new FileOutputStream(outFileName);
				byte[] b = new byte[4096];
				int len = 0;
				while((len=fis.read(b)) != -1 ) {
					fos.write(b, 0, len);
				}
			}catch ( Exception e) {
				Log.Debug(e.getLocalizedMessage());
			}finally {
				try {
					if ( fis != null) {
						fis.close();
					}
				}catch (IOException e) {
					Log.Debug(e.getLocalizedMessage());
				}
				try {
					if ( fos != null) {
						fos.close();
					}
				}catch (IOException e) {
					Log.Debug(e.getLocalizedMessage());
				}
			}
			
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
		}
	}
	
	public static void copyDirectory ( File sourceF, File targetF ) {
		if (sourceF == null || targetF == null) return;
		File[] targetFile = sourceF.listFiles();
		if (targetFile == null) return;
		
		for ( File file : targetFile ) {
			File temp = new File ( targetF.getAbsolutePath() + File.separator + file.getName() );
			if( file.isDirectory() ) {
				temp.mkdirs();
				copyDirectory(file, temp);
			}else {
				FileInputStream fis = null;
				FileOutputStream fos = null;
				try {
					fis = new FileInputStream(file);
					fos = new FileOutputStream(temp);
					byte[] b = new byte[4096];
					int len = 0;
					while((len=fis.read(b)) != -1 ) {
						fos.write(b, 0, len);
					}
				}catch ( Exception e) {
					Log.Debug(e.getLocalizedMessage());
				}finally {
					try {
						if ( fis != null) {
							fis.close();
						}
					}catch (IOException e) {
						Log.Debug(e.getLocalizedMessage());
					}
					try {
						if ( fos != null) {
							fos.close();
						}
					}catch (IOException e) {
						Log.Debug(e.getLocalizedMessage());
					}
				}
			}
		}
	}
}
