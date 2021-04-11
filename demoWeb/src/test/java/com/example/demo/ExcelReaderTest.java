package com.example.demo;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;


@SpringBootTest(properties = "classpath:/application.yml")  /*https://velog.io/@hellozin/Spring-Boot-Test에서-Yaml-프로퍼티-적용하기*/
@Rollback(false)  /*롤백하지 않게 하자. */
class ExcelReaderTest {
    @Autowired
    WebApplicationContext context;

    MockMvc mockMvc;

      
      //@Test
      @DisplayName("엑셀 데이터 읽어서 오브젝트에 담기 테스트")
      public void getObjectListTest() {
          //String fileName = "test.xls";
          //Path filePath = Paths.get("d:",File.separatorChar + fileName);
          //System.out.println("## filePath = "+filePath);
          /*
          List<ExcelDto> list=ExcelUtils.getExcelUpload("D:\\storage\\2021-01-26_251d2835-bbde-4cb5-85fe-3dc61a1c46aa.xls");
          System.out.println(list.size());
          for(int i=0;i<list.size();i++) {
              ExcelDto t = list.get(i);
              System.out.println(t);
          }
          */
      }

      @Test
      @DisplayName("Sample 엑셀 업로드")
      void excelUpload() throws Exception {
          this.mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
          String fileName = "test.xls";
          Path filePath = Paths.get("d:",File.separatorChar + fileName);
          System.out.println("## filePath = "+filePath);

          String originalFileName = fileName;
          String contentType = "";

          byte[] content = Files.readAllBytes(filePath);

          MockMultipartFile multipartFile = new MockMultipartFile("uploadFile", originalFileName, contentType, content);

          MockHttpServletRequestBuilder builder = MockMvcRequestBuilders.multipart("/excel_upld")
                  .file(multipartFile);
          ResultActions result = mockMvc.perform(builder);
                  //.andExpect(status().isOk());
                  //.andExpect(jsonPath("code").value(100))
                  //.andDo(print())

          String responseBody = result.andReturn().getResponse().getContentAsString();
      }
}
