// "Положение о правилах ведения бухгалтерского учета в кредитных организациях, расположенных на территории Российской Федерации"
// (утв. Банком России 16.07.2012 N 385-П)
// "Положение о плане счетов бухгалтерского учета для кредитных организаций и порядке его применения"
// (утв. Банком России 27.02.2017 N 579-П)

#Область ПланСчетовКредитныхОрганизаций
// - План счетов бухгалтерского учета в кредитных организациях

Функция БалансовыйСчет(НомерСчета) Экспорт
	
	Возврат Лев(НомерСчета, 5);
	
КонецФункции

Функция ТипНомерБалансовогоСчета() Экспорт
	
	Возврат Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(5));
	
КонецФункции

Функция СчетПозволяетИдентифицироватьКонтрагента(НомерСчета) Экспорт
	
	// В функцию на вход может прийти как полный номер счета, так и уже выделенный Балансовый счет.
	// В случае полного номера счета отдельно выделяем признак лицевого счета,
	// во втором случае это не требуется.
	
	ПризнакЛицевогоСчета = "";
	Если СтрокаСоответствуетФорматуБанковскогоСчета(НомерСчета) Тогда
		БалансовыйСчет = БалансовыйСчет(НомерСчета);
		ПризнакЛицевогоСчета = Сред(НомерСчета, 14, 1);
	Иначе
		БалансовыйСчет = НомерСчета;
	КонецЕсли;
	
	// Счета, перечисленные
	// - в разделе 4 "Операции с клиентами" Плана счетов,
	//   за исключением счетов, порядок использования которых не позволяет обеспечить
	//   раздельный учет операций с разными хозяйствующими субъектами на разных лицевых счетах
	// - в разделах 6 и 7 Плана счетов (позволяют идентифицировать банк как участника хозяйственных операций, а не
	// финансового агента)
	
	Если ЭтоСчетВнутрибанковскихОпераций(БалансовыйСчет) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Раздел = Лев(БалансовыйСчет, 1);
	
	Если Раздел <> "4" И Раздел <> "6" И Раздел <> "7" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// На некоторых счетах, предназначенных для учета средств государственного бюджета,
	// в аналитическом учете ведутся лицевые счета органов Федерального казначейства
	Если БалансовыйСчет = "40101"
		Или БалансовыйСчет = "40105"
		Или БалансовыйСчет = "40116"
		Или БалансовыйСчет = "40201"
		Или БалансовыйСчет = "40204"
		Или БалансовыйСчет = "40302"
		Или БалансовыйСчет = "40312"
		// Указание ЦБ РФ от 23 января 2018 г. N 4700-У
		Или БалансовыйСчет = "40501" И (ПризнакЛицевогоСчета = "1" Или ПризнакЛицевогоСчета = "2"
			Или ПризнакЛицевогоСчета = "5")
		Или БалансовыйСчет = "40601"
			И (ПризнакЛицевогоСчета = "1" Или ПризнакЛицевогоСчета = "2" Или ПризнакЛицевогоСчета = "3"
				Или ПризнакЛицевогоСчета = "4" Или ПризнакЛицевогоСчета = "5")
		Или БалансовыйСчет = "40701"
			И (ПризнакЛицевогоСчета = "1" Или ПризнакЛицевогоСчета = "2" Или ПризнакЛицевогоСчета = "3"
				Или ПризнакЛицевогоСчета = "4" Или ПризнакЛицевогоСчета = "5")
		Или БалансовыйСчет = "40503" И ПризнакЛицевогоСчета = "4"
		Или БалансовыйСчет = "40603" И ПризнакЛицевогоСчета = "4"
		Или БалансовыйСчет = "40703" И ПризнакЛицевогоСчета = "4" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// На счетах прочих операций аналитический учет может вестись по виду операций
	Если ЭтоОбязательстваПоПрочимОперациям(БалансовыйСчет) // 47422
		Или ЭтоСчетРасчетовСБанком(БалансовыйСчет) Тогда   // 47423
		Возврат Ложь;
	КонецЕсли;
	
	// На остальных счетах раздела 4 ведется аналитический учет по организациям, физическим лицам или более детальный
	Возврат Истина;
	
КонецФункции

Функция ЭтоСчетЮридическогоЛица(БалансовыйСчет) Экспорт
	
	// 401 - Средства федерального бюджета
	// 402 - Средства бюджетов субъектов Российской Федерации и местных бюджетов
	// 403 - Прочие средства бюджетов
	// 404 - Средства государственных и других внебюджетных фондов
	// 405 - Счета организаций, находящихся в федеральной собственности
	// 406 - Счета организаций, находящихся в государственной (кроме федеральной) собственности
	// 407 - Счета негосударственных организаций
	
	НомерСчетаПервогоПорядка = Лев(БалансовыйСчет, 3);
	
	Возврат НомерСчетаПервогоПорядка = "401"
		Или НомерСчетаПервогоПорядка = "402"
		Или НомерСчетаПервогоПорядка = "403"
		Или НомерСчетаПервогоПорядка = "404"
		Или НомерСчетаПервогоПорядка = "405"
		Или НомерСчетаПервогоПорядка = "406"
		Или ЭтоСчетНегосударственныхОрганизаций(БалансовыйСчет);
	
КонецФункции

Функция ЭтоСчетНегосударственныхОрганизаций(БалансовыйСчет) Экспорт
	
	НомерСчетаПервогоПорядка = Лев(БалансовыйСчет, 3);
	
	Возврат НомерСчетаПервогоПорядка = "407"; // Счета негосударственных организаций
	
КонецФункции

Функция ЭтоПрочийСчет(БалансовыйСчет) Экспорт
	
	НомерСчетаПервогоПорядка = Лев(БалансовыйСчет, 3);
	
	Возврат НомерСчетаПервогоПорядка = "408"; // Прочие счета
	
КонецФункции

Функция ЭтоСчетИндивидуальногоПредпринимателя(БалансовыйСчет) Экспорт
	
	// Счет - "Физические лица - индивидуальные предприниматели"
	Возврат БалансовыйСчет = "40802";
	
КонецФункции

Функция ЭтоСчетПереводовФизическимЛицам(БалансовыйСчет) Экспорт
	
	// 40817 - "Физические лица" - "Назначение счета - учет денежных средств физических лиц, не связанных с осуществлением
	//                             ими предпринимательской деятельности"
	// Как правило, лицевые счета открываются физическим лицам.
	// Но могут быть открыты и организациям - для учета средств, направленных на выплаты физическим лицам.
	// 40820 - "Счета физических лиц - нерезидентов"
	
	Возврат БалансовыйСчет = "40817" Или БалансовыйСчет = "40820";
	
КонецФункции

Функция ЭтоСчетДепозитовФизическихЛиц(БалансовыйСчет) Экспорт
	
	// 423   - Депозиты и прочие привлеченные средства физических лиц
	
	Возврат Лев(БалансовыйСчет, 3) = "423";
	
КонецФункции

Функция ЭтоКассаКредитнойОрганизации(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "20202"; // "Касса кредитных организаций"
	
КонецФункции

Функция ЭтоСчетКассыКредитнойОрганизации(БалансовыйСчет) Экспорт
	
	Возврат ЭтоКассаКредитнойОрганизации(БалансовыйСчет)
		Или БалансовыйСчет = "20208"; // "Денежные средства в банкоматах и платежных терминалах"
	
КонецФункции

Функция ЭтоСчетБанковскогоПлатежногоАгента(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "40821" // Специальный банковский счет платежного агента, банковского платежного агента (субагента), поставщика
	
КонецФункции

Функция ЭтоСчетИнкассированныхНаличныхДенег(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "40906" // "Инкассированные наличные деньги"
	
КонецФункции

Функция ЭтоСчетДоходовБанка(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "70601" // Доходы (банка)
		Или БалансовыйСчет = "61301" // Доходы (банка) будущих периодов по кредитным операциям
		Или БалансовыйСчет = "61304"; // Доходы (банка) будущих периодов по другим операциям

КонецФункции

Функция ЭтоРасчетыПоПереводамДенежныхСредств(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "40911"; // Расчеты по переводам денежных средств
	
КонецФункции

Функция ЭтоОбязательстваПоПрочимОперациям(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "47422"; // Обязательства по прочим операциям
	
КонецФункции

Функция ЭтоСчетРасчетовСБанком(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "47423"; // Требования по прочим операциям - "отражаются требования кредитной организации"
	
КонецФункции

Функция ЭтоРасчетыПоВыданнымБанковскимГарантиям(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "47502"; // Расчеты по выданным банковским гарантиям
	
КонецФункции

Функция ЭтоСчетВнутрибанковскихОпераций(БалансовыйСчет) Экспорт
	
	Раздел = Лев(БалансовыйСчет, 1);
	
	Возврат Раздел = "6" Или Раздел = "7";
	
КонецФункции

Функция ЭтоСчетВнутрибанковскихОперацийНДС(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "60309"; // Налог на добавленную стоимость, полученный
	
КонецФункции

Функция ЭтоВнутрибанковскиеРасчетыСПрочимиКредиторами(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "60322"; // Расчеты с прочими кредиторами
	
КонецФункции

Функция ЭтоСчетНезавершенныхРасчетов3023Актив(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30233"; // незавершенные расчеты с операторами услуг платежной инфраструктуры и операторами по переводу денежных средств
	
КонецФункции

Функция ЭтоСчетНезавершенныхРасчетов3023Пассив(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30232"; // незавершенные расчеты с операторами услуг платежной инфраструктуры и операторами по переводу денежных средств
	
КонецФункции

Функция ЭтоСчетНезавершенныхРасчетов3022Пассив(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30222"; // незавершенные переводы и расчеты кредитной организации
	
КонецФункции

Функция ЭтоСчетНезавершенныхРасчетов302(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30221" // незавершенные переводы и расчеты кредитной организации (Актив)
		Или ЭтоСчетНезавершенныхРасчетов3022Пассив(БалансовыйСчет)
		Или БалансовыйСчет = "30223"  // Незавершенные переводы и расчеты по банковским счетам клиентов при осуществлении расчетов через подразделения Банка России
		Или ЭтоСчетНезавершенныхРасчетов3023Актив(БалансовыйСчет)
		Или ЭтоСчетНезавершенныхРасчетов3023Пассив(БалансовыйСчет)
		Или БалансовыйСчет = "30236"; // Незавершенные переводы, поступившие от платежных систем и на корреспондентские счета
	
КонецФункции

Функция ЭтоСчетНезавершенныхРасчетов(БалансовыйСчет) Экспорт
	
	Возврат ЭтоСчетНезавершенныхРасчетов302(БалансовыйСчет)
		Или ЭтоОбязательстваПоПрочимОперациям(БалансовыйСчет)
		Или ЭтоСчетРасчетовСБанком(БалансовыйСчет) // Требования по прочим операциям
		Или БалансовыйСчет = "40907"  // Расчеты клиентов по зачетам
		Или БалансовыйСчет = "40911"; // Расчеты по переводам денежных средств
	
КонецФункции

Функция ЭтоСчетРасчетовПоФакторингу(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "47401"  // Расчеты с клиентами по факторинговым операциям
		Или БалансовыйСчет = "47402"; // Расчеты с клиентами по факторинговым операциям
	
КонецФункции

Функция ЭтоСчетВнутрибанковскиеТребованияПоПереводамКлиентов(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30302"; // Внутрибанковские требования по переводам клиентов
	
КонецФункции

Функция ЭтоСчетРасчетовФилиалаБанкаСКлиентамиБанка(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30301"  // Внутрибанковские обязательства по переводам клиентов
		Или ЭтоСчетВнутрибанковскиеТребованияПоПереводамКлиентов(БалансовыйСчет);
	
КонецФункции

Функция ЭтоСчетРасчетовВнутрибанковскиеРаспределения(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30305"  // Внутрибанковские обязательства по распределению (перераспределению) активов, обязательств, капитала
		Или БалансовыйСчет = "30306"; // Внутрибанковские требования по распределению (перераспределению) активов, обязательств, капитала
	
КонецФункции

Функция ЭтоКорСчетКредитныхОрганизацийКорреспондентов(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30109"; // Корреспондентские счета кредитных организаций - корреспондентов
	
КонецФункции

Функция ЭтоКорсчетВКредитнойОрганизацииКорреспонденте(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30110"; // Корреспондентские счета в кредитных организациях - корреспондентах
	
КонецФункции

Функция ЭтоКорсчетБанкаНерезидента(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "30111"; // "Корреспондентские счета банков-нерезидентов"
	
КонецФункции

Функция ЭтоСчетКредитаБанка(БалансовыйСчет) Экспорт
	
	// Кредит, предоставленный при недостатке средств на расчетном (текущем) счете ("овердрафт").
	Возврат БалансовыйСчет = "45201";
	
КонецФункции

Функция ЭтоСчетКредитаБанкаНаСрокДо30Дней(БалансовыйСчет) Экспорт
	
	// Кредиты, предоставленные негосударственным коммерческим организациям на срок до 30 дней.
	Возврат БалансовыйСчет = "45203";
	
КонецФункции

Функция ЭтоСчетКредитаБанкаНаСрокДо90Дней(БалансовыйСчет) Экспорт
	
	// Кредиты, предоставленные негосударственным коммерческим организациям на срок от 31 до 90 дней.
	Возврат БалансовыйСчет = "45204";
	
КонецФункции

Функция ЭтоСчетКредитаБанкаНаСрокДо180Дней(БалансовыйСчет) Экспорт
	
	// Кредиты, предоставленные негосударственным коммерческим организациям на срок  91 до до 180 дней.
	Возврат БалансовыйСчет = "45205";
	
КонецФункции

Функция ЭтоСчетКредитаБанкаНаСрокДоГода(БалансовыйСчет) Экспорт
	
	// Кредиты, предоставленные негосударственным коммерческим организациям на срок на срок от 181 дня до 1 года.
	Возврат БалансовыйСчет = "45206";
	
КонецФункции

Функция ЭтоСчетКредитаБанкаНаСрокДо3Лет(БалансовыйСчет) Экспорт
	
	// Кредиты, предоставленные негосударственным коммерческим организациям на срок от 1 года до 3 лет.
	Возврат БалансовыйСчет = "45207";
	
КонецФункции

Функция ЭтоСчетКредитаБанка401(БалансовыйСчет) Экспорт
	
	// Кредит, предоставленный при недостатке средств на расчетном (текущем) счете ("овердрафт").
	Возврат БалансовыйСчет = "45401";
	
КонецФункции

Функция ЭтоСчетКредитаБанка403НаСрокДо30Дней(БалансовыйСчет) Экспорт
	
	// Кредиты, предоставленные негосударственным коммерческим организациям на срок до 30 дней.
	Возврат БалансовыйСчет = "45403";
	
КонецФункции

Функция ЭтоСчетКредитаБанка404НаСрокДо90Дней(БалансовыйСчет) Экспорт
	
	// Кредиты, предоставленные негосударственным коммерческим организациям на срок от 31 до 90 дней.
	Возврат БалансовыйСчет = "45404";
	
КонецФункции

Функция ЭтоСчетКредитаБанка405НаСрокДо180Дней(БалансовыйСчет) Экспорт
	
	// Кредиты, предоставленные негосударственным коммерческим организациям на срок  91 до до 180 дней.
	Возврат БалансовыйСчет = "45405";
	
КонецФункции

Функция ЭтоСчетКредитаБанка406НаСрокДоГода(БалансовыйСчет) Экспорт
	
	// Кредиты, предоставленные негосударственным коммерческим организациям на срок на срок от 181 дня до 1 года.
	Возврат БалансовыйСчет = "45406";
	
КонецФункции

Функция ЭтоСчетКредитаБанка407НаСрокДо3Лет(БалансовыйСчет) Экспорт
	
	// Кредиты, предоставленные негосударственным коммерческим организациям на срок от 1 года до 3 лет.
	Возврат БалансовыйСчет = "45407";
	
КонецФункции

Функция ЭтоСчетКредитаБанка408НаСрокСвыше3Лет(БалансовыйСчет) Экспорт
	
	// Кредиты, предоставленные негосударственным коммерческим организациям на срок свыше 3 лет.
	Возврат БалансовыйСчет = "45408";
	
КонецФункции

Функция ЭтоСчетПросроченногоКредита(БалансовыйСчет) Экспорт
	
	// Просроченная задолженность по предоставленным кредитам и прочим размещенным средствам
	// негосударственным коммерческим организациям.
	Возврат БалансовыйСчет = "45812";
	
КонецФункции

Функция ЭтоСчетПроцентовПоПросроченномуКредиту(БалансовыйСчет) Экспорт
	
	// Просроченные проценты по предоставленным кредитам и прочим размещенным средствам
	// негосударственным коммерческим организациям.
	Возврат БалансовыйСчет = "45912";
	
КонецФункции

Функция ЭтоСчетПроцентовПоПросроченномуКредитуИП(БалансовыйСчет) Экспорт
	
	// Просроченные проценты по предоставленным кредитам и прочим размещенным средствам
	// Индивидуальным предпринимателям.
	Возврат БалансовыйСчет = "45914";
	
КонецФункции

Функция ЭтоСчетПроцентовПоКредиту(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "47427"; // Начисленные проценты по предоставленным (размещенным) денежным средствам.
	
КонецФункции

Функция ЭтоСчетКомиссииПоКредитуДепозиту(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "47443"; // Расчеты по прочим доходам, связанным с предоставлением (размещением) денежных средств
	
КонецФункции

Функция ЭтоРасчетыПоПроцентамПоРазмещеннымДенСредствам(БалансовыйСчет) Экспорт
	
	Возврат БалансовыйСчет = "47444"; // Расчеты по процентам по предоставленным (размещенным) денежным средствам
	
КонецФункции

// Возвращает балансовый счет (первые 5 цифр) Единого казначейского счета (ЕКС).
//
Функция БалансовыйСчетЕКС() Экспорт
	
	// 40102 - Единый казначейский счет, открытый Казначейству России.
	
	Возврат "40102";
	
КонецФункции

#КонецОбласти

#Область ЛицевыеСчета

Функция ТипНомерСчета() Экспорт
	
	Возврат Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(ДлинаНомераСчета()));
	
КонецФункции

Функция СтрокаСоответствуетФорматуБанковскогоСчета(Строка) Экспорт
	
	Если Не ПроверитьДлинуНомераСчета(Строка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Проверяем особый случай: алфавитный символ в номере счета
	
	ЗаведомоЦифровыеСимволы = Лев(Строка, 5) + Сред(Строка, 7);
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЗаведомоЦифровыеСимволы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	АлфавитныйСимвол = Сред(Строка, 6, 1);
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(АлфавитныйСимвол) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ЦифраШестогоРазряда = СтрНайти(ДопустимыеАлфавитныеСимволыНомераБанковскогоСчета(), АлфавитныйСимвол);
	Возврат ЦифраШестогоРазряда <> Неопределено;
	
КонецФункции

Функция ДопустимыеАлфавитныеСимволыНомераБанковскогоСчета() Экспорт
	// Символы приведены в порядке, определенном письмом ЦБР от 8 сентября 1997 г. N 515
	// См. также ПроверитьКонтрольныйКлючВНомереБанковскогоСчета()
	Возврат "ABCEHKMPTX";
КонецФункции

Функция ПроверитьКонтрольныйКлючВНомереБанковскогоСчета(Знач НомерСчета, Знач БИК, Знач СтрокаСоответствуетФормату = Неопределено) Экспорт
	
	// Письмо ЦБР от 8 сентября 1997 г. N 515
	
	Если СтрокаСоответствуетФормату = Неопределено Тогда
		СтрокаСоответствуетФормату = СтрокаСоответствуетФорматуБанковскогоСчета(НомерСчета);
	КонецЕсли;
	
	Если Не СтрокаСоответствуетФормату Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ПроверитьДлинуБИК(БИК) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ПроверитьДлинуНомераСчета(НомерСчета) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ЭтоБИКТОФК(БИК) И ЭтоКазначейскийСчет(НомерСчета) Тогда
		// Ключевание не предусмотрено.
		Возврат Истина;
	КонецЕсли;
	
	// 2. Для расчета контрольного ключа используется совокупность двух реквизитов - 
	// условного номера РКЦ (если лицевой счет открыт в РКЦ)
	// или кредитной организации (если лицевой счет открыт в кредитной организации)
	// и номера лицевого счета.
	
	// 3. Значение трехзначного условного номера РКЦ соответствует разрядам 5 и 6 
	// банковского идентификационного кода (БИК), дополненным слева нулем до трех разрядов.
	// 4. Значение условного номера кредитной организации соответствует разрядам 7, 8 и 9 БИК.
	
	Если ЭтоОтделениеЦентральногоБанка(БИК) Тогда
		УсловныйНомер = "0" + Сред(БИК, 5, 2);
	Иначе
		УсловныйНомер = Сред(БИК, 7, 3);
	КонецЕсли;
	
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(УсловныйНомер) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	//        Контрольный ключ (К)
	//        ────────────────────┐   Порядковые номера разрядов ──────┐
	//   ┌─┬─┬─┐ ┌─┬─┬─┬─┬─┬─┬─┬─┬┴┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐  │
	//   │1│2│3│ │1│2│3│4│5│6│7│8│9│10│11│12│13│14│15│16│17│18│19│20│<─┘
	//   └─┴─┴─┘ └─┴─┴─┴─┴─┴─┴─┴─┴─┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘
	//   │     │ │        Номер лицевого счета                      │
	//   │     │ └──────────────────────────────────────────────────┘
	//   │     └────────────────────────────────────────
	//   │  Условный номер РКЦ или кредитной организации
	//   └──────────────────────────────────────────────
	
	ВсеСимволы = УсловныйНомер + НомерСчета;
	ТипЧисло   = Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(1, 0, ДопустимыйЗнак.Неотрицательный));
	ПроверяемыйНаборЦифр = Новый Массив(23);
	Для НомерСимвола = 1 По 23 Цикл
		Цифра = ТипЧисло.ПривестиЗначение(Сред(ВсеСимволы, НомерСимвола, 1));
		ПроверяемыйНаборЦифр[НомерСимвола-1] = Цифра;
	КонецЦикла;
	
	// 8. При наличии алфавитного значения в 6-ом разряде лицевого счета 
	// (в случае использования клиринговой валюты) данный символ заменяется на соответствующую цифру:

	// ┌───────────────────────────────────────────┬──┬─┬─┬─┬─┬─┬─┬─┬─┬─┐
	// │Допустимое алфавитное значение 6-го разряда│ А│В│С│Е│Н│К│М│Р│Т│Х│
	// │номера лицевого счета                      │  │ │ │ │ │ │ │ │ │ │
	// ├───────────────────────────────────────────┼──┼─┼─┼─┼─┼─┼─┼─┼─┼─┤
	// │Соответствующая цифра                      │ 0│1│2│3│4│5│6│7│8│9│
	// └───────────────────────────────────────────┴──┴─┴─┴─┴─┴─┴─┴─┴─┴─┘

	// После выполнения замены расчет и проверка значения контрольного ключа производится в соответствии с п. 6 и п. 7.
	
	АлфавитныйСимвол = Сред(НомерСчета, 6, 1);
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(АлфавитныйСимвол) Тогда
		ЦифраШестогоРазряда = СтрНайти(ДопустимыеАлфавитныеСимволыНомераБанковскогоСчета(), АлфавитныйСимвол);
		Если ЦифраШестогоРазряда = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		ЦифраШестогоРазряда = ЦифраШестогоРазряда - 1;
		ПроверяемыйНаборЦифр[3+6] = ЦифраШестогоРазряда;
	КонецЕсли;
		
	// 5. Контрольный ключ рассчитывается с использованием весовых коэффициентов,
	// устанавливаемых каждому разряду.

	//                                 Порядковые номера разрядов ──────┐
	//    ┌─┬─┬─┐ ┌─┬─┬─┬─┬─┬─┬─┬─┬─┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐  │
	//    │1│2│3│ │1│2│3│4│5│6│7│8│9│10│11│12│13│14│15│16│17│18│19│20│<─┘
	//    ├─┼─┼─┤ ├─┼─┼─┼─┼─┼─┼─┼─┼─┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┤
	// ┌─>│7│1│3│ │7│1│3│7│1│3│7│1│3│ 7│ 1│ 3│ 7│ 1│ 3│ 7│ 1│ 3│ 7│ 1│
	// │  └─┴─┴─┘ └─┴─┴─┴─┴─┴─┴─┴─┴─┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘
	// │
	// └── Весовые коэффициенты
	
	ВесовыеКоэффициенты = Новый Массив;
	ВесовыеКоэффициенты.Добавить(7);
	ВесовыеКоэффициенты.Добавить(1);
	ВесовыеКоэффициенты.Добавить(3);
	
	// 7. Алгоритм проверки правильности расчета контрольного ключа:
	// 7.1. Рассчитываются произведения значений разрядов на соответствующие весовые коэффициенты 
	// с учетом контрольного ключа.
	// 7.2. Рассчитывается сумма младших разрядов полученных произведений.
	
	Сумма = 0;
	Для Разряд = 0 По 22 Цикл
		ИндексВесовогоКоэффициента = Разряд % 3;//3%3=0, 4%3=1, 5%3=2
		ВесовойКоэффициент = ВесовыеКоэффициенты[ИндексВесовогоКоэффициента];
		Произведение  = ПроверяемыйНаборЦифр[Разряд] * ВесовойКоэффициент;
		МладшийРазряд = Произведение % 10;
		Сумма = Сумма + МладшийРазряд;
	КонецЦикла;
	
	// При получении суммы, кратной 10 (младший разряд равен 0), 
	// значение контрольного ключа считается верным.

	Возврат Сумма % 10 = 0;
	
КонецФункции

Функция ДлинаНомераСчета() Экспорт
	
	Возврат 20;
	
КонецФункции

Функция ПроверитьДлинуНомераСчета(НомерСчета) Экспорт
	
	Возврат СтрДлина(НомерСчета) = ДлинаНомераСчета();
	
КонецФункции

Функция ЭтоКазначейскийСчет(НомерСчета) Экспорт
	
	// П. 1.1.3.1 Положение Банка России от 06.10.2020 N 735-П.
	// В реквизите "Сч. N" плательщика указывается номер казначейского счета, открытый территориальному органу
	// Федерального казначейства, финансовому органу, органу управления внебюджетным фондом в территориальном органе
	// Федерального казначейства, который состоит из двадцати цифр и начинается с цифры "0".
	
	// Приказ Казначейства России от 01.04.2020 № 15н "О Порядке открытия казначейских счетов".
	// Признак казначейского счета, всегда равен "0".
	// Код валюты указывается в соответствии с Общероссийским классификатором валют.
	// Отсутствует контрольный разряд.
	
	НачинаетсяНаНоль = СтрНачинаетсяС(НомерСчета, "0");
	
	КодВалюты = КодВалютыБанковскогоСчета(НомерСчета);
	
	Возврат НачинаетсяНаНоль И ПроверитьДлинуНомераСчета(НомерСчета) И КодВалюты = КодРубляВНомереКазначейскогоСчета();
	
КонецФункции

Функция ЭтоЕдиныйКазначейскийСчет(НомерСчета) Экспорт
	
	// 40102 - Единый казначейский счет, открытый Казначейству России Центральным Банком.
	// Единый казначейский счет - банковский счет (совокупность банковских счетов), открытый (открытых)
	// Федеральному казначейству в Центральном банке Российской Федерации в валюте Российской Федерации
	// (в кредитных организациях - в иностранной валюте) для совершения переводов денежных средств в целях
	// обеспечения осуществления и отражения операций на казначейских счетах, за исключением казначейских счетов
	// для осуществления и отражения операций с денежными средствами Фонда национального благосостояния.
	
	// Положение Банка России от 27.02.2017 N 579-П (ред. от 14.09.2020)
	// "О Плане счетов бухгалтерского учета для кредитных организаций и порядке его применения".
	// 40102 - Единый казначейский счет - Пассивный
	// (введено Указанием Банка России от 19.05.2020 N 5460-У)
	
	Возврат БалансовыйСчет(НомерСчета) = БалансовыйСчетЕКС();
	
КонецФункции

// Код рубля в соответствии с Общероссийским классификатором валют.
//
Функция КодРубляВНомереКазначейскогоСчета() Экспорт
	
	Возврат "643";
	
КонецФункции

Функция КодРубляВНомереСчета() Экспорт
	
	// П. 1.17 Положения
	// по счетам в валюте Российской Федерации используется признак рубля "810".
	
	Возврат "810";
	
КонецФункции

Функция КодВалютыБанковскогоСчета(НомерСчета) Экспорт
	
	// П. 1.17 Положения
	// При осуществлении операций по счетам в иностранных, клиринговых валютах, а также в драгоценных металлах
	// в лицевом счете в разрядах (6-8), предназначенных для кода валюты, указываются соответствующие коды,
	// предусмотренные Общероссийским классификатором валют (ОКВ).
	
	Возврат Сред(НомерСчета, 6,3);
	
КонецФункции

Функция ЭтоРублевыйСчет(НомерСчета) Экспорт
	
	КодВалюты = КодВалютыБанковскогоСчета(НомерСчета);
	
	ЭтоРублевыйСчет = КодВалюты = КодРубляВНомереСчета()
		Или ЭтоКазначейскийСчет(НомерСчета); // там своя проверка на код рубля по ОКВ
	
	Возврат ЭтоРублевыйСчет;
	
КонецФункции

#КонецОбласти

#Область ШифрыДокументов
// - Перечень условных обозначений (шифров) документов, проводимых по счетам в кредитных организациях

Функция ЭтоПлатежноеПоручение(ШифрОперации) Экспорт
	
	// 01 - Списано, зачислено по платежному поручению, по поручению банка
	Возврат ШифрОперации = 1;
	
КонецФункции

Функция ЭтоПлатежноеТребование(ШифрОперации) Экспорт
	
	// 02 - Оплачено, зачислено по платежному требованию
	Возврат ШифрОперации = 2;
	
КонецФункции

Функция ЭтоДокументВыдачиБанкомНаличных(ШифрОперации) Экспорт
	
	// 03 - Оплачен наличными денежный чек, выдано по расходному кассовому ордеру
	Возврат ШифрОперации = 3;
	
КонецФункции

Функция ЭтоДокументПоступленияНаличныхВБанк(ШифрОперации) Экспорт
	
	// 04 - Поступило наличными по объявлению на взнос наличными, приходному кассовому ордеру, препроводительной ведомости...
	Возврат ШифрОперации = 4;
	
КонецФункции

Функция ЭтоИнкассовоеПоручение(ШифрОперации) Экспорт
	
	// 06 - Оплачено, зачислено по инкассовому поручению
	Возврат ШифрОперации = 6;
	
КонецФункции

Функция ЭтоМемориальныйОрдер(ШифрОперации) Экспорт
	
	// 09 - Списано, зачислено по мемориальному ордеру
	Возврат ШифрОперации = 9;
КонецФункции

Функция ЭтоРасчетыСПрименениемБанковскихКарт(ШифрОперации) Экспорт
	
	// 13 - Расчеты с применением банковских карт
	Возврат ШифрОперации = 13;
	
КонецФункции

Функция ЭтоПлатежныйОрдер(ШифрОперации) Экспорт
	
	// 16 - Списано, зачислено по платежному ордеру
	Возврат ШифрОперации = 16;
	
КонецФункции

Функция ЭтоБанковскийОрдер(ШифрОперации) Экспорт
	
	// 17 - Списано, зачислено по банковскому ордеру
	Возврат ШифрОперации = 17;
	
КонецФункции

#КонецОбласти

// "Положение о Справочнике банковских идентификационных кодов участников расчетов,
// осуществляющих платежи через расчетную сеть Центрального банка Российской Федерации (Банка России),
// и расчетно-кассовых центров Банка России"
// (утв. Банком России 06.05.2003 N 225-П)

#Область БанковскиеИдентификационныеКоды

Функция ДлинаБИК()
	
	// п. 2.2 Положения
	Возврат 9;
	
КонецФункции

Функция ПроверитьДлинуБИК(БИК) Экспорт
	
	Возврат СтрДлина(СокрЛП(БИК)) = ДлинаБИК();
	
КонецФункции

Функция ЭтоОтделениеЦентральногоБанка(БИК) Экспорт
	
 	// П. 2.2 Положения 
	// 7 - 9 разряды слева - идентификатор кредитной организации (филиала), клиента, не являющегося кредитной организацией,
	// уникальный в рамках подразделения расчетной сети Банка России или РКЦ, - принимает значения от "050" до "999".
	//
	// Для РКЦ или подразделения расчетной сети Банка России в составе территориального учреждения Банка России,
	// отделения ГУ Банка России по Центральному федеральному округу,
	// наделенного функциями расчетно-кассового (кассового) центра, в 7 - 9 разрядах указывается значение "000".
	//
	// Для Головного расчетно-кассового центра или другого подразделения расчетной сети Банка России
	// в составе территориального учреждения Банка России, наделенного функциями Головного расчетно-кассового центра,
	// в 7 - 9 разрядах указывается значение "001".
	// 
	// Для других подразделений расчетной сети Банка России и структурных подразделений Банка России 
	// в 7 - 9 разрядах указывается значение "002".
	
	УсловныйНомер = Сред(БИК, 7, 3);
	Возврат УсловныйНомер = "000" Или УсловныйНомер = "001" Или УсловныйНомер = "002";
	
КонецФункции

Функция ИсправитьБИК(БИК) Экспорт
	
	// 2.2. БИК имеет следующую структуру:
	// 1 - 2 разряды слева - код Российской Федерации (используется код "04");
	
	// Так как некоторые алгоритмы преобразовывают БИК к числу, 
	// то нередко БИК предоставляется с ошибкой: теряется первая цифра "0" в номере БИК.
	
	Если СтрДлина(БИК) = ДлинаБИК() - 1
		И Лев(БИК, 1) = "4" // не приводим новые "казначейские" значения 00, 01 и 02
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(БИК) Тогда
		Возврат "0" + БИК;
	ИначеЕсли СтрДлина(БИК) > ДлинаБИК() Тогда
		Возврат Лев(БИК, ДлинаБИК()); // таким же образом БИК обрежет платформа в реквизите Код
	Иначе
		// Не можем исправить. Может быть, соответствует нормативному документу
		Возврат БИК;
	КонецЕсли;
	
КонецФункции

// Проверяет, что переданный БИК является кодом Территориального органа Федерального казначейства.
//
Функция ЭтоБИКТОФК(КодБанка) Экспорт
	
	ПервыеЦифрыБИК = Лев(КодБанка, 2);
	
	Результат = ПроверитьДлинуБИК(КодБанка)
		И (ПервыеЦифрыБИК = "00" Или ПервыеЦифрыБИК = "01" Или ПервыеЦифрыБИК = "02");
	
	Возврат Результат;
	
КонецФункции

Функция ЭтоБИКБанкаРФ(КодБанка) Экспорт
	
	Результат = ПроверитьДлинуБИК(КодБанка) И (Лев(КодБанка, 2) = "04" Или ЭтоБИКТОФК(КодБанка));
	
	Возврат Результат;
	
КонецФункции

Функция СвойстваКодаБанка(Код) Экспорт
	
	Результат = Новый Структура("ПохожеНаBIC, ПохожеНаSWIFT, ЭтоSWIFT", Ложь, Ложь, Ложь);
	
	ДлинаСтроки = СтрДлина(Код);
	ТолькоЦифрыВСтроке = СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Код);
	
	Результат.ПохожеНаBIC = ТолькоЦифрыВСтроке
		И Не ЭтоБИКБанкаРФ(Код) // проверяем, что это не начало российского БИК
		И ДлинаСтроки < 10;
	
	Результат.ЭтоSWIFT = Не Результат.ПохожеНаBIC И СтрокаСоответствуетФорматуSWIFT(Код)
		И Не ТолькоЦифрыВСтроке;
	
	// По формальным признакам код похож на SWIFT, введенный не до конца.
	Результат.ПохожеНаSWIFT = Не Результат.ПохожеНаBIC И Не Результат.ЭтоSWIFT
		И Не ТолькоЦифрыВСтроке // В SWIFT в 5-6 символах указан код страны.
		И ПроверитьРазрешенныеСимволыSWIFT(Код)
		И (ДлинаСтроки < 8      // Минимальная длина SWIFT.
		Или ДлинаСтроки > 8 И ДлинаСтроки < 11);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

// "Положение о правилах осуществления перевода денежных средств"
// (утв. Банком России 19.06.2012 N 383-П)

#Область ПлатежныеПоручения

Функция ДлинаНомераПлатежногоПоручения() Экспорт
	
	// см. Приложения 1 и 11 
	// к Положению Банка России
	// от 19 июня 2012 года N 383-П

	Возврат 6;
	
КонецФункции

#КонецОбласти

// ISO 13616
// Financial services - International bank account number (IBAN)

#Область МеждународныеБанковскиеСчета

Функция СтрокаСоответствуетФорматуIBAN(Строка) Экспорт
	
	// IBAN (International bank account number) - международный номер банковского счёта
	
	// Структура IBAN определена ISO 13616-1:
	// a) первые две буквы - код страны по ISO 3166-1 (alpha-2)
	// b) затем две цифры - контрольная сумма по алгоритму ISO/IEC 7064 (MOD97-10).
	// c) затем последовательность символов, длина и содержание которой определяется страной, указанной в a)
	// При этом, общая длина IBAN не может превышать 34 символа.
	// При передаче в электронном виде в IBAN не допускаются разделители (пробелы и т.п.)
	
	// Детальная информация, которая надежно позволяет валидировать строку на соответствие стандарту, содержится в IBAN Registry.
	// Однако, здесь определяем в упрощенном порядке:
	// a) первые два символа - латинские буквы, приведенные в IBAN Registry
	// b) вторые два символа - цифры (не проверяем контрольную сумму)
	// c) общая длина от 5 до 34 символов (не проверяем длину на соответствие правилам конкретной страны)
	
	Если ПустаяСтрока(Строка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаСтроки = СтрДлина(Строка);
	Если ДлинаСтроки < 5 Или ДлинаСтроки > МаксимальнаяДлинаМеждународногоНомераСчета() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не СтранаПрименяетФорматIBAN(КодСтраныIBAN(Строка)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Сред(Строка, 3, 2)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция КодСтраныIBAN(НомерСчетаIBAN) Экспорт
	
	Возврат Лев(НомерСчетаIBAN, 2);
	
КонецФункции

// Проверяет, применяет ли страна формат IBAN, по данным IBAN REGISTRY Release 78 - August 2017
// www.swift.com/standards/data-standards/iban
//
// Параметры:
//  КодСтраны - Строка - код страны по ISO 3166-1 (alpha-2)
// 
// Возвращаемое значение:
//  Булево - Истина, если страна применяет формат IBAN
//
Функция СтранаПрименяетФорматIBAN(КодСтраны) Экспорт
	
	Если ПустаяСтрока(КодСтраны) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КодыВсехСтранПрименяющихIBAN = "/AD/AE/AL/AT/AZ/BA/BE/BG/BH/BR/BY/CH/CR/CY/CZ/DE/DK/DO/EE/ES/FI" +
		"/FO/FR/GB/GE/GI/GL/GR/GT/HR/HU/IE/IL/IQ/IS/IT/JO/KW/KZ/LB/LC/LI/LT/LU/LV/MC/MD/ME/MK/MR/MT" +
		"/MU/NL/NO/PK/PL/PS/PT/QA/RO/RS/SA/SC/SE/SI/SK/SM/ST/SV/TL/TN/TR/UA/VG/XK/";
	
	Возврат СтрНайти(КодыВсехСтранПрименяющихIBAN, "/" + КодСтраны + "/") > 0;

КонецФункции

Функция ТипМеждународныйНомерСчета() Экспорт
	
	Возврат Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(МаксимальнаяДлинаМеждународногоНомераСчета()));
	
КонецФункции

Функция МаксимальнаяДлинаМеждународногоНомераСчета() Экспорт
	
	Возврат 34;
	
КонецФункции

// Функция проверяет контрольную сумму в счете IBAN.
// Алгоритм проверки описан в ECBS EBS204 v.3.1. (August 2002), стр 12.
//
// Параметры:
//  IBAN - Строка - номер счета в формате IBAN, который необходимо проверить.
// 
// Возвращаемое значение:
//  Булево - Признак корректности IBAN
//
Функция ПроверитьКонтрольныйКлючIBAN(IBAN) Экспорт
	
	// Предварительный этап. Удаляем лишние пробелы в IBAN т.к. он может быть указан в бумажном формате.
	ПроверяемыйIBAN  = СтрЗаменить(IBAN, " ", "");
	
	// 1. Передвигаем первые 4 символа в правую часть IBAN.
	ПроверяемыйIBAN = Сред(ПроверяемыйIBAN, 5) + Лев(ПроверяемыйIBAN, 4);
	
	// 2. Преобразуем буквы в числа согласно таблице конвертации.
	// 
	// A = 10  G = 16  M = 22  S = 28  Y = 34
	// B = 11  H = 17  N = 23  T = 29  Z = 35
	// C = 12  I = 18  O = 24  U = 30
	// D = 13  J = 19  P = 25  V = 31
	// E = 14  K = 20  Q = 26  W = 32
	// F = 15  L = 21  R = 27  X = 33
	
	БуквыДляКонвертации = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	Для ИндексБуквы = 1 По СтрДлина(БуквыДляКонвертации) Цикл
		
		КонвертируемаяБуква = Сред(БуквыДляКонвертации, ИндексБуквы, 1);
		КонвертируемаяЦифра = ИндексБуквы + 9;
		
		ПроверяемыйIBAN = СтрЗаменить(ПроверяемыйIBAN, КонвертируемаяБуква, КонвертируемаяЦифра);
		
	КонецЦикла;
	
	ОстатокПроверяемыйIBAN = ПроверяемыйIBAN;
	ДлинаПроверяемогоОтрезка = 9;
	ТипЧисло = Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(ДлинаПроверяемогоОтрезка,0));
	КонтрольнаяЦифра = 0;
	КонтрольнаяЦифраСтрока = "";
	// IBAN требует число длиной до 34 знаков, а веб-клиент поддерживает число длиной до 10 знаков,
	// поэтому разбиваем строку на числа в 9 знаков.
	Пока Не ПустаяСтрока(ОстатокПроверяемыйIBAN) Цикл
		
		ЧислоСимволов = Мин(ДлинаПроверяемогоОтрезка - СтрДлина(КонтрольнаяЦифраСтрока), СтрДлина(ОстатокПроверяемыйIBAN));
		
		ПроверяемыйIBANСтрока = Строка(КонтрольнаяЦифраСтрока) + Сред(ОстатокПроверяемыйIBAN, 1, ЧислоСимволов);
		
		ПроверяемыйIBANЧисло = ТипЧисло.ПривестиЗначение(ПроверяемыйIBANСтрока);
		
		// 3. Применяем Mod 97-10 (ISO 7064).
		// Если остаток равен 1 тогда
		// это признак того, что счет корректный.
		КонтрольнаяЦифра = ПроверяемыйIBANЧисло % 97;
		
		КонтрольнаяЦифраСтрока = Строка(КонтрольнаяЦифра);
		ОстатокПроверяемыйIBAN = Сред(ОстатокПроверяемыйIBAN, ЧислоСимволов +1);
		
	КонецЦикла;
	
	Возврат КонтрольнаяЦифра = 1;
	
КонецФункции

#КонецОбласти

// ISO 9362
// SWIFT BIC

#Область SWIFTКоды

// Получает код страны из SWIFT согласно ISO 9362.
//
// Параметры:
//  СВИФТБИК - Строка - код SWIFT BIC.
// 
// Возвращаемое значение:
//  Строка -  Код страны SWIFT.
//
Функция КодСтраныSWIFT(СВИФТБИК) Экспорт
	
	Возврат Сред(СВИФТБИК,5,2);
	
КонецФункции

// Функция проверяет соответствие строки банковскому коду SWIFT.
//
// Параметры:
//  ПроверяемаяСтрока - Строка - строка которую, требуется проверить на соответствие SWIFT коду.
// 
// Возвращаемое значение:
//  Булево - если Истина - строка соответствует формату SWIFT. 
//
Функция СтрокаСоответствуетФорматуSWIFT(ПроверяемаяСтрока) Экспорт
	
	Если ПроверитьДлинуSWIFT(ПроверяемаяСтрока) И ПроверитьРазрешенныеСимволыSWIFT(ПроверяемаяСтрока) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Функция возвращает признак корректности длины SWIFT.
// Согласно ISO 9362 центральные офисы банков имет длину 8 символов,
// а подразделения банков - 11 символов (3 дополнительных символа для номера филиала)
//
// Параметры:
//  СВИФТБИК - Строка - код SWIFT BIC.
// 
// Возвращаемое значение:
//  Булево -  Признак того, что длина корректная.
//
Функция ПроверитьДлинуSWIFT(СВИФТБИК) Экспорт
	
	ДлинаКода = СтрДлина(СВИФТБИК);
	ДлинаДляЦО = 8; 
	ДлинаДляФилиала = 11;
	
	Возврат ДлинаКода = ДлинаДляЦО Или ДлинаКода = ДлинаДляФилиала;
	
КонецФункции

// Функция проверяет код SWIFT на наличие разрешенных символов.
//  Источник: ISO 9362:2014 - BIC Implementation. Changes and impacts. (стр. 6).
//  Контроль всего кода выполняем на буквенно-цифровые символы, т.к.
//  стандарт не рекомендует выполнять проверки согласно конкретным разрешенным символам в отдельных разрядах SWIFT.
//
// Параметры:
//  СВИФТБИК - Строка - код SWIFT BIC.
// 
// Возвращаемое значение:
//  Булево - Признак того, что проверка пройдена.
//
Функция ПроверитьРазрешенныеСимволыSWIFT(СВИФТБИК) Экспорт
	
	Возврат ПроверитьБуквенноЦифровыеСимволы(СВИФТБИК);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПроверитьБуквенноЦифровыеСимволы(СтрокаСимволов)
	
	ПроверитьРазрешенныеСимволы = Истина;
	
	Для ИндексСимвола = 1 По СтрДлина(СтрокаСимволов) Цикл
		
		СимволКода = ВРег(Сред(СтрокаСимволов, ИндексСимвола, 1));
		
		Если СтрНайти("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", СимволКода) = 0 Тогда
			ПроверитьРазрешенныеСимволы = Ложь;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПроверитьРазрешенныеСимволы; 
	
КонецФункции

#КонецОбласти
