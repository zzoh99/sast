package com.hr.tus;

import me.desair.tus.server.upload.UploadInfo;




@FunctionalInterface
public interface TusOnUpload {
    void call(UploadInfo uploadInfo);
}
