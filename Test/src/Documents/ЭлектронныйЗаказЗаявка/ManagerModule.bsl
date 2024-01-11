#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Номер = Данные.Номер;
	Направление = "";
	Если ЗначениеЗаполнено(Данные.Ссылка) Тогда
		РеквизитыСсылки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Данные.Ссылка, "ТитулГрузоотправителяЗаказНомер,ТитулГрузоотправителяФункция,ЭтоВходящий", Истина);
		Если ЗначениеЗаполнено(РеквизитыСсылки.ТитулГрузоотправителяФункция) Тогда
			ФункцияДокумента = НРег(РеквизитыСсылки.ТитулГрузоотправителяФункция);
		Иначе
			ФункцияДокумента = "заказ (заявка)";
		КонецЕсли;
		Если ЗначениеЗаполнено(РеквизитыСсылки.ТитулГрузоотправителяЗаказНомер) Тогда
			Номер = РеквизитыСсылки.ТитулГрузоотправителяЗаказНомер;
		КонецЕсли;
		Если ЗначениеЗаполнено(РеквизитыСсылки.ЭтоВходящий) Тогда
			Направление = ?(РеквизитыСсылки.ЭтоВходящий, " (входящий)", "");
		КонецЕсли;
	КонецЕсли;
	Дата = Формат(Данные.Дата, "ДФ=dd.MM.yyyy");
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Электронный %1%2 № %3 от %4'"), ФункцияДокумента, Направление, Номер, Дата);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Документы.ЭлектронныйЗаказЗаявка.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульСозданиеНаОсновании = ОбщегоНазначения.ОбщийМодуль("СозданиеНаОсновании");
		КомандаСозданияНаОсновании = МодульСозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.ЭлектроннаяТранспортнаяНакладная);
		КомандаСозданияНаОсновании.ОтображениеКнопки = ОтображениеКнопки.КартинкаИТекст;
		Возврат КомандаСозданияНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецЕсли
