#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция КоличествоПрайсЛистовКонтрагентовПользователя(ПользовательСсылка = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПользовательСсылка) Тогда
		
		ПользовательСсылка = Пользователи.АвторизованныйПользователь();
		
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ Количество(1) КАК КоличествоПрайсЛистов ИЗ Справочник.ПрайсЛистыКонтрагентов КАК Прайсы ГДЕ Прайсы.Автор = &ТекущийПользователь ИЛИ НЕ Прайсы.Индивидуальный");
	Запрос.УстановитьПараметр("ТекущийПользователь", ПользовательСсылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат 0;
		
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.КоличествоПрайсЛистов, 0);
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//   Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ОбработчикиСобытий

// См. АвтоподборКонтактовКлиент.Подключаемый_АвтоПодбор
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Параметры.Отбор Цикл
		НайденныйРеквизит = Метаданные.Справочники.Контрагенты.Реквизиты.Найти(КлючИЗначение.Ключ);
		Если НайденныйРеквизит = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если НайденныйРеквизит.Использование = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляЭлемента Тогда
			Параметры.Отбор.Удалить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
