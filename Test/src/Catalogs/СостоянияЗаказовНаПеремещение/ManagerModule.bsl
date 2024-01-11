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
	
	Если Не НачальноеЗаполнениеЭлементовВыполнено() Тогда
		Элемент = Элементы.Добавить();
		Элемент.Наименование = НСтр("ru='В работе'");
		Элемент.РеквизитДопУпорядочивания = 1;
		Элемент.Цвет = Новый ХранилищеЗначения(ЦветаСтиля.ЦветТекстаФормы);
	КонецЕсли;
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Завершен";
	Элемент.Наименование = НСтр("ru='Завершен'");
	Элемент.Цвет = Новый ХранилищеЗначения(ЦветаСтиля.ПрошедшееСобытие);
	Элемент.РеквизитДопУпорядочивания = 99999;
	
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

#Область УстаревшиеПроцедурыИФункции

// Устарела. Будет удалена в следующей версии.
//
Процедура ЗаполнитьПоставляемыеСостояния() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СостоянияЗаказовНаПеремещение.Ссылка
		|ИЗ
		|	Справочник.СостоянияЗаказовНаПеремещение КАК СостоянияЗаказовНаПеремещение
		|ГДЕ
		|	СостоянияЗаказовНаПеремещение.Предопределенный = ЛОЖЬ";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();

	Попытка
		
		// 1. Состояние "Завершен"
		Состояние = Справочники.СостоянияЗаказовНаПеремещение.Завершен.ПолучитьОбъект();
		Состояние.Заблокировать();
		Состояние.РеквизитДопУпорядочивания = 99999;
		Состояние.Цвет = Новый ХранилищеЗначения(ЦветаСтиля.ПрошедшееСобытие);
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Состояние);
		
		// 2. Состояние "В работе"
		Состояние = Справочники.СостоянияЗаказовНаПеремещение.СоздатьЭлемент();
		Состояние.Наименование	= НСтр("ru = 'В работе'");
		Состояние.РеквизитДопУпорядочивания = 1;
		Состояние.Цвет = Новый ХранилищеЗначения(ЦветаСтиля.ЦветТекстаФормы);
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Состояние);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось заполнить справочник ""Состояния заказов на перемещение"" по умолчанию по причине:
				|%1'"), 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Справочники.СостоянияЗаказовНаПеремещение, , ТекстСообщения);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	Запрос = Новый Запрос;
	КоличествоЭлементовБыстрогоВыбора = 15;
	
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 15
		|	СостоянияЗаказовНаПеремещение.Ссылка КАК Состояние,
		|	СостоянияЗаказовНаПеремещение.Наименование КАК Наименование,
		|	СостоянияЗаказовНаПеремещение.Цвет КАК Цвет,
		|	ВЫБОР
		|		КОГДА СостоянияЗаказовНаПеремещение.Ссылка = ЗНАЧЕНИЕ(Справочник.СостоянияЗаказовНаПеремещение.Завершен)
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ЗавершенПоследним
		|ИЗ
		|	Справочник.СостоянияЗаказовНаПеремещение КАК СостоянияЗаказовНаПеремещение
		|ГДЕ
		|	СостоянияЗаказовНаПеремещение.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗавершенПоследним,
		|	СостоянияЗаказовНаПеремещение.РеквизитДопУпорядочивания";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "15", КоличествоЭлементовБыстрогоВыбора);
	Выборка = Запрос.Выполнить().Выбрать();
	НомерПоПорядку = 0;
	ЖирныйШрифт = ШрифтыСтиля.ЖирныйШрифтБЭД;
	
	Пока Выборка.Следующий() Цикл
		
		НомерПоПорядку = НомерПоПорядку + 1;
		Цвет = Выборка.Цвет.Получить();
		Если Цвет = Неопределено Тогда
			Цвет = ЦветаСтиля.ЦветТекстаПоля;
		КонецЕсли;
		
		КомпонентыФС = Новый Массив;
		КомпонентыФС.Добавить(Строка(НомерПоПорядку) + ". ");
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(Выборка.Наименование,
			?(Выборка.Состояние = Справочники.СостоянияЗаказовНаПеремещение.Завершен, ЖирныйШрифт, Неопределено),));
			
		ДанныеВыбора.Добавить(Выборка.Состояние, Новый ФорматированнаяСтрока(КомпонентыФС));	// АПК:1356 Используются локализованные имена состояний
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НачальноеЗаполнениеЭлементовВыполнено()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияЗаказовНаПеремещение.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СостоянияЗаказовНаПеремещение КАК СостоянияЗаказовНаПеремещение
	|ГДЕ
	|	СостоянияЗаказовНаПеремещение.Предопределенный = ЛОЖЬ";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли