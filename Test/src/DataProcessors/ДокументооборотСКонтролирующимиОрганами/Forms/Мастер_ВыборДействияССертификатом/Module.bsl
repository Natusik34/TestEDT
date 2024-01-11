

#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЭДОКлиент;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Инициализация(Параметры);
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособПолученияСертификатаСуществующийПриИзменении(Элемент)
	
	Модифицированность = Истина;
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВключаемыйСертификатНажатие(Элемент)
	
	Модифицированность = Истина;
	
	ОбработкаЗаявленийАбонентаКлиентСервер.ОчиститьВключаемыйСертификат(ЭтотОбъект);
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключаемыйСертификатНажатие(Элемент) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВключаемыйСертификатНажатие_Завершение", 
		ЭтотОбъект);
		
	КомпонентаДляРаботыСКриптографиейПодключена = КомпонентаУстановлена;
		
	ОбработкаЗаявленийАбонентаКлиентСервер.УточнитьРежимРаботыСКлючами(ЭтотОбъект);
	
	ПараметрыОперации = Новый Структура;
	ПараметрыОперации.Вставить("РежимВыбора", "Сертификат");
	Если КриптографияЭДКОКлиентСервер.ЭтоОблачнаяПодпись(МестоХраненияКлюча) Тогда
		ПараметрыОперации.Вставить("УчетнаяЗаписьОблачнойПодписи", КриптографияЭДКОКлиентСервер.ПолучитьУчетнуюЗаписьПодписи(МестоХраненияКлюча));
	КонецЕсли;
	КонтекстЭДОКлиент.ВключаемыйСертификатНажатие(ЭтотОбъект, ОписаниеОповещения, Истина, ПараметрыОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособПолученияСертификатаНовыйПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ЭтоСертификатДругогоУЦ = Ложь;
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	УказаныКорректно = Истина;
	ПроверитьВключаемыйСертификат(УказаныКорректно);
	
	Если НЕ УказаныКорректно Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"Сохранить_ПослеПредупреждения", 
		ЭтотОбъект);
	
	Если ИспользоватьСуществующий(ЭтотОбъект) Тогда
		
		Текст = НСтр("ru = 'Обратите внимание, изменение некоторых настроек будет недоступно в этом заявлении в связи с подключением сертификата из другой программы. Для изменения этих настроек дождитесь одобрения данного заявления и отправьте новое.'");
		ПоказатьВопрос(ОписаниеОповещения, Текст, РежимДиалогаВопрос.ОКОтмена);
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.ОК);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Сохранить_ПослеПредупреждения(РезультатВопроса, ВходящийКонтекст) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда

		ДополнительныеПараметры = ДанныеДляЗакрытия();
		Модифицированность = Ложь;
		Закрыть(ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеДляЗакрытия()
	
	ДополнительныеПараметры = Новый Структура(ПараметрыФормы);
	ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, ЭтотОбъект, ПараметрыФормы); 
	ДополнительныеПараметры.Вставить("ПараметрыФормы", 		ПараметрыФормы);
	ДополнительныеПараметры.Вставить("Модифицированность", 	Модифицированность);
	
	Адрес = ПоместитьВоВременноеХранилище(ОблачныеСертификатыКалуги, Новый УникальныйИдентификатор);
	ДополнительныеПараметры.Вставить("ОблачныеСертификатыКалуги", Адрес);
	
	Адрес = ПоместитьВоВременноеХранилище(СертификатыОрганизацииПоИНН, Новый УникальныйИдентификатор);
	ДополнительныеПараметры.Вставить("СертификатыОрганизацииПоИНН", Адрес);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

&НаСервере
Процедура ПроверитьВключаемыйСертификат(МастерДалее)
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ПроверитьВключаемыйСертификат(ЭтотОбъект, МастерДалее);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;

КонецПроцедуры

&НаКлиенте
Процедура ВключаемыйСертификатНажатие_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	Если ТелефонДляПаролей <> ТелефонМобильныйДляПаролей Тогда
		ТелефонМобильныйДляПаролей = ТелефонДляПаролей;
	КонецЕсли;
	
	ЭтоСертификатДругогоУЦ       = Результат.ЭтоСертификатДругогоУЦ;
	ВключаемыйСертификат         = Результат.ВключаемыйСертификат;
	ВключаемыйСертификатОблачный = Результат.ВключаемыйСертификатОблачный;
	МестоХраненияКлюча			 = КриптографияЭДКОКлиентСервер.КонтекстМоделиХраненияКлюча(ВключаемыйСертификат);
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ИзменитьОформлениеПодсказкиДляГалкиПродлитьСертификат();
	ИзменитьОформлениеВключаемогоСертификата();
	
КонецПроцедуры

&НаСервере
Процедура Инициализация(Параметры)
	
	ПараметрыФормы = Параметры.ПараметрыФормы;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ПараметрыФормы);
	
	СпособПолученияСертификата = Параметры.СпособПолученияСертификата;
	
	Адрес = Параметры.ОблачныеСертификатыКалуги;
	ОблачныеСертификатыКалуги = ПолучитьИзВременногоХранилища(Адрес);
	
	Адрес = Параметры.СертификатыОрганизацииПоИНН;
	СертификатыОрганизацииПоИНН = ПолучитьИзВременногоХранилища(Адрес);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеПодсказкиДляГалкиПродлитьСертификат()
	
	Надпись = Элементы.ПодсказкаПоСрокуДействияСертификата;
	
	// Определяем цвет
	Серый = Новый Цвет(139, 139, 139);
	Надпись.ЦветТекста = Серый;
	
	// Определяем заголовок
	ТекстЗаголовка = "";
	Если НЕ СертификатДоступен Тогда
		ТекстЗаголовка = НСтр("ru = 'Сертификат недоступен'");
	ИначеЕсли ПродлитьСертификатИсходный Тогда
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
		КоличествоОставшегосяВремени = КонтекстЭДОСервер.ТекстЧерезСколькоЛетМесяцевНедельДней(ТекущаяДатаСервер, СертификатДействителенПо, "", "");
		Надпись.ЦветТекста = КрасныйЦвет;
		
		Если КоличествоОставшегосяВремени = Неопределено Тогда
			ТекстЗаголовка = НСтр("ru = 'Срок действия сертификата истек %1'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%1", Формат(СертификатДействителенПо,"ДЛФ=DD"));
		Иначе
			ТекстЗаголовка = НСтр("ru = 'Срок действия сертификата истекает через %1'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%1", КоличествоОставшегосяВремени);
		КонецЕсли;
	Иначе
		ТекстЗаголовка = НСтр("ru = 'Текущий сертификат действует до %1'");
		ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%1", Формат(СертификатДействителенПо,"ДЛФ=DD"));
	КонецЕсли;
	Надпись.Заголовок = ТекстЗаголовка;
		 
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеВключаемогоСертификата()

	ИспользоватьСуществующий = ИспользоватьСуществующий(ЭтотОбъект);
	
	Если ИспользоватьСуществующий Тогда
		Элементы.ВключаемыйСертификат.Доступность = Истина;
		Элементы.УказательВключаемыйСертификат.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
	Иначе
		Элементы.ВключаемыйСертификат.Доступность = Ложь;
		Элементы.УказательВключаемыйСертификат.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	КонецЕсли;
	
	Если ВключаемыйСертификат = Неопределено Тогда
		Элементы.ВключаемыйСертификат.Заголовок  = НСтр("ru = 'Выбрать'");
		Элементы.ВключаемыйСертификат.ЦветТекста = КрасныйЦвет;
	Иначе
		ПредставлениеВключаемогоСертификата = ДокументооборотСКОКлиентСервер.ПредставлениеСертификата(ВключаемыйСертификат);
		
		Элементы.ВключаемыйСертификат.Заголовок  = ПредставлениеВключаемогоСертификата;
		Элементы.ВключаемыйСертификат.ЦветТекста = СинийЦвет;
	КонецЕсли;
	
	Элементы.ОчиститьВключаемыйСертификат.Видимость = ИспользоватьСуществующий И ВключаемыйСертификат <> Неопределено;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИспользоватьСуществующий(Форма) Экспорт
	Возврат ОбработкаЗаявленийАбонентаКлиентСервер.ИспользоватьСуществующий(Форма);
КонецФункции

#КонецОбласти

