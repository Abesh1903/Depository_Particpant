-- *** SqlDbx Personal Edition ***
-- !!! Not licensed for commercial use beyound 90 days evaluation period !!!
-- For version limitations please check http://www.sqldbx.com/personal_edition.htm
-- Number of queries executed: 1056, number of rows retrieved: 2916

CREATE OR REPLACE PACKAGE BODY PROJ_DB.PKG_MAST_DP
AS
	
	
	PROCEDURE bind_dropdown_depo_proc
	(
		dt_records		OUT		RECORD
	)
	AS
	BEGIN
		OPEN dt_records FOR
			SELECT md_depo_id, md_depo_code FROM MAST_DEPO WHERE md_depo_group = 2 AND md_active_flag = 1 ORDER BY md_depo_code desc;
	END;
	
	
	/* PROCEDURE FOR READING RECORDS IN REF CURSOR */
	
	PROCEDURE read_proc
	(
		p_dp_id	    		IN		VARCHAR2,
		search_dp_name		IN		VARCHAR2,
		dt_records			OUT		RECORD
	)
	AS
	Count_val NUMBER;
	BEGIN
	
		IF (p_dp_id IS NOT NULL OR p_dp_id <> '')
		THEN
			OPEN dt_records FOR
				SELECT MDP.dp_dp_id, MDP.dp_depo_id, MDP.dp_dp_name, MDP.dp_dp_addr1, MDP.dp_dp_addr2, MDP.dp_dp_addr3, MDP.dp_dp_addr4, MDP.dp_dp_city, MDP.dp_dp_state, 
				MDP.dp_dp_pincode, MDP.dp_dp_tele_no, MDP.dp_dp_fax_no, MDP.dp_active_flag, 
				CASE when MDP.dp_active_flag=1 THEN 'Active' ELSE 'Inactive' END AS active_status,
				MD.md_depo_code	depo_desc 		 
				FROM MAST_DP MDP
				INNER JOIN MAST_DEPO MD
				ON MDP.dp_depo_id = MD.md_depo_id				
				WHERE dp_dp_id = p_dp_id 
				ORDER BY dp_dp_name;
	
		ELSIF (search_dp_name IS NOT NULL OR search_dp_name <> '')
		THEN
			OPEN dt_records FOR
				SELECT MDP.dp_dp_id, MDP.dp_depo_id, MDP.dp_dp_name, MDP.dp_dp_addr1, MDP.dp_dp_addr2, MDP.dp_dp_addr3, MDP.dp_dp_addr4, MDP.dp_dp_city, MDP.dp_dp_state, 
				MDP.dp_dp_pincode, MDP.dp_dp_tele_no, MDP.dp_dp_fax_no, MDP.dp_active_flag, 
				CASE when MDP.dp_active_flag=1 THEN 'Active' ELSE 'Inactive' END AS active_status,
				MD.md_depo_code	depo_desc 		 
				FROM MAST_DP MDP
				INNER JOIN MAST_DEPO MD
				ON MDP.dp_depo_id = MD.md_depo_id
				WHERE UPPER(dp_dp_name) LIKE UPPER('%'||search_dp_name||'%') 
				ORDER BY dp_dp_name;
		ELSE
			OPEN dt_records FOR
				SELECT MDP.dp_dp_id, MDP.dp_depo_id, MDP.dp_dp_name, MDP.dp_dp_addr1, MDP.dp_dp_addr2, MDP.dp_dp_addr3, MDP.dp_dp_addr4, MDP.dp_dp_city, MDP.dp_dp_state, 
				MDP.dp_dp_pincode, MDP.dp_dp_tele_no, MDP.dp_dp_fax_no, MDP.dp_active_flag, 
				CASE when MDP.dp_active_flag=1 THEN 'Active' ELSE 'Inactive' END AS active_status,
				MD.md_depo_code	depo_desc 		 
				FROM MAST_DP MDP
				INNER JOIN MAST_DEPO MD
				ON MDP.dp_depo_id = MD.md_depo_id				
				ORDER BY dp_dp_name;
		END IF;		
	END;
	
	
	/* PROCEDURE FOR DELETING RECORD */
	
	PROCEDURE delete_proc
   	(
		p_dp_id		IN		VARCHAR2,
		p_retCode	OUT		NUMBER,
		p_retMsg	OUT		VARCHAR2
	)
	AS
	BEGIN
		-- Population in History Table
		INSERT INTO MAST_DP_HIST 
		(
			dp_dp_id,
			dp_depo_id,
			dp_dp_name,
			dp_dp_addr1,
			dp_dp_addr2,
			dp_dp_addr3,
			dp_dp_addr4,
			dp_dp_city,
			dp_dp_state,
			dp_dp_pincode,
			dp_dp_tele_no,
			dp_dp_fax_no,
			dp_active_flag,
			dp_crea_by,
			dp_crea_date,
			dp_modi_by,
			dp_modi_date,
			dp_oper_flag,
			dp_hist_date
		) 
		SELECT 
		dp_dp_id,
		dp_depo_id,
		dp_dp_name,
		dp_dp_addr1,
		dp_dp_addr2,
		dp_dp_addr3,
		dp_dp_addr4,
		dp_dp_city,
		dp_dp_state,
		dp_dp_pincode,
		dp_dp_tele_no,
		dp_dp_fax_no,
		dp_active_flag,
		dp_crea_by,
		dp_crea_date,
		dp_modi_by,
		dp_modi_date,
		3,
	    SYSDATE
	    FROM MAST_DP WHERE dp_dp_id = p_dp_id;
			
		IF SQLCODE <> 0
		THEN
			p_retCode := 0;
			p_retMsg := 'Oracle Error Code (History Table) : ' + to_char(SQLCODE) ;
			ROLLBACK;
			RETURN;
		END IF;
				
		DELETE FROM MAST_DP WHERE dp_dp_id = p_dp_id;
		
		IF SQLCODE <> 0
			THEN
				p_retCode := 0;
				p_retMsg := 'Oracle Error Code (Base Table) : ' + to_char(SQLCODE) ;
				ROLLBACK;
				RETURN;
		END IF;
		
		COMMIT;
		
		p_retCode := 1;
		p_retMsg := 'Data Deleted Successfully';
	END;
	
	
	
	/* PROCEDURE FOR INSERTING RECORD */
		
	PROCEDURE insert_proc
	(
		p_dp_id				IN		VARCHAR2,
		p_depo_id			IN		NUMBER,
		p_dp_name			IN		VARCHAR2,
		p_dp_addr1	  		IN		VARCHAR2,
		p_dp_addr2	  		IN		VARCHAR2,
		p_dp_addr3	  		IN		VARCHAR2,
		p_dp_addr4	  		IN		VARCHAR2,
		p_dp_city	   		IN		VARCHAR2,
		p_dp_state	   		IN		VARCHAR2,
		p_dp_pincode   		IN		VARCHAR2,
		p_dp_tele_no		IN		VARCHAR2,
		p_dp_fax_no			IN		VARCHAR2,
		p_active_flag		IN		NUMBER,
		p_retCode			OUT		NUMBER,
		p_retMsg			OUT		VARCHAR2
	)
	AS
	Count_DuplRec NUMBER;
	count_val NUMBER;
	target_dp_id VARCHAR2(10);
		
	BEGIN
		p_retCode := 0;
		p_retMsg := '';	
		
		/*
		IF NOT(p_depo_id = 2 OR p_depo_id = 3)
		THEN
			p_retCode := 2;
			p_retMsg := 'Depository must be either "NSDL" OR "CDSL"!';
			RETURN;
		END IF;
		*/
		
		SELECT count(*) INTO count_val FROM MAST_DEPO WHERE md_depo_id = p_depo_id AND md_depo_group = 2 AND md_active_flag = 1;
		
		IF count_val <> 1
		THEN
			p_retCode := 2;
			p_retMsg := 'Depository has not been defined!';
			RETURN;
		END IF;
		
		IF length(REPLACE(p_dp_id, ' ')) <> 8
		THEN
			p_retCode := 2;
			p_retMsg := 'The length of DP Id should be 8. Leading, trailing and in-between spaces are not allowed!';
			RETURN;
		END IF;
		
		SELECT upper(REPLACE(p_dp_id, ' ')) INTO target_dp_id FROM DUAL;
		
		SELECT count(*) INTO Count_DuplRec FROM MAST_DP WHERE upper(REPLACE(dp_dp_id, ' ')) = target_dp_id;
		
		IF (Count_DuplRec > 0)	
		THEN
			p_retCode := 2;
			p_retMsg := 'Duplicate DP Id exists!';
			RETURN;
		END	IF;
		
		SELECT count(*) INTO Count_DuplRec FROM MAST_DP WHERE upper(trim(dp_dp_name)) = upper(trim(p_dp_name));
		
		IF (Count_DuplRec > 0)	
		THEN
			p_retCode := 2;
			p_retMsg := 'Duplicate DP Name exists!';
			RETURN;
		END	IF;
		
		
		IF p_dp_addr2 = '' OR p_dp_addr2 IS NULL
	    THEN
			p_retCode := 2;
			p_retMsg := 'Please fill Depository Address 2 field';
			RETURN;
		END IF;	
			
		IF p_dp_city = '' OR p_dp_city IS NULL
		THEN
			p_retCode := 2;
			p_retMsg := 'Please provide a City name';
			RETURN;
		END IF;	 
				
		IF p_dp_state = '' OR p_dp_state IS NULL
		THEN
			p_retCode := 2;
			p_retMsg := 'Please provide a State name';
			RETURN;
		END IF;	
			
		IF ((p_dp_pincode <> '' OR p_dp_pincode IS NOT NULL) AND NOT REGEXP_LIKE(p_dp_pincode, '^[[:digit:]]+$'))
	    THEN	
	    	p_retCode := 2;
			p_retMsg := 'Please provide a valid Pin Code (Pin Code must be numeric)';
			RETURN;
		END IF;
		
		IF p_dp_tele_no = '' OR p_dp_tele_no IS NULL
		THEN
			p_retCode := 2;
			p_retMsg := 'Please provide a Telephone No.';
			RETURN;
		END IF;
			
		IF (NOT REGEXP_LIKE(p_dp_tele_no, '^[[:digit:]]+$'))
	    THEN	
	    	p_retCode := 2;
			p_retMsg := 'Please provide a valid Telephone No. (Telephone No. must be numeric)';
			RETURN;
		END IF;
			
		/*
		IF ((p_dp_fax_no <> '' OR p_dp_fax_no IS NOT NULL) AND NOT REGEXP_LIKE(p_dp_fax_no, '^[[:digit:]]+$'))
	    THEN	
	    	p_retCode := 2;
			p_retMsg := 'Please provide a valid Fax No. (Fax No. must be numeric)';
			RETURN;
		END IF;
		*/
			
		IF (p_active_flag = 0)
		THEN	
			p_retCode := 2;
			p_retMsg := 'New DP must be in "Active" Status';
			RETURN;
	    END IF;
	    
	        
	    INSERT INTO MAST_DP 
			(
				dp_dp_id,
				dp_depo_id,
				dp_dp_name,
				dp_dp_addr1,
				dp_dp_addr2,
				dp_dp_addr3,
				dp_dp_addr4,
				dp_dp_city,
				dp_dp_state,
				dp_dp_pincode,
				dp_dp_tele_no,
				dp_dp_fax_no,
				dp_active_flag,
				dp_crea_by,
				dp_crea_date,
				dp_modi_by,
				dp_modi_date
			) 
			VALUES
			(
				target_dp_id,
				p_depo_id,
				trim(upper(p_dp_name)),
				trim(p_dp_addr1),
				trim(p_dp_addr2),
				trim(p_dp_addr3),
				trim(p_dp_addr4),
				trim(upper(p_dp_city)),
				trim(upper(p_dp_state)),
				p_dp_pincode,
				p_dp_tele_no,
				trim(p_dp_fax_no),
				p_active_flag,
				-1,
				SYSDATE,
				NULL,
				NULL
			);
			
			IF SQLCODE <> 0
			THEN
				p_retCode := 0;
				p_retMsg := 'Oracle Error Code (Base Table) : ' + to_char(SQLCODE) ;
				ROLLBACK;
				RETURN;
			END IF;
			
			-- Population in History Table
			INSERT INTO MAST_DP_HIST 
			(
				dp_dp_id,
				dp_depo_id,
				dp_dp_name,
				dp_dp_addr1,
				dp_dp_addr2,
				dp_dp_addr3,
				dp_dp_addr4,
				dp_dp_city,
				dp_dp_state,
				dp_dp_pincode,
				dp_dp_tele_no,
				dp_dp_fax_no,
				dp_active_flag,
				dp_crea_by,
				dp_crea_date,
				dp_modi_by,
				dp_modi_date,
				dp_oper_flag,
				dp_hist_date
			) 
			VALUES
			(
				target_dp_id,
				p_depo_id,
				trim(upper(p_dp_name)),
				trim(p_dp_addr1),
				trim(p_dp_addr2),
				trim(p_dp_addr3),
				trim(p_dp_addr4),
				trim(upper(p_dp_city)),
				trim(upper(p_dp_state)),
				p_dp_pincode,
				p_dp_tele_no,
				trim(p_dp_fax_no),
				p_active_flag,
				-1,
				SYSDATE,
				NULL,
				NULL,
				1,
				SYSDATE
			);
			
			IF SQLCODE <> 0
			THEN
				p_retCode := 0;
				p_retMsg := 'Oracle Error Code (History Table) : ' + to_char(SQLCODE) ;
				ROLLBACK;
				RETURN;
			END IF;
			
			COMMIT;
			
			p_retCode := 1;
			p_retMsg := 'Data Successfully Saved';
		
	END;
	
	
	
	/* PROCEDURE FOR UPDATING RECORD */
	
	PROCEDURE update_proc
	(
		p_dp_id				IN		VARCHAR2,
		p_org_dp_id			IN		VARCHAR2,
		p_depo_id			IN		NUMBER,
		p_dp_name			IN		VARCHAR2,
		p_dp_addr1	  		IN		VARCHAR2,
		p_dp_addr2	  		IN		VARCHAR2,
		p_dp_addr3	  		IN		VARCHAR2,
		p_dp_addr4	  		IN		VARCHAR2,
		p_dp_city	   		IN		VARCHAR2,
		p_dp_state	   		IN		VARCHAR2,
		p_dp_pincode   		IN		VARCHAR2,
		p_dp_tele_no		IN		VARCHAR2,
		p_dp_fax_no			IN		VARCHAR2,
		p_active_flag		IN		NUMBER,
		p_retCode			OUT		NUMBER,
		p_retMsg			OUT		VARCHAR2
	)
	AS
	Count_DuplRec NUMBER;
	count_val NUMBER;
	target_dp_id VARCHAR2(10);
	
	BEGIN
		p_retCode := 0;
		p_retMsg := '';	
			
		/*
		IF NOT(p_depo_id = 2 OR p_depo_id = 3)
		THEN
			p_retCode := 2;
			p_retMsg := 'Depository must be either "NSDL" OR "CDSL"!';
			RETURN;
		END IF;
		*/
		
		SELECT count(*) INTO count_val FROM MAST_DEPO WHERE md_depo_id = p_depo_id AND md_depo_group = 2 AND md_active_flag = 1;
		
		IF count_val <> 1
		THEN
			p_retCode := 2;
			p_retMsg := 'Depository has not been defined!';
			RETURN;
		END IF;
		
		IF length(REPLACE(p_dp_id, ' ')) <> 8
		THEN
			p_retCode := 2;
			p_retMsg := 'The length of DP Id should be 8. Leading, trailing and in-between spaces are not allowed!';
			RETURN;
		END IF;
		
		SELECT upper(REPLACE(p_dp_id, ' ')) INTO target_dp_id FROM DUAL;
		
		SELECT count(*) INTO Count_DuplRec FROM MAST_DP 
		WHERE dp_dp_id <> p_dp_id AND upper(REPLACE(dp_dp_id, ' ')) = target_dp_id;
		
		IF (Count_DuplRec > 0)	
		THEN
			p_retCode := 2;
			p_retMsg := 'Duplicate DP Id exists!';
			RETURN;
		END	IF;
		
		SELECT count(*) INTO Count_DuplRec FROM MAST_DP 
		WHERE dp_dp_id <> p_dp_id AND upper(trim(dp_dp_name)) = upper(trim(p_dp_name));
		
		IF (Count_DuplRec > 0)	
		THEN
			p_retCode := 2;
			p_retMsg := 'Duplicate DP Name exists!';
			RETURN;
		END	IF;
		
		IF p_dp_addr2 = '' OR p_dp_addr2 IS NULL
	    THEN
			p_retCode := 2;
			p_retMsg := 'Please fill Depository Address 2 field';
			RETURN;
		END IF;	
			
		IF p_dp_city = '' OR p_dp_city IS NULL
		THEN
			p_retCode := 2;
			p_retMsg := 'Please provide a City name';
			RETURN;
		END IF;	 
				
		IF p_dp_state = '' OR p_dp_state IS NULL
		THEN
			p_retCode := 2;
			p_retMsg := 'Please provide a State name';
			RETURN;
		END IF;	
			
		IF ((p_dp_pincode <> '' OR p_dp_pincode IS NOT NULL) AND NOT REGEXP_LIKE(p_dp_pincode, '^[[:digit:]]+$'))
	    THEN	
	    	p_retCode := 2;
			p_retMsg := 'Please provide a valid Pin Code (Pin Code must be numeric)';
			RETURN;
		END IF;
		
		IF p_dp_tele_no = '' OR p_dp_tele_no IS NULL
		THEN
			p_retCode := 2;
			p_retMsg := 'Please provide a Telephone No.';
			RETURN;
		END IF;
			
		IF (NOT REGEXP_LIKE(p_dp_tele_no, '^[[:digit:]]+$'))
	    THEN	
	    	p_retCode := 2;
			p_retMsg := 'Please provide a valid Telephone No. (Telephone No. must be numeric)';
			RETURN;
		END IF;
			
		/*
		IF ((p_dp_fax_no <> '' OR p_dp_fax_no IS NOT NULL) AND NOT REGEXP_LIKE(p_dp_fax_no, '^[[:digit:]]+$'))
	    THEN	
	    	p_retCode := 2;
			p_retMsg := 'Please provide a valid Fax No. (Fax No. must be numeric)';
			RETURN;
		END IF;
		*/
		
		
		UPDATE MAST_DP 
		SET	dp_dp_id = target_dp_id,
			dp_depo_id = p_depo_id,
			dp_dp_name = trim(upper(p_dp_name)),
			dp_dp_addr1 = trim(p_dp_addr1),
			dp_dp_addr2 = trim(p_dp_addr2),
			dp_dp_addr3 = trim(p_dp_addr3),
			dp_dp_addr4 = trim(p_dp_addr4),
			dp_dp_city = trim(upper(p_dp_city)),
			dp_dp_state = trim(upper(p_dp_state)),
			dp_dp_pincode = p_dp_pincode,
			dp_dp_tele_no = p_dp_tele_no,
			dp_dp_fax_no = trim(p_dp_fax_no),
			dp_active_flag = p_active_flag,
			--dp_crea_by = dp_crea_by,
			--dp_crea_date = dp_crea_date,
			dp_modi_by = -1,
			dp_modi_date = SYSDATE
		WHERE dp_dp_id = p_dp_id; 
		
		IF SQLCODE <> 0
		THEN
			p_retCode := 0;
			p_retMsg := 'Oracle Error Code (Base Table) : ' + to_char(SQLCODE) ;
			ROLLBACK;
			RETURN;
		END IF;
		
		-- Population in History Table
		INSERT INTO MAST_DP_HIST 
		(
			dp_dp_id,
			dp_depo_id,
			dp_dp_name,
			dp_dp_addr1,
			dp_dp_addr2,
			dp_dp_addr3,
			dp_dp_addr4,
			dp_dp_city,
			dp_dp_state,
			dp_dp_pincode,
			dp_dp_tele_no,
			dp_dp_fax_no,
			dp_active_flag,
			dp_crea_by,
			dp_crea_date,
			dp_modi_by,
			dp_modi_date,
			dp_oper_flag,
			dp_hist_date
		) 
		VALUES
		(
			target_dp_id,
			p_depo_id,
			trim(upper(p_dp_name)),
			trim(p_dp_addr1),
			trim(p_dp_addr2),
			trim(p_dp_addr3),
			trim(p_dp_addr4),
			trim(upper(p_dp_city)),
			trim(upper(p_dp_state)),
			p_dp_pincode,
			p_dp_tele_no,
			trim(p_dp_fax_no),
			p_active_flag,
			NULL,
			NULL,
			-1,
			SYSDATE,
			2	,
			SYSDATE
		);
		
		IF SQLCODE <> 0
		THEN
			p_retCode := 0;
			p_retMsg := 'Oracle Error Code (History Table) : ' + to_char(SQLCODE) ;
			ROLLBACK;
			RETURN;
		END IF;
		
		COMMIT;
		
		p_retCode := 1;
		p_retMsg := 'Data Updated Successfully!';
				
	END;
	
END PKG_MAST_DP;