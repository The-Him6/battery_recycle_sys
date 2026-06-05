package com.battery.recycle.constant;

/**
 * 系统常量类 - 统一管理所有提示信息和常量
 */
public class SystemConstants {
    
    // ==================== 用户相关 ====================
    public static final String USER_REGISTER_SUCCESS = "注册成功";
    public static final String USER_LOGIN_SUCCESS = "登录成功";
    public static final String USER_LOGOUT_SUCCESS = "退出登录成功";
    public static final String USER_UPDATE_SUCCESS = "更新成功";
    public static final String USER_DELETE_SUCCESS = "删除成功";
    public static final String USER_PASSWORD_RESET_SUCCESS = "您的密码已被重置为123456";
    
    public static final String USER_ALREADY_EXISTS = "该用户名已注册";
    public static final String USER_NOT_FOUND = "该用户未注册";
    public static final String USER_PASSWORD_ERROR = "密码错误";
    public static final String USER_OLD_PASSWORD_ERROR = "原密码错误";
    public static final String USER_NEW_PASSWORD_SAME_AS_OLD = "新密码不能与原密码相同";
    public static final String USER_PHONE_MISMATCH = "手机号确认错误";
    public static final String USER_DISABLED = "该账号已被禁用";
    public static final String USER_USERNAME_EMPTY = "用户名不能为空";
    public static final String USER_PASSWORD_EMPTY = "密码不能为空";
    public static final String USER_PHONE_EMPTY = "手机号不能为空";
    
    // ==================== 权限相关 ====================
    public static final String TOKEN_INVALID = "登录已过期，请重新登录";
    public static final String TOKEN_MISSING = "请先登录";
    public static final String PERMISSION_DENIED = "权限不足";
    public static final String ADMIN_ONLY = "仅管理员可操作";
    
    // ==================== 电池种类相关 ====================
    public static final String BATTERY_TYPE_ADD_SUCCESS = "添加电池种类成功";
    public static final String BATTERY_TYPE_UPDATE_SUCCESS = "更新电池种类成功";
    public static final String BATTERY_TYPE_DELETE_SUCCESS = "删除电池种类成功";
    public static final String BATTERY_TYPE_NOT_FOUND = "电池种类不存在";
    public static final String BATTERY_TYPE_NAME_EXISTS = "电池种类名称已存在";
    
    // ==================== 回收订单相关 ====================
    public static final String ORDER_CREATE_SUCCESS = "创建订单成功";
    public static final String ORDER_UPDATE_SUCCESS = "更新订单成功";
    public static final String ORDER_CANCEL_SUCCESS = "取消订单成功";
    public static final String ORDER_NOT_FOUND = "订单不存在";
    public static final String ORDER_CANNOT_CANCEL = "订单状态不允许取消";
    
    // ==================== 文件上传相关 ====================
    public static final String FILE_UPLOAD_SUCCESS = "文件上传成功";
    public static final String FILE_UPLOAD_FAILED = "文件上传失败";
    public static final String FILE_TYPE_ERROR = "文件类型不支持";
    public static final String FILE_SIZE_ERROR = "文件大小超出限制";
    public static final String FILE_EMPTY = "文件不能为空";
    
    // ==================== 操作日志相关 ====================
    public static final String LOG_OPERATION_SUCCESS = "操作成功";
    public static final String LOG_OPERATION_FAILED = "操作失败";
    
    // ==================== 数据统计相关 ====================
    public static final String STATISTICS_QUERY_SUCCESS = "查询统计数据成功";
    
    // ==================== 通用提示 ====================
    public static final String OPERATION_SUCCESS = "操作成功";
    public static final String OPERATION_FAILED = "操作失败";
    public static final String PARAM_ERROR = "参数错误";
    public static final String SYSTEM_ERROR = "系统异常，请稍后重试";
    public static final String DATA_NOT_FOUND = "数据不存在";
    
    // ==================== 用户角色 ====================
    public static final Integer ROLE_USER = 0;  // 普通用户
    public static final Integer ROLE_ADMIN = 1; // 管理员
    
    // ==================== 用户状态 ====================
    public static final Integer STATUS_DISABLED = 0; // 禁用
    public static final Integer STATUS_NORMAL = 1;   // 正常
    
    // ==================== 订单状态 ====================
    public static final Integer ORDER_STATUS_PENDING = 0;    // 待处理
    public static final Integer ORDER_STATUS_PROCESSING = 1; // 处理中
    public static final Integer ORDER_STATUS_COMPLETED = 2;  // 已完成
    public static final Integer ORDER_STATUS_CANCELLED = 3;  // 已取消
    
    // ==================== 电池通道 ====================
    public static final Integer CHANNEL_NORMAL = 1;      // 普通干电池
    public static final Integer CHANNEL_BUTTON = 2;      // 纽扣电池
    public static final Integer CHANNEL_RECHARGEABLE = 3; // 充电电池
    public static final Integer CHANNEL_LARGE = 4;       // 大型电池
    
    // ==================== 操作结果 ====================
    public static final String RESULT_SUCCESS = "success";
    public static final String RESULT_FAIL = "fail";
    
    // ==================== 文件类型 ====================
    public static final String[] ALLOWED_IMAGE_TYPES = {"jpg", "jpeg", "png", "gif"};
    public static final Long MAX_FILE_SIZE = 10 * 1024 * 1024L; // 10MB
}

