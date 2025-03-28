CREATE TABLE "pay" (
	"pay_no"	number		NOT NULL,
	"package_name"	varchar(20)		NOT NULL,
	"pay_time"	datetime		NOT NULL,
	"user_no"	number		NOT NULL,
	"lawyer_no"	number		NOT NULL,
	"pay_status"	varchar(20)		NULL
);

CREATE TABLE "board_file" (
	"board_no"	number		NOT NULL,
	"file_path"	varchar(300)		NOT NULL,
	"file_name"	varchar(300)		NULL,
	"thumnail"	varchar(1)	DEFAULT N	NOT NULL,
	"file_realname"	varchar(300)		NOT NULL
);

CREATE TABLE "total_cmt" (
	"cmt_no"	number		NOT NULL,
	"contents"	varchar(300)		NULL,
	"total_no"	number		NOT NULL,
	"cdate"	datetime		NULL,
	"udate"	datetime		NULL
);

CREATE TABLE "totalDocs" (
	"total_no"	number		NOT NULL,
	"total_title"	varchar(100)		NULL,
	"total_contents"	varchar(500)		NULL,
	"cdate"	datetime		NULL,
	"udate"	datetime		NULL,
	"user_no"	number		NOT NULL,
	"kind"	varchar(10)		NOT NULL,
	"cnt"	varchar(30)	DEFAULT 0	NULL
);

CREATE TABLE "chat_message" (
	"chat_no"	number		NOT NULL,
	"time"	datetime		NOT NULL,
	"message"	varchar(300)		NOT NULL,
	"sender_nos"	number		NOT NULL
);

CREATE TABLE "chat_file" (
	"chat_no"	number		NOT NULL,
	"time"	datetime		NOT NULL,
	"chat_filepath"	varchar(300)		NULL,
	"sender_nos"	number		NOT NULL
);

CREATE TABLE "lawyer" (
	"lawyer_no"	number		NOT NULL,
	"lawyer_id"	varchar(30)		NOT NULL,
	"lawyer_pwd"	varchar(300)		NOT NULL,
	"lawyer_name"	varchar(30)		NOT NULL,
	"lawyer_email"	varchar(50)		NOT NULL,
	"lawyer_phone"	number		NOT NULL,
	"auth_endtime"	datetime		NULL,
	"lawyer_info"	varchar(500)		NULL,
	"lawyer_career"	varchar(500)		NULL,
	"lawyer_edu"	varchar(500)		NULL,
	"lawyer_task"	varchar(500)		NULL,
	"lawyer_img"	varchar(300)		NULL,
	"lawyer_status"	varchar(1)		NULL,
	"lawyer_pass"	varchar(1)		NULL,
	"main_case1_no"	number		NULL,
	"main_case2_no"	number		NULL,
	"main_case3_no"	number		NULL
);

CREATE TABLE "chat" (
	"chat_no"	number		NOT NULL,
	"sender_no"	number		NOT NULL,
	"receiver_no"	number		NOT NULL
);

CREATE TABLE "board" (
	"board_no"	number		NOT NULL,
	"board_title"	varchar(30)		NOT NULL,
	"contents"	varchar(300)		NOT NULL,
	"user_no"	number		NOT NULL,
	"cnt"	number	DEFAULT 0	NULL,
	"cdate"	datetime		NULL,
	"udate"	datetime		NULL,
	"board_status"	varchar(1)		NOT NULL,
	"lawyer_no"	number		NULL,
	"lawyer_review"	varchar(300)		NULL
);

CREATE TABLE "user" (
	"user_no"	number		NOT NULL,
	"user_name"	varchar(30)		NOT NULL,
	"user_password"	varchar(300)		NOT NULL,
	"user_status"	varchar(1)		NOT NULL,
	"user_phone"	varchar(30)		NOT NULL,
	"user_id"	varchar(30)		NOT NULL,
	"report_cnt"	number	DEFAULT 0	NULL
);

CREATE TABLE "license" (
	"lawyer_no"	number		NOT NULL,
	"license_name"	varchar(50)		NULL,
	"license_filepath"	varchar(300)		NULL
);

CREATE TABLE "report" (
	"report_no"	number		NOT NULL,
	"user_no"	number		NULL,
	"board_no"	number		NULL,
	"report_status"	VARCHAR(255)		NULL,
	"cdate"	datetime		NULL
);

CREATE TABLE "board_cmt" (
	"cmt_no"	number		NOT NULL,
	"board_no"	number		NOT NULL,
	"lawyer_no"	number		NULL,
	"contents"	varchar(300)		NOT NULL,
	"cdate"	datetime		NOT NULL,
	"udate"	datetime		NULL
);

CREATE TABLE "categories" (
	"board_no"	number		NOT NULL,
	"category"	vachar(30)		NOT NULL
);

CREATE TABLE "total_file" (
	"total_no"	number		NOT NULL,
	"file_path"	varchar(300)		NULL,
	"file_name"	varchar(50)		NULL
);

CREATE TABLE "package" (
	"package_name"	number		NOT NULL,
	"package_price"	number		NOT NULL,
	"package_info"	varchar(500)		NOT NULL,
	"package_status"	varchar(1)	DEFAULT U	NOT NULL
);

COMMENT ON COLUMN "package"."package_status" IS 'user,lawyer';

ALTER TABLE "pay" ADD CONSTRAINT "PK_PAY" PRIMARY KEY (
	"pay_no"
);

ALTER TABLE "board_file" ADD CONSTRAINT "PK_BOARD_FILE" PRIMARY KEY (
	"board_no"
);

ALTER TABLE "total_cmt" ADD CONSTRAINT "PK_TOTAL_CMT" PRIMARY KEY (
	"cmt_no"
);

ALTER TABLE "totalDocs" ADD CONSTRAINT "PK_TOTALDOCS" PRIMARY KEY (
	"total_no"
);

ALTER TABLE "lawyer" ADD CONSTRAINT "PK_LAWYER" PRIMARY KEY (
	"lawyer_no"
);

ALTER TABLE "chat" ADD CONSTRAINT "PK_CHAT" PRIMARY KEY (
	"chat_no"
);

ALTER TABLE "board" ADD CONSTRAINT "PK_BOARD" PRIMARY KEY (
	"board_no"
);

ALTER TABLE "user" ADD CONSTRAINT "PK_USER" PRIMARY KEY (
	"user_no"
);

ALTER TABLE "license" ADD CONSTRAINT "PK_LICENSE" PRIMARY KEY (
	"lawyer_no"
);

ALTER TABLE "report" ADD CONSTRAINT "PK_REPORT" PRIMARY KEY (
	"report_no"
);

ALTER TABLE "board_cmt" ADD CONSTRAINT "PK_BOARD_CMT" PRIMARY KEY (
	"cmt_no"
);

ALTER TABLE "total_file" ADD CONSTRAINT "PK_TOTAL_FILE" PRIMARY KEY (
	"total_no"
);

ALTER TABLE "package" ADD CONSTRAINT "PK_PACKAGE" PRIMARY KEY (
	"package_name"
);

