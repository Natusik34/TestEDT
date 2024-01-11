#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет в регистр хеш сумму текущей версии печатной формы.
//
// Параметры:
//   Объект - ОпределяемыйТип.ИнтеграцияС1СДокументооборотВсеСсылкиПереопределяемый - ссылка на объект ИС.
//   ИмяФайла - Строка - имя печатной формы.
//   ТабличныйДокумент - ТабличныйДокумент - сформированная печатная форма.
//
Процедура СохранитьХешСуммуВерсииФайла(Объект, ИмяФайла, ТабличныйДокумент) Экспорт
	
	Менеджер = РегистрыСведений.КонтрольОтправкиФайловВ1СДокументооборот.СоздатьМенеджерЗаписи();
	
	Менеджер.Период = ТекущаяДатаСеанса();
	Менеджер.Объект = Объект;
	Менеджер.ИмяФайла = ИмяФайла;
	Менеджер.ХешСумма = ХешСумма(ТабличныйДокумент);
	
	Менеджер.Записать();
	
КонецПроцедуры

// Проверяет есть ли изменения в текущей версии печатной формы по сравнению с предыдущей,
// отправленной в Документооборот версией.
//
// Параметры:
//   Объект - ОпределяемыйТип.ИнтеграцияС1СДокументооборотВсеСсылкиПереопределяемый - ссылка на объект ИС.
//   ИмяФайла - Строка - имя печатной формы.
//   ТабличныйДокумент - ТабличныйДокумент - сформированная печатная форма.
//
// Возвращаемое значение:
//   Булево - Истина, если печатная форма уже была отправлена в Документооборот ранее.
//
Функция ФайлУжеОтправлен(Объект, ИмяФайла, ТабличныйДокумент) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КонтрольОтправкиФайловВ1СДокументооборотСрезПоследних.ХешСумма КАК ХешСумма
		|ИЗ
		|	РегистрСведений.КонтрольОтправкиФайловВ1СДокументооборот.СрезПоследних(
		|			,
		|			Объект = &Объект
		|				И ИмяФайла = &ИмяФайла) КАК КонтрольОтправкиФайловВ1СДокументооборотСрезПоследних
		|ГДЕ
		|	КонтрольОтправкиФайловВ1СДокументооборотСрезПоследних.ХешСумма = &ХешСумма");
	Запрос.УстановитьПараметр("Объект", Объект);
	Запрос.УстановитьПараметр("ИмяФайла", ИмяФайла);
	Запрос.УстановитьПараметр("ХешСумма", ХешСумма(ТабличныйДокумент));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ХешСумма(ТабличныйДокумент)
	
	ТекстТабличногоДокумента = Новый Массив;
	Для НомерСтроки = 1 По ТабличныйДокумент.ВысотаТаблицы Цикл
		Для НомерКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
			ТекущаяОбласть = ТабличныйДокумент.Область(
				СтрШаблон("R%1C%2",
					Формат(НомерСтроки, "ЧН=0; ЧГ=0"),
					Формат(НомерКолонки, "ЧН=0; ЧГ=0")));
			ТекстТабличногоДокумента.Добавить(ПредставлениеГраницы(ТекущаяОбласть.ГраницаСверху));
			ТекстТабличногоДокумента.Добавить(ПредставлениеГраницы(ТекущаяОбласть.ГраницаСлева));
			ТекстТабличногоДокумента.Добавить(ПредставлениеГраницы(ТекущаяОбласть.ГраницаСнизу));
			ТекстТабличногоДокумента.Добавить(ПредставлениеГраницы(ТекущаяОбласть.ГраницаСправа));
			ТекстТабличногоДокумента.Добавить(ТекущаяОбласть.Текст);
			ТекстТабличногоДокумента.Добавить(Строка(ТекущаяОбласть.Шрифт));
		КонецЦикла;
	КонецЦикла;
	Для Каждого Рисунок Из ТабличныйДокумент.Рисунки Цикл
		ТекстТабличногоДокумента.Добавить(ПредставлениеРисунка(Рисунок));
	КонецЦикла;
	Хеш = Новый ХешированиеДанных(ХешФункция.MD5);
	Хеш.Добавить(СтрСоединить(ТекстТабличногоДокумента, ""));
	
	Возврат Base64Строка(Хеш.ХешСумма);
	
КонецФункции

Функция ПредставлениеГраницы(Граница)
	
	Возврат СтрШаблон("%1%2%3", Граница.Отступ, Граница.ТипЛинии, Граница.Толщина);
	
КонецФункции

Функция ПредставлениеРисунка(Рисунок)
	
	Возврат СтрШаблон("%1%2%3%4%5", Рисунок.Верх, Рисунок.Лево, Рисунок.Высота, Рисунок.Ширина, Рисунок.Имя);
	
КонецФункции

#КонецОбласти

#КонецЕсли