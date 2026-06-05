package com.battery.recycle.util;

import com.aliyun.oss.OSS;
import com.aliyun.oss.model.PutObjectRequest;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.exception.BusinessException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * 阿里云OSS工具类
 */
@Component
public class AliyunOssUtil {

    @Autowired
    private OSS ossClient;

    @Value("${aliyun.oss.bucket-name}")
    private String bucketName;

    @Value("${aliyun.oss.endpoint}")
    private String endpoint;

    /**
     * 上传文件到OSS
     * 
     * @param file   文件
     * @param folder 文件夹路径（如：avatar/、product/）
     * @return 文件访问URL
     */
    public String uploadFile(MultipartFile file, String folder) {
        if (file.isEmpty()) {
            throw new BusinessException(SystemConstants.FILE_EMPTY);
        }

        // 获取原始文件名
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            throw new BusinessException(SystemConstants.FILE_TYPE_ERROR);
        }

        // 获取文件扩展名
        String extension = "";
        int lastDotIndex = originalFilename.lastIndexOf(".");
        if (lastDotIndex > 0) {
            extension = originalFilename.substring(lastDotIndex + 1).toLowerCase();
        }

        // 获取当前日期作为子文件夹 (格式: 2026-02-10)
        String dateFolder = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        // 生成唯一文件名
        String filename = UUID.randomUUID().toString() + "." + extension;

        // 组合完整路径: folder/日期/文件名
        String objectName = folder + dateFolder + "/" + filename;

        try {
            // 上传文件到OSS
            InputStream inputStream = file.getInputStream();
            ossClient.putObject(new PutObjectRequest(bucketName, objectName, inputStream));

            // 返回文件访问URL
            String cleanEndpoint = endpoint.replace("https://", "").replace("http://", "");
            String fileUrl = "https://" + bucketName + "." + cleanEndpoint + "/" + objectName;
            System.out.println("文件上传成功，URL: " + fileUrl);
            return fileUrl;
        } catch (IOException e) {
            e.printStackTrace();
            throw new BusinessException("文件上传失败: " + e.getMessage());
        }
    }

    /**
     * 删除OSS文件
     * 
     * @param fileUrl 文件URL
     */
    public void deleteFile(String fileUrl) {
        try {
            // 从URL中提取objectName
            String objectName = fileUrl.substring(fileUrl.indexOf(bucketName) + bucketName.length() + 1);
            ossClient.deleteObject(bucketName, objectName);
        } catch (Exception e) {
            // 删除失败不抛出异常，只记录日志
            System.err.println("删除OSS文件失败: " + e.getMessage());
        }
    }
}
