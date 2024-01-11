
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#Область ОбновлениеВерсииИБ

// Определяет настройки начального заполнения элементов.
//
// Параметры:
//  Настройки - Структура - настройки заполнения
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РеквизитыКонтрагентов";
	Элемент.Наименование = НСтр("ru='Справочник контрагенты'");
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "СегментыКонтрагентов";
	Элемент.Родитель = ПланыВидовХарактеристик.РеквизитыДляСписка.РеквизитыКонтрагентов;
	Элемент.Наименование = НСтр("ru='Сегменты'");
	Элемент.Множественный = Истина;
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РеквизитыНоменклатуры";
	Элемент.Наименование = НСтр("ru='Справочник номенклатура'");
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "СегментыНоменклатуры";
	Элемент.Родитель = ПланыВидовХарактеристик.РеквизитыДляСписка.РеквизитыНоменклатуры;
	Элемент.Наименование = НСтр("ru='Сегменты'");
	Элемент.Множественный = Истина;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлемента
//
// Параметры:
//  Объект                  - СправочникОбъект.ВидыКонтактнойИнформации - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения объекта.
//  ДополнительныеПараметры - Структура:
//   * ПредопределенныеДанные - ТаблицаЗначений - данные заполненные в процедуре ПриНачальномЗаполненииЭлементов.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	Объект.УстановитьНовыйКод();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли