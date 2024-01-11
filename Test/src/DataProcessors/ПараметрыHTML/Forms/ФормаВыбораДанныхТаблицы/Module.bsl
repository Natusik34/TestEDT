
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрыПоказатьГраницы = Неопределено;
	Параметры.Свойство("ПоказатьГраницы", ПараметрыПоказатьГраницы);
	Если ПараметрыПоказатьГраницы = Неопределено Тогда
		
		КоличествоСтрок = 1;
		КоличествоКолонок = 1;
		ПоказатьГраницы = Истина;
		
	Иначе
		
		ПоказатьГраницы = ПараметрыПоказатьГраницы;
		Параметры.Свойство("КоличествоКолонок", КоличествоКолонок);
		Параметры.Свойство("КоличествоСтрок", КоличествоСтрок);
		Параметры.Свойство("ШиринаЯчеек", ШиринаЯчеек);
		Параметры.Свойство("ВысотаЯчеек", ВысотаЯчеек);
		
		ПринятаяШирина = ШиринаЯчеек;
		ПринятаяВысота = ВысотаЯчеек;
		
		Заголовок = НСтр("ru = 'Параметры таблицы'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ШиринаСтрокПриИзменении(Элемент)
	
	ОтобразитьСообщениеОбИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ВысотаСтрокПриИзменении(Элемент)
	
	ОтобразитьСообщениеОбИзменении();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Результат = Новый Структура;
	
	Результат.Вставить("КоличествоСтрок", КоличествоСтрок);
	Результат.Вставить("КоличествоКолонок", КоличествоКолонок);
	Результат.Вставить("ШиринаЯчеек", ШиринаЯчеек);
	Результат.Вставить("ВысотаЯчеек", ВысотаЯчеек);
	Результат.Вставить("ПоказатьГраницы", ПоказатьГраницы);
	
	Если ЭтаФормаДляИзменения() Тогда
		Результат.Вставить("РазмерыИзменились", РазмерыИзменились());
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтобразитьСообщениеОбИзменении()
	
	Если ЭтаФормаДляИзменения() И РазмерыИзменились() Тогда
		Элементы.ДанныеИзменены.Видимость = Истина;
	Иначе
		Элементы.ДанныеИзменены.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция РазмерыИзменились()
	Возврат ШиринаЯчеек <> ПринятаяШирина Или ВысотаЯчеек <> ПринятаяВысота;
КонецФункции

&НаКлиенте
Функция ЭтаФормаДляИзменения()
	Возврат Заголовок = НСтр("ru = 'Параметры таблицы'");
КонецФункции

#КонецОбласти