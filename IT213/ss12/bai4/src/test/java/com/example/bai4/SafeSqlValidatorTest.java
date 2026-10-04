package com.example.bai4;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class SafeSqlValidatorTest {

    @Test
    void input1_khongCoLimit_tuDongThemLimit100() {
        String input = "SELECT id, tracking_code, status FROM deliveries WHERE status = 'DELAYED'";
        String expected = "SELECT id, tracking_code, status FROM deliveries WHERE status = 'DELAYED' LIMIT 100";
        assertEquals(expected, SafeSqlValidator.validateAndSanitize(input));
    }

    @Test
    void input2_coLimitNhoHon100_giuNguyen() {
        String input = "select count(*) from deliveries limit 20";
        assertEquals(input, SafeSqlValidator.validateAndSanitize(input));
    }

    @Test
    void input3_coLimitLon_epVe100() {
        String input = "SELECT * FROM deliveries LIMIT 5000";
        String expected = "SELECT * FROM deliveries LIMIT 100";
        assertEquals(expected, SafeSqlValidator.validateAndSanitize(input));
    }

    @Test
    void input4_lenhPhaHoai_nemSecurityException() {
        String input = "DROP TABLE deliveries;";
        assertThrows(SecurityException.class, () -> SafeSqlValidator.validateAndSanitize(input));
    }

    @Test
    void input5_lachLuatBangComment_nemSecurityException() {
        String input = "SELECT * FROM deliveries WHERE 1=1 -- delete from deliveries";
        assertThrows(SecurityException.class, () -> SafeSqlValidator.validateAndSanitize(input));
    }
}
