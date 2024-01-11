///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура РазрешитьРедактированиеРеквизитовОбъектаПослеПредупреждения(ОбработкаПродолжения) Экспорт
	
	Если ОбработкаПродолжения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура РазрешитьРедактированиеРеквизитовОбъектаПослеЗакрытияФормы(Результат, Параметры) Экспорт
	
	РазблокированныеРеквизиты = Неопределено;
	
	Если Результат = Истина Тогда
		РазблокированныеРеквизиты = Параметры.ЗаблокированныеРеквизиты;
	ИначеЕсли ТипЗнч(Результат) = Тип("Массив") Тогда
		РазблокированныеРеквизиты = Результат;
	Иначе
		РазблокированныеРеквизиты = Неопределено;
	КонецЕсли;
	
	Если РазблокированныеРеквизиты <> Неопределено Тогда
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьРазрешенностьРедактированияРеквизитов(
			Параметры.Форма, РазблокированныеРеквизиты);
		
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(Параметры.Форма);
	КонецЕсли;
	
	Параметры.Форма = Неопределено;
	
	Если Параметры.ОбработкаПродолжения <> Неопределено Тогда
		ОбработкаПродолжения = Параметры.ОбработкаПродолжения;
		Параметры.ОбработкаПродолжения = Неопределено;
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьСсылкиНаОбъектПослеПодтвержденияПроверки(Ответ, Параметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения, Ложь);
		Возврат;
	КонецЕсли;
		
	Если Параметры.МассивСсылок.Количество() = 0 Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения, Истина);
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияВызовСервера.ЕстьСсылкиНаОбъект(Параметры.МассивСсылок) Тогда
		
		Если Параметры.МассивСсылок.Количество() = 1 Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Элемент ""%1"" уже используется в других местах в программе.
				           |Не рекомендуется разрешать редактирование из-за риска рассогласования данных.'"),
				Параметры.МассивСсылок[0]);
		Иначе
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Выбранные элементы (%1) уже используются в других местах в программе.
				           |Не рекомендуется разрешать редактирование из-за риска рассогласования данных.'"),
				Параметры.МассивСсылок.Количество());
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Разрешить редактирование'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Отмена'"));
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ПроверитьСсылкиНаОбъектПослеПодтвержденияРедактирования", ЭтотОбъект, Параметры),
			ТекстСообщения, Кнопки, , КодВозвратаДиалога.Нет, Параметры.ЗаголовокДиалога);
	Иначе
		Если Параметры.МассивСсылок.Количество() = 1 Тогда
			ПоказатьОповещениеПользователя(НСтр("ru = 'Редактирование реквизитов разрешено'"),
				ПолучитьНавигационнуюСсылку(Параметры.МассивСсылок[0]), Параметры.МассивСсылок[0]);
		Иначе
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Разрешено редактирование реквизитов объектов (%1)'"),
				Параметры.МассивСсылок.Количество());
			
			ПоказатьОповещениеПользователя(НСтр("ru = 'Редактирование реквизитов разрешено'"),,
				ТекстСообщения);
		КонецЕсли;
		ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьСсылкиНаОбъектПослеПодтвержденияРедактирования(Ответ, Параметры) Экспорт
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения, Ответ = КодВозвратаДиалога.Да);
	
КонецПроцедуры

#КонецОбласти
