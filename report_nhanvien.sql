CREATE EXTENSION IF NOT EXISTS pg_trgm;

--Tính số lượng nhân viên theo vùng và theo tháng
CREATE OR REPLACE PROCEDURE sl(kpi_montha int8)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Clear the data in nhanvien table
    delete from nhanvien where kpi_month = kpi_montha ;
    
    -- Insert aggregated data into nhanvien
    INSERT INTO nhanvien (kpi_month, area_name, sl)
    SELECT 
        kpi_montha AS kpi_month, kad.area_name,
        COUNT(
            CASE 
                WHEN kpi_montha = 202301 THEN kad.jan_ltn
                WHEN kpi_montha = 202302 THEN kad.feb_ltn
                WHEN kpi_montha = 202303 THEN kad.mar_ltn
                WHEN kpi_montha = 202304 THEN kad.apr_ltn
                WHEN kpi_montha = 202305 THEN kad.may_ltn
                WHEN kpi_montha = 202306 THEN kad.jun_ltn
                WHEN kpi_montha = 202307 THEN kad.july_ltn
                WHEN kpi_montha = 202308 THEN kad.aug_ltn
                WHEN kpi_montha = 202309 THEN kad.sep_ltn
                WHEN kpi_montha = 202310 THEN kad.oct_ltn
                WHEN kpi_montha = 202311 THEN kad.nov_ltn
                WHEN kpi_montha = 202312 THEN kad.dec_ltn
                ELSE NULL
            END
        ) AS sl
    from kpi_asm_data kad 
    GROUP BY  kad.area_name;
END;
$$;

-- gọi hàm
Call sl (202305)

select * from nhanvien n 