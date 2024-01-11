#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ИнтеграцияИС.НастроитьВидимостьДокументаОснования(ЭтотОбъект);
	Элементы.ДокументОснование.ДоступныеТипы = Метаданные.ОпределяемыеТипы.ОснованиеВнесениеСведенийОСобранномУрожаеЗЕРНО.Тип;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыИС.ПриСозданииНаСервере(ЭтотОбъект);
	
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ТоварыХарактеристика");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,   "ТоварыСерия");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСХарактеристикой(ЭтотОбъект, "ТоварыСерия");
	
	Элементы.Подразделение.Видимость = ИнтеграцияИС.ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс();
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
		ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ИнтеграцияИСКлиент.ПослеЗаписиВФормеОбъектаДокументаИС(
		ЭтотОбъект,
		Объект,
		ИнтеграцияЗЕРНОКлиентСервер.ИмяПодсистемы(),
		ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриСозданииЧтенииНаСервере();
	
	РазблокироватьДанныеФормыДляРедактирования();
	
	ИнтеграцияИС.ПослеЗаписиНаСервереВФормеОбъектаДокументаИС(
		ЭтотОбъект,
		ТекущийОбъект,
		ИнтеграцияЗЕРНОКлиентСервер.ИмяПодсистемы(),
		ПараметрыЗаписи);
	
	СобытияФормИСПереопределяемый.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЗЕРНОКлиентПереопределяемый.ОбработкаВыбораСерии(
		ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий);
	
	СобытияФормЗЕРНОКлиентПереопределяемый.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ИнтеграцияИСКлиентСервер.ИмяСобытияИзмененоСостояние(ИнтеграцияЗЕРНОКлиентСервер.ИмяПодсистемы())
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Если Параметр.Свойство("ОбъектИзменен")
			И Параметр.ОбъектИзменен Тогда
			ОбновитьПредставленияНаФорме(Истина);
		Иначе
			ОбновитьПредставленияНаФорме(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = ИнтеграцияИСКлиентСервер.ИмяСобытияВыполненОбмен(ИнтеграцияЗЕРНОКлиентСервер.ИмяПодсистемы())
	 И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		ОбновитьПредставленияНаФорме(Истина);
		
	КонецЕсли;
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СобытияФормИСКлиент.ОбработкаНавигационнойСсылки(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьЗаписатьПараметрыОбновленияСтатуса(Отказ, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Если НовыйОбъект = Элементы.ДокументОснование.ДоступныеТипы.ПривестиЗначение(НовыйОбъект) Тогда
		Объект.ДокументОснование = НовыйОбъект;
		Модифицированность = Истина;
		Записать();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусЗЕРНОПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения(
			"СтатусПредставлениеОбработкаНавигационнойСсылкиЗавершение",
			ЭтотОбъект,
			Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Документ ""Внесение сведений о собранном урожае"" не проведен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения(
			"СтатусПредставлениеОбработкаНавигационнойСсылкиЗавершение",
			ЭтотОбъект,
			Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Документ ""Внесение сведений о собранном урожае"" был изменен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияПриИзменении(Элемент)
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаПриИзменении(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияОчистка(Элемент, СтандартнаяОбработка)
	
	ДополнительныеПоля = Новый Массив;
	ДополнительныеПоля.Добавить("СкладКонтрагент");
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка, ДополнительныеПоля);
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ДополнительныеПоля = Новый Соответствие;
	ДополнительныеПоля.Вставить("СкладКонтрагент", "ВладелецАдреса");
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, ДополнительныеПоля);
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаАвтоПодбор(ЭтотОбъект, "СкладКонтрагентЗЕРНО",
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если РедактированиеФормыНедоступно Тогда
		СобытияФормЗЕРНОКлиент.ВыборЭлементаТабличнойЧастиОткрытьФормуЭлемента(ЭтотОбъект, Элемент, Поле);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные              = Элемент.ТекущиеДанные;
		ИдентификаторСтрокиТоваров = ТекущиеДанные.Идентификатор;
		
		Если Не ЗначениеЗаполнено(ИдентификаторСтрокиТоваров) Или Копирование Тогда
			ТекущиеДанные.Идентификатор = Строка(Новый УникальныйИдентификатор);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	Если РедактированиеФормыНедоступно Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	ОбновитьСтатусЗЕРНО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока Тогда
		ОбновитьСтатусЗЕРНО(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыМестоФормированияПартииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("Организации", Объект.Организация);
	СтруктураБыстрогоОтбора.Вставить("Статус",
		ПредопределенноеЗначение("Перечисление.СтатусыМестФормированияПартийЗЕРНО.Активно"));
	Если ЗначениеЗаполнено(ТекущиеДанные.ОКПД2) Тогда
		СтруктураБыстрогоОтбора.Вставить("ОКПД2", ТекущиеДанные.ОКПД2);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОткрытьФорму("Справочник.РеестрМестФормированияПартийЗЕРНО.ФормаВыбора",
		ПараметрыФормы,
		Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыМестоФормированияПартииПриИзменении(Элемент)
	
	ОбновитьСтатусЗЕРНО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Зерно");
	СобытияФормЗЕРНОКлиент.ПриНачалеВыбораНоменклатуры(Элемент, ВидПродукции, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормЗЕРНОКлиентПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	СобытияФормЗЕРНОКлиентПереопределяемый.ПриНачалеВыбораХарактеристики(
		Элемент, ТекущиеДанные, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	СобытияФормЗЕРНОКлиентПереопределяемый.ПриИзмененииХарактеристики(ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ОткрытьПодборСерий(ЭтотОбъект,, Элемент.ТекстРедактирования, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	СобытияФормЗЕРНОКлиентПереопределяемый.ПриИзмененииСерии(
		ЭтотОбъект, Элементы.Товары.ТекущиеДанные, КэшированныеЗначения, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыОКПД2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВидПродукции",ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Зерно"));
	
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуПодбораОКПД2(ЭтотОбъект, ТекущиеДанные, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыОКПД2ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ОКПД2 = ВыбранноеЗначение.Код;
	ТекущиеДанные.ОКПД2Представление = ВыбранноеЗначение.Представление;
	
	ВыбранноеЗначение = ВыбранноеЗначение.Код;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыОКПД2ПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ОКПД2) Тогда
		ТекущиеДанные.ОКПД2Представление = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыОКПД2ОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Зерно");
	СобытияФормЗерноКлиент.ОКПД2ОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка, ВидПродукции);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыОКПД2АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Зерно");
	СобытияФормЗЕРНОКлиент.ОКПД2АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка, ВидПродукции);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормЗЕРНОКлиентПереопределяемый.ПриИзмененииКоличества(
		ЭтотОбъект, ТекущиеДанные, ЕдиницаИзмеренияКилограмм, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоЗЕРНОПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормЗЕРНОКлиентПереопределяемый.ПриИзмененииКоличестваВКилограммах(
		ЭтотОбъект, ТекущиеДанные, ЕдиницаИзмеренияКилограмм, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыМестоВыращиванияПриИзменении(Элемент)
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаПриИзменении(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыМестоВыращиванияОчистка(Элемент, СтандартнаяОбработка)
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыМестоВыращиванияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыМестоВыращиванияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено
		И ТипЗнч(ВыбранноеЗначение) = Тип("Структура")
		И ВыбранноеЗначение.Свойство("ВладелецАдреса")
		И ЗначениеЗаполнено(ВыбранноеЗначение.ВладелецАдреса) Тогда
		ПлощадьЗемельногоУчастка = ИнтеграцияЗЕРНОВызовСервера.ПлощадьЗемельногоУчастка(ВыбранноеЗначение.ВладелецАдреса);
		Если ЗначениеЗаполнено(ПлощадьЗемельногоУчастка) Тогда
			ТекущиеДанные.ПлощадьСбораУрожая = ПлощадьЗемельногоУчастка;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыМестоВыращиванияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаАвтоПодбор(ЭтотОбъект, "ЗемельныйУчастокИС",
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АрхивироватьДокумент(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Объект.Ссылка, ИнтеграцияЗЕРНОКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура Аннулировать(Команда)
	
	ВыделенныеСтроки = Элементы.Товары.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Данные = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		ДанныеСтроки = Объект.Товары.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Если ДанныеСтроки.СтатусОбработки = ПредопределенноеЗначение(
			"Перечисление.СтатусыОбработкиВнесениеСведенийОСобранномУрожаеЗЕРНО.СведенияВнесены")
			Или ДанныеСтроки.СтатусОбработки = ПредопределенноеЗначение(
			"Перечисление.СтатусыОбработкиВнесениеСведенийОСобранномУрожаеЗЕРНО.АннулированиеОшибкаПередачи") Тогда
			Данные.Добавить(ДанныеСтроки);
		КонецЕсли;
	КонецЦикла;
	
	Если Данные.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Аннулирование по выделенным строкам невозможно'"));
		Возврат;
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		ВыполнитьАннулирование(Данные);
	Иначе
		Если Не Объект.Проведен Тогда
			ТекстВопроса = НСтр("ru = 'Документ не проведен. Провести?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Документ был изменен. Провести?'");
		КонецЕсли;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ВопросАннулированиеЗавершение", ЭтотОбъект, Данные),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПоОснованию(Команда)
	
	ОбработчикПерезаполненияПоОснованию();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтотОбъект);
	СобытияФормЗЕРНО.УстановитьУсловноеОформлениеКоличестваДляПустойНоменклатуры(ЭтотОбъект);
	
	СобытияФормЗЕРНО.УстановитьУсловноеОформлениеОКПД2(ЭтотОбъект);
	
	// Место формирования партии
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыМестоФормированияПартии.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ТоварыМестоФормированияПартии.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<будет создано автоматически>'"));
	
	// Статус обработки
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыСтатусОбработки.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ТоварыСтатусОбработки.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<неопределен>'"));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИнтеграцияЗЕРНО.УстановитьДоступностьПоляСтатус(ЭтотОбъект);
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	
	ПравоИзменения = ПравоДоступа("Изменение", Метаданные.Документы.ВнесениеСведенийОСобранномУрожаеЗЕРНО);
	
	ПараметрыУказанияСерий = ИнтеграцияИС.ПараметрыУказанияСерийФормыОбъекта(Объект, Документы.ВнесениеСведенийОСобранномУрожаеЗЕРНО);
	
	ЕдиницаИзмеренияКилограмм = ИнтеграцияИСКлиентСерверПовтИсп.ЕдиницаИзмеренияКилограмм();
	
	Если Объект.Товары.Количество() Тогда
		ИнициализироватьСлужебныеРеквизитыТоваров();
	КонецЕсли;
	
	ИнтеграцияЗЕРНОКлиентСервер.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект, Перечисления.ВидыПродукцииИС.Зерно);
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
	ИнициализироватьПоляКонтактнойИнформации();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Элементы = Форма.Элементы;
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	Если СтруктураРеквизитов.Свойство("СтатусЗЕРНО") Тогда
		
		РедактированиеФормыНеДоступно = Форма.СтатусЗЕРНО <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиВнесениеСведенийОСобранномУрожаеЗЕРНО.Черновик")
			И Форма.СтатусЗЕРНО <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиВнесениеСведенийОСобранномУрожаеЗЕРНО.Ошибка");
		
		Форма.РедактированиеФормыНеДоступно = РедактированиеФормыНеДоступно;
		
		ЗависимыеЭлементы = Новый Массив;
		ЗависимыеЭлементы.Добавить("ГруппаНередактируемыеПослеОтправкиРеквизитыОсновное");
		ЗависимыеЭлементы.Добавить("Товары");
		
		ИнтеграцияИСКлиентСервер.УстановитьДоступностьЭлементовФормы(Форма,
		ЗависимыеЭлементы, Не Форма.РедактированиеФормыНеДоступно);
		
		ВидимостьСтатусаСтроки = Форма.СтатусЗЕРНО <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиВнесениеСведенийОСобранномУрожаеЗЕРНО.Черновик")
		                          И Форма.СтатусЗЕРНО <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиВнесениеСведенийОСобранномУрожаеЗЕРНО.Аннулирован")
		                          И Форма.СтатусЗЕРНО <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиВнесениеСведенийОСобранномУрожаеЗЕРНО.Ошибка");
		
		ДоступностьКнопкиАннулирования = Форма.СтатусЗЕРНО = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиВнесениеСведенийОСобранномУрожаеЗЕРНО.СведенияВнесены")
		                             Или Форма.СтатусЗЕРНО = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиВнесениеСведенийОСобранномУрожаеЗЕРНО.СведенияВнесеныЧастично");
		
		Элементы.ТоварыСтатусОбработки.Видимость = ВидимостьСтатусаСтроки;
		Элементы.ТоварыАннулировать.Доступность  = ДоступностьКнопкиАннулирования;
			
	КонецЕсли;
	
	Если Инициализация Или СтруктураРеквизитов.Свойство("ОбновитьСтатусЗЕРНО") Тогда
		
		УстановитьПараметрыОбновленияСтатуса = Форма.Модифицированность И НЕ Инициализация;
		ОбновитьСтатусЗЕРНО(Форма, УстановитьПараметрыОбновленияСтатуса);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПослеВыбораОснования(ДанныеВыбора, ДополнительныеПараметры) Экспорт
	
	Если ДанныеВыбора = Элементы.ДокументОснование.ДоступныеТипы.ПривестиЗначение(ДанныеВыбора) Тогда
		Объект.ДокументОснование = ДанныеВыбора;
		Модифицированность       = Истина;
	КонецЕсли;
	
	ЗаполнитьТовары = (ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ОбработатьПерезаполнение"));
	Если ЗаполнитьТовары Тогда
		ОбработчикПерезаполненияПоОснованию();
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "ДокументОснование");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикПерезаполненияПоОснованию()
	
	ОчиститьСообщения();
	
	Если Объект.Товары.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные документа будут перезаполнены. Продолжить?'");
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ВопросОПерезаполнениииПоОснованиюПриЗавершении", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПерезаполнениииПоОснованиюПриЗавершении(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьПоОснованиюСервер()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.Заполнить(Объект.ДокументОснование);
	
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
	ПриСозданииЧтенииНаСервере();
	ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриЗавершенииОперации(Результат, ДополнительныеПараметры) Экспорт
	
	Прочитать();
	
КонецПроцедуры

#Область РаботаСАдресами

&НаСервере
Процедура ИнициализироватьПоляКонтактнойИнформации()
	
	ВидКонтактнойИнформации = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	
	КомментарийМестоХранения = ИнтеграцияЗЕРНО.КомментарийКонтактнойИнформации(Объект.МестоХранения);
	
	Для Каждого СтрокаТовары Из Объект.Товары Цикл
		СтрокаТовары.КомментарийМестоВыращивания = ИнтеграцияЗЕРНО.КомментарийКонтактнойИнформации(СтрокаТовары.МестоВыращивания);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПолеАдресаОкончаниеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	СобытияФормЗЕРНОКлиент.ПолеАдресаОкончаниеВыбора(ЭтотОбъект, Результат, ДополнительныеПараметры);
	
	Если Результат <> Неопределено Тогда
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			ПлощадьЗемельногоУчастка = ИнтеграцияЗЕРНОВызовСервера.ПлощадьЗемельногоУчастка(Результат);
			Если ЗначениеЗаполнено(ПлощадьЗемельногоУчастка) Тогда
				ТекущиеДанные.ПлощадьСбораУрожая = ПлощадьЗемельногоУчастка;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда) Экспорт
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюКомандПодключенныхКОбъекту(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаСервере
Процедура ОбновитьПредставленияНаФорме(Прочитать = Ложь)
	
	Если Прочитать Тогда
		Прочитать();
	Иначе
		ОбновитьСтатусЗЕРНО(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПредставлениеОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
		РазблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СоздатьМестаФормированияПартий" Тогда
		
		ПараметрыПередачи = ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПараметрыОбработкиСообщений();
		ПараметрыПередачи.ДальнейшееДействие = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.СоздайтеМестаФормированияПартий");
		ПараметрыПередачи.Ссылка             = Объект.Ссылка;
		ПараметрыПередачи.Организация        = Объект.Организация;
		ПараметрыПередачи.Подразделение      = Объект.Подразделение;
		
		ОписаниеПриЗавершении = Новый ОписаниеОповещения(
			"Подключаемый_ПриЗавершенииОперации", ЭтотОбъект, ПараметрыПередачи);
		
		ИнтеграцияЗЕРНОКлиент.ПодготовитьКПередаче(ЭтотОбъект, ПараметрыПередачи, ОписаниеПриЗавершении);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		ПараметрыПередачи = ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПараметрыОбработкиСообщений();
		ПараметрыПередачи.ДальнейшееДействие = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.ПередайтеДанные");
		ПараметрыПередачи.Ссылка             = Объект.Ссылка;
		ПараметрыПередачи.Организация        = Объект.Организация;
		ПараметрыПередачи.Подразделение      = Объект.Подразделение;
		
		ОписаниеПриЗавершении = Новый ОписаниеОповещения(
			"Подключаемый_ПриЗавершенииОперации", ЭтотОбъект, ПараметрыПередачи);
		
		ИнтеграцияЗЕРНОКлиент.ПодготовитьКПередаче(ЭтотОбъект, ПараметрыПередачи, ОписаниеПриЗавершении);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьОперацию" Тогда
		
		ИнтеграцияЗЕРНОКлиент.ОтменитьПоследнююОперацию(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьПередачуДанных" Тогда
		
		ИнтеграцияЗЕРНОКлиент.ОтменитьПередачу(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПоказатьПричинуОшибки" Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Документ", Объект.Ссылка);
		
		ОткрытьФорму(
			"Справочник.ЗЕРНОПрисоединенныеФайлы.Форма.ФормаОшибки",
			ПараметрыОткрытияФормы,
			ЭтотОбъект);
	
	КонецЕсли;
	
КонецПроцедуры

#Область Статус

&НаСервере
Процедура ОбновитьЗаписатьПараметрыОбновленияСтатуса(Отказ, ТекущийОбъект)
	
	Если ПараметрыОбновленияСтатуса = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.СтатусыОбъектовСинхронизацииЗЕРНО.ОбновитьСтатус(
		ТекущийОбъект.Ссылка,
		ПараметрыОбновленияСтатуса);
	
	ПараметрыОбновленияСтатуса = Неопределено;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСтатусЗЕРНО(Форма, УстановитьПараметрыОбновленияСтатуса = Ложь)
	
	Объект = Форма.Объект;
	
	ПараметрыСтатуса = ПараметрыСтатусаДокумента(Объект);
	
	Форма.СтатусЗЕРНО = ПараметрыСтатуса.СтатусЗЕРНО;
	Форма.СтатусЗЕРНОПредставление = ПараметрыСтатуса.СтатусЗЕРНОПредставление;
	Форма.РедактированиеФормыНеДоступно = ПараметрыСтатуса.РедактированиеФормыНеДоступно;
	
	СтатусПоУмолчанию = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиВнесениеСведенийОСобранномУрожаеЗЕРНО.Черновик");
	
	Для Каждого СтрокаТовары Из Объект.Товары Цикл
		
		СтатусСтроки = ПараметрыСтатуса.СтатусыПоСтрокам[СтрокаТовары.Идентификатор];
		Если СтатусСтроки = Неопределено Тогда
			СтрокаТовары.СтатусОбработки = СтатусПоУмолчанию;
		Иначе
			СтрокаТовары.СтатусОбработки = СтатусСтроки;
		КонецЕсли;
		
	КонецЦикла;
	
	НастроитьЗависимыеЭлементыФормы(Форма, "СтатусЗЕРНО");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыСтатусаДокумента(ДокументОбъект)
	
	Результат = Новый Структура;
	Результат.Вставить("СтатусЗЕРНО");
	Результат.Вставить("СтатусЗЕРНОПредставление");
	Результат.Вставить("РедактированиеФормыНеДоступно", Ложь);
	Результат.Вставить("СтатусыПоСтрокам", Новый Соответствие);
	
	Ссылка = ДокументОбъект.Ссылка;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ссылка);
	
	СтатусЗЕРНО = МенеджерОбъекта.СтатусПоУмолчанию();
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Статусы.Статус КАК Статус,
		|	Статусы.ИдентификаторСтроки КАК ИдентификаторСтроки,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие1 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие1
		|	КОНЕЦ КАК ДальнейшееДействие1,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие2 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие2
		|	КОНЕЦ КАК ДальнейшееДействие2,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие3 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие3
		|	КОНЕЦ КАК ДальнейшееДействие3
		|ИЗ
		|	РегистрСведений.СтатусыОбъектовСинхронизацииЗЕРНО КАК Статусы
		|ГДЕ
		|	Статусы.ОбъектСинхронизации = &Документ");
		
		Запрос.УстановитьПараметр("Документ",                 Ссылка);
		Запрос.УстановитьПараметр("МассивДальнейшиеДействия", ИнтеграцияЗЕРНО.НеотображаемыеВДокументахДальнейшиеДействия());
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			СтатусЗЕРНО = Выборка.Статус;
			
			Если ЗначениеЗаполнено(Выборка.ИдентификаторСтроки) Тогда
				
				Результат.СтатусыПоСтрокам.Вставить(Выборка.ИдентификаторСтроки, Выборка.Статус);
				
			Иначе
				
				Если СтатусЗЕРНО = Перечисления.СтатусыОбработкиВнесениеСведенийОСобранномУрожаеЗЕРНО.Черновик Тогда
				
					СтруктураПараметров = Новый Структура;
					СтруктураПараметров.Вставить("ОбъектРасчета", ДокументОбъект);
					ДальнейшееДействие = МенеджерОбъекта.ДальнейшееДействиеПоУмолчанию(СтруктураПараметров);
					
				Иначе
					
					ДальнейшееДействие = Новый Массив;
					ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие1);
					ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие2);
					ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие3);
					
				КонецЕсли;
			
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ОбъектРасчета", ДокументОбъект);
		ДальнейшееДействие = МенеджерОбъекта.ДальнейшееДействиеПоУмолчанию(СтруктураПараметров);
		
	КонецЕсли;
	
	ДопустимыеДействия = Новый Массив;
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.СоздайтеМестаФормированияПартий);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.ПередайтеДанные);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.ОтменитеОперацию);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.ОтменитеПередачуДанных);
	
	СтатусЗЕРНОПредставление = ИнтеграцияЗЕРНО.ПредставлениеСтатуса(СтатусЗЕРНО, ДальнейшееДействие, ДопустимыеДействия);
	
	РедактированиеФормыНеДоступно = СтатусЗЕРНО <> Перечисления.СтатусыОбработкиВнесениеСведенийОСобранномУрожаеЗЕРНО.Черновик;
	
	Результат.СтатусЗЕРНО                   = СтатусЗЕРНО;
	Результат.СтатусЗЕРНОПредставление      = СтатусЗЕРНОПредставление;
	Результат.РедактированиеФормыНеДоступно = РедактированиеФормыНеДоступно;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ИнициализироватьСлужебныеРеквизитыТоваров()
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	ТаблицаОКПД2 = ИнтеграцияЗЕРНО.НаименованияКодовОКПД2ПоТабличнойЧасти(Объект.Товары);
	
	Для Каждого ТекущаяСтрока Из Объект.Товары Цикл
		Если ЗначениеЗаполнено(ТекущаяСтрока.ОКПД2) Тогда
			ДанныеОКПД2 = ТаблицаОКПД2.Найти(ТекущаяСтрока.ОКПД2);
			Если ДанныеОКПД2 <> Неопределено Тогда
				ТекущаяСтрока.ОКПД2Представление = ИнтеграцияЗЕРНОКлиентСервер.ПредставлениеОКПД2(
					ДанныеОКПД2.Наименование, ДанныеОКПД2.Идентификатор);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияЗЕРНОСлужебныйКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьАннулирование(Данные)
	
	Если Данные.Количество() = 1 Тогда
		ТекстВопроса = СтрШаблон(
			НСтр("ru = 'Аннулировать данные по строке №%1 ?'"),
			Данные[0].НомерСтроки);
	Иначе
		МассивНомеровСтрок = Новый Массив;
		Для Каждого ДанныеСтроки Из Данные Цикл
			МассивНомеровСтрок.Добавить(Строка(ДанныеСтроки.НомерСтроки));
		КонецЦикла;
		ТекстВопроса = СтрШаблон(
			НСтр("ru = 'Аннулировать данные по строкам №%1 ?'"),
			СтрСоединить(МассивНомеровСтрок, ","));
	КонецЕсли;
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ПодтверждениеАннулированияЗавершение", ЭтотОбъект, Данные),
		ТекстВопроса,
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросАннулированиеЗавершение(РезультатВопроса, Данные) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
		РазблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		ВыполнитьАннулирование(Данные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеАннулированияЗавершение(РезультатВопроса, Данные) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	ПараметрыПередачи = ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПараметрыОбработкиСообщений();
	ПараметрыПередачи.Ссылка             = Объект.Ссылка;
	ПараметрыПередачи.Организация        = Объект.Организация;
	ПараметрыПередачи.Подразделение      = Объект.Подразделение;
	ПараметрыПередачи.ДальнейшееДействие = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.АннулируйтеОперацию");
	
	ПараметрыПередачи.ПараметрыЗапроса = Новый Массив;
	Для Каждого ДанныеСтроки Из Данные Цикл
		ПараметрыПередачи.ПараметрыЗапроса.Добавить(ДанныеСтроки.Идентификатор);
	КонецЦикла;
	
	ОписаниеПриЗавершении = Новый ОписаниеОповещения(
		"Подключаемый_ПриЗавершенииОперации", ЭтотОбъект, ПараметрыПередачи);
	
	ИнтеграцияЗЕРНОКлиент.ПодготовитьКПередаче(ЭтотОбъект, ПараметрыПередачи, ОписаниеПриЗавершении);
	
КонецПроцедуры

#КонецОбласти