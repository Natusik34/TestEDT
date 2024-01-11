
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.МножественныйВыбор <> Неопределено Тогда
		Элементы.Список.МножественныйВыбор = Параметры.МножественныйВыбор;
	КонецЕсли;
	
	ВладелецПартии = Неопределено;
	Параметры.Свойство("ВладелецПартии", ВладелецПартии);
	
	Если ВладелецПартии <> Неопределено Тогда
		
		Подразделение = Неопределено;
		Параметры.Свойство("Подразделение", Подразделение);
		
		Если Подразделение = Неопределено Тогда
			КлючиПоОрганизациямКонтрагентам = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.КлючиПоОрганизациямКонтрагентам(
				ВладелецПартии);
		Иначе
			ТаблицаИсточникиРеквизитов = ИнтеграцияЗЕРНО.НоваяТаблицаОрганизацияКонтрагентПодразделение();
			ИнтеграцияЗЕРНО.ДобавитьВТаблицуОтбораОрганизациюПодразделение(
				ТаблицаИсточникиРеквизитов, ВладелецПартии, Подразделение);
			КлючиПоОрганизациямКонтрагентам = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.КлючиПоОрганизациямКонтрагентам(
				ТаблицаИсточникиРеквизитов);
		КонецЕсли;
		
		КлючиРеквизитовОрганизаций.ЗагрузитьЗначения(КлючиПоОрганизациямКонтрагентам);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ВладелецПартии",
			КлючиРеквизитовОрганизаций,,,
			Истина);
			
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"ОКПД2", Параметры.ОКПД2, ВидСравненияКомпоновкиДанных.НачинаетсяС,, ЗначениеЗаполнено(Параметры.ОКПД2));
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИнтеграцияИСКлиент.ОбработкаОповещенияВФормеСпискаДокументовИС(
		ЭтотОбъект,
		ИнтеграцияЗЕРНОКлиентСервер.ИмяПодсистемы(),
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти