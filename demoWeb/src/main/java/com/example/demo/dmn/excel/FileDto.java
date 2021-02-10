package com.example.demo.dmn.excel;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FileDto {
    String fileId;
    String fileGroup;
    String orgFileNm;
    String ext;
    String svrFileNm;
    String svrDirPath;
    String fileStatusCd;
    Long fileSize;
    String contentType;
}