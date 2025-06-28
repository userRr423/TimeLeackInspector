/**
 * 10_init.sql - скрипт инициализации базы данных проекта TLI
 *
 * Copyright (c) 2022-2023, Pavel Krasnozhon <kpv.gov.karelia@yandex.ru>
 *
 * This code is licensed under a MIT-style license.
 */

CREATE DATABASE IF NOT EXISTS `tli`;

USE `tli`;

SET NAMES utf8mb4;

/* Справочник организаций */
CREATE TABLE IF NOT EXISTS `organizations` (
	`id` int NOT NULL AUTO_INCREMENT,
	`inn` varchar(12) NOT NULL UNIQUE COMMENT 'ИНН',
	`ogrn` varchar(13) NOT NULL UNIQUE COMMENT 'ОГРН',
	`full_name` varchar(255) NOT NULL COMMENT 'Полное наименование организации',
	`short_name` varchar(255) COMMENT 'Сокращенное наименование организации',
	`director` varchar(64) NOT NULL COMMENT 'ФИО руководителя организации',
	`senior_accountant` varchar(64) NOT NULL COMMENT 'ФИО главного бухгалтера организации',
	`start_time` TIME NOT NULL DEFAULT '09:00:00' COMMENT 'Время начала работы организации',
	`end_time` TIME NOT NULL DEFAULT '18:15:00' COMMENT 'Время окончания работы организации',
	PRIMARY KEY (`id`)
);

/* Справочник политик учета рабочего времени */
CREATE TABLE IF NOT EXISTS `time_control_policies` (
	`id` int NOT NULL AUTO_INCREMENT,
	`name` varchar(64) NOT NULL COMMENT 'Наименование политики',
	`is_default` bool NOT NULL DEFAULT false COMMENT 'Присваивать данную политику при добавлении нового сотрудника?',
	`interval_autoclose` bool NOT NULL DEFAULT true COMMENT 'Использовать автоматическое закрытие рабочих интервалов?',
	`autoclose_mode` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Режим автоматического закрытия',
/* Режим автоматического закрытия может принимать следующие значения:
*	'0' - определяется по графику работника
*	'1' - автоматическое удаление незаконченного интервала
*	'2' - определяется временем окончания работы организации
*	'3' - определяется временем окончания работы структурного подразделения
*	'4' - автоматическое удаление всех отметок регистрации за прошедший день
*/
	`lunch_break_type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Режим обеденного перерыва',
/* Режим обеденного перерыва может принимать следующие значения:
*	'0' - фиксированный обеденный перерыв;
*	'1' - нефиксированный обеденный перерыв. 
*/
	`is_lunch_break_subtracted` bool NOT NULL DEFAULT true COMMENT 'Вычитать обеденный перерыв из фактического времени?',
	`fixed_lunch_break_start` TIME COMMENT 'Начало фиксированного обеденного перерыва',
	`fixed_lunch_break_end` TIME COMMENT 'Окончание фиксированного обеденного перерыва',
	`unfixed_lunch_break_duration` tinyint unsigned COMMENT 'Продолжительность нефиксированного обеденного перерыва в минутах',
	`acceptable_lateness` tinyint unsigned NOT NULL DEFAULT '5' COMMENT 'Допустимое опоздание на работу в минутах',
	`acceptable_leaving_work` tinyint unsigned NOT NULL DEFAULT '5' COMMENT 'Допустимый ранний уход с работы в минутах',
	`acceptable_schedule_violation` tinyint unsigned NOT NULL DEFAULT '5' COMMENT 'Допустимое отклонение от графика в минутах',
	`acceptable_break_time_per_hour` tinyint unsigned NOT NULL DEFAULT '5' COMMENT 'Допустимое время перекура (мин) на 1 рабочий час',
	`schedule_limiting_mode` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Режим учета в отчетах работы сотрудника вне графика',
/* Режим учета работы вне графика может принимать следующие значения:
*	'0' - учитывать работу вне графика;
*	'1' - не учитывать работу вне графика; 
*	'2' - не учитывать ранний приход на работу;
*	'3' - не учитывать задержку на работе; 
*/
	PRIMARY KEY (`id`),
	CONSTRAINT `tc_policies_autoclose_mode_chk1` CHECK (autoclose_mode in (0, 1, 2, 3, 4)),
	CONSTRAINT `tc_policies_lunch_break_type_chk1` CHECK (lunch_break_type in (0, 1)),
	CONSTRAINT `tc_policies_schedule_limiting_mode_chk1` CHECK (schedule_limiting_mode in (0, 1, 2, 3))
);

/* Справочник должностей работников */
CREATE TABLE IF NOT EXISTS `positions` (
	`id` int NOT NULL AUTO_INCREMENT,
	`organization_id` int NOT NULL COMMENT 'Ссылка на идентификатор организации',
	`name` varchar(64) NOT NULL COMMENT 'Наименование должности',
	`default_tc_policy_id` int NOT NULL COMMENT 'Ссылка на идентификатор политики учета рабочего времени по умолчанию',
	PRIMARY KEY (`id`),
	CONSTRAINT `positions_fk0` FOREIGN KEY (`organization_id`) REFERENCES `organizations`(`id`),
	CONSTRAINT `positions_fk1` FOREIGN KEY (`default_tc_policy_id`) REFERENCES `time_control_policies`(`id`)
);

/* Справочник причин увольнения */
CREATE TABLE IF NOT EXISTS `dismissal_reasons` (
	`id` int NOT NULL AUTO_INCREMENT,
	`name` varchar(255) NOT NULL COMMENT 'Наименование причины увольнения работника',
	PRIMARY KEY (`id`)
);

/* Справочник работников */
CREATE TABLE IF NOT EXISTS `employees` (
	`id` int NOT NULL AUTO_INCREMENT,
	`surname` varchar(64) NOT NULL COMMENT 'Фамилия работника',
	`name` varchar(32) NOT NULL COMMENT 'Имя работника',
	`middle_name` varchar(32) COMMENT 'Отчество работника',
	`gender` bit(1) NOT NULL COMMENT 'Пол работника', /* 0 - женский, 1 - мужской */
	`birth_date` DATE NOT NULL COMMENT 'Дата рождения работника',
	`employed_at` DATE DEFAULT NULL COMMENT 'Дата приема на работу',
	`unit_id` int DEFAULT NULL COMMENT 'Ссылка на идентификатор структурного подразделения',
	`position_id` int DEFAULT NULL COMMENT 'Ссылка на идентификатор замещаемой должности',
	`tc_policy_id` int DEFAULT NULL COMMENT 'Ссылка на идентификатор применяемой политики учета рабочего времени',
	`access_code` bigint unsigned NOT NULL UNIQUE COMMENT 'Код доступа',
	`is_dismissed` bool NOT NULL DEFAULT false COMMENT 'Работник уволен?',
	`dismissal_reason_id` int DEFAULT NULL COMMENT 'Ссылка на идентификатор причины увольнения',
	`dismissal_date` DATE DEFAULT NULL COMMENT 'Дата увольнения',
	`photo` mediumblob COMMENT 'Фотография работника',
	PRIMARY KEY (`id`),
	CONSTRAINT `employees_fk1` FOREIGN KEY (`position_id`) REFERENCES `positions`(`id`),
	CONSTRAINT `employees_fk2` FOREIGN KEY (`tc_policy_id`) REFERENCES `time_control_policies`(`id`),
	CONSTRAINT `employees_fk3` FOREIGN KEY (`dismissal_reason_id`) REFERENCES `dismissal_reasons`(`id`)
);

/* Справочник структурных подразделений */
CREATE TABLE IF NOT EXISTS `organizational_units` (
	`id` int NOT NULL AUTO_INCREMENT,
	`organization_id` int NOT NULL COMMENT 'Ссылка на идентификатор организации',
	`higher_level_id` int COMMENT 'Ссылка на идентификатор вышестоящего структурного подразделения',
	`name` varchar(255) NOT NULL COMMENT 'Наименование структурного подразделения',
	`chief_id` int NOT NULL COMMENT 'Ссылка на идентификатор руководителя подразделения',
	`start_time` TIME NOT NULL DEFAULT '9:00:00' COMMENT 'Время начала работы структурного подразделения',
	`end_time` TIME NOT NULL DEFAULT '18:15:00' COMMENT 'Время окончания работы структурного подразделения',
	PRIMARY KEY (`id`),
	CONSTRAINT `organizational_units_fk0` FOREIGN KEY (`organization_id`) REFERENCES `organizations`(`id`),
	CONSTRAINT `organizational_units_fk1` FOREIGN KEY (`higher_level_id`) REFERENCES `organizational_units`(`id`),
	CONSTRAINT `organizational_units_fk2` FOREIGN KEY (`chief_id`) REFERENCES `employees`(`id`)
);

ALTER TABLE `employees` ADD CONSTRAINT `employees_fk0` FOREIGN KEY (`unit_id`) REFERENCES `organizational_units`(`id`);

/* Перенос выходных дней */
CREATE TABLE IF NOT EXISTS `weekend_shift` (
	`id` int NOT NULL AUTO_INCREMENT,
	`old_date` DATE NOT NULL UNIQUE,
	`new_date` DATE NOT NULL UNIQUE,
	`comment` TEXT,
	PRIMARY KEY (`id`)
);

/* Справочник праздничных дней */
CREATE TABLE IF NOT EXISTS `holidays` (
	`id` int NOT NULL AUTO_INCREMENT,
	`day` tinyint unsigned NOT NULL COMMENT 'Число месяца',
	`month` tinyint unsigned NOT NULL COMMENT 'Номер месяца',
	`name` varchar(64) NOT NULL COMMENT 'Наименование праздничного дня',
	`brief` varchar(5) NOT NULL COMMENT 'Сокращение',
	PRIMARY KEY (`id`)
);

/* Справочник типов интервалов времени графика работ */
CREATE TABLE IF NOT EXISTS `time_interval_types` (
	`id` int NOT NULL AUTO_INCREMENT,
	`letter_code` varchar(2) NOT NULL UNIQUE COMMENT 'Буквенный код',
	`name` varchar(64) NOT NULL UNIQUE COMMENT 'Наименование',
	`description` varchar(255) COMMENT 'Описание',
	`start_time` TIME COMMENT 'Время начала',
	`end_time` TIME COMMENT 'Время окончания',
	PRIMARY KEY (`id`)
);

/* График работы сотрудников */ 
CREATE TABLE IF NOT EXISTS `work_schedule` (
	`id` int NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор периода',
	`employee_id` int NOT NULL COMMENT 'Ссылка на идентификатор сотрудника',
	`period_start` DATE NOT NULL COMMENT 'Дата начала периода действия, например, 01.01.2023',
	`period_end` DATE NOT NULL COMMENT 'Дата окончания периода действия, например, 31.01.2023',
	`days_set` json NOT NULL COMMENT 'Дни недели и типы дней, учитываемые при формировании графика',
/* Поле days_set задается в формате JSON:
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
	`time_interval_type_id` int NOT NULL COMMENT 'Ссылка на идентификатор типа интервала',
	`work_intervals` json COMMENT 'Рабочие интервалы в периоде',
/* Поле work_intervals задается в формате JSON:
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

/* Отсутствия на работе */
CREATE TABLE IF NOT EXISTS `absense` (
	`id` int NOT NULL AUTO_INCREMENT,
	`employee_id` int NOT NULL COMMENT 'Ссылка на идентификатор работника',
	`absense_type` int NOT NULL COMMENT 'Ссылка на идентификатор типа интервала',
	`period_start` DATE NOT NULL COMMENT 'Начало периода отсутствия',
	`period_end` DATE NOT NULL COMMENT 'Окончание периода отсутствия',
	`in_shift_time` TIME COMMENT 'Продолжительность внутри смены',
	PRIMARY KEY (`id`),
	CONSTRAINT `absense_fk0` FOREIGN KEY (`employee_id`) REFERENCES `employees`(`id`),
	CONSTRAINT `absense_fk1` FOREIGN KEY (`absense_type`) REFERENCES `time_interval_types`(`id`)
);

/* Справочник EAM-клиентов */
CREATE TABLE IF NOT EXISTS `eam_clients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL COMMENT 'UUID-код ЕАМ-клиента',
  `host_ip` decimal(10,0) NOT NULL COMMENT 'IP-адрес хоста, на котором установлен ЕАМ-клиент',
  `hostname` varchar(64) COMMENT 'Наименование хоста, на котором установлен ЕАМ-клиент',
  PRIMARY KEY (`id`)
);

/* Фактически учтенное время */
CREATE TABLE IF NOT EXISTS `actual_time` (
	`id` int NOT NULL AUTO_INCREMENT,
	`empolyee_id` int NOT NULL COMMENT 'Ссылка на идентификатор работника',
	`eam_client_id` int NOT NULL COMMENT 'Ссылка на идентификатор ЕАМ-клиента',
	`interval_start` DATETIME NOT NULL COMMENT 'Начало учтенного интервала времени',
	`interval_end` DATETIME NOT NULL  COMMENT 'Окончание учтенного интервала времени',
	`time_interval_type_id` int NOT NULL COMMENT 'Ссылка на идентификатор типа интервала',
	PRIMARY KEY (`id`),
	CONSTRAINT `actual_time_fk0` FOREIGN KEY (`empolyee_id`) REFERENCES `employees`(`id`),
	CONSTRAINT `actual_time_fk1` FOREIGN KEY (`time_interval_type_id`) REFERENCES `time_interval_types`(`id`),
	CONSTRAINT `actual_time_fk2` FOREIGN KEY (`eam_client_id`) REFERENCES `eam_clients` (`id`)
);

/* Настройки системы */
CREATE TABLE IF NOT EXISTS `configuration` (
	`parameter` varchar(255) NOT NULL COMMENT 'Параметр настройки системы',
	`value` varchar(255) NOT NULL COMMENT 'Значение параметра',
	PRIMARY KEY (`parameter`)
);

/* Пользователи системы */
CREATE TABLE IF NOT EXISTS `users` (
	`id` int NOT NULL AUTO_INCREMENT,
	`status` tinyint unsigned NOT NULL COMMENT 'Статус пользователя',
/* Статус пользователя может принимать следующие значения:
*	'0' - удален;
*	'10 - заблокирован; 
*	'20' - ожидает подтверждения;
*	'30' - активен; 
*/	
	`login` varchar(50) UNIQUE COMMENT 'Логин пользователя',
	`password_hash` varchar(255) COMMENT 'Хэш пароля пользователя',
	`password_reset_token` varchar(255) UNIQUE COMMENT 'Токен сброса пароля пользователя',
	`name` varchar(255) NOT NULL COMMENT 'ФИО пользователя',
	`email` varchar(255) UNIQUE COMMENT 'Электронный почтовый адрес пользователя',
	`email_confirm_token` varchar(255) COMMENT 'Токен подтверждения электронной почты пользователя',
	`employee_id` int COMMENT 'Ссылка на идентификатор работника',
	PRIMARY KEY (`id`),
	CONSTRAINT `users_fk0` FOREIGN KEY (`employee_id`) REFERENCES `employees`(`id`),
	CONSTRAINT `users_status_chk1` CHECK (status in (0, 10, 20, 30))
);

/* Справочник событий системы */
CREATE TABLE IF NOT EXISTS `event_type` (
	`id` int NOT NULL AUTO_INCREMENT,
	`name` varchar(255) NOT NULL UNIQUE COMMENT 'Наименование типа события',
	`description` text NOT NULL COMMENT 'Описание типа события',
	PRIMARY KEY (`id`)
);

/* Журнал событий системы */
CREATE TABLE IF NOT EXISTS `event_log` (
	`id` int NOT NULL AUTO_INCREMENT,
	`datetime` DATETIME NOT NULL COMMENT 'Дата и время события',
	`event_type_id` int NOT NULL COMMENT 'Ссылка на идентификатор типа события',
	`user_id` int COMMENT 'Ссылка на идентификатор пользователя, инициировавшего возникнование события',
	`description` TEXT COMMENT 'Описание события',
	`host_ip` numeric NOT NULL COMMENT 'IP-адрес хоста, на котором было инициировано возникновение события',
	`hostname` varchar(64) COMMENT 'Наименование хоста, на котором было инициировано возникновение события',
	PRIMARY KEY (`id`),
	CONSTRAINT `event_log_fk0` FOREIGN KEY (`event_type_id`) REFERENCES `event_type`(`id`),
	CONSTRAINT `event_log_fk1` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
);

/* Справочник ролей пользователей */
CREATE TABLE IF NOT EXISTS `roles` (
	`name` varchar(64) NOT NULL COMMENT 'Наименование роли',
	PRIMARY KEY (`name`)
);

/* Назначенные пользователям системы роли */
CREATE TABLE IF NOT EXISTS `roles_assignment` (
	`user_id` int NOT NULL COMMENT 'Ссылка на идентификатор пользователя',
	`role_name` varchar(64) NOT NULL COMMENT 'Ссылка на наименование роли',
	PRIMARY KEY (`user_id`,`role_name`),
	CONSTRAINT `roles_assignment_fk0` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
	CONSTRAINT `roles_assignment_fk1` FOREIGN KEY (`role_name`) REFERENCES `roles`(`name`)
);

/* Права доступа к объектам системы */ 
CREATE TABLE IF NOT EXISTS `access_rights` (
	`name` varchar(64) NOT NULL COMMENT 'Наименование',
	`description` TEXT COMMENT 'Описание',
	PRIMARY KEY (`name`)
);

/* Назначенные ролям права доступа к объектам системы */
CREATE TABLE IF NOT EXISTS `access_assignment` (
	`right_name` varchar(64) NOT NULL,
	`role_name` varchar(64) NOT NULL,
	PRIMARY KEY (`right_name`,`role_name`),
	CONSTRAINT `access_assignment_fk0` FOREIGN KEY (`right_name`) REFERENCES `access_rights`(`name`),
	CONSTRAINT `access_assignment_fk1` FOREIGN KEY (`role_name`) REFERENCES `roles`(`name`)
);

/* Справочник типов приложений */
CREATE TABLE IF NOT EXISTS `application_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'Наименование типа приложения',
  `description` text NOT NULL COMMENT 'Описание типа приложения',
  PRIMARY KEY (`id`)  
);

/* Справочник пользовательских приложений */
CREATE TABLE IF NOT EXISTS `applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL COMMENT 'UUID-код приложения',
  `name` varchar(255) NOT NULL COMMENT 'Наименование приложения',
  `description` text NOT NULL COMMENT 'Описание приложения',
  `type_id` int NOT NULL COMMENT 'Ссылка на идентификатор типа приложения',
  PRIMARY KEY (`id`),
  CONSTRAINT `applications_fk0` FOREIGN KEY (`type_id`) REFERENCES `application_types` (`id`)
);

/* Справочник категорий URI */
CREATE TABLE IF NOT EXISTS `uri_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL COMMENT 'Наименование категории URI',
  `description` text COMMENT 'Описание категории URI',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
);

/* Справочник шаблонов URI */
CREATE TABLE IF NOT EXISTS `uri_patterns` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pattern` varchar(512) NOT NULL COMMENT 'Шаблон URI',
  `uri_type_id` int NOT NULL COMMENT 'Ссылка на идентификатор категории URI',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pattern` (`pattern`),
  CONSTRAINT `uri_patterns_fk0` FOREIGN KEY (`uri_type_id`) REFERENCES `uri_types` (`id`)
);

INSERT INTO `dismissal_reasons` (`id`, `name`) VALUES
(1, 'перевод работника по его просьбе или с его согласия на работу к другому работодателю или переход на выборную работу (должность)'),
(2, 'отказ работника от продолжения работы в связи со сменой собственника имущества организации, с изменением подведомственности (подчиненности) организации либо ее реорганизацией, с изменением типа государственного или муниципального учреждения'),
(3, 'отказ работника от продолжения работы в связи с изменением определенных сторонами условий трудового договора'),
(4, 'отказ работника от перевода на другую работу, необходимого ему в соответствии с медицинским заключением, выданным в порядке, установленном федеральными законами и иными нормативными правовыми актами, либо отсутствие у работодателя соответствующей работы'),
(5, 'отказ работника от перевода на работу в другую местность вместе с работодателем'),
(6, 'соглашение сторон'),
(7, 'истечение срока трудового договора'),
(8, 'по инициативе работника (по собственному желанию)'),
(9, 'ликвидация организации либо прекращение деятельности индивидуальным предпринимателем'),
(10, 'сокращение численности или штата работников организации, индивидуального предпринимателя'),
(11, 'несоответствие работника занимаемой должности или выполняемой работе вследствие недостаточной квалификации, подтвержденной результатами аттестации'),
(12, 'смена собственника имущества организации (в отношении руководителя организации, его заместителей и главного бухгалтера)'),
(13, 'неоднократное неисполнение работником без уважительных причин трудовых обязанностей, если он имеет дисциплинарное взыскание'),
(14, 'прогул'),
(15, 'появление работника на работе в состоянии алкогольного, наркотического или иного токсического опьянения'),
(16, 'разглашение охраняемой законом тайны (государственной, коммерческой, служебной и иной), ставшей известной работнику в связи с исполнением им трудовых обязанностей, в том числе разглашение персональных данных другого работника'),
(17, 'совершение по месту работы хищения (в том числе мелкого) чужого имущества, растраты, умышленного его уничтожения или повреждения, установленных вступившим в законную силу приговором суда или постановлением по делу об адм. правонарушении'),
(18, 'установленное комиссией по охране труда или уполномоченным по охране труда нарушение работником требований охраны труда, если это нарушение повлекло за собой тяжкие последствия либо заведомо создавало реальную угрозу наступления таких последствий'),
(19, 'совершенияе виновных действий работником, непосредственно обслуживающим денежные или товарные ценности, если эти действия дают основание для утраты доверия к нему со стороны работодателя'),
(20, 'непринятие работником мер по предотвращению или урегулированию конфликта интересов'),
(21, 'совершение работником, выполняющим воспитательные функции, аморального проступка, несовместимого с продолжением данной работы'),
(22, 'принятие необоснованного решения руководителем организации (филиала, представительства), его заместителями и главным бухгалтером, повлекшего за собой нарушение сохранности имущества, неправомерное его использование или иной ущерб имуществу организации'),
(23, 'однократное грубое нарушение руководителем организации (филиала, представительства), его заместителями своих трудовых обязанностей'),
(24, 'представление работником работодателю подложных документов при заключении трудового договора'),
(25, 'по обстоятельствам, предусмотренным трудовым договором с руководителем организации, членами коллегиального исполнительного органа организации'),
(26, 'невыход работника на работу по истечении трех месяцев после окончания прохождения им военной службы по мобилизации или военной службы по контракту'),
(27, 'призыв работника на военную службу (за исключением призыва работника на военную службу по мобилизации) или направление его на заменяющую ее альтернативную гражданскую службу'),
(28, 'восстановление на работе работника, ранее выполнявшего эту работу, по решению государственной инспекции труда или суда'),
(29, 'неизбрание на должность'),
(30, 'осуждение работника к наказанию, исключающему продолжение прежней работы, в соответствии с приговором суда, вступившим в законную силу'),
(31, 'признание работника полностью неспособным к трудовой деятельности в соответствии с медицинским заключением, выданным в порядке, установленном федеральными законами и иными нормативными правовыми актами Российской Федерации'),
(32, 'смерть работника либо работодателя - физического лица, а также признание судом работника либо работодателя - физического лица умершим или безвестно отсутствующим'),
(33, 'наступление чрезвычайных обстоятельств, препятствующих продолжению трудовых отношений, а также призыв работодателя - физического лица на военную службу по мобилизации'),
(34, 'дисквалификация или иное административное наказание, исключающее возможность исполнения работником обязанностей по трудовому договору'),
(35, 'истечение срока действия, приостановление действия на срок более двух месяцев или лишение работника специального права, если это влечет за собой невозможность исполнения работником обязанностей по трудовому договору'),
(36, 'прекращение допуска к государственной тайне, если выполняемая работа требует такого допуска'),
(37, 'отмена решения суда или отмена (признание незаконным) решения государственной инспекции труда о восстановлении работника на работе'),
(38, 'возникновение установленных законом и исключающих возможность исполнения работником обязанностей по трудовому договору ограничений на занятие определенными видами трудовой деятельности'),
(39, 'заключение трудового договора в нарушение приговора суда о лишении конкретного лица права занимать определенные должности или заниматься определенной деятельностью'),
(40, 'заключение трудового договора на выполнение работы, противопоказанной данному работнику по состоянию здоровья в соответствии с медицинским заключением'),
(41, 'отсутствие соответствующего документа об образовании и (или) о квалификации, если выполнение работы требует специальных знаний в соответствии с федеральным законом или иным нормативным правовым актом'),
(42, 'заключение трудового договора в нарушение постановления о дисквалификации или ином административном наказании либо заключение трудового договора в нарушение установленных законами ограничений'),
(43, 'заключение трудового договора в нарушение установленных законом ограничений на занятие определенными видами трудовой деятельности');

INSERT INTO `holidays` (`id`, `day`, `month`, `name`, `brief`) VALUES
(1, 1, 1, 'Новогодние каникулы', 'НГ'),
(2, 2, 1, 'Новогодние каникулы', 'НГ'),
(3, 3, 1, 'Новогодние каникулы', 'НГ'),
(4, 4, 1, 'Новогодние каникулы', 'НГ'),
(5, 5, 1, 'Новогодние каникулы', 'НГ'),
(6, 6, 1, 'Новогодние каникулы', 'НГ'),
(7, 7, 1, 'Рождество Христово', 'РХ'),
(8, 8, 1, 'Новогодние каникулы', 'НГ'),
(9, 23, 2, 'День защитника Отечества', 'ДЗО'),
(10, 8, 3, 'Международный женский день', 'МЖД'),
(11, 1, 5, 'Праздник Весны и Труда', 'ПВТ'),
(12, 9, 5, 'День Победы', 'ДП'),
(13, 12, 6, 'День России', 'ДР'),
(14, 4, 11, 'День народного единства', 'ДНЕ');

INSERT INTO `time_interval_types` (`id`, `letter_code`, `name`, `description`, `start_time`, `end_time`) VALUES
(1, 'Я', 'Явка', 'Продолжительность работы в дневное время', NULL, NULL),
(2, 'Н', 'Ночь', 'Продолжительность работы в ночное время', NULL, NULL),
(3, 'РВ', 'Праздники', 'Продолжительность работы в выходные и нерабочие, праздничные дни', NULL, NULL),
(4, 'С', 'Сверхурочно', 'Продолжительность сверхурочной работы', NULL, NULL),
(5, 'ВМ', 'Вахта', 'Продолжительность работы вахтовым методом', NULL, NULL),
(6, 'К', 'Командировка', 'Продолжительность работы во время командировки', NULL, NULL),
(7, 'ПК', 'Повышение квалификации с отрывом от работы', 'Повышение квалификации с отрывом от работы', NULL, NULL),
(8, 'ПМ', 'Повышение квалификации с отрывом от работы в другой местности', 'Повышение квалификации с отрывом от работы в другой местности', NULL, NULL),
(9, 'ОТ', 'Отпуск', 'Ежегодный основной оплачиваемый отпуск', NULL, NULL),
(10, 'ОД', 'Доп. отпуск', 'Ежегодный дополнительный оплачиваемый отпуск', NULL, NULL),
(11, 'У', 'Учебный отпуск', 'Учебный отпуск с сохранением заработной платы', NULL, NULL),
(12, 'УВ', 'Сокр. время обучающихся без отрыва от производства', 'Сокращенная продолжительность рабочего времени для работников, обучающихся без отрыва от производства с частичным сохранением заработной платы', NULL, NULL),
(13, 'УД', 'Учебный отпуск за свой счет', 'Учебный отпуск без сохранения заработной платы', NULL, NULL),
(14, 'Р', 'Отпуск по беременности и родам', 'Отпуск по беременности и родам или в связи с усыновлением новорожденного ребенка', NULL, NULL),
(15, 'ОЖ', 'Отпуск по уходу за ребенком', 'Отпуск по уходу за ребенком до достижения трехлетнего возраста', NULL, NULL),
(16, 'ДО', 'Отпуск за свой счет', 'Отпуск без сохранения заработной платы с разрешения работодателя', NULL, NULL),
(17, 'ОЗ', 'Отпуск за свой счет (ветераны, инвалиды)', 'Отпуск за свой счет при условиях, предусмотренных законом', NULL, NULL),
(18, 'ДБ', 'Ежегодный доп. отпуск без сохранения зарплаты', 'Ежегодный дополнительный отпуск без сохранения заработной платы', NULL, NULL),
(19, 'Б', 'Больничный', 'Временная нетрудоспособность (кроме бытовых трав, отпуска по уходу за больными и по карантину)', NULL, NULL),
(20, 'Т', 'Травма', 'Временная нетрудоспособность в связи с бытовой травмой, отпуском по уходу за больными и по карантину', NULL, NULL),
(21, 'ЛЧ', 'Сокращенное рабочее время в соответствии с законом', 'Сокращенная продолжительность рабочего времени в случаях, предусмотренных законодательством', NULL, NULL),
(22, 'ПВ', 'Вынужденный прогул', 'Время вынужденного прогула в связи с связи с признанием увольнения, перевода на другую работу или отстранения от работы незаконными с восстановлением на прежней работе', NULL, NULL),
(23, 'Г', 'Исполнение государственных или общественных обязанностей', 'Невыходы на работу во время исполнения государственных или общественных обязанностей', NULL, NULL),
(24, 'ПР', 'Прогул', 'Прогулы', NULL, NULL),
(25, 'НС', 'Работа в режиме неполного рабочего времени', 'Продолжительность работы в режиме неполного рабочего времени по инициативе работодателя', NULL, NULL),
(26, 'В', 'Выходной (праздник)', 'Выходные и нерабочие праздничные дни', NULL, NULL),
(27, 'ОВ', 'Доп. выходной', 'Дополнительные выходные (оплачиваемые)', NULL, NULL),
(28, 'НВ', 'Доп. выходной (без сохр. зарплаты)', 'Дополнительные выходные дни (без сохранения заработной платы)', NULL, NULL),
(29, 'ЗБ', 'Забастовка', 'Забастовка', NULL, NULL),
(30, 'НН', 'Неявка', 'Неявка по невыясненным причинам (до выяснения обстоятельств)', NULL, NULL),
(31, 'РП', 'Простой по вине работодателя', 'Время простоя по вине работодателя', NULL, NULL),
(32, 'НП', 'Простой', 'Время простоя по причинам, не зависящим от от работодателя и работника', NULL, NULL),
(33, 'ВП', 'Простой по вине работника', 'Время простоя по вине работника', NULL, NULL),
(34, 'НО', 'Отстранение от работы с оплатой', 'Время отстранения от работы (недопущение к работе) с оплатой', NULL, NULL),
(35, 'НБ', 'Отстранение от работы без оплаты', 'Отстранение от работы (недопущение к работе) без оплаты', NULL, NULL),
(36, 'НЗ', 'Приостановка работы при задержке зарплаты', 'Время приостановки работы при задержке оплаты труда.', NULL, NULL);

INSERT INTO `weekend_shift` (`id`, `old_date`, `new_date`, `comment`) VALUES
(1, '2023-01-01', '2023-02-24', 'Постановление Правительства РФ от 29.08.2022 N 1505 \"О переносе выходных дней в 2023 году\"'),
(2, '2023-01-08', '2023-05-08', 'Постановление Правительства РФ от 29.08.2022 N 1505 \"О переносе выходных дней в 2023 году\"');
