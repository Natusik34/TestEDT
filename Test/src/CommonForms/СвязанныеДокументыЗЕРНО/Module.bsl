#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Если ЗначениеЗаполнено(Параметры.ДанныеДокументов) Тогда
		Для Каждого СтрокаКоллекции Из Параметры.ДанныеДокументов Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКоллекции);
		КонецЦикла;
	КонецЕсли;
	
	ТолькоПросмотр  = Параметры.ТолькоПросмотр;
	ПрочиеДокументы = Параметры.ПрочиеДокументы;
	
	ДанныеПараметраВыбора = Новый Массив();
	ТипыДокументов        = Новый Массив();
	
	Если ПрочиеДокументы Тогда
		ТипыДокументов.Добавить(ОбщегоНазначения.ОписаниеТипаСтрока(100));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ВидыДокументов) Тогда
		
		Для Каждого ВидДокумента Из Параметры.ВидыДокументов Цикл
			ДанныеПараметраВыбора.Добавить(ВидДокумента);
			Если ТипЗнч(ВидДокумента) = Тип("ПеречислениеСсылка.ВидыКлассификаторовЗЕРНО") Тогда
				ТипыДокументов.Добавить(Новый ОписаниеТипов("СправочникСсылка.КлассификаторНСИЗЕРНО"));
			КонецЕсли;
			ВидыДокументов.Добавить(ВидДокумента)
		КонецЦикла;
		
	КонецЕсли;
	
	Если ДанныеПараметраВыбора.Количество() Тогда
		
		ПараметрыВыбора = Новый ПараметрВыбора("Отбор.ВидКлассификатора", Новый ФиксированныйМассив(ДанныеПараметраВыбора));
		НовыйПараметрыВыбора = ОбщегоНазначения.СкопироватьРекурсивно(Элементы.СвязанныеДокументыТипДокумента.ПараметрыВыбора, Ложь);
		НовыйПараметрыВыбора.Добавить(ПараметрыВыбора);
		Элементы.СвязанныеДокументыТипДокумента.ПараметрыВыбора     = Новый ФиксированныйМассив(НовыйПараметрыВыбора);
		Элементы.СвязанныеДокументыТипДокумента.РежимВыбораИзСписка = Истина;
		
	КонецЕсли;
	
	Элементы.СвязанныеДокументыТипДокумента.ОграничениеТипа = Новый ОписаниеТипов(ТипыДокументов);
	
	ЗаполнитьКэшТиповДокументов(Параметры.ДополнительныеПараметры);
	ЗаполнитьПоПервичномуДокументу();
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСвязанныеДокументы

&НаКлиенте
Процедура СвязанныеДокументыПриИзменении(Элемент)
	Если ТекущееКоличествоСтрок <> СвязанныеДокументы.Количество() Тогда
		ОбновитьЗаголовок(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СвязанныеДокументыПослеУдаления(Элемент)
	ОбновитьЗаголовок(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СвязанныеДокументыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	ОбновитьЗаголовок(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СвязанныеДокументыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ОбновитьЗаголовок(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СвязанныеДокументыПриАктивизацииЯчейки(Элемент)
	
	Если Элементы.СвязанныеДокументы.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.СвязанныеДокументыТипДокумента Тогда
		
		Элемент.ТекущийЭлемент.СписокВыбора.Очистить();
		
		Если ПрочиеДокументы Тогда
			ОписаниеТипа = Новый ОписаниеТипов("Строка");
		Иначе
			ОписаниеТипа = Новый ОписаниеТипов("СправочникСсылка.КлассификаторНСИЗЕРНО");
		КонецЕсли;
		
		Для Каждого СтрокаДанных Из КэшТиповДокументов Цикл
			
			Если ПрочиеДокументы Тогда
				Элемент.ТекущийЭлемент.СписокВыбора.Добавить(СтрокаДанных.ТипДокументаПредставление);
			Иначе
				Элемент.ТекущийЭлемент.СписокВыбора.Добавить(СтрокаДанных.ТипДокумента);
			КонецЕсли;
			
		КонецЦикла;
		
		Элемент.ТекущийЭлемент.СписокВыбора.СортироватьПоПредставлению();
		Элемент.ТекущийЭлемент.ВыбиратьТип         = Ложь;
		Элемент.ТекущийЭлемент.РежимВыбораИзСписка = Не ПрочиеДокументы;
		
		ТекущиеДанные = Элементы.СвязанныеДокументы.ТекущиеДанные;
		ТекущиеДанные.ТипДокумента = ОписаниеТипа.ПривестиЗначение(ТекущиеДанные.ТипДокумента);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвязанныеДокументыТипДокументаПриИзменении(Элемент)
	
	Если Не ПрочиеДокументы Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = Элементы.СвязанныеДокументы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("ТипДокументаПредставление", ТекущиеДанные.ТипДокумента);
	Если КэшТиповДокументов.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
		
		СтрокаКэша = КэшТиповДокументов.Добавить();
		СтрокаКэша.ТипДокумента              = ТекущиеДанные.ТипДокумента;
		СтрокаКэша.ТипДокументаПредставление = ТекущиеДанные.ТипДокумента;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если ПроверитьЗаполнениеТаблицы() Тогда
		Закрыть(СвязанныеДокументы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовок(Форма)
	
	Форма.ТекущееКоличествоСтрок = Форма.СвязанныеДокументы.Количество();
	Форма.Заголовок = НСтр("ru = 'Связанные документы'") + " (" + Строка(Форма.ТекущееКоличествоСтрок) + ")";
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ОбновитьЗаголовок(ЭтотОбъект);
	Если ТолькоПросмотр Тогда
		Элементы.СвязанныеДокументыСохранить.Видимость      = Ложь;
		Элементы.СвязанныеДокументыОтмена.КнопкаПоУмолчанию = Истина;
		Элементы.СвязанныеДокументыОтмена.Заголовок         = НСтр("ru = 'Закрыть'");
		Элементы.СвязанныеДокументы.ТолькоПросмотр          = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПервичномуДокументу()
	
	ПервичныеДокументы = Новый Массив();
	Для Каждого СтрокаТаблицы Из СвязанныеДокументы Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.ПервичныйДокумент) Тогда
			ПервичныеДокументы.Добавить(СтрокаТаблицы.ПервичныйДокумент);
		КонецЕсли;
	КонецЦикла;
	
	РеквизитыДокументов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ПервичныеДокументы, "ТипДокумента, Дата, Номер");
	Для Каждого СтрокаТаблицы Из СвязанныеДокументы Цикл
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.ПервичныйДокумент) Тогда
			Продолжить;
		КонецЕсли;
		РеквизитыДокумента = РеквизитыДокументов[СтрокаТаблицы.ПервичныйДокумент];
		Если РеквизитыДокумента = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, РеквизитыДокумента);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеТаблицы()
	
	Отказ = Ложь;
	НомерСтроки = 0;
	Для Каждого СтрокаТаблицы Из СвязанныеДокументы Цикл
		НомерСтроки = НомерСтроки + 1;
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ТипДокумента) Тогда
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("СвязанныеДокументы", НомерСтроки, "ТипДокумента");
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не заполнен тип связанного документа!'"),,
				Поле,,
				Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Номер) Тогда
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("СвязанныеДокументы", НомерСтроки, "Номер");
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не заполнен номер связанного документа!'"),,
				Поле,,
				Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Дата) Тогда
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("СвязанныеДокументы", НомерСтроки, "Дата");
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не заполнена дата связанного документа!'"),,
				Поле,,
				Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат НЕ Отказ;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКэшТиповДокументов(ДополнительныеПараметры = Неопределено)
	
	Если ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	КэшТиповДокументов.Очистить();
	
	Если ВидыДокументов.Количество() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	КлассификаторНСИЗЕРНО.Ссылка       КАК ТипДокумента,
		|	КлассификаторНСИЗЕРНО.Наименование КАК ТипДокументаПредставление
		|ИЗ
		|	Справочник.КлассификаторНСИЗЕРНО КАК КлассификаторНСИЗЕРНО
		|ГДЕ
		|	КлассификаторНСИЗЕРНО.ВидКлассификатора В (&ВидКлассификатора)
		|	И НЕ КлассификаторНСИЗЕРНО.ПометкаУдаления
		|	И (КлассификаторНСИЗЕРНО.ДействуетПо >= &Дата
		|		Или КлассификаторНСИЗЕРНО.ДействуетПо = ДатаВремя(1,1,1))
		|";
		
		Запрос.УстановитьПараметр("ВидКлассификатора", ВидыДокументов);
		Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
		
		КэшТиповДокументов.Загрузить(Запрос.Выполнить().Выгрузить());
		
	ИначеЕсли ПрочиеДокументы Тогда
		
		Отбор = Новый Структура("ТипДокумента");
		Для Каждого СтрокаТаблицы Из СвязанныеДокументы Цикл
			Если ТипЗнч(СтрокаТаблицы.ТипДокумента) = Тип("Строка")
				И ЗначениеЗаполнено(СтрокаТаблицы.ТипДокумента) Тогда
				Отбор.ТипДокумента = СтрокаТаблицы.ТипДокумента;
				СтрокиКэша = КэшТиповДокументов.НайтиСтроки(Отбор);
				Если СтрокиКэша.Количество() = 0 Тогда
					НоваяСтрока = КэшТиповДокументов.Добавить();
					НоваяСтрока.ТипДокумента              = СтрокаТаблицы.ТипДокумента;
					НоваяСтрока.ТипДокументаПредставление = СтрокаТаблицы.ТипДокумента;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если КэшТиповДокументов.Количество() >= 5 Тогда
			Возврат;
		КонецЕсли;
		
		Если ДополнительныеПараметры <> Неопределено Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 20
			|	СвязанныеДокументыПрочие.ТипДокумента КАК ТипДокумента,
			|	СвязанныеДокументыПрочие.ТипДокумента КАК ТипДокументаПредставление
			|ИЗ
			|	Документ.ОформлениеСДИЗЗЕРНО.СвязанныеДокументыПрочие КАК СвязанныеДокументыПрочие
			|ГДЕ
			|	СвязанныеДокументыПрочие.Ссылка.Организация = &Организация
			|	И СвязанныеДокументыПрочие.Ссылка.Операция = &Операция
			|	И СвязанныеДокументыПрочие.Ссылка.Проведен
			|	И СвязанныеДокументыПрочие.Ссылка <> &Документ
			|
			|УПОРЯДОЧИТЬ ПО
			|	СвязанныеДокументыПрочие.Ссылка.Дата УБЫВ";
			
			Запрос.УстановитьПараметр("Организация",   ДополнительныеПараметры.Организация);
			Запрос.УстановитьПараметр("Операция",      ДополнительныеПараметры.Операция);
			Если ДополнительныеПараметры.Свойство("ТекущийДокумент") Тогда
				Запрос.УстановитьПараметр("Документ", ДополнительныеПараметры.ТекущийДокумент);
			Иначе
				Запрос.УстановитьПараметр("Документ", Неопределено);
			КонецЕсли;
			
			ДанныеСтатистики = Запрос.Выполнить().Выгрузить();
			ДанныеСтатистики.Свернуть("ТипДокумента, ТипДокументаПредставление");
			Отбор = Новый Структура("ТипДокумента");
			Для Каждого СтрокаСтатистики Из ДанныеСтатистики Цикл
				Отбор.ТипДокумента = СтрокаСтатистики.ТипДокумента;
				СтрокиКэша = КэшТиповДокументов.НайтиСтроки(Отбор);
				Если СтрокиКэша.Количество() = 0 Тогда
					НоваяСтрока = КэшТиповДокументов.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаСтатистики);
				КонецЕсли;
				Если КэшТиповДокументов.Количество() = 5 Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти