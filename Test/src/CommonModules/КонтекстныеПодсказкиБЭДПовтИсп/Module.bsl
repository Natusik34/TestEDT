////////////////////////////////////////////////////////////////////////////////
// КонтекстныеПодсказкиБЭДПовтИсп:  механизм контекстных подсказок.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает значение категории по ее коду.
//
// Параметры:
//  КодКатегории - Строка - код категории.
//
// Возвращаемое значение:
//  ПланВидовХарактеристикСсылка.КатегорииНовостей - категория.
// 
Функция КатегорияПоКоду(КодКатегории) Экспорт
	
	Если Не КонтекстныеПодсказкиБЭД.ФункционалКонтекстныхПодсказокДоступен() Тогда 
		Возврат Неопределено;
	КонецЕсли; 

	Возврат ПланыВидовХарактеристик["КатегорииНовостей"].НайтиПоКоду(КодКатегории);
	
КонецФункции

// Возвращает значение признака доступности механизма контекстных подсказок.
//
// Возвращаемое значение:
//  Булево - значение признака доступности механизма контекстных подсказок.
//
Функция ФункционалКонтекстныхПодсказокДоступен() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		Возврат МодульОбработкаНовостей.РазрешенаРаботаСНовостями(); 
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция СписокВнеконтекстныхКатегорий() Экспорт
	
	СписокВнеконтекстныхКатегорий = Новый Соответствие;
	
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_ExistCustOfOper"),	"СуществуетКонтрагентОператора");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_DocStsOfAccEx"),	"СуществуетДокументСоСтатусомОтраженияВУчете");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_NotPrcDocInActTr"), "СуществуетНеобработанныйДокументВДеревеДействийДляРаздела");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_SertIsExist"),		"СертификатыЕстьВСписке");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_PrivLstCntSert"),	"СертификатыЕстьВЛичномСписке");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_ElemExistInCat"),	"СуществуютЭлементыВСправочнике");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_ElemNotExInCat"),	"ОтсутствуютЭлементыВСправочнике");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_SignOnSrv"),		"СоздаватьЭлектронныеПодписиНаСервере");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_CheckOnSrv"),		"ПроверятьЭлектронныеПодписиНаСервере");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_AccountIsExist"),	"СуществуютУчетныеЗаписи");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_AccOfOperIsExist"), "СуществуютУчетныеЗаписиОператора");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_AdHockCertExist"),	"СуществуютСертификатыСИстекающимСрокомДействия");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_ExpiredCertExist"), "СуществуютСертификатыСИстекшимСрокомДействия");
	СписокВнеконтекстныхКатегорий.Вставить(КатегорияПоКоду("LED_EmpPrcDocInActTr"), "ОтсутствуетНеобработанныйДокументВДеревеДействийДляРаздела");
	
	Возврат Новый ФиксированноеСоответствие(СписокВнеконтекстныхКатегорий);
	
КонецФункции

// Возвращает идентификатор имени формы (MD5 хеш от имени).
//
// Параметры:
//  ИмяФормы - Строка - имя формы. Например, "Обработка.ОбменСКонтрагентами.Форма.ТекущиеДелаПоЭДО".
//
// Возвращаемое значение:
//  Строка - хеш строки.
//
Функция ИдентификаторИмениФормы(ИмяФормы) Экспорт
	
	ХешMD5 = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешMD5.Добавить(ИмяФормы);
	ИмяХеш = ХешMD5.ХешСумма;
	Возврат СтрЗаменить(Строка(ИмяХеш), " ", "");
	
КонецФункции

#КонецОбласти
