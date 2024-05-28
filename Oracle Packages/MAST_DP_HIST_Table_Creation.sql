-- Table to store history of depository participant information

DROP TABLE MAST_DP_HIST;

CREATE TABLE MAST_DP_HIST
(
	dp_dp_id			VARCHAR2(10)		NOT NULL,		-- Depository Participant ID
	dp_depo_id			NUMBER(2)			NOT NULL,		-- Depository ID
	dp_dp_name			VARCHAR2(60)		NOT NULL,		-- Depository Participant Name
	dp_dp_addr1			VARCHAR2(35)		NOT NULL,		-- Address Line 1
	dp_dp_addr2			VARCHAR2(35),						-- Address Line 2
	dp_dp_addr3			VARCHAR2(35),						-- Address Line 3
	dp_dp_addr4			VARCHAR2(35),						-- Address Line 4
	dp_dp_city			VARCHAR2(35),						-- City
	dp_dp_state			VARCHAR2(35),						-- State
	dp_dp_pincode		VARCHAR2(15)		NOT NULL,		-- Pin Code
	dp_dp_tele_no		VARCHAR2(35),						-- Telephone No
	dp_dp_fax_no		VARCHAR2(35),						-- Fax no
	dp_active_flag		NUMBER(1)			NOT NULL,		-- 0 -> INACTIVE	1 -> ACTIVE
	dp_crea_by			NUMBER(9),							-- Original Record Created By whom
	dp_crea_date		DATE,								-- Original Record Creation Date (DB Server Date)
	dp_modi_by			NUMBER(9),							-- Record Last Modified By
	dp_modi_date		DATE,								-- DB Server Date for last modification
	dp_oper_flag		NUMBER(1)			NOT NULL,		-- Operation: 1 - Insert	2- Update	3 - Delete
	dp_hist_date		DATE				NOT NULL		-- Operation Date
);

SELECT * FROM MAST_DP_HIST;