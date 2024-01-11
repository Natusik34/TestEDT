#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Команда = Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФСССотрудников.Команды.ФормаСписка;
	НавигационнаяСсылка = "e1cib/command/" + Команда.ПолноеИмя();
	Заголовок           = Команда.Представление();
	
	Список.Параметры.УстановитьЗначениеПараметра("МаксимальноеНачалоДня", '39991231000000');
	Список.Параметры.УстановитьЗначениеПараметра("ВнутреннееСовместительство", Перечисления.ВидыЗанятости.ВнутреннееСовместительство);
	Список.Параметры.УстановитьЗначениеПараметра("Подработка", Перечисления.ВидыЗанятости.Подработка);
	Список.Параметры.УстановитьЗначениеПараметра("ПустойВидЗанятости", Перечисления.ВидыЗанятости.ПустаяСсылка());
	
	ФильтрОрганизация   = Параметры.Организация;
	ФильтрПодразделение = Параметры.Подразделение;
	
	АдаптироватьКВыборуТипов();
	
	Элементы.КартинкаИдетРасчетСпособовВыплаты.Видимость = Ложь;
	Если Не ОбщегоНазначенияБЗК.ЕстьСохраненныеНастройкиФормы(ЭтотОбъект) Тогда
		ПослеЗагрузкиДанныхИзНастроекНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	Если ЗначениеЗаполнено(ФильтрОрганизация) Тогда
		Настройки.Очистить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ПослеЗагрузкиДанныхИзНастроекНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОжидатьЗавершенияРасчетаПодробностей();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_НастройкиПрямыхВыплатФСССотрудников"
		Или ИмяСобытия = "Запись_НастройкиПрямыхВыплатФСССотрудниковПодробности" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФильтрОрганизацияПриИзменении(Элемент)
	ФильтрОрганизацияПриИзмененииНаСервере();
	ОжидатьЗавершенияРасчетаПодробностей();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрПодразделениеПриИзменении(Элемент)
	ИспользоватьФильтрПодразделение = ЗначениеЗаполнено(ФильтрПодразделение);
	ОбновитьПараметрыСписка();
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьФильтрПодразделениеПриИзменении(Элемент)
	ОбновитьПараметрыСписка();
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьФильтрСпособПрямыхВыплатПриИзменении(Элемент)
	ОбновитьПараметрыСписка();
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрТипаСпособаПриИзменении(Элемент)
	ИспользоватьФильтрТипСпособа = ЗначениеЗаполнено(ФильтрТипаСпособа);
	ОбновитьПараметрыСписка();
	Элементы.Список.Обновить();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(ТаблицаФормы, ИдентификаторСтроки, ПолеФормы, СтандартнаяОбработка)
	Если ИдентификаторСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущаяСтрока = Элементы.Список.ДанныеСтроки(ИдентификаторСтроки);
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	Если ПолеФормы = Элементы.СписокСотрудник Тогда
		ПоказатьЗначение(, ТекущаяСтрока.Сотрудник);
	ИначеЕсли ПолеФормы = Элементы.СписокФизическоеЛицо Тогда
		ПоказатьЗначение(, ТекущаяСтрока.ФизическоеЛицо);
	Иначе
		УчетПособийСоциальногоСтрахованияКлиент.НастроитьСпособПрямыхВыплатФизическогоЛица(
			ТекущаяСтрока.ГоловнаяОрганизация,
			ТекущаяСтрока.ФизическоеЛицо,
			ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РассчитатьСпособыОпределяемыеАвтоматически(Команда)
	НачатьРасчетПодробностей();
	ОжидатьЗавершенияРасчетаПодробностей();
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОрганизации(Команда)
	УчетПособийСоциальногоСтрахованияКлиент.ОткрытьНастройкиПрямыхВыплатОрганизации(
		ФильтрОрганизация,
		ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РасширениеСобытийФормы

&НаСервере
Процедура ПослеЗагрузкиДанныхИзНастроекНаСервере()
	Если Не ЗначениеЗаполнено(ФильтрОрганизация) Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация", "ФильтрОрганизация");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
	КонецЕсли;
	ОбновитьПараметрыСписка();
	НачатьРасчетПодробностей();
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура АдаптироватьКВыборуТипов()
	// В запросе в полях "Способ" и "РассчитанныйСпособ" используются представления типов т.к.:
	//   ТИПЗНАЧЕНИЯ(Настройки.Значение) не удалось использовать в запросе на платформе 8.3.14.1976,
	//     поскольку тип некорректно передается в запрос и не работает отбор по типу;
	//   Имя типа также не удалось использовать в запросе,
	//     поскольку тогда представление типа необходимо задавать условным оформлением списка,
	//     а при таком варианте не работает поиск по Ctrl+F.
	
	ТекстыВыбораТипа1 = Новый Массив;
	ШаблонВыбораТипа1 = "КОГДА Настройки.Значение ССЫЛКА %1 И Настройки.Значение <> ЗНАЧЕНИЕ(%1.ПустаяСсылка) ТОГДА ""%2""";
	
	ТекстыВыбораТипа2 = Новый Массив;
	ТекстыВыбораТипа2.Добавить("");
	ТекстыВыбораТипа2.Добавить("ВЫБОР");
	ШаблонВыбораТипа2 = "КОГДА ПодробностиНастроек.Значение ССЫЛКА %1 ТОГДА ""%2""";
	
	СпособОпределятьАвтоматически = СпособОпределятьАвтоматически();
	ТипыСпособовПрямыхВыплат = СпособыПрямыхВыплатФСС.ТипыСпособовПрямыхВыплат();
	Элементы.ФильтрТипаСпособа.СписокВыбора.Добавить(СпособОпределятьАвтоматически, СпособОпределятьАвтоматически);
	ПустыеЗначения = Новый Массив;
	ПустыеЗначения.Добавить(Неопределено);
	Для Каждого СтрокаТаблицы Из ТипыСпособовПрямыхВыплат Цикл
		Элементы.ФильтрТипаСпособа.СписокВыбора.Добавить(СтрокаТаблицы.Заголовок, СтрокаТаблицы.Заголовок);
		ОписаниеТипов = Новый ОписаниеТипов(СтрокаТаблицы.ИмяТипа);
		ПустыеЗначения.Добавить(ОписаниеТипов.ПривестиЗначение(Неопределено));
		ПолноеИмя = Метаданные.НайтиПоТипу(СтрокаТаблицы.Тип).ПолноеИмя();
		ТекстыВыбораТипа1.Добавить(СтрШаблон(ШаблонВыбораТипа1, ПолноеИмя, СтрокаТаблицы.Заголовок));
		ТекстыВыбораТипа2.Добавить(СтрШаблон(ШаблонВыбораТипа2, ПолноеИмя, СтрокаТаблицы.Заголовок));
	КонецЦикла;
	Список.Параметры.УстановитьЗначениеПараметра("ПустыеЗначения", ПустыеЗначения);
	
	ТекстыВыбораТипа1.Добавить("ИНАЧЕ """"");
	ТекстыВыбораТипа2.Добавить("ИНАЧЕ """"");
	ТекстыВыбораТипа2.Добавить("КОНЕЦ");
	ФрагментЗапроса1 = СтрСоединить(ТекстыВыбораТипа1, Символы.ПС + Символы.Таб + Символы.Таб);
	ФрагментЗапроса2 = СтрСоединить(ТекстыВыбораТипа2, Символы.ПС + Символы.Таб + Символы.Таб + Символы.Таб);
	ТекстЗапроса = Список.ТекстЗапроса;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&СпособОпределятьАвтоматически", СпособОпределятьАвтоматически);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИНАЧЕ ВЫРАЗИТЬ(""&ФрагментЗапроса1"" КАК СТРОКА(100))", ФрагментЗапроса1);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, """&ФрагментЗапроса2""", ФрагментЗапроса2);
	Список.ТекстЗапроса = ТекстЗапроса;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СпособОпределятьАвтоматически()
	Возврат НСтр("ru = 'Определять автоматически'");
КонецФункции

&НаСервере
Процедура ОбновитьПараметрыСписка()
	
	Если ЗначениеЗаполнено(ФильтрПодразделение)
		И ИспользоватьФильтрПодразделение
		И Не ЗначениеЗаполнено(ФильтрОрганизация) Тогда
		ФильтрОрганизация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФильтрПодразделение, "Владелец");
	КонецЕсли;
	
	Элементы.СписокОрганизация.Видимость = Не ЗначениеЗаполнено(ФильтрОрганизация);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ФильтрОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ФильтрОрганизация),
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
	ВидСравненияПодразделения = ?(ТипЗнч(ФильтрПодразделение) = Тип("СправочникСсылка.ПодразделенияОрганизаций"),
		ВидСравненияКомпоновкиДанных.ВИерархии,
		ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Подразделение",
		ФильтрПодразделение,
		ВидСравненияПодразделения,
		,
		ИспользоватьФильтрПодразделение,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
	Если ФильтрТипаСпособа = СпособОпределятьАвтоматически() Тогда
		ОтборСпособИспользование = ИспользоватьФильтрТипСпособа;
		ОтборРассчитанныйСпособИспользование = Ложь;
	Иначе
		ОтборСпособИспользование = Ложь;
		ОтборРассчитанныйСпособИспользование = ИспользоватьФильтрТипСпособа И ЗначениеЗаполнено(ФильтрТипаСпособа);
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Способ",
		СпособОпределятьАвтоматически(),
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ОтборСпособИспользование,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"РассчитанныйСпособ",
		ФильтрТипаСпособа,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ОтборРассчитанныйСпособИспользование,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

&НаСервере
Процедура ФильтрОрганизацияПриИзмененииНаСервере()
	ОбновитьПараметрыСписка();
	Если ЗначениеЗаполнено(ФильтрОрганизация) Тогда
		НачатьРасчетПодробностей();
	КонецЕсли;
КонецПроцедуры

#Область ДлительнаяОперация

&НаСервере
Процедура НачатьРасчетПодробностей()
	Если ДлительнаяОперация <> Неопределено И ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	ИмяМетода = "РегистрыСведений.НастройкиПрямыхВыплатФСССотрудниковПодробности.РассчитатьСпособыОпределяемыеАвтоматически";
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Пособия ФСС: Расчет способов прямых выплат'");
	НастройкиЗапуска.ОжидатьЗавершение = 0;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьПроцедуру(НастройкиЗапуска, ИмяМетода, ФильтрОрганизация);
	
	Элементы.КартинкаИдетРасчетСпособовВыплаты.Видимость = (ДлительнаяОперация <> Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьЗавершенияРасчетаПодробностей()
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("ПослеЗавершенияРасчетаПодробностейКлиент", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, НастройкиОжидания);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияРасчетаПодробностейКлиент(Задание, ДополнительныеПараметры) Экспорт
	// Задание - Неопределено - Если задание было отменено;
	//         - Структура - Результат выполнения фонового задания:
	//   * Статус - Строка - "Выполнено", если задание завершено успешно; "Ошибка", если возникло исключение.
	//   * АдресРезультата - Строка - адрес временного хранилища, в которое помещен результат работы процедуры.
	//   * АдресДополнительногоРезультата - Строка - если установлен параметр ДополнительныйРезультат,
	//       содержит адрес дополнительного временного хранилища, в которое помещен результат работы процедуры.
	//   * КраткоеПредставлениеОшибки   - Строка - краткая информация об исключении, если Статус = "Ошибка".
	//   * ПодробноеПредставлениеОшибки - Строка - подробная информация об исключении, если Статус = "Ошибка".
	//   * Сообщения - Неопределено, ФиксированныйМассив из СообщениеПользователю
	ДлительнаяОперация = Неопределено;
	Элементы.КартинкаИдетРасчетСпособовВыплаты.Видимость = Ложь;
	Оповестить("Запись_НастройкиПрямыхВыплатФСССотрудниковПодробности", Неопределено, ЭтотОбъект);
	Если Задание <> Неопределено И ЗначениеЗаполнено(Задание.КраткоеПредставлениеОшибки) Тогда
		ИнформированиеПользователяКлиент.Предупредить(Задание.КраткоеПредставлениеОшибки, Задание.ПодробноеПредставлениеОшибки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти
