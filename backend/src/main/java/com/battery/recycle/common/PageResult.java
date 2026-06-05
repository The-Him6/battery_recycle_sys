package com.battery.recycle.common;

import lombok.Data;
import java.io.Serializable;
import java.util.List;

/**
 * 分页结果封装类
 */
@Data
public class PageResult<T> implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 总记录数
     */
    private long total;

    /**
     * 数据列表
     */
    private List<T> list;

    /**
     * 当前页码
     */
    private int pageNum;

    /**
     * 每页大小
     */
    private int pageSize;

    /**
     * 总页数
     */
    private int pages;

    public PageResult() {
    }

    public PageResult(List<T> list, long total, int pageNum, int pageSize) {
        this.list = list;
        this.total = total;
        this.pageNum = pageNum;
        this.pageSize = pageSize;
        this.pages = (int) Math.ceil((double) total / pageSize);
    }

    /**
     * 从 PageHelper 的 PageInfo 创建
     */
    public static <T> PageResult<T> of(com.github.pagehelper.PageInfo<T> pageInfo) {
        PageResult<T> result = new PageResult<>();
        result.setTotal(pageInfo.getTotal());
        result.setList(pageInfo.getList());
        result.setPageNum(pageInfo.getPageNum());
        result.setPageSize(pageInfo.getPageSize());
        result.setPages(pageInfo.getPages());
        return result;
    }
}




































