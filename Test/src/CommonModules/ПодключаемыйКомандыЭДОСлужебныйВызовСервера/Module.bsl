// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Получение структуры команд ЭДО из сохраненной настройки
// 
// Параметры:
//  ИмяКоманды - Строка
//  АдресКомандВоВременномХранилище - Строка
// 
// Возвращаемое значение:
// 	Структура
//
Функция ОписаниеКомандыЭДО(ИмяКоманды, АдресКомандВоВременномХранилище) Экспорт

	КомандыЭДО = ПолучитьИзВременногоХранилища(АдресКомандВоВременномХранилище); // ТаблицаЗначений
	Для Каждого КомандаЭДО Из КомандыЭДО.НайтиСтроки(Новый Структура("ИмяКомандыНаФорме", ИмяКоманды)) Цикл
		Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(КомандаЭДО);
	КонецЦикла;

КонецФункции

// Вычислить условия по алгоритму.
// 
// Параметры:
//  Алгоритмы - Соответствие Из КлючИЗначение:
//  * Ключ - Строка - Алгоритм
//  ПараметрАлгоритма - Массив Из ЛюбаяСсылка
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение:
//  * Ключ - Строка - Алгоритм
//  * Значение - Произвольный - Значение алгоритма
//
Функция ВычислитьЗначенияАлгоритмов(Знач Алгоритмы, Знач ПараметрАлгоритма) Экспорт
	ЗначенияАлгоритмов = Новый Соответствие;
	Для Каждого КлючИЗначение Из Алгоритмы Цикл
		Значение = ПодключаемыеКомандыЭДОСлужебный.ВычислитьЗначениеАлгоритма(КлючИЗначение.Ключ, ПараметрАлгоритма);
		ЗначенияАлгоритмов.Вставить(КлючИЗначение.Ключ, Значение);
	КонецЦикла;
	Возврат ЗначенияАлгоритмов;
КонецФункции

#КонецОбласти