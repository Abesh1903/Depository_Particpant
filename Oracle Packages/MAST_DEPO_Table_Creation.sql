-- Table to store depository information

CREATE TABLE MAST_DEPO
(
	md_depo_id			NUMBER(2)		NOT NULL,		-- Depository ID
	md_depo_code		VARCHAR2(10)	NOT NULL,		-- Depository Code (NSDL, CDSL, etc.)
	md_depo_desc		VARCHAR2(100)	NOT NULL,		-- Depository Name
	md_depo_group		NUMBER(2)		NOT NULL,		-- Segment Group (1 - Physical	2 - Demat)
	md_active_flag		NUMBER(1)		NOT NULL,		-- 0 -> INACTIVE	1 -> ACTIVE
	CONSTRAINT MAST_DEPO_PK PRIMARY KEY (md_depo_id)
);


INSERT INTO MAST_DEPO VALUES (1, 'PHYSICAL', 'PHYSICAL', 1, 1);
INSERT INTO MAST_DEPO VALUES (2, 'NSDL', 'National Securities Depository Limited', 2, 1);
INSERT INTO MAST_DEPO VALUES (3, 'CDSL', 'Central Depository Services Limited', 2, 1);

SELECT * FROM MAST_DEPO;