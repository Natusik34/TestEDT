
#Область ПрограммныйИнтерфейс

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОтработаныВсеДанные = Ложь;
	Ссылка = Справочники.ВидыДокументовЭДО.ПустаяСсылка();
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	ПараметрыВыборки.ПолныеИменаОбъектов = Ссылка.Метаданные().ПолноеИмя();
	
	Пока Не ОтработаныВсеДанные Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1000
			|	ВидыДокументовЭДО.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ВидыДокументовЭДО КАК ВидыДокументовЭДО
			|ГДЕ
			|	ВидыДокументовЭДО.Ссылка > &Ссылка
			|	И ((ВидыДокументовЭДО.ТипДокумента = ЗНАЧЕНИЕ(Перечисление.ТипыДокументовЭДО.ПустаяСсылка)
			|			ИЛИ ВидыДокументовЭДО.ПорядокСортировкиВПакете = 0
			|			И ВидыДокументовЭДО.ТипДокумента <> ЗНАЧЕНИЕ(Перечисление.ТипыДокументовЭДО.Внутренний))
			|		ИЛИ ВидыДокументовЭДО.ТипДокумента = ЗНАЧЕНИЕ(Перечисление.ТипыДокументовЭДО.ДоговорныйДокумент))
			|
			|УПОРЯДОЧИТЬ ПО
			|	Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
		
		КоличествоСсылок = МассивСсылок.Количество();
		Если КоличествоСсылок < 1000 Тогда
			ОтработаныВсеДанные = Истина;
		КонецЕсли;
		
		Если КоличествоСсылок > 0 Тогда
			Ссылка = МассивСсылок[КоличествоСсылок - 1];
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.Справочники.ВидыДокументовЭДО;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	ПараметрыОтметкиВыполнения = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	
	ВыбранныеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Для Каждого СтрокаДанных Из ВыбранныеДанные Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Записать = Ложь;
			
			Объект = ОбщегоНазначенияБЭД.ОбъектПоСсылкеДляИзменения(СтрокаДанных.Ссылка);
			
			Если Объект <> Неопределено Тогда
				
				ЗаполнитьТипДокументаДляВидовВнутреннегоЭДО(Объект, Записать);
				ЗаполнитьПорядокСортировкиВПакете(Объект, Записать);
				ОбновитьНаименованиеВидаДокумента(Объект, Записать);
				
			КонецЕсли;
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(СтрокаДанных.Ссылка, ПараметрыОтметкиВыполнения);
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось обработать вид электронного документа: %1 по причине:
				|%2'"), СтрокаДанных.Ссылка, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка, МетаданныеОбъекта, СтрокаДанных.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Не удалось обработать некоторые виды электронных документов (пропущены): %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ШаблонСообщения = НСтр("ru = 'Обработана очередная порция видов электронных документов: %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбъектовОбработано);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация,
			МетаданныеОбъекта,, ТекстСообщения);
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов =
		Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбъектовОбработано;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецЕсли

#КонецОбласти

#Область ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ДляПроизвольногоФормата", Ложь) Тогда
		СтандартнаяОбработка = Ложь;
		ВидыДокументов = ЭлектронныеДокументыЭДО.ВидыДокументовДляПроизвольногоФормата();
		ДанныеВыбора = Новый СписокЗначений;
		
		Для Каждого ВидДокумента Из ВидыДокументов Цикл
			Если ВидДокумента.ТипДокумента <> Перечисления.ТипыДокументовЭДО.ДоговорныйДокумент Тогда
				ДанныеВыбора.Добавить(ВидДокумента, ВидДокумента.Наименование);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Если ЭлектронныеДокументыЭДОВызовСервера.ИспользоватьКраткоеПредставлениеВидовДокументов() Тогда
		СтандартнаяОбработка = Ложь;
		Поля.Добавить("КраткоеНаименование");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если ЭлектронныеДокументыЭДОВызовСервера.ИспользоватьКраткоеПредставлениеВидовДокументов() Тогда
		СтандартнаяОбработка = Ложь;
		Представление = Данные.КраткоеНаименование;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункцииОбработчиковОбновления

Процедура ЗаполнитьТипДокументаДляВидовВнутреннегоЭДО(Объект, Записать)
	
	Если ЗначениеЗаполнено(Объект.ТипДокумента)
		ИЛИ Не ЗначениеЗаполнено(Объект.ИдентификаторКомандыПечати) Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ТипДокумента = Перечисления.ТипыДокументовЭДО.Внутренний;
	
	Записать = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьПорядокСортировкиВПакете(Объект, Записать)
	
	Если ЗначениеЗаполнено(Объект.ПорядокСортировкиВПакете) Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ПорядокСортировкиВПакете = ЭлектронныеДокументыЭДО.ПорядокСортировкиВПакете(Объект.ТипДокумента);
	
	Записать = Истина;
	
КонецПроцедуры

Процедура ОбновитьНаименованиеВидаДокумента(Объект, Записать)
	
	Если Объект.ТипДокумента <> Перечисления.ТипыДокументовЭДО.ДоговорныйДокумент
		ИЛИ Объект.Наименование = Строка(Объект.ТипДокумента) Тогда
			
		Возврат;
		
	КонецЕсли;
	
	ЭлектронныеДокументыЭДО.ЗаполнитьНаименованиеВидаДокумента(Объект);
	
	Записать = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#КонецОбласти
