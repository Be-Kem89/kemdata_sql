CREATE OR REPLACE PROCEDURE report_tonghop_asm (kpi_yeara int8, kpi_montha int8)
LANGUAGE plpgsql
AS $$
BEGIN
 
	delete from tmp_report_asm where monthkey = (kpi_yeara*100 + kpi_montha) ;
	insert into tmp_report_asm (id_khu_vuc, area_name, email, ltn_avg, psdn_avg, approval_rate_avg, ltn_rank, psdn_rank, approval_rate_rank, monthkey)				
	--tính tb và rank
		SELECT id_khu_vuc,
	    area_name, 
	    email,
	    ltn_avg,
	    psdn_avg,
	    approval_rate_avg,
	    RANK() OVER (ORDER BY ltn_avg DESC) AS ltn_rank,
	    RANK() OVER (ORDER BY psdn_avg DESC) AS psdn_rank,
	    RANK() OVER (ORDER BY approval_rate_avg DESC) AS approval_rate_rank, kpi_yeara*100 + kpi_montha 
	FROM (
	    SELECT mkv.id_khu_vuc,
	        kpi_asm_data.area_name, 
	        kpi_asm_data.email,
	        AVG(ltn) FILTER (WHERE month <= kpi_montha) AS ltn_avg,
	        AVG(psdn) FILTER (WHERE month <= kpi_montha) AS psdn_avg,
	        AVG(apr) FILTER (WHERE month <= kpi_montha) AS approval_rate_avg
	    FROM (
	        SELECT area_name, email, 1 AS month, jan_ltn AS ltn, jan_psdn AS psdn, jan_approval_rate AS apr FROM kpi_asm_data
	        UNION ALL
	        SELECT area_name, email, 2, feb_ltn, feb_psdn, feb_approval_rate FROM kpi_asm_data
	        UNION ALL
	        SELECT area_name, email, 3, mar_ltn, mar_psdn, mar_approval_rate FROM kpi_asm_data
	        UNION ALL
	        SELECT area_name, email, 4, apr_ltn, apr_psdn, apr_approval_rate FROM kpi_asm_data
	        UNION ALL
	        SELECT area_name, email, 5, may_ltn, may_psdn, may_approval_rate FROM kpi_asm_data
	        UNION ALL
	        SELECT area_name, email, 6, jun_ltn, jun_psdn, jun_approval_rate FROM kpi_asm_data
	        UNION ALL
	        SELECT area_name, email, 7, july_ltn, july_psdn, july_approval_rate FROM kpi_asm_data
	        UNION ALL
	        SELECT area_name, email, 8, aug_ltn, aug_psdn, aug_approval_rate FROM kpi_asm_data
	        UNION ALL
	        SELECT area_name, email, 9, sep_ltn, sep_psdn, sep_approval_rate FROM kpi_asm_data
	        UNION ALL
	        SELECT area_name, email, 10, oct_ltn, oct_psdn, oct_approval_rate FROM kpi_asm_data
	        UNION ALL
	        SELECT area_name, email, 11, nov_ltn, nov_psdn, nov_approval_rate FROM kpi_asm_data
	        UNION ALL
	        SELECT area_name, email, 12, dec_ltn, dec_psdn, dec_approval_rate FROM kpi_asm_data
	    ) AS monthly_data
	    JOIN kpi_asm_data ON monthly_data.area_name = kpi_asm_data.area_name AND monthly_data.email = kpi_asm_data.email
	    join ma_khu_vuc mkv on trim(mkv.ten_khu_vuc) = trim(monthly_data.area_name) 
	    GROUP by mkv.id_khu_vuc, kpi_asm_data.area_name, kpi_asm_data.email
	) AS aggregated_data
	WHERE ltn_avg IS NOT NULL AND psdn_avg IS NOT NULL AND approval_rate_avg IS NOT null;
	
	--Tinh NPL LUY KE truoc WO 
	delete from npl_luyke_truocwo where monthkey = (kpi_yeara*100 + kpi_montha) ;
	insert into npl_luyke_truocwo (id_kv, npl_luyke_trcwo, rank_npl, monthkey)
		select x.id_kv, 100* (sum(x.os_amt_khu_vuc) + z.wob_kv)/(z.wob_kv + y.total_sau_wo) as npl_truoc_luy_ke,
		RANK() OVER (ORDER BY 100 * (SUM(x.os_amt_khu_vuc) + z.wob_kv) / (z.wob_kv + y.total_sau_wo) DESC) AS rank_npl, kpi_yeara*100 + kpi_montha 
		from dnbq_khu_vuc x 
		join (select id_kv, sum(os_amt_khu_vuc) as total_sau_wo from dnbq_khu_vuc where kpi_month = (kpi_yeara*100+ kpi_montha) and  monthkey = (kpi_yeara*100 + kpi_montha) group by id_kv) y on x.id_kv = y.id_kv 
		join (select id_kv, sum(wob_kv) as wob_kv from dnbq_khu_vuc where kpi_month = write_off_month and kpi_month <= (kpi_yeara*100+ kpi_montha) and  monthkey = (kpi_yeara*100 + kpi_montha) group by id_kv ) z on z.id_kv = x.id_kv 
		where x.kpi_month = (kpi_yeara*100+ kpi_montha) and x.bucket in (3,4,5) and  monthkey = (kpi_yeara*100 + kpi_montha) group by x.id_kv, y.total_sau_wo,z.wob_kv ;
	
	--Đánh giá phòng kinh doanh
	delete from tmp_report_ptckd where monthkey = (kpi_yeara*100 + kpi_montha) ;
	insert into tmp_report_ptckd  (id_khu_vuc, area_name, email, ltn_avg, psdn_avg, approval_rate_avg, ltn_rank, psdn_rank, approval_rate_rank,
		npl_truoc_luy_ke, npl_rank, diem_quy_mo, monthkey)
		select a.id_khu_vuc, a.area_name, a.email, a.ltn_avg, psdn_avg, a.approval_rate_avg, a.ltn_rank, 
		a.psdn_rank, a.approval_rate_rank, nlt.npl_luyke_trcwo, rank () over (order by nlt.npl_luyke_trcwo asc) as npl_rank,
		a.ltn_rank + a.psdn_rank + a.approval_rate_rank + rank () over (order by nlt.npl_luyke_trcwo asc) as diem_quy_mo, a.monthkey 
		from tmp_report_asm a 
		left join npl_luyke_truocwo nlt on nlt.id_kv = a.id_khu_vuc and a.monthkey = nlt.monthkey 
		where a.monthkey = (kpi_yeara*100 + kpi_montha) ;

	--Đánh giá phòng FIN
	delete from tmp_report_fin where  monthkey = (kpi_yeara*100 + kpi_montha);
	insert into tmp_report_fin (id_khu_vuc, area_name, email, cir ,rank_cir, margin, rank_margin, hs_von, rank_hsvon, bqns, rank_bqns, diem_quy_mo1, monthkey)
		SELECT tra.id_khu_vuc, tra.area_name, tra.email, f1.amount AS cir,dense_rank() over (order by f1.amount desc) as rank_cir, 
		f2.amount AS margin, dense_rank() over (order by f2.amount desc) as rank_margin, f3.amount AS hs_von,dense_rank() over (order by f3.amount asc) as rank_hsvon,
		f4.bqns, dense_rank() over (order by f4.bqns desc) as rank_bqns, dense_rank() over (order by f1.amount desc) + 
		dense_rank() over (order by f2.amount desc) + dense_rank() over (order by f3.amount asc) + dense_rank() over (order by f4.bqns desc) as diem_quy_mo, tra.monthkey
		FROM tmp_report_asm tra
		JOIN (SELECT monthkey, code_khu_vuc, amount FROM report_tong_hop WHERE code_report = 'F/E') f1 ON tra.id_khu_vuc = f1.code_khu_vuc and tra.monthkey = f1.monthkey 
		JOIN (SELECT monthkey, code_khu_vuc, amount FROM report_tong_hop WHERE code_report = 'A/H') f2 ON tra.id_khu_vuc = f2.code_khu_vuc and tra.monthkey = f2.monthkey
		JOIN (SELECT monthkey, code_khu_vuc, amount FROM report_tong_hop WHERE code_report = 'A/C') f3 ON tra.id_khu_vuc = f3.code_khu_vuc and tra.monthkey = f3.monthkey
		JOIN (SELECT monthkey, code_khu_vuc, sum(amount) as bqns FROM report_tong_hop WHERE code_report = 'A/J' group by monthkey, code_khu_vuc) f4 ON tra.id_khu_vuc = f4.code_khu_vuc and tra.monthkey = f4.monthkey
		where tra.monthkey = (kpi_yeara*100 + kpi_montha);
	
	--Báo Cáo Xếp hạng ASM
	delete from report_asm where monthkey = (kpi_yeara*100 + kpi_montha) ;
	insert into report_asm (id_khu_vuc, area_name, email, ltn_avg,ltn_rank, psdn_avg,psdn_rank, approval_rate_avg,approval_rate_rank, npl_truoc_luy_ke, 
	npl_rank, diem_quy_mo,rank_ptckd,cir,rank_cir, margin, rank_margin, hs_von,rank_hsvon, bqns, rank_bqns, diem_fin,rank_fin, diem_total, rank_final,monthkey)
		select x.id_khu_vuc, x.area_name, x.email, x.ltn_avg,x.ltn_rank, x.psdn_avg,x.psdn_rank, x.approval_rate_avg, x.approval_rate_rank,
			x.npl_truoc_luy_ke, x.npl_rank, x.diem_quy_mo, rank() over (order by x.diem_quy_mo asc) as rank_ptckd, y.cir, y.rank_cir, y.margin, y.rank_margin,
			y.hs_von, y.rank_hsvon, y.bqns, y.rank_bqns, y.diem_quy_mo1, rank() over (order by y.diem_quy_mo1 asc) as rank_fin,
			x.diem_quy_mo + y.diem_quy_mo1 as diem_total, rank() over (order by x.diem_quy_mo + y.diem_quy_mo1 asc) as rank_final, x.monthkey
		from tmp_report_ptckd x
		join tmp_report_fin y on x.id_khu_vuc = y.id_khu_vuc and x.email = y.email and x.monthkey = y.monthkey
		where x.monthkey = (kpi_yeara*100 + kpi_montha);
	
END;
$$;

call report_tonghop_asm (2023,01);

select * from report_asm

