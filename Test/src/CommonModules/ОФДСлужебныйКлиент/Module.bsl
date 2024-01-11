///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ОФДКлиент".
// ОбщийМодуль.ОФДКлиент.
//
// Клиентские процедуры настройки использования интеграции ОФД:
//  - открытие формы данных чеков.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. ОФДСлужебный.ПриОпределенииКомандПодключенныхКОбъекту
//
Процедура Подключаемый_ОткрытьФормуДанныеЧеков(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Документ", ПараметрКоманды);
	
	ОткрытьФорму("ОбщаяФорма.ДанныеЧеков", Параметры);
	
КонецПроцедуры

#КонецОбласти