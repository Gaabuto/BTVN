package com.example.bai4;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Lớp phòng vệ cho MCP Tool "execute_sql_query".
 * <p>
 * Chống 2 rủi ro chí mạng khi để LLM tự sinh câu lệnh SQL:
 * <ol>
 *   <li>Phá hoại dữ liệu qua Prompt Injection (DROP/DELETE/UPDATE/...)</li>
 *   <li>Tràn RAM của JVM và tràn Context Window của LLM do SELECT không giới hạn dòng</li>
 * </ol>
 */
public final class SafeSqlValidator {

    /** Các từ khóa DDL/DML có thể phá hoại hoặc thay đổi dữ liệu. */
    private static final String[] FORBIDDEN_KEYWORDS = {
            "DROP", "DELETE", "UPDATE", "INSERT", "ALTER", "TRUNCATE", "GRANT", "REVOKE", "EXEC"
    };

    /** Các chuỗi ký tự nguy hiểm: comment SQL và dấu phân tách đa lệnh. */
    private static final String[] FORBIDDEN_TOKENS = {
            "--", "/*", "*/", ";"
    };

    private static final Pattern LIMIT_PATTERN =
            Pattern.compile("\\bLIMIT\\s+(\\d+)\\b", Pattern.CASE_INSENSITIVE);

    private static final int MAX_LIMIT = 100;

    private SafeSqlValidator() {
        // utility class, không cho khởi tạo
    }

    /**
     * Kiểm duyệt và làm sạch một câu lệnh SQL do LLM sinh ra trước khi thực thi.
     *
     * @param rawSql câu lệnh SQL thô do LLM tạo ra
     * @return câu lệnh SQL an toàn, đã được cưỡng chế LIMIT &lt;= 100
     * @throws SecurityException nếu câu lệnh vi phạm quy tắc bảo mật
     */
    public static String validateAndSanitize(String rawSql) {
        if (rawSql == null) {
            throw new SecurityException("Chỉ cho phép thực thi câu lệnh SELECT tra cứu dữ liệu.");
        }

        String sql = rawSql.trim();

        // Quy tắc 1: Chỉ chấp nhận SELECT
        if (!sql.regionMatches(true, 0, "SELECT", 0, "SELECT".length())) {
            throw new SecurityException("Chỉ cho phép thực thi câu lệnh SELECT tra cứu dữ liệu.");
        }

        // Quy tắc 2a: Lọc từ khóa phá hoại
        for (String keyword : FORBIDDEN_KEYWORDS) {
            Pattern p = Pattern.compile("\\b" + keyword + "\\b", Pattern.CASE_INSENSITIVE);
            if (p.matcher(sql).find()) {
                throw new SecurityException("Phát hiện từ khóa SQL nguy hiểm bị cấm: " + keyword);
            }
        }

        // Quy tắc 2b: Lọc ký tự nguy hiểm (comment, đa lệnh)
        for (String token : FORBIDDEN_TOKENS) {
            if (sql.contains(token)) {
                throw new SecurityException("Phát hiện từ khóa SQL nguy hiểm bị cấm: " + token);
            }
        }

        // Quy tắc 3: Tự động cưỡng chế LIMIT 100
        Matcher matcher = LIMIT_PATTERN.matcher(sql);
        if (matcher.find()) {
            int currentLimit = Integer.parseInt(matcher.group(1));
            if (currentLimit > MAX_LIMIT) {
                sql = sql.substring(0, matcher.start())
                        + "LIMIT " + MAX_LIMIT
                        + sql.substring(matcher.end());
            }
            // currentLimit <= 100: giữ nguyên
        } else {
            sql = sql + " LIMIT " + MAX_LIMIT;
        }

        return sql;
    }
}
