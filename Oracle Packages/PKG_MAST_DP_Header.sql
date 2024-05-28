CREATE OR REPLACE PACKAGE PROJ_DB.PKG_MAST_DP
AS 	

TYPE RECORD IS REF CURSOR;

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
	);
	
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
	);
	
	PROCEDURE read_proc
	(
		p_dp_id	    		IN		VARCHAR2,
		search_dp_name		IN		VARCHAR2,
		dt_records			OUT		RECORD
	);
	
	PROCEDURE delete_proc
   	(
		p_dp_id		IN		VARCHAR2,
		p_retCode	OUT		NUMBER,
		p_retMsg	OUT		VARCHAR2
	);
	
	PROCEDURE bind_dropdown_depo_proc
	(
		dt_records		OUT		RECORD
	);
	
END PKG_MAST_DP;