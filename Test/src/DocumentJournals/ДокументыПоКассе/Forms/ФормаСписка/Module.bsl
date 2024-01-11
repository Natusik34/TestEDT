#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	//Итоги
	РасчетыРаботаСФормамиВызовСервера.ПередЗагрузкойНастроекИтогов(ЭтаФорма, Настройки);
	//Конец Итоги
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	//Итоги
	РасчетыРаботаСФормамиВызовСервера.ПриЗагрузкеНастроекИтогов(ЭтаФорма, Настройки);
	//Конец Итоги
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПоКассеПриАктивизацииСтроки(Элемент)
	
	Если ВариантОтображенияИтогов = ВедомостьЗаДень Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры // ДокументыПоКассеПриАктивизацииСтроки()

&НаКлиенте
Процедура ДокументыПоКассеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметр) Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ИмяДокумента = РаботаСФормойДокументаКлиент.ИмяДокументаПоТипу(Параметр);
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент(ИмяДокумента, "", ДанныеМеток, "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОповещениеОбИзмененииДолга" Тогда
		Если ВариантОтображенияИтогов = ВедомостьЗаДень Тогда
			Подключаемый_ОбработатьАктивизациюСтрокиСписка();
		ИначеЕсли ВариантОтображенияИтогов <> НеОтображатьИтоги Тогда // Итоги по валюте (за период) и остаток в валюте.
			НастройкаИтоговЗавершениеНаСервере();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Запись_ПоступлениеВКассу" ИЛИ
		ИмяСобытия = "Запись_РасходИзКассы" Тогда
		Если Параметр.Свойство("Ссылка") Тогда
			Элементы.ДокументыПоКассе.ТекущаяСтрока = Параметр.Ссылка;
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "НастройкиИтоговИзменены" Тогда
		РасчетыРаботаСФормамиКлиент.ОбработкаОповещенияОбИзмененииНастроекИтогов(ЭтаФорма, Параметр);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Отборы
	// Банк и касса
	ПрочитатьРасчетныеСчетаИКассы();
	// Конец Отборы
	
	// Итоги
	РасчетыРаботаСФормамиВызовСервера.НастроитьПанельИтоговПриСозданииНаСервере(ЭтаФорма, "Касса");
	// Конец Итоги
	
	//УНФ.ОтборыСписка
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	Если Параметры.Свойство("ЭтоНачальнаяСтраница") Тогда
		РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, ДокументыПоКассе, "ДокументыПоКассе");
		ЭтоНачальнаяСтраница = Ложь;
	Иначе
		ЭтоНачальнаяСтраница = Истина;
		РаботаСОтборами.СвернутьРазвернутьОтборыНаСервере(ЭтотОбъект, Ложь);
		ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(Неопределено);
	КонецЕсли;
	//Конец УНФ.ОтборыСписка
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(ДокументыПоКассе);
	
	// МобильноеПриложение
	Если МобильноеПриложениеВызовСервера.НужноОграничитьФункциональность() Тогда
		Элементы.ПраваяПанель.Видимость = Ложь;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаПоступлениеВКассу_ОтПоставщика", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаПоступлениеВКассу_ПрочиеРасчеты", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаПоступлениеВКассу_ОтПодотчетника", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаРасходИзКассы_ПрочиеРасчеты", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаРасходИзКассы_Покупателю", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаРасходИзКассы_Прочее", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаРасходИзКассы_Подотчетнику", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаРасходИзКассы_Налоги", "Видимость", Ложь);
		Элементы.ГруппаВажныеКоманды.Видимость = Ложь;
		Элементы.ФормаСоздатьПоШаблону.Видимость = Ложь;
		Элементы.ФормаОбработкаНастройкаПрограммыБольшеВозможностейКонтекст.Видимость = Ложь;
		Элементы.СписокКасса.Видимость = Ложь;
	КонецЕсли;
	// Конец МобильноеПриложение
	
	ДвижениеДенежныхСредствСервер.СформироватьСписокКомандСозданияДокументов(ЭтотОбъект, "СписокСоздатьПоступление", "ПоступлениеВКассу", "ДокументыПоКассе");
	ДвижениеДенежныхСредствСервер.СформироватьСписокКомандСозданияДокументов(ЭтотОбъект, "СписокСоздатьРасход", "РасходИзКассы", "ДокументыПоКассе");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВедомостьПерейти(Команда)
	
	ОткрытьФорму("Отчет.ДенежныеСредства.Форма", Новый Структура("КлючВарианта", "Ведомость"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(
	"ЖурналДокументов.ДокументыПоКассе",
	ДокументыПоКассе.КомпоновщикНастроек.Настройки.Отбор.Элементы,
	Элементы.ДокументыПоКассе.ТекущаяСтрока);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбработчикКомандСозданияДокумента(Команда)
	
	ДвиженияДенежныхСредствКлиент.ВыполнитьКомандуСозданияДокумента(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервере
Процедура ПрочитатьРасчетныеСчетаИКассы()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Кассы.Ссылка,
		|	ПРЕДСТАВЛЕНИЕ(Кассы.Ссылка) КАК Представление
		|ИЗ
		|	Справочник.Кассы КАК Кассы
		|
		|УПОРЯДОЧИТЬ ПО
		|	Кассы.Наименование";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаКасс = РезультатЗапроса.Выбрать();
	
	Элементы.ОтборСчетИКасса.СписокВыбора.Очистить();
	
	Пока ВыборкаКасс.Следующий() Цикл
		Элементы.ОтборСчетИКасса.СписокВыбора.Добавить(ВыборкаКасс.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

#Область ОтборПоПериоду

// Процедура настраивает период динамического списка (если требуется интерактивный выбор периода).
//
&НаКлиенте
Процедура УстановитьПериодЗавершение(Результат, Параметры) Экспорт
	
	УстановитьПериодЗавершениеНаСервере(Результат, Параметры);
	
КонецПроцедуры

// Процедура настраивает период динамического списка на сервере (если требуется интерактивный выбор периода).
//
&НаСервере
Процедура УстановитьПериодЗавершениеНаСервере(Результат, Параметры)
	
	Если Результат <> Неопределено Тогда
		
		Элементы[Параметры.ИмяСписка].Период.Вариант = Результат.Вариант;
		Элементы[Параметры.ИмяСписка].Период.ДатаНачала = Результат.ДатаНачала;
		Элементы[Параметры.ИмяСписка].Период.ДатаОкончания = Результат.ДатаОкончания;
		Элементы[Параметры.ИмяСписка].Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ДИНАМИЧЕСКОГО СПИСКА

// Выбор значения отбора в поле отбора
&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ДокументыПоКассе", "Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	УстановитьМеткуИОтборСписка("ДокументыПоКассе", "ОрганизацияДляОтбора", Элемент.Родитель.Имя, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидОперацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		УстановитьМеткуИОтборСписка("ДокументыПоКассе", "ВидОперации", Элемент.Родитель.Имя, "Перемещение. "+СокрЛП(ВыбранноеЗначение));
	Иначе
		УстановитьМеткуИОтборСписка("ДокументыПоКассе", "ВидОперации", Элемент.Родитель.Имя, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСчетИКассаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	УстановитьМеткуИОтборСписка("ДокументыПоКассе", "СчетКасса", Элемент.Родитель.Имя, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	УстановитьМеткуИОтборСписка("ДокументыПоКассе", "Автор", Элемент.Родитель.Имя, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидОперацииНачалоВыбораЗавершение(РезультатЗавершения, ПараметрыЗавершения) Экспорт
	
	Если ЗначениеЗаполнено(РезультатЗавершения) Тогда
		Если ТипЗнч(РезультатЗавершения) = Тип("Строка") Тогда
			УстановитьМеткуИОтборСписка("ДокументыПоКассе", "ВидОперации", "ГруппаОтборВидОперации", "Перемещение. "
				+ РезультатЗавершения);
		Иначе
			УстановитьМеткуИОтборСписка("ДокументыПоКассе", "ВидОперации", "ГруппаОтборВидОперации",
				РезультатЗавершения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервере
Процедура УстановитьМеткуИОтборСписка(СписокДляОтбора, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="", ИмяПараметраЗапроса="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения, СписокДляОтбора, ИмяПараметраЗапроса);
	
	Если ИмяПараметраЗапроса="" Тогда
		РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, ЭтотОбъект[СписокДляОтбора], ИмяПоляОтбораСписка);
	Иначе	
		
		СтруктураОтбораМеток = Новый Структура("ИмяПараметраЗапроса", ИмяПараметраЗапроса);
		НайденныеСтроки = ДанныеМеток.НайтиСтроки(СтруктураОтбораМеток);
		МассивОтбора = Новый Массив;
		Для каждого стр Из НайденныеСтроки Цикл
			МассивОтбора.Добавить(стр.Метка);
		КонецЦикла;
		ЭтотОбъект[СписокДляОтбора].Параметры.УстановитьЗначениеПараметра("БезОтбора", НайденныеСтроки.Количество()=0);
		ЭтотОбъект[СписокДляОтбора].Параметры.УстановитьЗначениеПараметра(ИмяПараметраЗапроса, МассивОтбора);
	КонецЕсли; 
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + 1);
	
	ИмяРеквизитаСписка = "ДокументыПоКассе";
	
	УдалитьМеткуОтбора(МеткаИД, ИмяРеквизитаСписка);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД, ИмяРеквизитаСписка)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, ЭтотОбъект[ИмяРеквизитаСписка], МеткаИД, ИмяРеквизитаСписка);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтруктураИменЭлементов = Новый Структура("ОтборПериод, ПредставлениеПериода, СобытиеОповещения", "ОтборПериод", "ПредставлениеПериода", "ОповещениеОбИзмененииДолга");
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "ДокументыПоКассе", "Дата", СтруктураИменЭлементов);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	Если НЕ ЭтоНачальнаяСтраница Тогда
		РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект, "ДокументыПоКассе");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтборы(Команда)
	
	ИмяРеквизитаСписка = "ДокументыПоКассе";
	ИмяТЧДанныеМеток = "ДанныеМеток";
	ИмяТЧДанныеОтборов = "ДанныеОтборов";
	ИмяГруппыОтборов = "ГруппаОтборы";
	ИмяПредопределенныеОтборыПоУмолчанию = "ПредопределенныеОтборыПоУмолчанию";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяРеквизитаСписка", ИмяРеквизитаСписка);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеМеток", ИмяТЧДанныеМеток);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеОтборов", ИмяТЧДанныеОтборов);
	ДополнительныеПараметры.Вставить("ИмяГруппыОтборов", ИмяГруппыОтборов);
	ДополнительныеПараметры.Вставить("ИмяПредопределенныеОтборыПоУмолчанию", ИмяПредопределенныеОтборыПоУмолчанию);
	
	РаботаСОтборамиКлиент.НастроитьОтборыНажатие(ЭтотОбъект, ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры), ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры)
	
	Возврат РаботаСОтборами.ПараметрыДляОткрытияФормыСНастройкамиОтборов(ЭтотОбъект, ДополнительныеПараметры);
	
КонецФункции

&НаКлиенте
Процедура НастройкаОтборовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаОтборовЗавершениеНаСервере(Результат.АдресВыбранныеОтборы, Результат.АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура НастройкаОтборовЗавершениеНаСервере(АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ИмяРеквизитаСписка = "ДокументыПоКассе";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	Иначе
		ИмяРеквизитаСписка = ДополнительныеПараметры.ИмяРеквизитаСписка;
		ИмяТЧДанныеМеток = ДополнительныеПараметры.ИмяТЧДанныеМеток;
		ИмяТЧДанныеОтборов = ДополнительныеПараметры.ИмяТЧДанныеОтборов;
	КонецЕсли;
	
	РаботаСОтборами.НастройкаОтборовЗавершение(ЭтотОбъект, АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборПриИзменении(Элемент)
	
	Подключаемый_ОтборПриИзмененииНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборПриИзмененииНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборПриИзменении(ЭтотОбъект, ЭлементИмя, ЭлементРодительИмя, "ДокументыПоКассе");
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборОчистка(Элемент)
	
	Подключаемый_ОтборОчисткаНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборОчисткаНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборОчистка(ЭтотОбъект, ЭлементИмя, "ДокументыПоКассе");

КонецПроцедуры

&НаКлиенте
Процедура СброситьВсеОтборы(Команда)
	
	СтруктураИменЭлементов = Новый Структура("ОтборПериод, ПредставлениеПериода, СобытиеОповещения", "ОтборПериод", "ПредставлениеПериода", "ОповещениеОбИзмененииДолга");
	
	РаботаСОтборамиКлиент.СброситьОтборПоПериоду(ЭтотОбъект, "ДокументыПоКассе", "Дата", СтруктураИменЭлементов);
	СброситьВсеМеткиОтбораНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СброситьВсеМеткиОтбораНаСервере()
	РаботаСОтборами.УдалитьМеткиОтбораСервер(ЭтотОбъект, ДокументыПоКассе,,"ДокументыПоКассе");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ОбработатьАктивизациюСтрокиСписка()
	
	ТекущаяСтрока = Элементы.ДокументыПоКассе.ТекущиеДанные;
	
	РасчетыРаботаСФормамиКлиент.ОбновлениеИтоговПриАктивизацииСтрокиСписка(ЭтаФорма, ТекущаяСтрока, "Касса");
	
КонецПроцедуры // ОбработатьАктивизациюСтрокиСписка()

&НаКлиенте
Процедура ДекорацияОткрытьФормуНастройкиИтоговНажатие(Элемент)
	
	НастройкаИтогов(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИтогов(Команда)
	
	СтруктураПараметров = Новый Структура();
	
	СтруктураПараметров.Вставить("ВариантОтображенияИтогов", ВариантОтображенияИтогов);
	СтруктураПараметров.Вставить("ВалютаВедомости", ОтборВалютаВедомости);
	СтруктураПараметров.Вставить("ВалютаОстатков", ОтборВалютаОстатков);
	
	ОткрытьФорму("ОбщаяФорма.ФормаНастройкиИтоговБанкИКасса", 
		СтруктураПараметров, 
		ЭтотОбъект, 
		УникальныйИдентификатор,,,
		Новый ОписаниеОповещения("НастройкаИтоговЗавершение", ЭтотОбъект), 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИтоговЗавершение(РезультатЗавершения, ПараметрыЗавершения) Экспорт
	
	Если ТипЗнч(РезультатЗавершения) = Тип("Структура") Тогда
		
		ВариантОтображенияИтогов = РезультатЗавершения.ВариантОтображенияИтогов;
		ОтборВалютаВедомости = РезультатЗавершения.ВалютаВедомости;
		ОтборВалютаОстатков = РезультатЗавершения.ВалютаОстатков;
		
		НастройкаИтоговЗавершениеНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастройкаИтоговЗавершениеНаСервере()

	РасчетыРаботаСФормамиВызовСервера.НастройкаИтоговЗавершениеНаСервере(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкаВыводаИтоговНажатие(Элемент)
	
	НастройкаИтогов(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОстатокВВалютеНажатие(Элемент)
	
	ПериодОтчета = Новый СтандартныйПериод;
	ПериодОтчета.ДатаНачала = ТекущаяДата();
	ПериодОтчета.ДатаОкончания = ТекущаяДата();
	ПараметрыОтчета = Новый Структура("СтПериод", ПериодОтчета);
	
	ОткрытьФорму("Отчет.ДенежныеСредства.Форма", Новый Структура("КлючВарианта, СформироватьПриОткрытии, Отбор", "ОстаткиВВалюте", Истина, ПараметрыОтчета));
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВедомостьПоВалютеНажатие(Элемент)
	
	ПараметрыОтчета = Новый Структура("СтПериод, Валюта", ОтборПериод, ОтборВалютаВедомости);
	ОткрытьФорму("Отчет.ДенежныеСредства.Форма", Новый Структура("КлючВарианта, СформироватьПриОткрытии, Отбор", "ВедомостьВВалюте", Истина, ПараметрыОтчета));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВалютаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	УстановитьМеткуИОтборСписка("ДокументыПоКассе", "Валюта", Элемент.Родитель.Имя, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("ЖурналДокументов.ДокументыПоКассе.Форма.ФормаВыбораВидаОперации",,,,,, Новый ОписаниеОповещения("ОтборВидОперацииНачалоВыбораЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Дата1Нажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ДокументыПоКассе.ТекущиеДанные <> Неопределено Тогда
		ПериодОтчета = Новый СтандартныйПериод;
		ПериодОтчета.ДатаНачала = Элементы.ДокументыПоКассе.ТекущиеДанные.Дата;
		ПериодОтчета.ДатаОкончания = Элементы.ДокументыПоКассе.ТекущиеДанные.Дата;
		ПараметрыОтчета = Новый Структура("СтПериод", ПериодОтчета);
	Иначе
		ПериодОтчета = Новый СтандартныйПериод;
		ПериодОтчета.ДатаНачала = '00010101';
		ПериодОтчета.ДатаОкончания = '00010101';
		ПараметрыОтчета = Новый Структура("СтПериод", ПериодОтчета);
	КонецЕсли;
	
	ОткрытьФорму("Отчет.ДенежныеСредства.Форма", Новый Структура("КлючВарианта, СформироватьПриОткрытии, Отбор", "ВедомостьВВалюте", Истина, ПараметрыОтчета));
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьИтогиКонтекстноеМеню(Команда)
	
	РасчетыРаботаСФормамиКлиент.ОткрытьФормуИтоговКонтекстноеМеню(ЭтаФорма, "Касса");
	
КонецПроцедуры

#КонецОбласти
