
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("АдресТаблицыОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ИмяТаблицыДляЗаполнения", ИмяТаблицыДляЗаполнения);
	Если Не ЗначениеЗаполнено(ИмяТаблицыДляЗаполнения) Тогда
		ИмяТаблицыДляЗаполнения = "Организации";
	КонецЕсли;
	
	ЗаполнитьОрганизации(Параметры.АдресТаблицыОрганизаций);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	
	ПараметрыЗакрытияФормы = Новый Структура();
	ПараметрыЗакрытияФормы.Вставить("АдресТаблицыВоВременномХранилище", СформироватьТаблицуВыбранныхЗначений());
	ПараметрыЗакрытияФормы.Вставить("ИмяТаблицыДляЗаполнения",          ИмяТаблицыДляЗаполнения);
	
	ОповеститьОВыборе(ПараметрыЗакрытияФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	ЗаполнитьОтметки(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	ЗаполнитьОтметки(Истина);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтметки(ЗначениеОтметки)
	
	ТаблицаЗаполняемыхЗначений = Организации.Выгрузить();
	ТаблицаЗаполняемыхЗначений.ЗаполнитьЗначения(ЗначениеОтметки, "Использовать");
	Организации.Загрузить(ТаблицаЗаполняемыхЗначений);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОрганизации(АдресТаблицыОрганизаций)
	
	ТаблицаОрганизаций = ПолучитьИзВременногоХранилища(АдресТаблицыОрганизаций);
	
	Если ИмяТаблицыДляЗаполнения = "ОрганизацииБП" Тогда
		
		Для каждого СтрокаТаблицы Из ТаблицаОрганизаций Цикл
			НоваяСтрока = Организации.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		КонецЦикла;
		
	Иначе
		
		МассивОрганизаций = Новый Массив;
		Для каждого СтрокаТаблицы Из ТаблицаОрганизаций Цикл
			Если СтрокаТаблицы.Использовать Тогда
				МассивОрганизаций.Добавить(СтрокаТаблицы.Организация);
			КонецЕсли; 
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка КАК Организация,
		|	ВЫБОР
		|		КОГДА Организации.Ссылка В (&МассивОрганизаций)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Использовать
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ПометкаУдаления = ЛОЖЬ";
		
		Запрос.УстановитьПараметр("МассивОрганизаций", МассивОрганизаций);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = Организации.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.УникальныйИдентификаторСсылки = НоваяСтрока.Организация.УникальныйИдентификатор();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьТаблицуВыбранныхЗначений()

	ТаблицаВыбранныхЗначений = Организации.Выгрузить();
	Возврат ПоместитьВоВременноеХранилище(ТаблицаВыбранныхЗначений, УникальныйИдентификатор);

КонецФункции

#КонецОбласти