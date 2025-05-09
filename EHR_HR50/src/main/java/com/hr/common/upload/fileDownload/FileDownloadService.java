package com.hr.common.upload.fileDownload;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("FileDownloadService")
public class FileDownloadService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * [제증명] 원천징수영수증 PDF 파일 정보 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?,?> getCertiAppDetPdfDownloadFileMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap("getCertiAppDetPdfDownloadFileMap", paramMap);
	}
}