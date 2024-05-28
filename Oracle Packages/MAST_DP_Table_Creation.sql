-- Table to store depository participant information

DROP TABLE MAST_DP;

CREATE TABLE MAST_DP
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
	dp_crea_by			NUMBER(9)			NOT NULL,		-- Record Created By
	dp_crea_date		DATE				NOT NULL,		-- DB Server Date for record creation
	dp_modi_by			NUMBER(9),							-- Record Last Modified By
	dp_modi_date		DATE,								-- DB Server Date for last modification
	CONSTRAINT MAST_DP_PK PRIMARY KEY (dp_dp_id),
	CONSTRAINT MAST_DP_UK1 UNIQUE (dp_dp_id, dp_depo_id),
	CONSTRAINT MAST_DP_FK1 FOREIGN KEY (dp_depo_id) REFERENCES MAST_DEPO (md_depo_id)
);

SELECT * FROM MAST_DP;