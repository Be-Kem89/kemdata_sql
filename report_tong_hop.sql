CREATE OR REPLACE PROCEDURE report_tonghop (kpi_montha int)
LANGUAGE plpgsql
AS $$
BEGIN

    --Truy vấn tính lần 1 các code account
	delete from tmp_code_vale  where monthkey = kpi_montha;
    insert into tmp_code_vale ( id_report, ma_kv, tmp_value, monthkey )
		-- Truy vấn cho loại 'B2'- lãi trong hạn
		select 'B2' as tieu_de, SUBSTRING(analysis_code, 9, 1) as ma_kv ,sum(amount) as value, kpi_montha from fact_txn_month_raw_data x 
		where account_code in (702000030002, 702000030001, 702000030102) 
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'B1' - lãi quá hạn 
		select 'B1' as tieu_de, SUBSTRING(analysis_code, 9, 1), sum(amount),kpi_montha  from fact_txn_month_raw_data x 
		where account_code in (702000030012, 702000030112) 
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'B3' - Phí bảo hiểm
		select 'B3' as tieu_de,SUBSTRING(analysis_code, 9, 1), sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code in (716000000001) 
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'B4' - Phí tăng hạn mức
		select 'B4' as tieu_de, SUBSTRING(analysis_code, 9, 1),sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code in (719000030002)  
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'B5' - Phí thanh toán chậm, thu từ ngoại bảng
		select 'B5' as tieu_de, SUBSTRING(analysis_code, 9, 1),sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code in (719000030003,719000030103,790000030003,790000030103,790000030004,790000030104) 
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union
		-- Truy vấn cho loại 'C1' - CP vốn CCTG
		select 'C1' as tieu_de, SUBSTRING(analysis_code, 9, 1),sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code in (803000000001)  
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'C2' - CP vốn TT1
		select 'C2' as tieu_de, SUBSTRING(analysis_code, 9, 1),sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code in (802000000002,802000000003,802014000001,802037000001) 
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'C3' - CP vốn TT2
		select 'C3' as tieu_de,SUBSTRING(analysis_code, 9, 1), sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code in (801000000001,802000000001) 
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union
		-- Truy vấn cho loại 'D1'- CP hoa hồng
		select 'D1' as tieu_de, SUBSTRING(analysis_code, 9, 1),sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code in (816000000001,816000000002,816000000003)  
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'D2' - CP thuần KD khác
		select 'D2' as tieu_de, SUBSTRING(analysis_code, 9, 1),sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code in (809000000002,809000000001,811000000001,811000000102,811000000002,811014000001,811037000001,811039000001,
		811041000001,815000000001,819000000002,819000000003,819000000001,790000000003,790000050101,790000000101,790037000001,849000000001,
		899000000003,899000000002,811000000101,819000060001) 
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date)  <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'D3' - DT kinh doanh
		select 'D3' as tieu_de, SUBSTRING(analysis_code, 9, 1),sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code in (702000010001,702000010002,704000000001,705000000001,709000000001,714000000002,714000000003,714037000001,
		714000000004,714014000001,715000000001,715037000001,719000000001,709000000101,719000000101) 
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'F1'- CP thuế, phí
		select 'F1' as tieu_de, SUBSTRING(analysis_code, 9, 1),sum(amount),kpi_montha  from fact_txn_month_raw_data x
		where account_code in (831000000001,831000000002,832000000101,832000000001,831000000102) 
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'F2'- CP nhân viên
		select 'F2' as tieu_de, SUBSTRING(analysis_code, 9, 1),sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code::varchar like '85%' 
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'F3'- CP quản lý
		select 'F3' as tieu_de,SUBSTRING(analysis_code, 9, 1), sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code::varchar like '86%' 
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'F4'- CP tài sản
		select 'F4' as tieu_de,SUBSTRING(analysis_code, 9, 1), sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code::varchar like '87%'  
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1)
		union 
		-- Truy vấn cho loại 'G'- Chi phí dự phòng
		select 'G' as tieu_de,SUBSTRING(analysis_code, 9, 1), sum(amount),kpi_montha from fact_txn_month_raw_data x
		where account_code in (790000050001, 882200050001, 790000030001, 882200030001, 790000000001, 790000020101, 882200000001, 882200050101, 882200020101, 
		882200060001,790000050101,882200030101)  
		and EXTRACT(YEAR FROM transaction_date) * 100 + EXTRACT(MONTH FROM transaction_date) <= kpi_montha
		group by SUBSTRING(analysis_code, 9, 1);
	
	--Tính dư nợ bình quân toàn hàng
	delete from dnbq_toan_hang where monthkey = kpi_montha ;
    insert into dnbq_toan_hang (kpi_month, bucket , write_off_month, os_amt_toan_hang, wobs, monthkey)
		select kpi_month, coalesce(max_bucket,1) as bucket,write_off_month, sum(outstanding_principal ) as os_amt_toan_hang , sum(write_off_balance_principal) as wob_os,kpi_montha
		from fact_kpi_month_raw_data fkmrd where kpi_month <= kpi_montha 
		group by  max_bucket, kpi_month ,write_off_month ;
			
	-- Tính dư nợ bình quân theo khu vực
	delete from dnbq_khu_vuc where monthkey = kpi_montha ;
    insert into dnbq_khu_vuc  ( kpi_month,id_kv, bucket,write_off_month, os_amt_khu_vuc, wob_kv, monthkey)
		select a.kpi_month, mkv.id_khu_vuc, coalesce(max_bucket,1) as bucket,write_off_month,sum(a.outstanding_principal) as os_amt_khu_vuc , sum(a.write_off_balance_principal) as wob_kv,kpi_montha
		from fact_kpi_month_raw_data a
		join ma_khu_vuc mkv  on a.pos_city = mkv.tinh where a.kpi_month <= kpi_montha
		group by a.kpi_month, mkv.id_khu_vuc, a.max_bucket, a.write_off_month ;
		
	-- Tính phân bổ của header 
	delete from  pbo_head where monthkey = kpi_montha;
	insert into pbo_head (id, ma_kv, head_da_pb, monthkey)
		select a.id_report , kv_nhom1.id_kv , round((a.tmp_value * (avg(kv_nhom1.os_amt_khu_vuc)/ avg(os_nhom1.os_amt_toan_hang)))::numeric,2),kpi_montha
		from tmp_code_vale a join dnbq_toan_hang os_nhom1 on os_nhom1.bucket = 1 and os_nhom1.monthkey = kpi_montha join dnbq_khu_vuc kv_nhom1 on kv_nhom1.bucket = 1 and kv_nhom1.monthkey = kpi_montha
		where a.ma_kv like  '%0%' and a.id_report = 'B2' group by a.id_report , kv_nhom1.id_kv, a.tmp_value 
		union 
		select a.id_report , kv_nhom2.id_kv, round((a.tmp_value *(avg(kv_nhom2.os_amt_khu_vuc)/ avg(os_nhom2.os_amt_toan_hang)))::numeric ,2),kpi_montha
		from tmp_code_vale a join dnbq_toan_hang os_nhom2 on os_nhom2.bucket = 2 and os_nhom2.monthkey = kpi_montha join dnbq_khu_vuc kv_nhom2 on kv_nhom2.bucket = 2 and kv_nhom2.monthkey = kpi_montha 
		where a.ma_kv like  '%0%' and a.id_report = 'B1' group by a.id_report, kv_nhom2.id_kv, a.tmp_value 
		union 
		SELECT a.id_report, x.id_khu_vuc, round((a.tmp_value * (COUNT(y.psdn)::float / (SELECT COUNT(psdn) FROM fact_kpi_month_raw_data)::float))::numeric,2), kpi_montha 
		FROM tmp_code_vale a
		LEFT JOIN ma_khu_vuc x ON 1=1
		LEFT JOIN fact_kpi_month_raw_data y ON x.tinh = y.pos_city 
		WHERE a.ma_kv LIKE '%0%' AND a.id_report = 'B3' GROUP BY a.id_report, x.id_khu_vuc, a.tmp_value
		union 
		select a.id_report , kv_nhom1.id_kv , round((a.tmp_value *(sum(kv_nhom1.os_amt_khu_vuc)/ sum(os_nhom1.os_amt_toan_hang)))::numeric ,2),kpi_montha
		from tmp_code_vale a join dnbq_toan_hang os_nhom1 on os_nhom1.bucket = 1 and os_nhom1.monthkey = kpi_montha join dnbq_khu_vuc kv_nhom1 on kv_nhom1.bucket = 1 and kv_nhom1.monthkey = kpi_montha
		where a.ma_kv like '%0%' and a.id_report = 'B4' group by a.id_report , kv_nhom1.id_kv, a.tmp_value 
		union 
		SELECT a.id_report, dkv.id_kv , round((a.tmp_value * (COALESCE(sum(dkv.os_amt_khu_vuc)::numeric, 0)/COALESCE(dth.tong_os::numeric, 1)))::numeric,2), kpi_montha 
		FROM tmp_code_vale a 
		cross join (select sum(os_amt_toan_hang) as tong_os from dnbq_toan_hang where bucket in (2,3,4,5) and monthkey = kpi_montha) dth  
		left join dnbq_khu_vuc dkv on dkv.bucket in (2,3,4,5) and dkv.monthkey = kpi_montha 
		WHERE a.ma_kv LIKE '%0%' AND a.id_report = 'B5' 
		GROUP BY a.id_report, dkv.id_kv, a.tmp_value,dth.tong_os
		union 
		select a.id_report , n.id_kv , round((a.tmp_value *(sum(n.dnbq_kv) /m.tb_dn_toan_hang))::numeric,2),kpi_montha from tmp_code_vale a 
		cross join (select sum(os_amt_toan_hang) as tb_dn_toan_hang from dnbq_toan_hang where monthkey = kpi_montha) m
		cross join (select id_kv , sum(os_amt_khu_vuc) as dnbq_kv from dnbq_khu_vuc where monthkey = kpi_montha group by id_kv) n
		where a.ma_kv like  '%0%' and a.id_report = 'C1' group by a.id_report, n.id_kv ,a.tmp_value,m.tb_dn_toan_hang 
		union 
		select a.id_report , n.id_kv , round((a.tmp_value *(sum(n.dnbq_kv) /m.tb_dn_toan_hang))::numeric,2),kpi_montha from tmp_code_vale a 
		cross join (select sum(os_amt_toan_hang) as tb_dn_toan_hang from dnbq_toan_hang where monthkey = kpi_montha) m
		cross join (select id_kv , sum(os_amt_khu_vuc) as dnbq_kv from dnbq_khu_vuc where monthkey = kpi_montha group by id_kv) n
		where a.ma_kv like  '%0%' and a.id_report = 'C2' group by a.id_report, n.id_kv ,a.tmp_value,m.tb_dn_toan_hang 
		union 
		select a.id_report , n.id_kv , round((a.tmp_value *(sum(n.dnbq_kv) /m.tb_dn_toan_hang))::numeric,2),kpi_montha from tmp_code_vale a 
		cross join (select sum(os_amt_toan_hang) as tb_dn_toan_hang from dnbq_toan_hang where monthkey = kpi_montha ) m
		cross join (select id_kv , sum(os_amt_khu_vuc) as dnbq_kv from dnbq_khu_vuc where monthkey = kpi_montha group by id_kv) n
		where a.ma_kv like  '%0%' and a.id_report = 'C3' group by a.id_report, n.id_kv ,a.tmp_value,m.tb_dn_toan_hang 
		union 
		select a.id_report , n.id_kv , round((a.tmp_value *(sum(n.dnbq_kv) /m.tb_dn_toan_hang))::numeric,2),kpi_montha from tmp_code_vale a 
		cross join (select sum(os_amt_toan_hang) as tb_dn_toan_hang from dnbq_toan_hang where monthkey = kpi_montha ) m
		cross join (select id_kv ,sum(os_amt_khu_vuc) as dnbq_kv from dnbq_khu_vuc where monthkey = kpi_montha group by id_kv) n
		where a.ma_kv like  '%0%' and a.id_report = 'D1' group by a.id_report, n.id_kv ,a.tmp_value,m.tb_dn_toan_hang 
		union 
		select a.id_report , n.id_kv , round((a.tmp_value *(sum(n.dnbq_kv) /m.tb_dn_toan_hang))::numeric,2),kpi_montha from tmp_code_vale a 
		cross join (select sum(os_amt_toan_hang) as tb_dn_toan_hang from dnbq_toan_hang where monthkey = kpi_montha) m
		cross join (select id_kv , sum(os_amt_khu_vuc) as dnbq_kv from dnbq_khu_vuc where monthkey = kpi_montha group by id_kv) n
		where a.ma_kv like  '%0%' and a.id_report = 'D2' group by a.id_report, n.id_kv ,a.tmp_value,m.tb_dn_toan_hang 
		union 
		select a.id_report , n.id_kv , round((a.tmp_value *(sum(n.dnbq_kv) /m.tb_dn_toan_hang))::numeric,2),kpi_montha from tmp_code_vale a 
		cross join (select sum(os_amt_toan_hang) as tb_dn_toan_hang from dnbq_toan_hang where monthkey = kpi_montha) m
		cross join (select id_kv , sum(os_amt_khu_vuc) as dnbq_kv from dnbq_khu_vuc where monthkey = kpi_montha group by id_kv) n
		where a.ma_kv like  '%0%' and a.id_report = 'D3' group by a.id_report, n.id_kv ,a.tmp_value,m.tb_dn_toan_hang 
		union 
		select a.id_report, mkv.id_khu_vuc , round((a.tmp_value * (b.sl/ nv.tongnv))::numeric,2), kpi_montha  from tmp_code_vale a
		cross join (select sum(sl) as tongnv from nhanvien where kpi_month = kpi_montha) nv
		left join  nhanvien b on b.kpi_month = kpi_montha
		left join ma_khu_vuc mkv on trim(b.area_name) = trim(mkv.ten_khu_vuc ) 
		where a.ma_kv like  '%0%' and a.id_report = 'F1' group by a.id_report, mkv.id_khu_vuc , a.tmp_value, b.sl , nv.tongnv 
		union 
		select a.id_report, mkv.id_khu_vuc , round((a.tmp_value * (b.sl/ nv.tongnv))::numeric,2),kpi_montha from tmp_code_vale a
		cross join (select sum(sl) as tongnv from nhanvien where kpi_month = kpi_montha ) nv
		left join  nhanvien b on b.kpi_month = kpi_montha
		left join (select distinct id_khu_vuc, ten_khu_vuc from ma_khu_vuc) mkv on trim(mkv.ten_khu_vuc) = trim(b.area_name)
		where a.ma_kv like  '%0%' and a.id_report = 'F2' group by a.id_report, mkv.id_khu_vuc , a.tmp_value, b.sl , nv.tongnv  
		union 
		select a.id_report, mkv.id_khu_vuc , round((a.tmp_value * (b.sl/ nv.tongnv))::numeric,2), kpi_montha from tmp_code_vale a
		cross join (select sum(sl) as tongnv from nhanvien where kpi_month = kpi_montha ) nv
		left join  nhanvien b on b.kpi_month = kpi_montha
		left join (select distinct id_khu_vuc, ten_khu_vuc from ma_khu_vuc) mkv on trim(mkv.ten_khu_vuc) = trim(b.area_name)
		where a.ma_kv like  '%0%' and a.id_report = 'F3' group by a.id_report, mkv.id_khu_vuc, a.tmp_value, b.sl , nv.tongnv 
		union 
		select a.id_report, mkv.id_khu_vuc , round((a.tmp_value * (b.sl/ nv.tongnv))::numeric,2),kpi_montha from tmp_code_vale a
		cross join (select sum(sl) as tongnv from nhanvien where kpi_month = kpi_montha ) nv
		left join  nhanvien b on b.kpi_month = kpi_montha 
		left join ma_khu_vuc mkv on trim(b.area_name) = trim(mkv.ten_khu_vuc) 
		where a.ma_kv like  '%0%' and a.id_report = 'F4' group by a.id_report, mkv.id_khu_vuc , a.tmp_value, b.sl , nv.tongnv 
		union 
		select a.id_report, d1.id_kv,round((a.tmp_value * (coalesce((d.tong_kv + sum(d1.cumulative_sum_kv)/2), 0)/coalesce((z.tong_wo + sum(z1.cumulative_sum_total)/2))))::numeric,2),kpi_montha
		from tmp_code_vale a
		cross join (select sum(os_amt_toan_hang) as tong_wo  from dnbq_toan_hang where monthkey <= kpi_montha and bucket in (2,3,4,5)) z
		cross join (select kpi_month, SUM(sum(wobs)) OVER (ORDER BY kpi_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sum_total
					from dnbq_toan_hang where kpi_month = write_off_month and monthkey = kpi_montha group by kpi_month order by kpi_month) z1
		left join (select id_kv, sum(os_amt_khu_vuc) as tong_kv from dnbq_khu_vuc where monthkey <= kpi_montha  and bucket in (2,3,4,5) group by id_kv) d ON a.id_report = 'G' 
		left join (select kpi_month, id_kv, sum(sum(wob_kv)) over (PARTITION BY id_kv ORDER BY kpi_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cumulative_sum_kv
					from dnbq_khu_vuc where kpi_month = write_off_month and monthkey = kpi_montha group by kpi_month,id_kv order by kpi_month, id_kv) d1 ON d.id_kv = d1.id_kv   
		where a.ma_kv like '%0%' and a.id_report = 'G' group by a.id_report, d1.id_kv , a.tmp_value,d.tong_kv ,z.tong_wo ;

	delete from report_code_nho where monthkey = kpi_montha ;
	insert into report_code_nho (id_report, id_kv, giatri, monthkey)
		select m.id_report , ph.ma_kv , ROUND((COALESCE(m.tmp_value, 0)/1000000 + COALESCE(ph.head_da_pb, 0)/1000000)::NUMERIC, 2), kpi_montha from tmp_code_vale  m
		join pbo_head ph on m.ma_kv = ph.ma_kv  and m.id_report = ph.id and m.monthkey = ph.monthkey group by m.id_report, ph.ma_kv, m.tmp_value, ph.head_da_pb 
		union 
		select id_report,ma_kv, round(tmp_value::numeric /1000000,2), kpi_montha from tmp_code_vale where ma_kv like '%0%' and monthkey = kpi_montha 
		union 
		select id, ma_kv, round(head_da_pb::numeric /1000000,2), monthkey from pbo_head where id in ('C1','C3') and monthkey = kpi_montha;

	-- truncate table report_tong_hop;
	delete from report_tong_hop where monthkey = kpi_montha;
	insert into report_tong_hop (code_report,danh_muc, code_khu_vuc, khu_vuc, amount, monthkey)
		select r.id_report,o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, r.giatri, kpi_montha  from report_code_nho r
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc 
		left join code_account o on o.report_id = r.id_report 
		where r.monthkey = kpi_montha 
		group by r.id_report,o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, r.giatri
		union
		select 'B', o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, round(SUM(r.giatri)::numeric,2), kpi_montha from report_code_nho r
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc
		left join code_account o on o.report_id = 'B'
		where r.id_report in ('B1','B2','B3','B4','B5') and r.monthkey = kpi_montha group by r.id_kv,a.ten_khu_vuc,o.ten_danh_muc
		union 
		select 'C', o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, round(SUM(r.giatri)::numeric,2),kpi_montha from report_code_nho r
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc
		left join code_account o on o.report_id = 'C'
		where r.id_report in ('C1','C2','C3') and r.monthkey = kpi_montha group by o.ten_danh_muc, r.id_kv,a.ten_khu_vuc		
		union 
		select 'D', o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, round(SUM(r.giatri)::numeric,2),kpi_montha from report_code_nho r
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc 
		left join code_account o on o.report_id = 'D'
		where r.id_report in ('D1','D2','D3') and r.monthkey = kpi_montha group by o.ten_danh_muc, r.id_kv,a.ten_khu_vuc
		union 
		select 'F', o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, round(SUM(r.giatri)::numeric,2),kpi_montha from report_code_nho r
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc
		left join code_account o on o.report_id = 'F'
		where r.id_report in ('F1','F2','F3','F4') and r.monthkey = kpi_montha group by o.ten_danh_muc, r.id_kv,a.ten_khu_vuc
		union 
		select 'E', o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, round(SUM(r.giatri)::numeric,2),kpi_montha from report_code_nho r
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc
		left join code_account o on o.report_id = 'E'
		where r.id_report in ('B1','B2','B3','B4','B5','C1','C2','C3','D1','D2','D3') and r.monthkey = kpi_montha 
		group by o.ten_danh_muc, r.id_kv,a.ten_khu_vuc
		union 
		select 'A', o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, round(SUM(r.giatri)::numeric,2),kpi_montha from report_code_nho r
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc
		left join code_account o on o.report_id = 'A'
		where r.id_report IN ('B1','B2','B3','B4','B5','C1','C2','C3','D1','D2','D3','F1','F2','F3','F4','G') and r.monthkey = kpi_montha 
		group by o.ten_danh_muc, r.id_kv,a.ten_khu_vuc	
		union 
		select 'H', o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, round(SUM(r.giatri)::numeric,2),kpi_montha from report_code_nho r
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc
		left join code_account o on o.report_id = 'H'
		where r.id_report in ('B1','B2','B3','B4','B5','D3') and  r.monthkey = kpi_montha 
		group by o.ten_danh_muc, r.id_kv,a.ten_khu_vuc
		union 
		select 'J',o.ten_danh_muc, mkv.id_khu_vuc, mkv.ten_khu_vuc, n.sl, kpi_montha from nhanvien n
		join ma_khu_vuc mkv on trim(n.area_name) = trim(mkv.ten_khu_vuc)
		left join code_account o on o.report_id = 'J' 
		where n.kpi_month = kpi_montha 
		group by o.ten_danh_muc,mkv.ten_khu_vuc, mkv.id_khu_vuc, n.sl	
		union all
		select 'J',o.ten_danh_muc,'0',a.ten_khu_vuc, sum(sl),kpi_montha from nhanvien n2
		left join ma_khu_vuc a on a.id_khu_vuc = '0'
		left join code_account o on o.report_id = 'J' 
		where n2.kpi_month = kpi_montha 
		group by o.ten_danh_muc,a.ten_khu_vuc
		union
		select 'F/E', o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, round((SUM(r.giatri)/bang_e.e_giatri)::numeric * 100,2),kpi_montha from report_code_nho r
		left  join (select id_kv, SUM(giatri) as e_giatri from report_code_nho where id_report in ('B1','B2','B3','B4','B5','C1','C2','C3','D1','D2','D3') group by id_kv ) bang_e on r.id_kv = bang_e.id_kv 
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc
		left join code_account o on o.report_id = 'F/E'
		where r.id_report IN ('F1','F2','F3','F4') and r.monthkey = kpi_montha group by o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, bang_e.e_giatri 
		union 
		select 'A/H', o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, round((SUM(r.giatri)/bang_h.h_giatri)::numeric * 100,2),kpi_montha  from report_code_nho r
		left join (select id_kv, SUM(giatri) as h_giatri from report_code_nho where id_report in ('B1','B2','B3','B4','B5','D3') group by id_kv ) as bang_h on r.id_kv = bang_h.id_kv 
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc 
		left join code_account o on o.report_id = 'A/H'
		where r.id_report in ('B1','B2','B3','B4','B5','C1','C2','C3','D1','D2','D3','F1','F2','F3','F4','G') and r.monthkey = kpi_montha
		group by o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, bang_h.h_giatri 	
		union 
		select 'A/C', o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, round((SUM(r.giatri)/bang_c.c_giatri)::numeric *100,2),kpi_montha from report_code_nho r
		left join (select id_kv, SUM(giatri) as c_giatri from report_code_nho where id_report in ('C1','C2','C3') group by id_kv ) as bang_c on r.id_kv = bang_c.id_kv 
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc
		left join code_account o on o.report_id = 'A/C'
		where r.id_report in ('B1','B2','B3','B4','B5','C1','C2','C3','D1','D2','D3','F1','F2','F3','F4','G') and r.monthkey = kpi_montha
		group by o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, bang_c.c_giatri		
		union 
		select 'A/J', o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, round((SUM(r.giatri)/bang_j.j_giatri)::numeric,2), kpi_montha from report_code_nho r
		left join (select mkv.id_khu_vuc, n.sl as j_giatri from nhanvien n
		join ma_khu_vuc mkv on trim(n.area_name) = trim(mkv.ten_khu_vuc) group by mkv.id_khu_vuc, n.sl ) as bang_j on r.id_kv = bang_j.id_khu_vuc 
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc
		left join code_account o on o.report_id = 'A/J'
		where r.id_report in ('B1','B2','B3','B4','B5','C1','C2','C3','D1','D2','D3','F1','F2','F3','F4','G') and r.monthkey = kpi_montha
		group by o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, bang_j.j_giatri
		union 
		select 'A/J',o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, round((sum(r.giatri)/n3.tongnv)::numeric,2), kpi_montha from report_code_nho r 
		cross join (select sum(sl) as tongnv from nhanvien ) as n3
		left join (SELECT DISTINCT id_khu_vuc, ten_khu_vuc FROM ma_khu_vuc) a ON r.id_kv = a.id_khu_vuc
		left join code_account o on o.report_id = 'A/J'
		where r.id_kv like '%0%' and r.id_report in ('B1','B2','B3','B4','B5','C1','C2','C3','D1','D2','D3','F1','F2','F3','F4','G') and r.monthkey = kpi_montha
		group by o.ten_danh_muc, r.id_kv,a.ten_khu_vuc, n3.tongnv;
		
END;
$$;

-- Gọi stored procedure
CALL report_tonghop (202305);

select * from report_code_nho rcn 
select * from tmp_code_vale tcv 