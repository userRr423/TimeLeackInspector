/**
 * 10_init.sql - ������ ������������� ���� ������ ������� TLI
 *
 * Copyright (c) 2022-2023, Pavel Krasnozhon <kpv.gov.karelia@yandex.ru>
 *
 * This code is licensed under a MIT-style license.
 */

CREATE DATABASE IF NOT EXISTS `tli`;

USE `tli`;

SET NAMES utf8mb4;

/* ���������� ����������� */
CREATE TABLE IF NOT EXISTS `organizations` (
	`id` int NOT NULL AUTO_INCREMENT,
	`inn` varchar(12) NOT NULL UNIQUE COMMENT '���',
	`ogrn` varchar(13) NOT NULL UNIQUE COMMENT '����',
	`full_name` varchar(255) NOT NULL COMMENT '������ ������������ �����������',
	`short_name` varchar(255) COMMENT '����������� ������������ �����������',
	`director` varchar(64) NOT NULL COMMENT '��� ������������ �����������',
	`senior_accountant` varchar(64) NOT NULL COMMENT '��� �������� ���������� �����������',
	`start_time` TIME NOT NULL DEFAULT '09:00:00' COMMENT '����� ������ ������ �����������',
	`end_time` TIME NOT NULL DEFAULT '18:15:00' COMMENT '����� ��������� ������ �����������',
	PRIMARY KEY (`id`)
);

/* ���������� ������� ����� �������� ������� */
CREATE TABLE IF NOT EXISTS `time_control_policies` (
	`id` int NOT NULL AUTO_INCREMENT,
	`name` varchar(64) NOT NULL COMMENT '������������ ��������',
	`is_default` bool NOT NULL DEFAULT false COMMENT '����������� ������ �������� ��� ���������� ������ ����������?',
	`interval_autoclose` bool NOT NULL DEFAULT true COMMENT '������������ �������������� �������� ������� ����������?',
	`autoclose_mode` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '����� ��������������� ��������',
/* ����� ��������������� �������� ����� ��������� ��������� ��������:
*	'0' - ������������ �� ������� ���������
*	'1' - �������������� �������� �������������� ���������
*	'2' - ������������ �������� ��������� ������ �����������
*	'3' - ������������ �������� ��������� ������ ������������ �������������
*	'4' - �������������� �������� ���� ������� ����������� �� ��������� ����
*/
	`lunch_break_type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '����� ���������� ��������',
/* ����� ���������� �������� ����� ��������� ��������� ��������:
*	'0' - ������������� ��������� �������;
*	'1' - ��������������� ��������� �������. 
*/
	`is_lunch_break_subtracted` bool NOT NULL DEFAULT true COMMENT '�������� ��������� ������� �� ������������ �������?',
	`fixed_lunch_break_start` TIME COMMENT '������ �������������� ���������� ��������',
	`fixed_lunch_break_end` TIME COMMENT '��������� �������������� ���������� ��������',
	`unfixed_lunch_break_duration` tinyint unsigned COMMENT '����������������� ���������������� ���������� �������� � �������',
	`acceptable_lateness` tinyint unsigned NOT NULL DEFAULT '5' COMMENT '���������� ��������� �� ������ � �������',
	`acceptable_leaving_work` tinyint unsigned NOT NULL DEFAULT '5' COMMENT '���������� ������ ���� � ������ � �������',
	`acceptable_schedule_violation` tinyint unsigned NOT NULL DEFAULT '5' COMMENT '���������� ���������� �� ������� � �������',
	`acceptable_break_time_per_hour` tinyint unsigned NOT NULL DEFAULT '5' COMMENT '���������� ����� �������� (���) �� 1 ������� ���',
	`schedule_limiting_mode` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '����� ����� � ������� ������ ���������� ��� �������',
/* ����� ����� ������ ��� ������� ����� ��������� ��������� ��������:
*	'0' - ��������� ������ ��� �������;
*	'1' - �� ��������� ������ ��� �������; 
*	'2' - �� ��������� ������ ������ �� ������;
*	'3' - �� ��������� �������� �� ������; 
*/
	PRIMARY KEY (`id`),
	CONSTRAINT `tc_policies_autoclose_mode_chk1` CHECK (autoclose_mode in (0, 1, 2, 3, 4)),
	CONSTRAINT `tc_policies_lunch_break_type_chk1` CHECK (lunch_break_type in (0, 1)),
	CONSTRAINT `tc_policies_schedule_limiting_mode_chk1` CHECK (schedule_limiting_mode in (0, 1, 2, 3))
);

/* ���������� ���������� ���������� */
CREATE TABLE IF NOT EXISTS `positions` (
	`id` int NOT NULL AUTO_INCREMENT,
	`organization_id` int NOT NULL COMMENT '������ �� ������������� �����������',
	`name` varchar(64) NOT NULL COMMENT '������������ ���������',
	`default_tc_policy_id` int NOT NULL COMMENT '������ �� ������������� �������� ����� �������� ������� �� ���������',
	PRIMARY KEY (`id`),
	CONSTRAINT `positions_fk0` FOREIGN KEY (`organization_id`) REFERENCES `organizations`(`id`),
	CONSTRAINT `positions_fk1` FOREIGN KEY (`default_tc_policy_id`) REFERENCES `time_control_policies`(`id`)
);

/* ���������� ������ ���������� */
CREATE TABLE IF NOT EXISTS `dismissal_reasons` (
	`id` int NOT NULL AUTO_INCREMENT,
	`name` varchar(255) NOT NULL COMMENT '������������ ������� ���������� ���������',
	PRIMARY KEY (`id`)
);

/* ���������� ���������� */
CREATE TABLE IF NOT EXISTS `employees` (
	`id` int NOT NULL AUTO_INCREMENT,
	`surname` varchar(64) NOT NULL COMMENT '������� ���������',
	`name` varchar(32) NOT NULL COMMENT '��� ���������',
	`middle_name` varchar(32) COMMENT '�������� ���������',
	`gender` bit(1) NOT NULL COMMENT '��� ���������', /* 0 - �������, 1 - ������� */
	`birth_date` DATE NOT NULL COMMENT '���� �������� ���������',
	`employed_at` DATE DEFAULT NULL COMMENT '���� ������ �� ������',
	`unit_id` int DEFAULT NULL COMMENT '������ �� ������������� ������������ �������������',
	`position_id` int DEFAULT NULL COMMENT '������ �� ������������� ���������� ���������',
	`tc_policy_id` int DEFAULT NULL COMMENT '������ �� ������������� ����������� �������� ����� �������� �������',
	`access_code` bigint unsigned NOT NULL UNIQUE COMMENT '��� �������',
	`is_dismissed` bool NOT NULL DEFAULT false COMMENT '�������� ������?',
	`dismissal_reason_id` int DEFAULT NULL COMMENT '������ �� ������������� ������� ����������',
	`dismissal_date` DATE DEFAULT NULL COMMENT '���� ����������',
	`photo` mediumblob COMMENT '���������� ���������',
	PRIMARY KEY (`id`),
	CONSTRAINT `employees_fk1` FOREIGN KEY (`position_id`) REFERENCES `positions`(`id`),
	CONSTRAINT `employees_fk2` FOREIGN KEY (`tc_policy_id`) REFERENCES `time_control_policies`(`id`),
	CONSTRAINT `employees_fk3` FOREIGN KEY (`dismissal_reason_id`) REFERENCES `dismissal_reasons`(`id`)
);

/* ���������� ����������� ������������� */
CREATE TABLE IF NOT EXISTS `organizational_units` (
	`id` int NOT NULL AUTO_INCREMENT,
	`organization_id` int NOT NULL COMMENT '������ �� ������������� �����������',
	`higher_level_id` int COMMENT '������ �� ������������� ������������ ������������ �������������',
	`name` varchar(255) NOT NULL COMMENT '������������ ������������ �������������',
	`chief_id` int NOT NULL COMMENT '������ �� ������������� ������������ �������������',
	`start_time` TIME NOT NULL DEFAULT '9:00:00' COMMENT '����� ������ ������ ������������ �������������',
	`end_time` TIME NOT NULL DEFAULT '18:15:00' COMMENT '����� ��������� ������ ������������ �������������',
	PRIMARY KEY (`id`),
	CONSTRAINT `organizational_units_fk0` FOREIGN KEY (`organization_id`) REFERENCES `organizations`(`id`),
	CONSTRAINT `organizational_units_fk1` FOREIGN KEY (`higher_level_id`) REFERENCES `organizational_units`(`id`),
	CONSTRAINT `organizational_units_fk2` FOREIGN KEY (`chief_id`) REFERENCES `employees`(`id`)
);

ALTER TABLE `employees` ADD CONSTRAINT `employees_fk0` FOREIGN KEY (`unit_id`) REFERENCES `organizational_units`(`id`);

/* ������� �������� ���� */
CREATE TABLE IF NOT EXISTS `weekend_shift` (
	`id` int NOT NULL AUTO_INCREMENT,
	`old_date` DATE NOT NULL UNIQUE,
	`new_date` DATE NOT NULL UNIQUE,
	`comment` TEXT,
	PRIMARY KEY (`id`)
);

/* ���������� ����������� ���� */
CREATE TABLE IF NOT EXISTS `holidays` (
	`id` int NOT NULL AUTO_INCREMENT,
	`day` tinyint unsigned NOT NULL COMMENT '����� ������',
	`month` tinyint unsigned NOT NULL COMMENT '����� ������',
	`name` varchar(64) NOT NULL COMMENT '������������ ������������ ���',
	`brief` varchar(5) NOT NULL COMMENT '����������',
	PRIMARY KEY (`id`)
);

/* ���������� ����� ���������� ������� ������� ����� */
CREATE TABLE IF NOT EXISTS `time_interval_types` (
	`id` int NOT NULL AUTO_INCREMENT,
	`letter_code` varchar(2) NOT NULL UNIQUE COMMENT '��������� ���',
	`name` varchar(64) NOT NULL UNIQUE COMMENT '������������',
	`description` varchar(255) COMMENT '��������',
	`start_time` TIME COMMENT '����� ������',
	`end_time` TIME COMMENT '����� ���������',
	PRIMARY KEY (`id`)
);

/* ������ ������ ����������� */ 
CREATE TABLE IF NOT EXISTS `work_schedule` (
	`id` int NOT NULL AUTO_INCREMENT COMMENT '������������� �������',
	`employee_id` int NOT NULL COMMENT '������ �� ������������� ����������',
	`period_start` DATE NOT NULL COMMENT '���� ������ ������� ��������, ��������, 01.01.2023',
	`period_end` DATE NOT NULL COMMENT '���� ��������� ������� ��������, ��������, 31.01.2023',
	`days_set` json NOT NULL COMMENT '��� ������ � ���� ����, ����������� ��� ������������ �������',
/* ���� days_set �������� � ������� JSON:
{
	"days_of_week": {
		"Monday": true,
		"Tuesday" : true,
		"Wednesday" : true,
		"Thursday" : true,
		"Friday" : true,
		"Saturday" : false,
		"Sunday" : false
	},
	"holidays" : false,
	"shortened_working_day" : {
		"Friday" : "60"
	},
	"shortened_pre_holiday_day" : "60"
}
*/
	`time_interval_type_id` int NOT NULL COMMENT '������ �� ������������� ���� ���������',
	`work_intervals` json COMMENT '������� ��������� � �������',
/* ���� work_intervals �������� � ������� JSON:
{
	"intervals" : [
		{
			"interval_start" : "09:00:00",
			"interval_end" : "10:00:00"
		},
		{
			"interval_start" : "12:00:00",
			"interval_end" : "13:00:00"
		}
	]
}
*/
	PRIMARY KEY (`id`),
	CONSTRAINT `work_schedule_fk0` FOREIGN KEY (`employee_id`) REFERENCES `employees`(`id`),
	CONSTRAINT `work_schedule_fk1` FOREIGN KEY (`time_interval_type_id`) REFERENCES `time_interval_types`(`id`),
	CONSTRAINT `work_schedule_days_set_chk1` CHECK (JSON_VALID(days_set)),
	CONSTRAINT `work_schedule_work_intervals_chk1` CHECK (JSON_VALID(work_intervals))
);

/* ���������� �� ������ */
CREATE TABLE IF NOT EXISTS `absense` (
	`id` int NOT NULL AUTO_INCREMENT,
	`employee_id` int NOT NULL COMMENT '������ �� ������������� ���������',
	`absense_type` int NOT NULL COMMENT '������ �� ������������� ���� ���������',
	`period_start` DATE NOT NULL COMMENT '������ ������� ����������',
	`period_end` DATE NOT NULL COMMENT '��������� ������� ����������',
	`in_shift_time` TIME COMMENT '����������������� ������ �����',
	PRIMARY KEY (`id`),
	CONSTRAINT `absense_fk0` FOREIGN KEY (`employee_id`) REFERENCES `employees`(`id`),
	CONSTRAINT `absense_fk1` FOREIGN KEY (`absense_type`) REFERENCES `time_interval_types`(`id`)
);

/* ���������� EAM-�������� */
CREATE TABLE IF NOT EXISTS `eam_clients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL COMMENT 'UUID-��� ���-�������',
  `host_ip` decimal(10,0) NOT NULL COMMENT 'IP-����� �����, �� ������� ���������� ���-������',
  `hostname` varchar(64) COMMENT '������������ �����, �� ������� ���������� ���-������',
  PRIMARY KEY (`id`)
);

/* ���������� �������� ����� */
CREATE TABLE IF NOT EXISTS `actual_time` (
	`id` int NOT NULL AUTO_INCREMENT,
	`empolyee_id` int NOT NULL COMMENT '������ �� ������������� ���������',
	`eam_client_id` int NOT NULL COMMENT '������ �� ������������� ���-�������',
	`interval_start` DATETIME NOT NULL COMMENT '������ ��������� ��������� �������',
	`interval_end` DATETIME NOT NULL  COMMENT '��������� ��������� ��������� �������',
	`time_interval_type_id` int NOT NULL COMMENT '������ �� ������������� ���� ���������',
	PRIMARY KEY (`id`),
	CONSTRAINT `actual_time_fk0` FOREIGN KEY (`empolyee_id`) REFERENCES `employees`(`id`),
	CONSTRAINT `actual_time_fk1` FOREIGN KEY (`time_interval_type_id`) REFERENCES `time_interval_types`(`id`),
	CONSTRAINT `actual_time_fk2` FOREIGN KEY (`eam_client_id`) REFERENCES `eam_clients` (`id`)
);

/* ��������� ������� */
CREATE TABLE IF NOT EXISTS `configuration` (
	`parameter` varchar(255) NOT NULL COMMENT '�������� ��������� �������',
	`value` varchar(255) NOT NULL COMMENT '�������� ���������',
	PRIMARY KEY (`parameter`)
);

/* ������������ ������� */
CREATE TABLE IF NOT EXISTS `users` (
	`id` int NOT NULL AUTO_INCREMENT,
	`status` tinyint unsigned NOT NULL COMMENT '������ ������������',
/* ������ ������������ ����� ��������� ��������� ��������:
*	'0' - ������;
*	'10 - ������������; 
*	'20' - ������� �������������;
*	'30' - �������; 
*/	
	`login` varchar(50) UNIQUE COMMENT '����� ������������',
	`password_hash` varchar(255) COMMENT '��� ������ ������������',
	`password_reset_token` varchar(255) UNIQUE COMMENT '����� ������ ������ ������������',
	`name` varchar(255) NOT NULL COMMENT '��� ������������',
	`email` varchar(255) UNIQUE COMMENT '����������� �������� ����� ������������',
	`email_confirm_token` varchar(255) COMMENT '����� ������������� ����������� ����� ������������',
	`employee_id` int COMMENT '������ �� ������������� ���������',
	PRIMARY KEY (`id`),
	CONSTRAINT `users_fk0` FOREIGN KEY (`employee_id`) REFERENCES `employees`(`id`),
	CONSTRAINT `users_status_chk1` CHECK (status in (0, 10, 20, 30))
);

/* ���������� ������� ������� */
CREATE TABLE IF NOT EXISTS `event_type` (
	`id` int NOT NULL AUTO_INCREMENT,
	`name` varchar(255) NOT NULL UNIQUE COMMENT '������������ ���� �������',
	`description` text NOT NULL COMMENT '�������� ���� �������',
	PRIMARY KEY (`id`)
);

/* ������ ������� ������� */
CREATE TABLE IF NOT EXISTS `event_log` (
	`id` int NOT NULL AUTO_INCREMENT,
	`datetime` DATETIME NOT NULL COMMENT '���� � ����� �������',
	`event_type_id` int NOT NULL COMMENT '������ �� ������������� ���� �������',
	`user_id` int COMMENT '������ �� ������������� ������������, ��������������� ������������� �������',
	`description` TEXT COMMENT '�������� �������',
	`host_ip` numeric NOT NULL COMMENT 'IP-����� �����, �� ������� ���� ������������ ������������� �������',
	`hostname` varchar(64) COMMENT '������������ �����, �� ������� ���� ������������ ������������� �������',
	PRIMARY KEY (`id`),
	CONSTRAINT `event_log_fk0` FOREIGN KEY (`event_type_id`) REFERENCES `event_type`(`id`),
	CONSTRAINT `event_log_fk1` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
);

/* ���������� ����� ������������� */
CREATE TABLE IF NOT EXISTS `roles` (
	`name` varchar(64) NOT NULL COMMENT '������������ ����',
	PRIMARY KEY (`name`)
);

/* ����������� ������������� ������� ���� */
CREATE TABLE IF NOT EXISTS `roles_assignment` (
	`user_id` int NOT NULL COMMENT '������ �� ������������� ������������',
	`role_name` varchar(64) NOT NULL COMMENT '������ �� ������������ ����',
	PRIMARY KEY (`user_id`,`role_name`),
	CONSTRAINT `roles_assignment_fk0` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
	CONSTRAINT `roles_assignment_fk1` FOREIGN KEY (`role_name`) REFERENCES `roles`(`name`)
);

/* ����� ������� � �������� ������� */ 
CREATE TABLE IF NOT EXISTS `access_rights` (
	`name` varchar(64) NOT NULL COMMENT '������������',
	`description` TEXT COMMENT '��������',
	PRIMARY KEY (`name`)
);

/* ����������� ����� ����� ������� � �������� ������� */
CREATE TABLE IF NOT EXISTS `access_assignment` (
	`right_name` varchar(64) NOT NULL,
	`role_name` varchar(64) NOT NULL,
	PRIMARY KEY (`right_name`,`role_name`),
	CONSTRAINT `access_assignment_fk0` FOREIGN KEY (`right_name`) REFERENCES `access_rights`(`name`),
	CONSTRAINT `access_assignment_fk1` FOREIGN KEY (`role_name`) REFERENCES `roles`(`name`)
);

/* ���������� ����� ���������� */
CREATE TABLE IF NOT EXISTS `application_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '������������ ���� ����������',
  `description` text NOT NULL COMMENT '�������� ���� ����������',
  PRIMARY KEY (`id`)  
);

/* ���������� ���������������� ���������� */
CREATE TABLE IF NOT EXISTS `applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL COMMENT 'UUID-��� ����������',
  `name` varchar(255) NOT NULL COMMENT '������������ ����������',
  `description` text NOT NULL COMMENT '�������� ����������',
  `type_id` int NOT NULL COMMENT '������ �� ������������� ���� ����������',
  PRIMARY KEY (`id`),
  CONSTRAINT `applications_fk0` FOREIGN KEY (`type_id`) REFERENCES `application_types` (`id`)
);

/* ���������� ��������� URI */
CREATE TABLE IF NOT EXISTS `uri_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL COMMENT '������������ ��������� URI',
  `description` text COMMENT '�������� ��������� URI',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
);

/* ���������� �������� URI */
CREATE TABLE IF NOT EXISTS `uri_patterns` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pattern` varchar(512) NOT NULL COMMENT '������ URI',
  `uri_type_id` int NOT NULL COMMENT '������ �� ������������� ��������� URI',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pattern` (`pattern`),
  CONSTRAINT `uri_patterns_fk0` FOREIGN KEY (`uri_type_id`) REFERENCES `uri_types` (`id`)
);

INSERT INTO `dismissal_reasons` (`id`, `name`) VALUES
(1, '������� ��������� �� ��� ������� ��� � ��� �������� �� ������ � ������� ������������ ��� ������� �� �������� ������ (���������)'),
(2, '����� ��������� �� ����������� ������ � ����� �� ������ ������������ ��������� �����������, � ���������� ������������������ (�������������) ����������� ���� �� ��������������, � ���������� ���� ���������������� ��� �������������� ����������'),
(3, '����� ��������� �� ����������� ������ � ����� � ���������� ������������ ��������� ������� ��������� ��������'),
(4, '����� ��������� �� �������� �� ������ ������, ������������ ��� � ������������ � ����������� �����������, �������� � �������, ������������� ������������ �������� � ����� ������������ ��������� ������, ���� ���������� � ������������ ��������������� ������'),
(5, '����� ��������� �� �������� �� ������ � ������ ��������� ������ � �������������'),
(6, '���������� ������'),
(7, '��������� ����� ��������� ��������'),
(8, '�� ���������� ��������� (�� ������������ �������)'),
(9, '���������� ����������� ���� ����������� ������������ �������������� ����������������'),
(10, '���������� ����������� ��� ����� ���������� �����������, ��������������� ���������������'),
(11, '�������������� ��������� ���������� ��������� ��� ����������� ������ ���������� ������������� ������������, �������������� ������������ ����������'),
(12, '����� ������������ ��������� ����������� (� ��������� ������������ �����������, ��� ������������ � �������� ����������)'),
(13, '������������� ������������ ���������� ��� ������������ ������ �������� ������������, ���� �� ����� �������������� ���������'),
(14, '������'),
(15, '��������� ��������� �� ������ � ��������� ������������, �������������� ��� ����� ������������ ���������'),
(16, '����������� ���������� ������� ����� (���������������, ������������, ��������� � ����), ������� ��������� ��������� � ����� � ����������� �� �������� ������������, � ��� ����� ����������� ������������ ������ ������� ���������'),
(17, '���������� �� ����� ������ ������� (� ��� ����� �������) ������ ���������, ��������, ����������� ��� ����������� ��� �����������, ������������� ���������� � �������� ���� ���������� ���� ��� �������������� �� ���� �� ���. ��������������'),
(18, '������������� ��������� �� ������ ����� ��� �������������� �� ������ ����� ��������� ���������� ���������� ������ �����, ���� ��� ��������� �������� �� ����� ������ ����������� ���� �������� ��������� �������� ������ ����������� ����� �����������'),
(19, '����������� �������� �������� ����������, ��������������� ������������� �������� ��� �������� ��������, ���� ��� �������� ���� ��������� ��� ������ ������� � ���� �� ������� ������������'),
(20, '���������� ���������� ��� �� �������������� ��� �������������� ��������� ���������'),
(21, '���������� ����������, ����������� �������������� �������, ����������� ���������, �������������� � ������������ ������ ������'),
(22, '�������� ��������������� ������� ������������� ����������� (�������, �����������������), ��� ������������� � ������� �����������, ���������� �� ����� ��������� ����������� ���������, ������������� ��� ������������� ��� ���� ����� ��������� �����������'),
(23, '����������� ������ ��������� ������������� ����������� (�������, �����������������), ��� ������������� ����� �������� ������������'),
(24, '������������� ���������� ������������ ��������� ���������� ��� ���������� ��������� ��������'),
(25, '�� ���������������, ��������������� �������� ��������� � ������������� �����������, ������� �������������� ��������������� ������ �����������'),
(26, '������� ��������� �� ������ �� ��������� ���� ������� ����� ��������� ����������� �� ������� ������ �� ����������� ��� ������� ������ �� ���������'),
(27, '������ ��������� �� ������� ������ (�� ����������� ������� ��������� �� ������� ������ �� �����������) ��� ����������� ��� �� ���������� �� �������������� ����������� ������'),
(28, '�������������� �� ������ ���������, ����� ������������ ��� ������, �� ������� ��������������� ��������� ����� ��� ����'),
(29, '���������� �� ���������'),
(30, '��������� ��������� � ���������, ������������ ����������� ������� ������, � ������������ � ���������� ����, ���������� � �������� ����'),
(31, '��������� ��������� ��������� ����������� � �������� ������������ � ������������ � ����������� �����������, �������� � �������, ������������� ������������ �������� � ����� ������������ ��������� ������ ���������� ���������'),
(32, '������ ��������� ���� ������������ - ����������� ����, � ����� ��������� ����� ��������� ���� ������������ - ����������� ���� ������� ��� ��������� �������������'),
(33, '����������� ������������ �������������, �������������� ����������� �������� ���������, � ����� ������ ������������ - ����������� ���� �� ������� ������ �� �����������'),
(34, '��������������� ��� ���� ���������������� ���������, ����������� ����������� ���������� ���������� ������������ �� ��������� ��������'),
(35, '��������� ����� ��������, ��������������� �������� �� ���� ����� ���� ������� ��� ������� ��������� ������������ �����, ���� ��� ������ �� ����� ������������� ���������� ���������� ������������ �� ��������� ��������'),
(36, '����������� ������� � ��������������� �����, ���� ����������� ������ ������� ������ �������'),
(37, '������ ������� ���� ��� ������ (��������� ����������) ������� ��������������� ��������� ����� � �������������� ��������� �� ������'),
(38, '������������� ������������� ������� � ����������� ����������� ���������� ���������� ������������ �� ��������� �������� ����������� �� ������� ������������� ������ �������� ������������'),
(39, '���������� ��������� �������� � ��������� ��������� ���� � ������� ����������� ���� ����� �������� ������������ ��������� ��� ���������� ������������ �������������'),
(40, '���������� ��������� �������� �� ���������� ������, ����������������� ������� ��������� �� ��������� �������� � ������������ � ����������� �����������'),
(41, '���������� ���������������� ��������� �� ����������� � (���) � ������������, ���� ���������� ������ ������� ����������� ������ � ������������ � ����������� ������� ��� ���� ����������� �������� �����'),
(42, '���������� ��������� �������� � ��������� ������������� � ��������������� ��� ���� ���������������� ��������� ���� ���������� ��������� �������� � ��������� ������������� �������� �����������'),
(43, '���������� ��������� �������� � ��������� ������������� ������� ����������� �� ������� ������������� ������ �������� ������������');

INSERT INTO `holidays` (`id`, `day`, `month`, `name`, `brief`) VALUES
(1, 1, 1, '���������� ��������', '��'),
(2, 2, 1, '���������� ��������', '��'),
(3, 3, 1, '���������� ��������', '��'),
(4, 4, 1, '���������� ��������', '��'),
(5, 5, 1, '���������� ��������', '��'),
(6, 6, 1, '���������� ��������', '��'),
(7, 7, 1, '��������� ��������', '��'),
(8, 8, 1, '���������� ��������', '��'),
(9, 23, 2, '���� ��������� ���������', '���'),
(10, 8, 3, '������������� ������� ����', '���'),
(11, 1, 5, '�������� ����� � �����', '���'),
(12, 9, 5, '���� ������', '��'),
(13, 12, 6, '���� ������', '��'),
(14, 4, 11, '���� ��������� ��������', '���');

INSERT INTO `time_interval_types` (`id`, `letter_code`, `name`, `description`, `start_time`, `end_time`) VALUES
(1, '�', '����', '����������������� ������ � ������� �����', NULL, NULL),
(2, '�', '����', '����������������� ������ � ������ �����', NULL, NULL),
(3, '��', '���������', '����������������� ������ � �������� � ���������, ����������� ���', NULL, NULL),
(4, '�', '�����������', '����������������� ������������ ������', NULL, NULL),
(5, '��', '�����', '����������������� ������ �������� �������', NULL, NULL),
(6, '�', '������������', '����������������� ������ �� ����� ������������', NULL, NULL),
(7, '��', '��������� ������������ � ������� �� ������', '��������� ������������ � ������� �� ������', NULL, NULL),
(8, '��', '��������� ������������ � ������� �� ������ � ������ ���������', '��������� ������������ � ������� �� ������ � ������ ���������', NULL, NULL),
(9, '��', '������', '��������� �������� ������������ ������', NULL, NULL),
(10, '��', '���. ������', '��������� �������������� ������������ ������', NULL, NULL),
(11, '�', '������� ������', '������� ������ � ����������� ���������� �����', NULL, NULL),
(12, '��', '����. ����� ����������� ��� ������ �� ������������', '����������� ����������������� �������� ������� ��� ����������, ����������� ��� ������ �� ������������ � ��������� ����������� ���������� �����', NULL, NULL),
(13, '��', '������� ������ �� ���� ����', '������� ������ ��� ���������� ���������� �����', NULL, NULL),
(14, '�', '������ �� ������������ � �����', '������ �� ������������ � ����� ��� � ����� � ������������ �������������� �������', NULL, NULL),
(15, '��', '������ �� ����� �� ��������', '������ �� ����� �� �������� �� ���������� ����������� ��������', NULL, NULL),
(16, '��', '������ �� ���� ����', '������ ��� ���������� ���������� ����� � ���������� ������������', NULL, NULL),
(17, '��', '������ �� ���� ���� (��������, ��������)', '������ �� ���� ���� ��� ��������, ��������������� �������', NULL, NULL),
(18, '��', '��������� ���. ������ ��� ���������� ��������', '��������� �������������� ������ ��� ���������� ���������� �����', NULL, NULL),
(19, '�', '����������', '��������� ������������������ (����� ������� ����, ������� �� ����� �� �������� � �� ���������)', NULL, NULL),
(20, '�', '������', '��������� ������������������ � ����� � ������� �������, �������� �� ����� �� �������� � �� ���������', NULL, NULL),
(21, '��', '����������� ������� ����� � ������������ � �������', '����������� ����������������� �������� ������� � �������, ��������������� �����������������', NULL, NULL),
(22, '��', '����������� ������', '����� ������������ ������� � ����� � ����� � ���������� ����������, �������� �� ������ ������ ��� ����������� �� ������ ����������� � ��������������� �� ������� ������', NULL, NULL),
(23, '�', '���������� ��������������� ��� ������������ ������������', '�������� �� ������ �� ����� ���������� ��������������� ��� ������������ ������������', NULL, NULL),
(24, '��', '������', '�������', NULL, NULL),
(25, '��', '������ � ������ ��������� �������� �������', '����������������� ������ � ������ ��������� �������� ������� �� ���������� ������������', NULL, NULL),
(26, '�', '�������� (��������)', '�������� � ��������� ����������� ���', NULL, NULL),
(27, '��', '���. ��������', '�������������� �������� (������������)', NULL, NULL),
(28, '��', '���. �������� (��� ����. ��������)', '�������������� �������� ��� (��� ���������� ���������� �����)', NULL, NULL),
(29, '��', '����������', '����������', NULL, NULL),
(30, '��', '������', '������ �� ������������ �������� (�� ��������� �������������)', NULL, NULL),
(31, '��', '������� �� ���� ������������', '����� ������� �� ���� ������������', NULL, NULL),
(32, '��', '�������', '����� ������� �� ��������, �� ��������� �� �� ������������ � ���������', NULL, NULL),
(33, '��', '������� �� ���� ���������', '����� ������� �� ���� ���������', NULL, NULL),
(34, '��', '����������� �� ������ � �������', '����� ����������� �� ������ (����������� � ������) � �������', NULL, NULL),
(35, '��', '����������� �� ������ ��� ������', '����������� �� ������ (����������� � ������) ��� ������', NULL, NULL),
(36, '��', '������������ ������ ��� �������� ��������', '����� ������������ ������ ��� �������� ������ �����.', NULL, NULL);

INSERT INTO `weekend_shift` (`id`, `old_date`, `new_date`, `comment`) VALUES
(1, '2023-01-01', '2023-02-24', '������������� ������������� �� �� 29.08.2022 N 1505 \"� �������� �������� ���� � 2023 ����\"'),
(2, '2023-01-08', '2023-05-08', '������������� ������������� �� �� 29.08.2022 N 1505 \"� �������� �������� ���� � 2023 ����\"');
