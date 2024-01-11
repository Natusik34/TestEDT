#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - Массив - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати - СписокЗначений - значение - ссылка на объект;
//                                            представление - имя области, в которой был выведен объект (выходной параметр);
//  ПараметрыВывода - Структура - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТабличныйДокумент") Тогда
		
		ТабличныйДокумент = ПараметрыПечати.ТабличныйДокумент;
		Если ТипЗнч(ТабличныйДокумент) <> Тип("ТабличныйДокумент") Тогда
			Возврат;
		КонецЕсли;
		// ivcs }
		
		ТабличныйДокумент.АвтоМасштаб = Истина;
		ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПроверкиИПодборКодовМаркировкиИСМП_ТабличныйДокумент";
			
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ТабличныйДокумент",
			НСтр("ru = 'Этикетки ИС МП'"),
			ТабличныйДокумент);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОпределенииКомандПодключенныхКОбъекту(Команды) Экспорт
	
КонецПроцедуры

#КонецОбласти

// Устанавливает связанные значения новому элементу справочник ШтрихкодыУпаковок при перемаркировке
// 
// Параметры:
// 	КодМаркировки - СправочникСсылка.ШтрихкодыУпаковок - Старый код маркировки
// 	НовыйКодМаркировки - СправочникСсылка.ШтрихкодыУпаковок - Новый код маркировки
Процедура УстановитьЗначенияНовогоКодаМаркировки(КодМаркировки, НовыйКодМаркировки) Экспорт
	
	ШтрихкодУпаковкиОбъект = НовыйКодМаркировки.ПолучитьОбъект();
	Если Не ШтрихкодУпаковкиОбъект.Серия = КодМаркировки.Серия Тогда
		ШтрихкодУпаковкиОбъект.Серия = КодМаркировки.Серия;
	КонецЕсли;
	Если ШтрихкодУпаковкиОбъект.Модифицированность() Тогда
		ШтрихкодУпаковкиОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
	
#КонецЕсли