/**
 * 20_init.sql - скрипт заполнения тестовыми данными
 *
 * Copyright (c) 2022-2023, Pavel Krasnozhon <kpv.gov.karelia@yandex.ru>
 *
 * This code is licensed under a MIT-style license.
 */

CREATE USER 'tli'@'%' identified by 'tli';

GRANT ALL ON `tli`.* TO `tli`@`%`;

USE `tli`;

INSERT INTO `employees` (`id`, `surname`, `name`, `middle_name`, `gender`, `birth_date`, `employed_at`, `unit_id`, `position_id`, `tc_policy_id`, `access_code`, `is_dismissed`, `dismissal_reason_id`, `dismissal_date`, `photo`) VALUES
(1,	'Кузнецов',	'Кирилл',	'Аркадьевич',	CONV('1', 2, 10) + 0,	'2023-06-17',	NULL,	NULL,	NULL,	NULL,	123,	0,	NULL,	NULL,	NULL);