#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.Заголовок =  НСтр("ru = 'Список дублей по штрихкоду (магнитному коду) и виду карты'");
							
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДисконтныеКарты.Ссылка КАК ДисконтнаяКарта,
		|	ДисконтныеКарты.Наименование,
		|	ДисконтныеКарты.КодКартыШтрихкод,
		|	ДисконтныеКарты.КодКартыМагнитный,
		|	ДисконтныеКарты.ВладелецКарты,
		|	ВЫБОР
		|		КОГДА ДисконтныеКарты.КодКартыШтрихкод = &КодКартыШтрихкод
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК НайденПоШтрихКоду,
		|	ВЫБОР
		|		КОГДА ДисконтныеКарты.КодКартыМагнитный = &КодКартыМагнитный
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК НайденПоМагнитномуКоду,
		|	ДисконтныеКарты.Владелец КАК ВидДисконтнойКарты,
		|	ВЫБОР
		|		КОГДА ДисконтныеКарты.ПометкаУдаления
		|			ТОГДА 4
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Картинка
		|ИЗ
		|	Справочник.ДисконтныеКарты КАК ДисконтныеКарты
		|ГДЕ
		|	ДисконтныеКарты.Владелец = &Владелец
		|	И (ДисконтныеКарты.КодКартыШтрихкод = &КодКартыШтрихкод
		|				И &ПроверятьШтрихкод
		|			ИЛИ ДисконтныеКарты.КодКартыМагнитный = &КодКартыМагнитный
		|				И &ПроверятьМагнитныйКод)
		|	И ДисконтныеКарты.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Владелец", Параметры.Владелец);
	Запрос.УстановитьПараметр("КодКартыМагнитный", Параметры.КодКартыМагнитный);
	Запрос.УстановитьПараметр("КодКартыШтрихкод", Параметры.КодКартыШтрихкод);
	Запрос.УстановитьПараметр("Ссылка", Параметры.Ссылка);
	Запрос.УстановитьПараметр("ПроверятьШтрихкод", (Параметры.Владелец.ТипКарты = Перечисления.ТипыКарт.Штриховая ИЛИ Параметры.Владелец.ТипКарты = Перечисления.ТипыКарт.Смешанная) И 
	                                               ЗначениеЗаполнено(Параметры.КодКартыШтрихкод));
	Запрос.УстановитьПараметр("ПроверятьМагнитныйКод", (Параметры.Владелец.ТипКарты = Перечисления.ТипыКарт.Магнитная ИЛИ Параметры.Владелец.ТипКарты = Перечисления.ТипыКарт.Смешанная) И 
	                                               ЗначениеЗаполнено(Параметры.КодКартыМагнитный));
	
	Результат = Запрос.Выполнить();
	ТаблицыДублирующихДисконтныхКарт.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// Процедура - обработчик события Выбор в таблице значений СписокДублей. Открывает форму выбранной дисконтной карты.
//
&НаКлиенте
Процедура СписокДублейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыПередачи = Новый Структура("Ключ", Элемент.ТекущиеДанные.ДисконтнаяКарта);
	ПараметрыПередачи.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ОткрытьФорму("Справочник.ДисконтныеКарты.ФормаОбъекта",
				  ПараметрыПередачи, 
				  Элемент,
				  ,
				  ,
				  ,
				  Новый ОписаниеОповещения("ОбработатьРедактированиеЭлемента", ЭтаФорма));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура вызывается при закрытии формы дисконтной карты. Открытие формы вызывается из процедуры СписокДублейВыбор
//
&НаКлиенте
Процедура ОбработатьРедактированиеЭлемента(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Элементы.ТаблицыДублирующихДисконтныхКарт.Обновить();
КонецПроцедуры

#КонецОбласти
