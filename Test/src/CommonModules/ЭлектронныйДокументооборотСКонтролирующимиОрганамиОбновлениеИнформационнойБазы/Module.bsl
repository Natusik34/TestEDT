////////////////////////////////////////////////////////////////////////////////
// Служебный программный интерфейс обновления ИБ подсистемы
// электронного документооборота с контролирующими органами. 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "Справочники.ЭлектронныеПредставленияРегламентированныхОтчетов.ЗаполнитьРеквизитыПриПереходе20";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.СконвертироватьРеквизитыЗаявленияПо1СОтчетности";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "0.0.0.1";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗавершитьНастройкуЗаявлений";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗавершитьНастройкуЗаявлений";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "0.0.0.1";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗаполнитьТипСверкиИОН";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗаполнитьТипСверкиИОН";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "0.0.0.1";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗаполнитьСпособПолученияСертификата";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗаполнитьСпособПолученияСертификата";
	Обработчик.НачальноеЗаполнение = Истина;
	
	#Область Версия_1_0
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.23";
	Обработчик.Процедура = "Документы.ТранспортноеСообщение.ОбновитьСвойстваТранспортныхСообщений";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.24";
	Обработчик.Процедура = "Справочники.УчетныеЗаписиДокументооборота.ЗаполнениеРеквизитовУчетныхЗаписейПриОбновлении";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.41";
	Обработчик.Процедура = "Справочники.ДокументыРеализацииПолномочийНалоговыхОрганов.ОбновитьДокументыРеализацииПолномочийНалоговыхОрганов";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.43";  
	Обработчик.Процедура = "Справочники.ОтправкиФСС.ЗаполнитьНовыеПоляОтправкиФСС";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.58";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ПереносДанныхЭДОПриОбновлении10158";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.3.1";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ОбновитьОтправкиПослеЗаменыПредопределенныхЗначенийДляФСРАР";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.5.1";
	Обработчик.Процедура = "Справочники.УчетныеЗаписиДокументооборота.ЗадатьДляУчетныхЗаписейИспользованиеСервисаОнлайнПроверки";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.8.1";
	Обработчик.Процедура = "РегистрыСведений.СтатусыОтправки.ЗаполнитьСтатусыОтправкиДляФССиФСРАР";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.14.1";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ОбновитьРеквизитВидОбменаСКонтролирующимиОрганамиСправочникаОрганизации";
	
	#КонецОбласти

	#Область Версия_1_1_1
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.1";
	Обработчик.Процедура = "Справочники.ОписиИсходящихДокументовВНалоговыеОрганы.ОбновитьНаименованиеВсехОписейИсходящихДокументов";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.2";
	Обработчик.Процедура = "ДокументооборотСКОВызовСервера.ЗаполнитьРегистрЖурналОтправокВКонтролирующиеОрганы";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет обновление информации в форме 1С-Отчетность во всех разделах, кроме Отчеты. До завершения выполнения данные в форме 1С-Отчетность могут отображаться некорректно'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.2";
	Обработчик.Процедура = "Справочники.ЭлектронныеПредставленияРегламентированныхОтчетов.ОбновитьНаименование";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет обновление наименования загруженных отчетов.'");
	
	#КонецОбласти
	
	#Область Версия_1_1_5
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.5.5";
	Обработчик.Процедура = "Справочники.ВидыОтправляемыхДокументов.ОбновитьНаименованияПредопределенныхЭлементов";
	
	#КонецОбласти
	
	#Область Версия_1_1_6
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.6.1";
	Обработчик.Процедура = "Справочники.СканированныеДокументыДляПередачиВЭлектронномВиде.ЗаполнитьНовыеРеквизиты";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.6.1";
	Обработчик.Процедура = "Справочники.СканированныеДокументыДляПередачиВЭлектронномВидеПрисоединенныеФайлы.ВыполнитьНачальноеЗаполнение";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Преобразуются файлы избражений сканированных документов, предназначенных для отправки в ФНС. 
	|До завершения обработки рекомендуется воздержаться от формирования и отправки документов в ответ на требование о представлении документов в ФНС'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.6.1";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗаполнитьРегистрДокументыПоТребованиюФНС";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Заполняются данные единого списка документов для представления в ФНС. 
	|До завершения обработки рекомендуется воздержаться от формирования и отправки документов в ответ на требование о представлении документов в ФНС'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.6.2";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ИсправитьНекорректныеСостоянияОтправок2НДФЛ";
	Обработчик.НачальноеЗаполнение = Ложь;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.6.7";
	Обработчик.Процедура = "Справочники.ЭлектронныеПредставленияРегламентированныхОтчетов.ПеренестиРеквизитВидОтчета";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.6.7";
	Обработчик.Процедура = "Справочники.ЦиклыОбмена.ПеренестиРеквизитВидОтчета";
	
	#КонецОбласти
	
	#Область Версия_1_1_7

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.7.9";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганамиОбновлениеИнформационнойБазы.ВключитьАвтоматическийОбменСКонтролирующимиОрганамиПриОбновлении";
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.7.9";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганамиОбновлениеИнформационнойБазы.ИсправитьСостояниеОтправкиЗаявленияОВвозеТоваров";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.7.10";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганамиОбновлениеИнформационнойБазы.ЗаменитьДублиСправочникаВидыОтправляемыхДокументов";

	#КонецОбласти
	
	#Область Версия_1_1_8
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.8.7";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПеренестиПризнакНепрочтенности";
	
	#КонецОбласти
	
	#Область Версия_1_1_9
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.14";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ИсправитьНекорректныеСостоянияОтправок2НДФЛ";
	
	#КонецОбласти
	
	#Область Версия_1_1_10
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.10.3";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ДобавитьНовыеДокументыВРегистрДокументыПоТребованиюФНС";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Добавляются новые виды документов для ответа на требование ФНС. 
	|До завершения обработки рекомендуется воздержаться от формирования и отправки ответов на требование о представлении документов в ФНС'");
	
	#КонецОбласти
	
	#Область Версия_1_1_11
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия              = "1.1.11.22";
	Обработчик.Процедура           = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗапуститьПереносТранспортныхСообщенийВПрисоединенныеФайлы";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия              = "1.1.11.23";
	Обработчик.Процедура           = "РегистрыСведений.НастройкиОбменаРПН.ОтключитьОбменНапрямую";
	Обработчик.НачальноеЗаполнение = Истина;
	
	#КонецОбласти
	
	#Область Версия_1_1_13
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия              = "1.1.13.5";
	Обработчик.Процедура           = "Справочники.ВидыОтправляемыхДокументов.ИсправитьОписаниеФармацевтическихДекларацийНДФЛиАДВ1";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия              = "1.1.13.5";
	Обработчик.Процедура           = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗаполнитьДатыОтправки";
	Обработчик.Идентификатор       = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения     = "Отложенно";
	Обработчик.Комментарий         = НСтр("ru = 'Заполнение даты отправки отчетов, уведомлений, выписок ЕГРЮЛ, сверок, писем. 
	|До завершения обработки дата отправки может быть заполнена не везде'");
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия              = "1.1.13.8";
	Обработчик.Процедура           = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗаменитьВОрганизацияхИПодразделенияхКодОрганаФСГС";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия              = "1.1.13.30";
	Обработчик.Процедура           = "Справочники.ВидыОтправляемыхДокументов.ИсправитьИмяОбъектаМетаданныхСтатистикаФорма2ТПВоздух";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "1.1.13.33";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ИсправитьНекорректныеСостоянияОтправок2НДФЛ_2";
	Обработчик.НачальноеЗаполнение = Ложь;
	
	#КонецОбласти
	
	#Область Версия_1_1_14
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "1.1.14.3";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗаполнитьТипСверкиИОН";
	Обработчик.НачальноеЗаполнение = Ложь;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "1.1.14.3";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ИсправитьНекорректныеСостоянияОтправок2НДФЛ_1110307";
	Обработчик.НачальноеЗаполнение = Ложь;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "1.1.14.3";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗаполнитьПериодЗапросовИОН";
	Обработчик.НачальноеЗаполнение = Ложь;
	
	#КонецОбласти
	
	#Область Версия_1_2_1
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "1.2.1.3";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗаполнитьСпособПолученияСертификата";
	Обработчик.НачальноеЗаполнение = Ложь;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "1.2.1.11";
	Обработчик.Процедура 		   = "Справочники.ВидыОтправляемыхДокументов.ИсправитьВидыОтправляемыхДокументовОбъемВиноградаДо2019";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "1.2.1.36";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ВключитьОбменСФССПриНеобходимости";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "1.2.1.53";
	Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.СброситьПризнакПодпискиСтрахователяСЭДОФСС";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.2.1.55";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ДобавитьНовыеДокументыВРегистрДокументыПоТребованиюФНС_2";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Добавляются новые виды документов для ответа на требование ФНС. 
	|До завершения обработки рекомендуется воздержаться от формирования и отправки ответов на требование о представлении документов в ФНС'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.2.1.78";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗаменитьВОрганизацияхИПодразделенияхКодОрганаФСГСОтложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Заменяются коды ТОГС в организациях и обособленных подразделениях'");
	Обработчик.НачальноеЗаполнение = Истина;
	
	// обработчики для облачной подписи
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "*";
	Обработчик.Процедура 		   = "Справочники.УчетныеЗаписиДокументооборота.ЗаполнитьМестоХраненияКлюча";
	Обработчик.Идентификатор       = Новый УникальныйИдентификатор();
	Обработчик.НачальноеЗаполнение = Ложь;
	Обработчик.Комментарий         = НСтр("ru = 'Конвертация параметров хранения закрытого ключа в учетной записи.
	|До завершения обработки может быть заполнена не везде'");
	Обработчик.РежимВыполнения = "Отложенно";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "*";
	Обработчик.Процедура 		   = "Документы.ЗаявлениеАбонентаСпецоператораСвязи.ЗаполнитьМестоХраненияКлюча";
	Обработчик.Идентификатор 	   = Новый УникальныйИдентификатор();
	Обработчик.НачальноеЗаполнение = Ложь;
	Обработчик.Комментарий         = НСтр("ru = 'Конвертация параметров хранения закрытого ключа в заявлениях.
	|До завершения обработки может быть заполнена не везде'");
	Обработчик.РежимВыполнения = "Отложенно";

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "1.2.1.118";
	Обработчик.Процедура 		   = "РегистрыСведений.ХранилищеСертификатовПолучателей.ПеренестиОблачныеСертификаты";
	Обработчик.Идентификатор       = Новый УникальныйИдентификатор();
	Обработчик.НачальноеЗаполнение = Ложь;
	Обработчик.Комментарий         = НСтр("ru = 'Копирование сертификатов в режиме подписи в модели сервиса в отдельный регистр.
	|До завершения обработки может быть заполнена не везде'");
	Обработчик.РежимВыполнения = "Отложенно";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия 			   = "1.2.1.120";
	Обработчик.Процедура 		   = "РегистрыСведений.НастройкиОбменаСервисаПодписи.РасширитьРеестрИзмерений";
	Обработчик.Идентификатор       = Новый УникальныйИдентификатор();
	Обработчик.НачальноеЗаполнение = Ложь;
	Обработчик.Комментарий         = НСтр("ru = 'Дублирование измерения по идентификатору учетной записи.'");
	Обработчик.РежимВыполнения = "Отложенно";
	
	ДобавитьОбработчикиОбновленияОблачнойПодписи(Обработчики);
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.2.1.143";
	Обработчик.Процедура = "ТребованияФНС.ЗаполнитьВидДокументаВЖурналеОтправокВКонтролирующиеОрганы";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.Комментарий = НСтр("ru = 'Заполнение вида входящего документа 1С-Отчетности'");
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.2.1.150";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ОбработатьСообщенияСЭДОФССНаСервере";
	Обработчик.Комментарий = НСтр("ru = 'Формирование требований ФСС из входящих сообщений'");
	Обработчик.НачальноеЗаполнение = Ложь;
	Обработчик.РежимВыполнения = "Оперативно";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.2.1.183";
	Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ОбработатьТребованияСФРНаСервере";
	Обработчик.Комментарий = НСтр("ru = 'Формирование данных в регистре сведений журнал отправок в контролирующие органы'");
	Обработчик.НачальноеЗаполнение = Ложь;
	Обработчик.РежимВыполнения = "Оперативно";
	
	#КонецОбласти
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ВключитьАвтоматическийОбменСКонтролирующимиОрганамиПриОбновлении() Экспорт
	
	Если ЗначениеЗаполнено(ПланыОбмена.ГлавныйУзел()) Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Организации.УчетнаяЗаписьОбмена КАК УчетнаяЗапись
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|	И НЕ Организации.УчетнаяЗаписьОбмена.ПометкаУдаления
	|	И НЕ Организации.УчетнаяЗаписьОбмена.ОтключитьАвтообмен";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДокументооборотСКО.ВключитьОбменПоУчетнойЗаписи(Выборка.УчетнаяЗапись);
	КонецЦикла;
	
	// Очистка сведений о ранее полученных сообщений автообменом.
	НовыйНабор = РегистрыСведений.СвойстваТранспортныхСообщений.СоздатьНаборЗаписей();
	НовыйНабор.Записать();
	
КонецПроцедуры

Процедура ИсправитьСостояниеОтправкиЗаявленияОВвозеТоваров() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТранспортноеСообщение.ЦиклОбмена.Предмет КАК Ссылка,
		|	ЖурналОтчетовСтатусы.СостояниеСдачиОтчетности
		|ИЗ
		|	Документ.ТранспортноеСообщение КАК ТранспортноеСообщение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЖурналОтчетовСтатусы КАК ЖурналОтчетовСтатусы
		|		ПО ТранспортноеСообщение.ЦиклОбмена.Предмет = ЖурналОтчетовСтатусы.Ссылка
		|ГДЕ
		|	ТранспортноеСообщение.ПометкаУдаления = ЛОЖЬ
		|	И ТранспортноеСообщение.ЦиклОбмена.ПометкаУдаления = ЛОЖЬ
		|	И ТранспортноеСообщение.ЦиклОбмена.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыЦикловОбмена.Заявление)
		|	И ТранспортноеСообщение.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыТранспортныхСообщений.РезультатОбработкиЗаявлениеНО)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Если ВыборкаДетальныеЗаписи.СостояниеСдачиОтчетности <>
			Перечисления.СостояниеСдачиОтчетности.ПоложительныйРезультатДокументооборота Тогда
			
			Отказ = Ложь;
			РегламентированнаяОтчетность.ЗаписьОбъектовРегламентированнойОтчетности(ВыборкаДетальныеЗаписи.Ссылка, Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаменитьДублиСправочникаВидыОтправляемыхДокументов() Экспорт
	
	РазнестиДублиПредопределенныхЭлементовВИБ();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦиклыОбмена.Ссылка
	|ИЗ
	|	Справочник.ЦиклыОбмена КАК ЦиклыОбмена
	|ГДЕ
	|	ЦиклыОбмена.ВидОтчета В (ЗНАЧЕНИЕ(Справочник.ВидыОтправляемыхДокументов.УдалитьБухОтчетностьМП), ЗНАЧЕНИЕ(Справочник.ВидыОтправляемыхДокументов.УдалитьБухОтчетностьСОНКО), ЗНАЧЕНИЕ(Справочник.ВидыОтправляемыхДокументов.УдалитьФинансовыйРезультатИнвестиционногоТоварищества), ЗНАЧЕНИЕ(Справочник.ВидыОтправляемыхДокументов.УдалитьСведенияСЗВ64), ЗНАЧЕНИЕ(Справочник.ВидыОтправляемыхДокументов.УдалитьОтходыСубъектовМСП))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭлектронныеПредставленияРегламентированныхОтчетов.Ссылка
	|ИЗ
	|	Справочник.ЭлектронныеПредставленияРегламентированныхОтчетов КАК ЭлектронныеПредставленияРегламентированныхОтчетов
	|ГДЕ
	|	ЭлектронныеПредставленияРегламентированныхОтчетов.ВидОтчета В (ЗНАЧЕНИЕ(Справочник.ВидыОтправляемыхДокументов.УдалитьБухОтчетностьМП), ЗНАЧЕНИЕ(Справочник.ВидыОтправляемыхДокументов.УдалитьБухОтчетностьСОНКО), ЗНАЧЕНИЕ(Справочник.ВидыОтправляемыхДокументов.УдалитьФинансовыйРезультатИнвестиционногоТоварищества), ЗНАЧЕНИЕ(Справочник.ВидыОтправляемыхДокументов.УдалитьСведенияСЗВ64), ЗНАЧЕНИЕ(Справочник.ВидыОтправляемыхДокументов.УдалитьОтходыСубъектовМСП))";
	Результат = Запрос.ВыполнитьПакет();
	
	// Циклы обмена
	Выборка = Результат[0].Выбрать();
	Пока Выборка.Следующий() Цикл
		ЦиклОбменаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ЦиклОбменаОбъект.ВидОтчета = ПолучитьВидОтчетаПоДублю(ЦиклОбменаОбъект.ВидОтчета);
		ЦиклОбменаОбъект.ОбменДанными.Загрузка = Истина;
		ЦиклОбменаОбъект.Записать();
	КонецЦикла;
	
	// Электронные представления
	Выборка = Результат[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		ЭлектронноеПредставлениеОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ЭлектронноеПредставлениеОбъект.ВидОтчета = ПолучитьВидОтчетаПоДублю(ЭлектронноеПредставлениеОбъект.ВидОтчета);
		ЭлектронноеПредставлениеОбъект.ОбменДанными.Загрузка = Истина;
		ЭлектронноеПредставлениеОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьВидОтчетаПоДублю(ВидОтчета)
	
	СоответствиеВидовОтчетов = Новый Соответствие;
	СоответствиеВидовОтчетов.Вставить(
		Справочники.ВидыОтправляемыхДокументов.УдалитьБухОтчетностьМП,
		Справочники.ВидыОтправляемыхДокументов.БухОтчетностьМП);
	СоответствиеВидовОтчетов.Вставить(
		Справочники.ВидыОтправляемыхДокументов.УдалитьБухОтчетностьСОНКО,
		Справочники.ВидыОтправляемыхДокументов.БухОтчетностьСОНКО);
	СоответствиеВидовОтчетов.Вставить(
		Справочники.ВидыОтправляемыхДокументов.УдалитьФинансовыйРезультатИнвестиционногоТоварищества,
		Справочники.ВидыОтправляемыхДокументов.ФинансовыйРезультатИнвестиционногоТоварищества);
	СоответствиеВидовОтчетов.Вставить(
		Справочники.ВидыОтправляемыхДокументов.УдалитьСведенияСЗВ64,
		Справочники.ВидыОтправляемыхДокументов.СведенияСЗВ64);
	СоответствиеВидовОтчетов.Вставить(
		Справочники.ВидыОтправляемыхДокументов.УдалитьОтходыСубъектовМСП,
		Справочники.ВидыОтправляемыхДокументов.ОтходыСубъектовМСП);
	
	Возврат СоответствиеВидовОтчетов.Получить(ВидОтчета);
	
КонецФункции
 
Процедура РазнестиДублиПредопределенныхЭлементовВИБ()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыОтправляемыхДокументов.Ссылка,
	|	ВидыОтправляемыхДокументов.ИмяПредопределенныхДанных
	|ИЗ
	|	Справочник.ВидыОтправляемыхДокументов КАК ВидыОтправляемыхДокументов
	|ГДЕ
	|	НЕ ВидыОтправляемыхДокументов.ЭтоГруппа";
	
	ПредопределенныеЭлементы = Запрос.Выполнить().Выгрузить();
	
	ЭлементыДляПроверки = Новый Массив;
	ЭлементыДляПроверки.Добавить("БухОтчетностьМП");
	ЭлементыДляПроверки.Добавить("БухОтчетностьСОНКО");
	ЭлементыДляПроверки.Добавить("ФинансовыйРезультатИнвестиционногоТоварищества");
	ЭлементыДляПроверки.Добавить("СведенияСЗВ64");
	ЭлементыДляПроверки.Добавить("ОтходыСубъектовМСП");
	
	НачатьТранзакцию();
	Попытка
		ЭлементыДляДобавления = Новый Массив;
		Для Каждого ЭлементДляПроверки Из ЭлементыДляПроверки Цикл
			НайденныеЭлементы = Новый Массив;
			Для Каждого ПредопределенныйЭлемент Из ПредопределенныеЭлементы Цикл
				Если ВРег(ПредопределенныйЭлемент.ИмяПредопределенныхДанных) = ВРег(ЭлементДляПроверки)
					ИЛИ ВРег(ПредопределенныйЭлемент.ИмяПредопределенныхДанных) = ВРег("Удалить" + ЭлементДляПроверки) Тогда
					НайденныеЭлементы.Добавить(ПредопределенныйЭлемент);
				КонецЕсли;
			КонецЦикла;
			
			Если НайденныеЭлементы.Количество() = 2 Тогда 
				// Ситуация если в ИБ есть два предопределенных элемента и они оба одинаковые.
				// Тогда просто один из перекинем в другую группу.
				Если ПредопределенныеЭлементы.НайтиСтроки(Новый Структура("ИмяПредопределенныхДанных", "Удалить" + ЭлементДляПроверки)).Количество() = 2 Тогда
					ОбъектДляИзменения = НайденныеЭлементы[0].Ссылка.ПолучитьОбъект();
					ОбъектДляИзменения.ИмяПредопределенныхДанных = СтрЗаменить(ОбъектДляИзменения.ИмяПредопределенныхДанных, "Удалить", "");
					ОбъектДляИзменения.Наименование = СтрЗаменить(ОбъектДляИзменения.Наименование, "(не используется) ", "");
					ОбъектДляИзменения.Записать();
				ИначеЕсли ПредопределенныеЭлементы.НайтиСтроки(Новый Структура("ИмяПредопределенныхДанных", ЭлементДляПроверки)).Количество() = 2 Тогда
					ОбъектДляИзменения = НайденныеЭлементы[0].Ссылка.ПолучитьОбъект();
					ОбъектДляИзменения.ИмяПредопределенныхДанных = "Удалить" + ОбъектДляИзменения.ИмяПредопределенныхДанных;
					ОбъектДляИзменения.Наименование = "(не используется) " + ОбъектДляИзменения.Наименование;
					ОбъектДляИзменения.Записать();
				КонецЕсли;
			ИначеЕсли НайденныеЭлементы.Количество() = 0 Тогда
				ЭлементыДляДобавления.Добавить(ЭлементДляПроверки);
				ЭлементыДляДобавления.Добавить("Удалить" + ЭлементДляПроверки);
			Иначе 
				Для Каждого НайденныйЭлемент Из НайденныеЭлементы Цикл
					ОбъектДляИзменения = НайденныйЭлемент.Ссылка.ПолучитьОбъект();
					ОбъектДляИзменения.ИмяПредопределенныхДанных = "";
					ОбъектДляИзменения.Записать();
				КонецЦикла;
				ЭлементыДляДобавления.Добавить(ЭлементДляПроверки);
				ЭлементыДляДобавления.Добавить("Удалить" + ЭлементДляПроверки);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ЭлементДляДобавления Из ЭлементыДляДобавления Цикл
			Если СтрНайти(ЭлементДляДобавления, "БухОтчетностьМП") ИЛИ СтрНайти(ЭлементДляДобавления, "БухОтчетностьСОНКО") Тогда
				Группа = Справочники.ВидыОтправляемыхДокументов.БухгалтерскаяОтчетность;
			ИначеЕсли СтрНайти(ЭлементДляДобавления, "ФинансовыйРезультатИнвестиционногоТоварищества") Тогда
				Группа = Справочники.ВидыОтправляемыхДокументов.НалоговаяОтчетность;
			ИначеЕсли СтрНайти(ЭлементДляДобавления, "СведенияСЗВ64") Тогда
				Группа = Справочники.ВидыОтправляемыхДокументов.ОтчетностьПоФизлицам;
			ИначеЕсли СтрНайти(ЭлементДляДобавления, "ОтходыСубъектовМСП") Тогда
				Группа = Справочники.ВидыОтправляемыхДокументов.ОтчетностьПрочая;
			КонецЕсли;
			
			Если СтрНайти(ЭлементДляДобавления, "Удалить") = 1 Тогда
				Наименование = "(не используется)";
			Иначе
				Наименование = ЭлементДляДобавления;
			КонецЕсли;
			
			НовыйОбъект = Справочники.ВидыОтправляемыхДокументов.СоздатьЭлемент();
			НовыйОбъект.Наименование = Наименование;
			НовыйОбъект.Родитель = Группа;
			НовыйОбъект.ИмяПредопределенныхДанных = ЭлементДляДобавления;
			НовыйОбъект.Записать();		
		КонецЦикла;	
		
		Справочники.ВидыОтправляемыхДокументов.ЗаполнитьПредопределенныеВидыОтправляемыхДокументов(Ложь);
		ЗафиксироватьТранзакцию();
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'БРО. Восстановление предопределенных элементов'", ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка,
			,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОтменитьТранзакцию();
	КонецПопытки;

КонецПроцедуры

Процедура ДобавитьОбработчикиОбновленияОблачнойПодписи(Обработчики, Принудительно = Ложь) Экспорт
	
	Если КриптографияЭДКО.РаботаВМоделиСервиса() И Принудительно Тогда
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия 			   = "*";
		Обработчик.Процедура 		   = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПодключитьПодписьСервисаDSS";
		Обработчик.Идентификатор       = Новый УникальныйИдентификатор();
		Обработчик.НачальноеЗаполнение = Истина;
		Обработчик.Комментарий         = НСтр("ru = 'Проверяем установку константы ЭП'");
		Если Принудительно Тогда
			Обработчик.РежимВыполнения = "Оперативно";
		Иначе
			Обработчик.РежимВыполнения = "Отложенно";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти